import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class KyberTableSlider extends StatefulWidget {
  const KyberTableSlider({
    required this.min,
    required this.max,
    required this.value,
    required this.hover,
    super.key,
    this.onChanged,
  });

  final int min;
  final int max;
  final int value;
  final bool hover;
  final void Function(int value)? onChanged;

  @override
  State<KyberTableSlider> createState() => _KyberTableSliderState();
}

class _KyberTableSliderState extends State<KyberTableSlider> {
  bool dragging = false;

  int get calculateWidth => (widget.value / widget.max * 100).toInt();

  double get totalWidth =>
      (calculateWidth.toDouble() / 100);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Listener(
        onPointerDown: (event) {
          final width = event.localPosition.dx;
          final percent = width / context.size!.width;
          final value = (percent * widget.max).toInt();
          if (value >= widget.min && value <= widget.max) {
            widget.onChanged!(value);
            setState(() {});
          }
          setState(() => dragging = true);
        },
        onPointerCancel: (_) => setState(() => dragging = false),
        onPointerUp: (_) => setState(() => dragging = false),
        onPointerMove: (event) {
          if (dragging) {
            final width = event.localPosition.dx;
            final percent = width / context.size!.width;
            final value = (percent * widget.max).toInt();
            if (value >= widget.min && value <= widget.max) {
              widget.onChanged!(value);
              setState(() {});
            }
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: kWhiteBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
              ),
            ),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 50),
              curve: Curves.easeOutCubic,
              widthFactor: totalWidth,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  color: widget.hover || dragging
                      ? kActiveColor
                      : kInactiveColor,
                  boxShadow: [
                    if (widget.hover || dragging)
                      BoxShadow(
                        color: kActiveColor.withOpacity(.15),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                  ],
                ),
              ),
            ),
            //Positioned.fill(
            //  child: Center(
            //    child: Text(
            //      widget.value.toString(),
            //      style: const TextStyle(
            //        fontFamily: FontFamily.battlefrontUI,
            //        fontSize: 20,
            //      ),
            //    ),
            //  ),
            //),
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: <Color>[
                      kWhiteBackgroundColor,
                      if (widget.hover || dragging)
                        kActiveColor
                      else
                        kInactiveColor,
                    ],
                    stops: <double>[totalWidth, totalWidth],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcIn,
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Text(
                    widget.value.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      shadows: widget.hover || dragging
                          ? [
                              Shadow(
                                color: kActiveColor.withOpacity(.5),
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
