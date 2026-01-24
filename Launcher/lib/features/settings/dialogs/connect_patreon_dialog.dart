import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/services/notification_service.dart';
import 'package:kyber_launcher/features/maxima/providers/maxima_cubit.dart';
import 'package:kyber_launcher/features/patreon/services/patreon_service.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';
import 'package:logging/logging.dart';

class ConnectPatreonDialog extends StatefulWidget {
  const ConnectPatreonDialog({super.key});

  @override
  State<ConnectPatreonDialog> createState() => _ConnectPatreonDialogState();
}

class _ConnectPatreonDialogState extends State<ConnectPatreonDialog> {
  bool loading = false;
  bool whitelistPrompt = false;

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: const Text('CONNECT PATREON'),
      constraints: const BoxConstraints(
        maxWidth: 600,
        maxHeight: 500,
      ),
      content: Column(
        children: [
          if (loading)
            const Center(child: ProgressRing())
          else ...[
            const Text(
              'You are about to authorize Kyber Launcher to access your Patreon account. '
              'This will allow you to unlock exclusive features and content.',
              style: TextStyle(
                fontFamily: FontFamily.battlefrontUI,
                fontSize: 15,
                color: kWhiteColor,
              ),
            ),
          ],
        ],
      ),
      actions: [
        KyberButton(
          text: 'CANCEL',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        KyberButton(
          text: 'CONNECT',
          onPressed: () async {
            try {
              setState(() => loading = true);
              final code = await PatreonService.requestOAuthLogin();
              if (code == null) {
                NotificationService.error(
                  message: 'No authorization code was received',
                );
                return;
              }

              await PatreonService.fetchToken(code);
              await PatreonService.addToWhitelist();
              await Future<void>.delayed(const Duration(milliseconds: 200));

              if (!mounted) return;

              await context.read<MaximaCubit>().requestLogin(
                skipMaximaCheck: true,
              );

              NotificationService.showNotification(
                title: 'Authorization successful',
                message:
                    'You have been successfully authorized as a Patreon member',
                severity: InfoBarSeverity.success,
              );
            } catch (e, s) {
              String? message;
              if (e is GrpcError) {
                message = e.message;
              } else if (e is PatreonException) {
                Logger.root.warning('Failed to authorize Patreon', e, s);
                message = e.message;
              }

              Logger.root.warning('Failed to authorize Patreon', e, s);
              NotificationService.showNotification(
                title: 'Authorization failed',
                message: message ?? e.toString(),
                severity: InfoBarSeverity.error,
              );
            } finally {
              setState(() => loading = false);
            }
          },
        ),
      ],
    );
  }
}
