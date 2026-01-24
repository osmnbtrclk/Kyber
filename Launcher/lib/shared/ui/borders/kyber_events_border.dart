import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';

class KyberEventsCustomBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintStroke0 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = kWhiteBackgroundColor;

    final path_0 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path_0, paintStroke0);

    final paintStroke1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = kWhiteBackgroundColor;

    final path_1 = Path()
      ..moveTo(0, 0)
      ..lineTo(20, 0)
      ..moveTo(size.width - 20, 0)
      ..lineTo(size.width, 0)
      ..moveTo(0, size.height)
      ..lineTo(20, size.height)
      ..moveTo(size.width - 20, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path_1, paintStroke1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class KyberEventsCustomBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path_0 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0);

    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
