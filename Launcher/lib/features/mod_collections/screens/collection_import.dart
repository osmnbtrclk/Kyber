import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/routing/app_router.dart';
import 'package:kyber_launcher/features/mods/helper/mod_helper.dart';
import 'package:kyber_launcher/features/settings/dialogs/chromium_download_dialog.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_event_container.dart';
import 'package:kyber_launcher/shared/ui/elements/list/kyber_list.dart';

class CollectionImport extends StatefulWidget {
  const CollectionImport({required this.collectionPath, super.key});

  final String collectionPath;

  @override
  State<CollectionImport> createState() => _CollectionImportState();
}

class _CollectionImportState extends State<CollectionImport> {
  ModCollectionMetaData? _metaData;

  @override
  void initState() {
    if (!File(widget.collectionPath).existsSync()) {
      return;
    }

    ModCollection.readCollection(File(widget.collectionPath)).then((value) {
      setState(() => _metaData = value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_metaData == null) {
      return const Center(child: ProgressRing());
    }

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              const Expanded(child: Placeholder()),
              const SizedBox(width: 20),
              SizedBox(
                width: 400,
                child: KyberEventContainer(
                  expand: true,
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Collection Mods'.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: FontFamily.battlefrontUI,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7.5),
                      Expanded(
                        child: KyberList(
                          itemPadding: EdgeInsets.zero,
                          activeIndex: -1,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            final mod = _metaData!.mods.elementAt(index);
                            final isInstalled = ModHelper.isInstalled(
                              mod.name,
                              mod.version,
                            );
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 13,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isInstalled
                                        ? FluentIcons.check_mark
                                        : FluentIcons.error_badge,
                                    color: isInstalled
                                        ? Colors.green
                                        : Colors.red,
                                    size: 19,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: AutoSizeText(
                                      '${mod.name} (${mod.version})',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        height: 1,
                                        color: kWhiteColor,
                                        fontFamily: FontFamily.battlefrontUI,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    formatBytes(200, 2),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: kWhiteColor1,
                                      fontFamily: FontFamily.battlefrontUI,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: _metaData!.mods.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            KyberButton(
              text: 'CANCEL',
              onPressed: router.pop,
            ),
            KyberButton(
              text: 'DOWNLOAD COLLECTION MODS',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
