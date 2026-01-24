import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:kyber/gen/Proto/mod_bridge.pb.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/routing/app_router.dart';
import 'package:kyber_launcher/core/services/app_settings.dart';
import 'package:kyber_launcher/core/services/notification_service.dart';
import 'package:kyber_launcher/features/download_manager/models/download_link_type.dart' as dl;
import 'package:kyber_launcher/features/download_manager/models/download_request.dart';
import 'package:kyber_launcher/features/download_manager/providers/download_manager_cubit.dart';
import 'package:kyber_launcher/features/download_manager/services/download_orchestrator.dart';
import 'package:kyber_launcher/features/download_manager/services/mod_bridge_service.dart';
import 'package:kyber_launcher/features/mods/helper/mod_helper.dart';
import 'package:kyber_launcher/features/mods/services/mod_service.dart';
import 'package:kyber_launcher/features/nexusmods/dialogs/nexusmods_login.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:kyber_launcher/main.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';

class CollectionImportDialog extends StatefulWidget {
  const CollectionImportDialog({required this.collection, super.key});

  final ModCollectionMetaData collection;

  @override
  State<CollectionImportDialog> createState() => _CollectionImportDialogState();
}

class _CollectionImportDialogState extends State<CollectionImportDialog> {
  Map<int, Future<SearchModResponse>> availableMods = {};

  @override
  void initState() {
    for (var i = 0; i < widget.collection.mods.length; i++) {
      final mod = widget.collection.mods[i];
      if (ModHelper.isInstalled(mod.name, mod.version)) {
        availableMods[i] = Future.value(
          SearchModResponse(
            mod: null,
          ),
        );
        continue;
      }

      availableMods[i] = sl.get<ModBridgeGRPCService>().searchClient.searchMod(
        SearchModRequest(
          modName: mod.name,
          modVersion: mod.version,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: Text('Import Collection'),
      constraints: BoxConstraints(maxWidth: 600, maxHeight: 400),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Import a collection to install all mods at once.\n'),
          Expanded(
            child: ListView.builder(
              itemCount: widget.collection.mods.length,
              itemBuilder: (context, index) {
                final mod = widget.collection.mods[index];
                return FutureBuilder<SearchModResponse>(
                  future: availableMods[index],
                  builder: (context, snapshot) {
                    final mod = widget.collection.mods[index];
                    final isInstalled = ModHelper.isInstalled(
                      mod.name,
                      mod.version,
                    );

                    if (isInstalled) {
                      return Row(
                        spacing: 8,
                        children: [
                          Icon(
                            mt.Icons.check_circle_outline,
                            color: kActiveColor,
                          ),
                          Text(mod.name),
                        ],
                      );
                    }

                    if (snapshot.hasError) {
                      return Row(
                        spacing: 8,
                        children: [
                          Icon(mt.Icons.cancel_outlined, color: Colors.red),
                          Text(mod.name),
                        ],
                      );
                    }
                    if (!snapshot.hasData) {
                      return Row(
                        spacing: 8,
                        children: [
                          const SizedBox(
                            height: 18,
                            width: 18,
                            child: ProgressRing(),
                          ),
                          Text(mod.name),
                        ],
                      );
                    }

                    return Row(
                      spacing: 8,
                      children: [
                        Icon(
                          mt.Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                        Text(mod.name),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        KyberButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Cancel',
        ),
        KyberButton(
          onPressed: () async {
            final collection = widget.collection;
            final requiredMods = collection.mods
                .where((mod) => !ModHelper.isInstalled(mod.name, mod.version))
                .toList();
            for (final mod in requiredMods) {
              try {
                final resp = await availableMods[collection.mods.indexOf(mod)];
                if (resp == null) {
                  continue;
                }

                if (resp.mod.link.startsWith('https://www.nexusmods')) {
                  final result = await _nexusLogin();
                  if (!result) {
                    final id = const Uuid().v4();
                    await collectionBox.put(
                      id,
                      collection.copyWith(localId: id),
                    );
                    NotificationService.showNotification(
                      message:
                          'You need to login to NexusMods to download mods!',
                    );
                    Navigator.of(context).pop();
                    return;
                  }
                }

                int? fileSize;
                String? filename;

                if (resp.mod.hasFileSize()) {
                  fileSize = resp.mod.fileSize.toInt();
                  filename = resp.mod.link.split('/').last.split('?').first;
                }

                final request = DownloadRequest(
                  filename: filename,
                  link: resp.mod.link.contains('https://www.nexusmods')
                      ? '${resp.mod.link}&file_id=${resp.mod.fileId}'
                      : resp.mod.link,
                  displayName: resp.mod.name,
                  linkType: resp.mod.link.startsWith('https://www.nexusmods')
                      ? dl.DownloadLinkType.nexus
                      : dl.DownloadLinkType.direct,
                  size: fileSize,
                );
                await sl.get<DownloadOrchestrator>().enqueueDownload(request);
              } catch (e) {
                NotificationService.showNotification(
                  message: 'Failed to download ${mod.name}',
                  severity: InfoBarSeverity.error,
                );
                Logger.root.severe('Failed to download ${mod.name}', e);
              }
            }

            // TODO: check if collection has file data
            for (final mod in collection.mods) {
              final modIndex = collection.mods.indexOf(mod);
              if (modIndex == -1) continue;

              final isInstalled = ModHelper.isInstalled(mod.name, mod.version);
              if (isInstalled) {
                final localMod = sl
                    .get<ModService>()
                    .mods
                    .where(
                      (m) =>
                          m.details.name == mod.name &&
                          m.details.version == mod.version,
                    )
                    .firstOrNull;
                if (localMod == null) continue;
                collection.mods[modIndex] = mod.copyWith(
                  filename: localMod.filename,
                );
              } else {
                collection.mods[modIndex] = CollectionMod(
                  name: mod.name,
                  version: mod.version,
                  link: mod.link,
                );
              }
            }

            final id = const Uuid().v4();
            await collectionBox.put(id, collection.copyWith(localId: id));

            Navigator.of(context).pop();
          },
          text: 'Import',
        ),
      ],
    );
  }

  Future<bool> _nexusLogin() async {
    if (!Preferences.nexusMods.isLoggedIn) {
      await Future.delayed(const Duration(milliseconds: 1000));
      await showKyberDialog(
        context: navigatorKey.currentContext!,
        routeSettings: const RouteSettings(name: 'nexusmods_login'),
        builder: (_) => const NexusmodsLogin(),
      );

      if (!Preferences.nexusMods.isLoggedIn) {
        NotificationService.showNotification(
          message: 'You need to login to NexusMods to download mods!',
        );
        return false;
      }
    }

    return true;
  }
}
