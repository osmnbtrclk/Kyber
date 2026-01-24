import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class ChangeBackgroundDialog extends StatefulWidget {
  const ChangeBackgroundDialog({super.key});

  @override
  State<ChangeBackgroundDialog> createState() => _ChangeBackgroundDialogState();
}

class _ChangeBackgroundDialogState extends State<ChangeBackgroundDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: const Text('Change Background'),
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 300),
      content: TextBox(
        controller: controller,
        placeholder: 'https://example.com/image.png',
      ),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Button(
          onPressed: () {
            Navigator.of(context).pop('');
          },
          child: const Text('Reset to Default'),
        ),
        Button(
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
