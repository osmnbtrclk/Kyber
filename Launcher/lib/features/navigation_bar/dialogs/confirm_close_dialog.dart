import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';
import 'package:window_manager/window_manager.dart';

class ConfirmCloseDialog extends StatefulWidget {
  const ConfirmCloseDialog({super.key});

  @override
  State<ConfirmCloseDialog> createState() => _ConfirmCloseDialogState();
}

class _ConfirmCloseDialogState extends State<ConfirmCloseDialog> {
  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: const Text('EXIT LAUNCHER'),
      content: const Text(
        'Are you sure you want to close this window? This will also close the game.',
      ),
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 300),
      actions: [
        KyberButton(
          text: 'Cancel',
          onPressed: Navigator.of(context).pop,
        ),
        KyberButton(
          text: 'Close',
          onPressed: windowManager.destroy,
        ),
      ],
    );
  }
}
