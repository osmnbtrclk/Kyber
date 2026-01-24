import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class StrokeText extends StatelessWidget {
  const StrokeText(
    this.text, {
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    required this.strokeColor,
    required this.strokeWidth,
    super.key,
  }) : super();
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color strokeColor;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: FontFamily.battlefrontUI,
            height: 1,
            foreground: Paint()
              ..strokeWidth = strokeWidth
              ..color = strokeColor
              ..style = PaintingStyle.stroke,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: FontFamily.battlefrontUI,
            fontSize: fontSize,
            fontWeight: fontWeight,
            height: 1,
            foreground: Paint()..color = color,
          ),
        ),
      ],
    );
  }
}
