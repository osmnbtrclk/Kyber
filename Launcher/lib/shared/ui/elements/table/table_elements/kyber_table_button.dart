import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class KyberTableButton extends StatefulWidget {
  const KyberTableButton({
    required this.onPressed,
    this.text,
    this.widget,
    required this.hover,
    super.key,
  });

  final bool hover;
  final String? text;
  final Widget? widget;
  final void Function()? onPressed;

  @override
  State<KyberTableButton> createState() => _KyberTableButtonState();
}

class _KyberTableButtonState extends State<KyberTableButton> {
  @override
  Widget build(BuildContext context) {
    assert(
      widget.text != null || widget.widget != null,
      'Either text or widget must be provided',
    );

    final color = widget.onPressed == null
        ? kWhiteBackgroundColor
        : kActiveColor;
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 100),
              style: TextStyle(
                fontFamily: FontFamily.battlefrontUI,
                color: widget.onPressed == null
                    ? color
                    : widget.hover
                    ? kActiveColor
                    : Colors.white,
                shadows: widget.hover
                    ? [
                        Shadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: widget.text != null
                  ? Text(
                      widget.text!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : widget.widget!,
            ),
          ),
          const SizedBox(width: 15),
          Icon(
            FluentIcons.play_solid,
            size: 20,
            color: widget.onPressed == null
                ? color
                : widget.hover
                ? color
                : kWhiteColor,
          ),
        ],
      ),
    );
  }
}
