import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:tinycolor2/tinycolor2.dart';

Path getPath(Size size) {
  final path_0 = Path()
    ..moveTo(4, 0)
    ..lineTo(size.width * 0.06, 0)
    ..cubicTo(size.width * .09, 0, size.width * .08, 12, size.width * .1, 12)
    ..lineTo(size.width * 0.2, 12)
    ..cubicTo(size.width * .225, 12, size.width * .215, 0, size.width * .235, 0)
    ..lineTo((size.width) - 4, 0)
    ..quadraticBezierTo(size.width, 0, size.width, 4)
    ..lineTo(size.width, size.height - 15)
    ..lineTo(size.width - 15, size.height)
    ..lineTo(4, size.height)
    ..quadraticBezierTo(0, size.height, 0, size.height - 4)
    ..lineTo(0, 4)
    ..quadraticBezierTo(0, 0, 4, 0);

  path_0.close();

  return path_0;
}

class TutorialContainerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintStroke1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = kWhiteBackgroundColor.lighten(2);

    canvas.drawPath(getPath(size), paintStroke1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class TutorialContainerBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return getPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
