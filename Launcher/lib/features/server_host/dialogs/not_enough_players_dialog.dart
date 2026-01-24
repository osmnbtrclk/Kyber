import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class NotEnoughPlayersDialog extends StatefulWidget {
  const NotEnoughPlayersDialog({super.key});

  @override
  State<NotEnoughPlayersDialog> createState() => _NotEnoughPlayersDialogState();
}

class _NotEnoughPlayersDialogState extends State<NotEnoughPlayersDialog> {
  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: const Text('NOT ENOUGH PLAYERS'),
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 300),
      content: const Column(
        children: [
          Text(
            'You are about to start a game with less than 2 players. This can end the round immediately. Are you sure you want to continue?',
          ),
        ],
      ),
      actions: [
        KyberButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'CANCEL',
        ),
        KyberButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          text: 'START',
        ),
      ],
    );
  }
}
