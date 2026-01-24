import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/nexusmods/services/nexusmods_service.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_event_container.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NexusAuthScreen extends StatelessWidget {
  const NexusAuthScreen({super.key, this.onAuthSuccess});

  final VoidCallback? onAuthSuccess;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KyberEventContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NexusMods Authorization'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.battlefrontUI,
                ),
              ),
              const Text(
                'You need to authorize KyberLauncher on NexusMods to use the mod browser.',
                style: TextStyle(
                  fontSize: 18,
                  color: kWhiteColor,
                  fontFamily: FontFamily.battlefrontUI,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  KyberButton(
                    text: 'Authorize Kyber',
                    onPressed: () {
                      sl<NexusModsService>()
                          .requestApiToken(onUrl: launchUrlString)
                          .then(
                            (value) {
                              onAuthSuccess?.call();
                              //if (mounted) {
                              //  setState(() {});
                              //}
                            },
                          );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
