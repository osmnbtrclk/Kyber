import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';
import 'package:window_manager/window_manager.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DragToMoveArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Assets.icons.betaIcon.svg(height: 20),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
