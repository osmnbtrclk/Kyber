import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/shared/ui/utils/background_blur.dart';

class KyberCard extends StatelessWidget {
  const KyberCard({
    required this.child,
    this.padding,
    this.borderRadius = kDefaultOuterBorderRadius,
    this.borderColor,
    super.key,
  });

  final EdgeInsets? padding;
  final Color? borderColor;
  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(borderRadius),
      child: BackgroundBlur(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.2),
            borderRadius: .circular(borderRadius),
            border: .all(
              color: borderColor ?? decoColor,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: .circular(borderRadius - 2),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(8),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class CardSection extends StatelessWidget {
  const CardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 2,
      width: double.infinity,
      child: ColoredBox(color: decoColor),
    );
  }
}

class VCardSection extends StatelessWidget {
  const VCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 2,
      height: double.infinity,
      child: ColoredBox(color: decoColor),
    );
  }
}

class KyberContainer extends StatefulWidget {
  const KyberContainer({
    required this.child,
    super.key,
    this.padding,
    this.constraints,
  });

  final BoxConstraints? constraints;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  State<KyberContainer> createState() => _KyberContainerState();
}

class _KyberContainerState extends State<KyberContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      constraints: widget.constraints,
      height: 200,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: .85,
        heightFactor: .9,
        child: ClipPath(
          clipper: _KyberContainerClipper(),
          child: ClipRRect(
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _KyberContainerCustomPainter(),
                  ),
                ),
                Padding(
                  padding:
                      widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Path _generateContainerPath(Size size) {
  final path_0 = Path();
  path_0.moveTo(5, 0);
  path_0.lineTo((size.width * 0.60) - 5, 0);
  path_0.quadraticBezierTo(size.width * 0.60, 0, (size.width * 0.60) + 5, 10);
  path_0.quadraticBezierTo(
    (size.width * 0.60) + 10,
    20,
    (size.width * 0.60) + 20,
    20,
  );

  path_0.lineTo(size.width * 0.87 - 5, 20);

  path_0.quadraticBezierTo(
    size.width * 0.87,
    20,
    (size.width * 0.87) + 5,
    10,
  );
  path_0.quadraticBezierTo(
    (size.width * 0.87) + 10,
    0,
    (size.width * 0.87) + 20,
    0,
  );

  path_0.lineTo(size.width - 5, 0);

  path_0.quadraticBezierTo(size.width, 0, size.width, 5);
  path_0.lineTo(size.width, size.height - 5);

  path_0.quadraticBezierTo(
    size.width,
    size.height,
    size.width - 5,
    size.height,
  );

  path_0.lineTo(size.width * 0.875 + 5, size.height);
  path_0.quadraticBezierTo(
    size.width * 0.875,
    size.height,
    (size.width * 0.875) - 5,
    size.height - 10,
  );
  path_0.quadraticBezierTo(
    (size.width * 0.875) - 10,
    size.height - 20,
    (size.width * 0.875) - 20,
    size.height - 20,
  );

  path_0.lineTo(size.width * 0.125 + 5, size.height - 20);
  path_0.quadraticBezierTo(
    size.width * 0.125,
    size.height - 20,
    (size.width * 0.125) - 5,
    size.height - 10,
  );
  path_0.quadraticBezierTo(
    (size.width * 0.125) - 10,
    size.height,
    (size.width * 0.125) - 20,
    size.height,
  );

  path_0.lineTo(5, size.height);
  path_0.quadraticBezierTo(0, size.height, 0, size.height - 5);
  path_0.lineTo(0, 5);
  path_0.quadraticBezierTo(0, 0, 5, 0);
  path_0.close();

  return path_0;
}

class _KyberContainerCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintStroke0 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = kInactiveColor.withOpacity(.4);

    canvas.drawPath(_generateContainerPath(size), paintStroke0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _KyberContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return _generateContainerPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
