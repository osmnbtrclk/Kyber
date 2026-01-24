import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class UnsavedChangesDialog extends StatelessWidget {
  const UnsavedChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: const Text('Unsaved Changes'),
      content: const Text(
        'You have unsaved changes. Do you want to save them?',
      ),
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
      actions: [
        KyberButton(
          text: 'CANCEL',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        KyberButton(
          text: 'DISCARD',
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
