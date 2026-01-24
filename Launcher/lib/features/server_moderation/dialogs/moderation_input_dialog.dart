import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/shared/ui/ui.dart';

class ModerationInputDialog extends StatefulWidget {
  const ModerationInputDialog({super.key});

  @override
  State<ModerationInputDialog> createState() => _ModerationInputDialogState();
}

class _ModerationInputDialogState extends State<ModerationInputDialog> {
  String value = '';

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
      title: Text('REASON'.toUpperCase()),
      content: Column(
        children: [
          const Text(
            'Enter the reason:',
            style: TextStyle(color: kWhiteColor),
          ),
          const SizedBox(height: 8),
          KyberInput(
            placeholder: 'Optional',
            onChanged: (value) {
              this.value = value;
            },
          ),
        ],
      ),
      actions: [
        KyberButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'Cancel',
        ),
        KyberButton(
          onPressed: () {
            Navigator.of(context).pop(value);
          },
          text: 'Submit',
        ),
      ],
    );
  }
}
