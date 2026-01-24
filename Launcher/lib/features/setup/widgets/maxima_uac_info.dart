import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class MaximaUACInfo extends StatelessWidget {
  const MaximaUACInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maxima Installation',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: FontFamily.battlefrontUI,
          ),
        ),
        SizedBox(height: 10),
        Text(
          """
Maxima is an unofficial in-development replacement for the EA App - and eventually a whole new game launcher - we'll talk more about this in a future update.
          
To maintain complete transparency, the source code for Maxima will be made public nearer to the launch of KYBER V2, as will the entire stack of source code for KYBER V2.""",
          style: TextStyle(
            fontFamily: FontFamily.battlefrontUI,
            color: kWhiteColor,
          ),
        ),
        SizedBox(height: 10),
        Divider(
          style: DividerThemeData(horizontalMargin: EdgeInsets.zero),
        ),
        SizedBox(height: 10),
        Text(
          'You will now be prompted to install Maxima, and log in with your EA account.',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: FontFamily.battlefrontUI,
          ),
        ),
      ],
    );
  }
}
