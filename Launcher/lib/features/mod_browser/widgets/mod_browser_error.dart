import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_event_container.dart';

class ModBrowserErrorWidget extends StatelessWidget {
  const ModBrowserErrorWidget({super.key, this.error = 'An error occurred.'});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: KyberEventContainer(
        expand: true,
        child: Column(
          children: [
            const Text(
              'An error occurred.',
              style: TextStyle(
                fontFamily: FontFamily.battlefrontUI,
                fontSize: 22,
              ),
            ),
            Text(
              error,
              style: const TextStyle(
                color: kWhiteColor,
                fontFamily: FontFamily.battlefrontUI,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
