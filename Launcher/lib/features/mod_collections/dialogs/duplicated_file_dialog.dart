import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class DuplicatedFileDialog extends StatefulWidget {
  const DuplicatedFileDialog({super.key});

  @override
  State<DuplicatedFileDialog> createState() => _DuplicatedFileDialogState();
}

class _DuplicatedFileDialogState extends State<DuplicatedFileDialog> {
  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: Text('Duplicated Mod'.toUpperCase()),
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 400),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'The mod you are trying to add already exists in your selected collection. This can happen if the mod is part of a Frosty Collection.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text('Are you sure you want to add it again?'),
        ],
      ),
      actions: [
        KyberButton(
          onPressed: () => Navigator.of(context).pop(),
          text: 'Cancel',
        ),
        KyberButton(
          onPressed: () => Navigator.of(context).pop(true),
          text: 'Add',
        ),
      ],
    );
  }
}
