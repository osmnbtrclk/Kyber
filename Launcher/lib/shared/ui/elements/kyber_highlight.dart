import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class KyberHighlight extends StatelessWidget {
  const KyberHighlight({required this.body, super.key});

  final String body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: kActiveColor),
            bottom: BorderSide(color: kActiveColor),
          ),
        ),
        child: Center(
          child: Text(
            body,
            style: TextStyle(
              color: kActiveColor,
              fontSize: 12,
              height: 1,
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
