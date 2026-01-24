import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kyber_launcher/core/services/app_settings.dart';
import 'package:kyber_launcher/core/services/notification_service.dart';
import 'package:kyber_launcher/core/services/windows_utils.dart';
import 'package:kyber_launcher/features/setup/widgets/nexus_login_screen.dart';
import 'package:kyber_launcher/main.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';
import 'package:logging/logging.dart';

Future<bool> showNexusLoginDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => const NexusmodsLogin(),
  );

  if (result == null || !result) {
    if (result == null) {
      NotificationService.error(message: 'Aborting NexusMods login');
    }

    return false;
  }

  return result;
}

class NexusmodsLogin extends StatefulWidget {
  const NexusmodsLogin({super.key});

  @override
  State<NexusmodsLogin> createState() => _NexusmodsLoginState();
}

class _NexusmodsLoginState extends State<NexusmodsLogin> {
  int _currentStep = 0;

  bool browserOpen = false;
  bool showOverlay = false;

  @override
  void initState() {
    super.initState();
    Logger.root.info('Checking installed WebView');
    if (Platform.isWindows) {
      WebViewEnvironment.getAvailableVersion().then((value) async {
        if (value == null) {
          if (mounted) {
            Navigator.of(context).pop();
          }

          NotificationService.showNotification(
            message: 'Please install WebView to use this feature.',
            severity: InfoBarSeverity.error,
          );
          return;
        }

        if (WindowsUtils.isWindowsCompMode()) {
          setState(() {
            _currentStep = 3;
          });
          return;
        }

        await CookieManager.instance(
          webViewEnvironment: webViewEnvironment,
        ).deleteAllCookies();

        if (!mounted) {
          return;
        }

        setState(() {
          _currentStep = 1;
        });
      });
    } else {
      _currentStep = 1;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: Text('NexusMods Login'.toUpperCase()),
      constraints: BoxConstraints(
        maxWidth: browserOpen ? 1000 : 600,
        maxHeight: browserOpen ? 857 : 400,
      ),
      style: const ContentDialogThemeData(
        barrierColor: Colors.transparent,
      ),
      actions: [
        KyberButton(
          text: 'Skip',
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        if (_currentStep == 1)
          KyberButton(
            onPressed: browserOpen
                ? null
                : () async {
                    setState(() => browserOpen = true);
                  },
            text: !browserOpen ? 'CONTINUE' : 'WAIT',
          ),
      ],
      content: Builder(
        builder: (context) {
          if (_currentStep == 3) {
            return const Center(
              child: Column(
                children: [
                  Text('Windows 7 Compatibility Mode detected'),
                  SizedBox(height: 15),
                  Text(
                    'To login to NexusMods, please disable Windows 7 Compatibility Mode for Kyber Launcher.',
                  ),
                  SizedBox(height: 15),
                  Text(
                    'After you have logged in, you need to re-enable Windows 7 Compatibility Mode.',
                  ),
                ],
              ),
            );
          }

          if (_currentStep == 0) {
            return const Center(
              child: Row(
                children: [
                  ProgressRing(),
                  SizedBox(width: 15),
                  Text('Checking WebView installation...'),
                ],
              ),
            );
          }

          return SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: browserOpen
                  ? [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: NexusLoginScreen(
                                onShowOverlay: (showOverlay) {
                                  setState(() => this.showOverlay = showOverlay);
                                },
                                onSuccess: () async {
                                  if (!mounted) return;
                                  Preferences.nexusMods.isLoggedIn = true;
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ),
                            if (showOverlay)
                              Positioned.fill(
                                child: Container(
                                  color: FluentTheme.of(
                                    context,
                                  ).micaBackgroundColor.withOpacity(.9),
                                  alignment: Alignment.center,
                                  child: const Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: ProgressRing(),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          'Waiting for NexusMods...',
                                          style: TextStyle(fontSize: 19),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ]
                  : [
                      const Text(
                        'To continue, you will need to log in with your NexusMods account in the browser that is about to open.',
                        style: .new(
                          fontSize: 16,
                          fontWeight: .bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'The data is processed locally and will only be sent to Nexusmods.\nYou can also enable/disable this feature later in the settings menu..',
                        style: .new(fontSize: 14),
                      ),
                    ],
            ),
          );
        },
      ),
    );
  }
}
