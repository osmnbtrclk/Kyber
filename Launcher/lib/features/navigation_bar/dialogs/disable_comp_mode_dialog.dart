import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class DisableCompModeDialog extends StatefulWidget {
  const DisableCompModeDialog({super.key});

  @override
  State<DisableCompModeDialog> createState() => _DisableCompModeDialogState();
}

class _DisableCompModeDialogState extends State<DisableCompModeDialog> {
  @override
  Widget build(BuildContext context) {
    return const KyberContentDialog(
      title: Text('COMPATIBILITY MODE'),
      content: Text(
        "We've fixed a crash that previously required compatibility mode to be enabled.\n\nPlease disable Windows 7 compatibility mode to ensure the launcher works correctly.",
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
      constraints: BoxConstraints(maxWidth: 500, maxHeight: 300),
    );
  }
}
