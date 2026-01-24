import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:kyber_launcher/core/routing/app_router.dart';
import 'package:kyber_launcher/core/services/storage_helper.dart';
import 'package:kyber_launcher/features/navigation_bar/providers/status_cubit.dart';
import 'package:kyber_launcher/main.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class SettingsResetDialog extends StatefulWidget {
  const SettingsResetDialog({super.key});

  @override
  State<SettingsResetDialog> createState() => _SettingsResetDialogState();
}

class _SettingsResetDialogState extends State<SettingsResetDialog> {
  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      constraints: const BoxConstraints(maxHeight: 500, maxWidth: 600),
      title: const Text('Reset Settings'),
      content: const Text(
        'Are you sure you want to reset the app? This will erase all your settings and data.',
      ),
      actions: [
        KyberButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Cancel',
        ),
        KyberButton(
          onPressed: () {
            Navigator.of(context).pop();
            box.deleteFromDisk().then((value) async {
              await StorageHelper.initializeHive();
              await CookieManager.instance(
                webViewEnvironment: webViewEnvironment,
              ).deleteAllCookies();

              if (!mounted) return;

              navigatorKey.currentContext!.go('/home');
              BlocProvider.of<StatusCubit>(
                navigatorKey.currentContext!,
              ).setInitialized(false);
            });
          },
          text: 'Reset',
        ),
      ],
    );
  }
}
