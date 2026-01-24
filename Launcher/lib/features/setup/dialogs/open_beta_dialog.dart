import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:kyber_launcher/core/core.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';
import 'package:kyber_launcher/shared/ui/buttons/custom_icon_button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vector_graphics/vector_graphics.dart';

Future<void> showOpenBetaDialog(BuildContext context) async {
  if (Preferences.general.openBetaDialogShown) {
    return;
  }
  final result = await showKyberDialog<bool?>(
    context: context,
    builder: (_) => const OpenBetaDialog(),
  );
  if (result == null || !result) {
    return showOpenBetaDialog(context);
  }

  Preferences.general.openBetaDialogShown = true;
}

final links = [
  'asset://${Assets.videos.kblFirststartVideoHeroes}',
  'https://s3.kyber.gg/frontend-assets/videos/kbl-firststart-video-reinforcements.mp4',
  'https://s3.kyber.gg/frontend-assets/videos/kbl-firststart-video-skins.mp4',
];

class OpenBetaDialog extends StatefulWidget {
  const OpenBetaDialog({super.key});

  @override
  State<OpenBetaDialog> createState() => _OpenBetaDialogState();
}

class _OpenBetaDialogState extends State<OpenBetaDialog> {
  List<FadeInController> _fadeInControllers = [];

  late final VideoController _videoController;
  late final Player _player;

  @override
  void initState() {
    _fadeInControllers = List.generate(
      3,
      (_) => FadeInController(),
    );
    _player = Player();
    _videoController = VideoController(_player);

    Timer.run(() async {
      await _player.setPlaylistMode(.loop);
      for (final link in links) {
        await _player.add(Media(link));
      }

      await _player.play();
      await _player.setVolume(0);
      await _player.next();

      await Future<void>.delayed(const .new(milliseconds: 1000));
      for (final controller in _fadeInControllers) {
        final isLast = controller == _fadeInControllers.last;
        await Future<void>.delayed(.new(milliseconds: isLast ? 2500 : 1000));
        controller.fadeIn();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      constraints: const .new(
        maxWidth: 870,
        maxHeight: 550,
      ),
      contentPadding: .zero,
      content: Stack(
        children: [
          Positioned.fill(
            child: Video(
              controller: _videoController,
              controls: (state) => const SizedBox.shrink(),
              fit: .cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 50,
              ).copyWith(top: 80),
              child: Column(
                mainAxisAlignment: .spaceBetween,
                children: [
                  FadeIn(
                    controller: _fadeInControllers[1],
                    duration: const .new(seconds: 1),
                    child: Assets.icons.betaIcon.svg(height: 32),
                  ),
                  FadeIn(
                    controller: _fadeInControllers.first,
                    child: Assets.icons.galaxyAwaits.svg(),
                  ),
                  FadeIn(
                    controller: _fadeInControllers.last,
                    child: Column(
                      spacing: 20,
                      children: [
                        _PlayButton(
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                        Row(
                          spacing: 20,
                          mainAxisAlignment: .center,
                          children: [
                            CustomSvgButton(
                              path: Assets.icons.discord.path,
                              onPressed: () =>
                                  launchUrlString('https://discord.gg/kyber'),
                            ),
                            CustomSvgButton(
                              path: Assets.icons.iconLib.kblBrowserIcon.path,
                              onPressed: () =>
                                  launchUrlString('https://kyber.gg'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  const _PlayButton({required this.onPressed, super.key, this.text});

  final VoidCallback onPressed;
  final String? text;

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final target = hovered ? kActiveColor : kWhiteColor;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Stack(
          children: [
            VectorGraphic(
              loader: AssetBytesLoader(Assets.icons.kblPlayIcon.path),
              height: 47,
              width: 208,
            ),
            VectorGraphic(
              loader: AssetBytesLoader(Assets.icons.kblPlayIconBorder.path),
              height: 47,
              width: 208,
              colorFilter: ColorFilter.mode(
                target,
                BlendMode.srcIn,
              ),
            ),
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  color: target,
                  fontSize: 24,
                  fontWeight: .bold,
                  height: 1,
                  shadows: hovered
                      ? [
                          Shadow(
                            color: kActiveColor.withOpacity(.7),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                textAlign: .center,
                child: Text(widget.text ?? 'START'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
