import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/mods/helper/mod_helper.dart';
import 'package:kyber_launcher/features/settings/dialogs/chromium_download_dialog.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/ui.dart';

class ServerModTile extends StatefulWidget {
  const ServerModTile({required this.mod, this.downloading = false, super.key});

  final ServerMod mod;
  final bool downloading;

  @override
  State<ServerModTile> createState() => _ServerModTileState();
}

class _ServerModTileState extends State<ServerModTile> {
  bool isInstalled = false;

  @override
  void initState() {
    isInstalled = ModHelper.isInstalled(widget.mod.name, widget.mod.version);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ServerModTile oldWidget) {
    isInstalled = ModHelper.isInstalled(widget.mod.name, widget.mod.version);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return KyberTooltip(
      message: '${widget.mod.name} (${widget.mod.version})',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: Row(
          spacing: 10,
          children: [
            Icon(
              widget.downloading
                  ? FluentIcons.download
                  : isInstalled
                  ? mt.Icons.check_rounded
                  : mt.Icons.close_rounded,
              color: widget.downloading
                  ? kActiveColor
                  : isInstalled
                  ? Colors.green
                  : Colors.red,
              size: 19,
            ),
            Expanded(
              child: AutoSizeText(
                '${widget.mod.name} (${widget.mod.version})',
                style: const TextStyle(
                  fontSize: 18,
                  height: 1,
                  color: kWhiteColor,
                  fontFamily: FontFamily.battlefrontUI,
                ),
                maxLines: 1,
              ),
            ),
            Text(
              formatBytes(widget.mod.fileSize.toInt(), 1),
              style: const TextStyle(
                fontSize: 14,
                color: kWhiteColor1,
                fontFamily: FontFamily.battlefrontUI,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
