import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';

class CustomBorder extends StatelessWidget {
  const CustomBorder({
    required this.clipper,
    required this.painter,
    required this.child,
    super.key,
    this.padding,
    this.expand = false,
    this.blur = true,
    this.background,
  });

  final CustomClipper<Path> clipper;
  final CustomPainter painter;
  final Widget child;
  final Widget? background;
  final EdgeInsetsGeometry? padding;
  final bool blur;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    if (expand) {
      return ClipPath(
        clipper: clipper,
        child: Stack(
          children: [
            if (background != null)
              Positioned.fill(
                child: background!,
              ),
            if (blur)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.4),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 4,
                      sigmaY: 4,
                      tileMode: TileMode.mirror,
                    ),
                    child: Align(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: painter,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ClipPath(
      clipper: clipper,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.4),
          ),
          child: CustomPaint(
            isComplex: true,
            painter: painter,
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
