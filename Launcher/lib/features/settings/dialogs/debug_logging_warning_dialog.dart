import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class DebugLoggingWarningDialog extends StatelessWidget {
  const DebugLoggingWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: Text('Debug Logging'.toUpperCase()),
      constraints: const BoxConstraints(
        maxWidth: 600,
        maxHeight: 400,
      ),
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Debug logging is enabled.',
          ),
          SizedBox(height: 20),
          Text(
            'Attention: Debug logging logs sensitive information. Please do not share the logs publicly',
          ),
        ],
      ),
      actions: [
        KyberButton(
          onPressed: () => Navigator.pop(context),
          text: 'Okay',
        ),
      ],
    );
  }
}
