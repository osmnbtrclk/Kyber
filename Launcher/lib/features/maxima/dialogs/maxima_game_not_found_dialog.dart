import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';

class MaximaGameNotFoundDialog extends StatelessWidget {
  const MaximaGameNotFoundDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: const Text('Game not owned'),
      constraints: const BoxConstraints(maxWidth: 650, maxHeight: 400),
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The account you are logging in with does not own the game STAR WARS™ Battlefront™ II (2017).',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 15,
            ),
          ),
          Text(
            'Please make sure that your EA account owns the game before continuing.',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'If you own the game on Steam, make sure to link your Steam account to your EA account.',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 15,
            ),
          ),
        ],
      ),
      actions: [
        KyberButton(text: 'Okay', onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}
