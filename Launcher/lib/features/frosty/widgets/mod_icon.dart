import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';

class ModIcon extends StatelessWidget {
  const ModIcon({this.mod, super.key});

  final FrostyMod? mod;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Assets.images.kyberNoImage.image(
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.modulate,
          color: Colors.white.withOpacity(.5),
        ),
        if (mod?.icon != null)
          Positioned.fill(
            child: Image.memory(
              mod!.icon!,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
      ],
    );
  }
}
