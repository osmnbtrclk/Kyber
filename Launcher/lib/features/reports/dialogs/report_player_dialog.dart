import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:grpc/grpc.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/services/notification_service.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/cards/kyber_container.dart';
import 'package:kyber_launcher/shared/ui/dialog/default_dialog.dart';
import 'package:kyber_launcher/shared/ui/elements/dropdown/kyber_dropdown.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_highlight.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_input.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' hide context;
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class ReportPlayerDialog extends StatefulWidget {
  const ReportPlayerDialog({required this.targetPlayer, super.key});

  final ServerPlayer targetPlayer;

  @override
  State<ReportPlayerDialog> createState() => _ReportPlayerDialogState();
}

class _ReportPlayerDialogState extends State<ReportPlayerDialog> {
  final controller = TextEditingController();
  final evidence = <String>[];
  bool _dragging = false;
  bool _isSending = false;
  final List<File> evidenceFiles = [];

  ReportReason selectedReportReason = ReportReason.TOXIC_BEHAVIOUR;

  void submit() async {
    setState(() => _isSending = true);

    try {
      if (controller.text.isEmpty || controller.text.length < 10) {
        NotificationService.error(
          message: 'Please enter a valid description (at least 10 characters)',
        );
        return;
      }

      final extensionMap = <String, int>{};
      for (final file in evidenceFiles) {
        final ext = extension(file.path).toLowerCase().substring(1);
        extensionMap[ext] = (extensionMap[ext] ?? 0) + 1;
      }

      final extResponse = await sl
          .get<KyberGRPCService>()
          .reportServiceClient
          .generateEvidenceLinks(
            GenerateEvidenceLinksRequest(fileExtensions: extensionMap.entries),
          );

      final evidenceIds = <String>[];
      for (final uploadLink in extResponse.links) {
        final uri = Uri.parse(uploadLink);
        final file = evidenceFiles.firstWhere(
          (f) =>
              extension(f.path).toLowerCase() == '.${uri.path.split('.').last}',
        );
        final response = await Dio().putUri(
          uri,
          data: file.openRead(),
          options: Options(
            headers: {
              'Content-Length': file.lengthSync().toString(),
              'Content-Type': 'application/octet-stream',
            },
          ),
        );

        if (response.statusCode != 200) {
          NotificationService.error(
            message: 'Failed to upload file: ${file.path}',
          );
          return;
        }

        evidenceFiles.removeWhere((e) => e.path == file.path);

        evidenceIds.add(uri.pathSegments.last);
      }

      if (evidence.isEmpty && evidenceIds.isEmpty) {
        NotificationService.error(
          message: 'Please add at least one evidence link or image',
        );
        return;
      }

      final req = CreateReportRequest(
        report: CreateReportModel(
          description: controller.text,
          evidenceLinks: evidence,
          reason: selectedReportReason,
          reportedPlayerId: widget.targetPlayer.id,
          evidenceIds: evidenceIds,
        ),
      );

      await sl.get<KyberGRPCService>().reportServiceClient.createReport(req);
      NotificationService.success(message: 'Report sent successfully');

      if (!mounted) return;

      Navigator.of(context).pop();
    } on GrpcError catch (e, s) {
      NotificationService.error(message: e.message ?? 'Failed to send report');
      Logger.root.severe('Failed to send report', e, s);
    } catch (e, s) {
      NotificationService.error(message: e.toString());
      Logger.root.severe('Failed to send report', e, s);
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContentDialog(
      title: Text('REPORT PLAYER'.toUpperCase()),
      description: const Text(
        'SEND A REPORT ABOUT SUSPICIOUS OR UNWELCOME BEHAVIOUR',
      ),
      constraints: const BoxConstraints(
        maxWidth: 700,
        maxHeight: 600,
      ),
      actions: [
        KyberButton(
          text: 'CANCEL',
          onPressed: () => Navigator.of(context).pop(),
        ),
        KyberButton(
          icon: _isSending
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: ProgressRing(
                    strokeWidth: 3,
                  ),
                )
              : const Icon(mt.Icons.file_upload_rounded),
          text: 'SEND',
          onPressed: _isSending ? null : submit,
        ),
      ],
      content: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        children: [
          const Text('REPORT USER'),
          const SizedBox(height: 5),
          ButtonBuilder(
            builder: (context, hovered) {
              return AnimatedContainer(
                height: 50,
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: .circular(4),
                  border: .all(
                    color: hovered ? kActiveColor : decoColor,
                    width: 2,
                  ),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: const TextStyle(
                    color: kWhiteColor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const .all(10),
                          child: Row(
                            children: [
                              Assets.logos.kyberLight.svg(
                                color: kWhiteColor,
                                height: 30,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.targetPlayer.name,
                                style: const TextStyle(
                                  fontFamily: FontFamily.battlefrontUI,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onClick: () async {},
          ),
          const SizedBox(height: 15),
          const Row(
            spacing: 5,
            children: [
              Text('SELECT A REASON FOR REPORTING'),
              KyberHighlight(body: 'REQUIRED'),
            ],
          ),
          const SizedBox(height: 5),
          KyberDropdown<ReportReason>(
            items: ReportReason.values
                .map(
                  (e) => DropdownItem<ReportReason>(
                    label: e.name.replaceAll('_', ' '),
                    value: e,
                  ),
                )
                .toList(),
            selectedItem: selectedReportReason,
            onChanged: (value) {
              setState(() => selectedReportReason = value);
            },
            itemBuilder: (item) => Container(
              alignment: Alignment.centerLeft,
              height: 35,
              child: Padding(
                padding: const .symmetric(horizontal: 10),
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontFamily: FontFamily.battlefrontUI,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Row(
            spacing: 5,
            children: [
              Text('ADD COMMENTS'),
              KyberHighlight(body: 'REQUIRED'),
            ],
          ),
          const SizedBox(height: 5),
          mt.TextFormField(
            style: const TextStyle(
              color: kWhiteColor,
              fontFamily: FontFamily.battlefrontUI,
              height: 1,
            ),
            maxLines: 4,
            minLines: 1,
            controller: controller,
            decoration: mt.InputDecoration(
              hintText: 'Enter a short description'.toUpperCase(),
              hintStyle: const TextStyle(
                color: kInactiveColor,
                fontFamily: FontFamily.battlefrontUI,
                fontSize: 15,
                height: 1,
              ),
              isDense: true,
              fillColor: Colors.black.withOpacity(.6),
              focusColor: Colors.black.withOpacity(.6),
              hoverColor: Colors.black.withOpacity(.6),
              filled: true,
              contentPadding: const .symmetric(
                horizontal: 10,
                vertical: 13.5,
              ),
              enabledBorder: const mt.OutlineInputBorder(
                borderSide: .new(color: decoColor, width: 2),
                borderRadius: .all(
                  .circular(kDefaultInnerBorderRadius),
                ),
              ),
              focusedBorder: mt.OutlineInputBorder(
                borderSide: .new(color: kActiveColor, width: 2),
                borderRadius: const .all(
                  .circular(kDefaultInnerBorderRadius),
                ),
              ),
            ),
            buildCounter:
                (
                  context, {
                  required currentLength,
                  required isFocused,
                  required maxLength,
                }) {
                  return Text(
                    '$currentLength / $maxLength',
                    style: const TextStyle(
                      fontFamily: FontFamily.battlefrontUI,
                      fontSize: 14,
                      color: kInactiveColor,
                    ),
                  );
                },
            maxLength: 500,
            onChanged: (value) {
              setState(() {});
            },
          ),
          if (selectedReportReason == .HACKING)
            Padding(
              padding: const .symmetric(vertical: 20),
              child: KyberCard(
                borderRadius: kDefaultInnerBorderRadius,
                borderColor: kActiveColor,
                padding: const .all(15),
                child: const Text(
                  'As you are reporting for Hacking, please provide as much evidence as possible, especially video evidence.',
                  style: TextStyle(
                    fontFamily: FontFamily.battlefrontUI,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          Row(
            spacing: 5,
            children: [
              Text('ADD EVIDENCE (${evidence.length}/10) (IMAGES OR LINKS)'),
              //const KyberHighlight(body: 'REQUIRED'),
            ],
          ),
          const SizedBox(height: 5),
          DropRegion(
            formats: const [
              Formats.jpeg,
              Formats.png,
              Formats.webp,
            ],
            onPerformDrop: (detail) async {
              for (final item in detail.session.items) {
                item.dataReader?.getValue(
                  Formats.fileUri,
                  (value) {
                    if (value?.path != null && evidenceFiles.length < 5) {
                      var path = Uri.decodeFull(value?.path ?? '-');
                      if (Platform.isWindows) {
                        path = path.substring(1);
                      }

                      final fileSize = File(path);
                      if (fileSize.lengthSync() >= 5 * 1024 * 1024) {
                        NotificationService.error(
                          message: 'File size exceeds 5MB limit',
                        );
                        return;
                      }

                      evidenceFiles.add(File(path));
                    } else {
                      NotificationService.error(
                        message: 'You can only add up to 5 files',
                      );
                    }
                  },
                );
              }

              setState(() {});
            },
            onDropEnter: (_) async => setState(() => _dragging = true),
            onDropLeave: (_) async => setState(() => _dragging = false),
            onDropOver: (DropOverEvent p1) async {
              for (final item in p1.session.items) {
                if (!item.canProvide(Formats.jpeg) &&
                    !item.canProvide(Formats.png) &&
                    !item.canProvide(Formats.webp)) {
                  return .forbidden;
                }
              }

              return .copy;
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: _dragging
                    ? kActiveColor.withOpacity(0.2)
                    : Colors.black.withOpacity(0.2),
                border: Border.all(
                  color: _dragging ? kActiveColor : decoColor,
                  width: 2,
                ),
                borderRadius: .circular(4),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      'Drag & drop files here (max 10)',
                      style: TextStyle(color: kWhiteColor),
                    ),
                    Text(
                      '(jpg, png or webp and MAX 5mb)',
                      style: TextStyle(color: kInactiveColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: evidenceFiles.map((file) {
              final ext = extension(file.path).toLowerCase();
              Widget preview;
              if (['.jpg', '.jpeg', '.png', '.gif'].contains(ext)) {
                preview = Image.file(
                  file,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                );
              } else if (['.mp4', '.mov', '.avi', '.mkv'].contains(ext)) {
                preview = const Icon(
                  mt.Icons.videocam,
                  size: 60,
                  color: kInactiveColor,
                );
              } else {
                preview = const Icon(
                  mt.Icons.insert_drive_file,
                  size: 60,
                  color: kInactiveColor,
                );
              }

              return Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: .circular(4),
                      border: .all(color: decoColor, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: .circular(4),
                      child: preview,
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: IconButton(
                      icon: const Icon(
                        mt.Icons.close,
                        size: 16,
                        color: kWhiteColor,
                      ),
                      onPressed: () =>
                          setState(() => evidenceFiles.remove(file)),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 5),
          const Text('(VIDEO) LINKS'),
          for (int i = 0; i < 10; i++)
            if (i == 0 || evidence.length >= i)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: KyberInput(
                  placeholder: 'Enter evidence',
                  onChanged: (value) {
                    if (value.isEmpty) {
                      evidence.removeAt(i);
                    } else if (evidence.length <= i) {
                      evidence.add(value);
                    } else {
                      evidence[i] = value;
                    }

                    setState(() => null);
                  },
                ),
              ),
        ],
      ),
    );
  }
}
