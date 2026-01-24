import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class RankIcon extends StatelessWidget {
  const RankIcon({
    required this.level,
    super.key,
    this.fontSize,
    this.useNormalIcon = false,
  });

  final int level;
  final double? fontSize;
  final bool useNormalIcon;

  @override
  Widget build(BuildContext context) {
    if (level < 41 || useNormalIcon) {
      return Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 20, spreadRadius: 1)],
        ),
        child: _NormalIcon(level: level),
      );
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          const BoxShadow(
            blurRadius: 20,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: kActiveColor.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: RepaintBoundary(
        child: _PrestigeIcon(level: level, fontSize: fontSize),
      ),
    );
  }
}

class _PrestigeIcon extends StatefulWidget {
  const _PrestigeIcon({required this.level, this.fontSize});

  final int level;
  final double? fontSize;

  @override
  State<_PrestigeIcon> createState() => _PrestigeIconState();
}

class _PrestigeIconState extends State<_PrestigeIcon> {
  late Timer timer;
  int state = 0;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (state == 0) {
        setState(() {
          state = 1;
        });
      } else {
        setState(() {
          state = 0;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          //child: SvgPicture.file(
          //  File(
          //    "$applicationDocumentsDirectory\\portraits\\rank_border\\LevelBackgroundPrestigeIconBG.svg",
          //  ),
          //  color: kActiveColor,
          //),
          child: Assets.icons.rankBorder.levelBackgroundPrestigeIconBG.svg(
            color: kActiveColor,
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.255,
            child: Assets.icons.rankBorder.levelBackgroundPrestigeIconBGfill
                .svg(
                  color: kActiveColor,
                ),
          ),
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 700),
            opacity: state == 0 ? 0.8 : 0,
            child: Assets.icons.rankBorder.levelBackgroundPrestigeIcon1.svg(
              color: kActiveColor,
            ),
          ),
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 700),
            opacity: state == 1 ? 0.8 : 0,
            curve: Curves.easeOut,
            child: Assets.icons.rankBorder.levelBackgroundPrestigeIcon2.svg(
              color: kActiveColor,
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: AutoSizeText(
              widget.level > 999 ? 'MAX' : widget.level.toString(),
              style: TextStyle(
                fontSize: widget.fontSize ?? (widget.level > 999 ? 13 : 16),
                color: kActiveColor,
                height: 1,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _NormalIcon extends StatelessWidget {
  const _NormalIcon({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Assets.icons.rankBorder.levelBackgroundIcon.svg(
            color: kWhiteColor,
          ),
        ),
        Positioned.fill(
          child: Align(
            child: AutoSizeText(
              level.toString(),
              style: const TextStyle(
                fontSize: 25,
                color: kWhiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
