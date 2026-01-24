import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/shared/ui/borders/custom_border.dart';

class Panel extends StatelessWidget {
  const Panel({required this.child, required this.background, super.key});

  final Widget background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomBorder(
      expand: true,
      background: background,
      clipper: _KyberContainerClipper(),
      painter: _KyberContainerCustomPainter(),
      blur: false,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 10,
          bottom: 10,
          right: 10,
        ),
        child: child,
      ),
    );
  }
}

Path _generateContainerPath(Size size) {
  final path_0 = Path();
  path_0.moveTo(5, 0);
  path_0.lineTo((size.width * 0.50) - 5, 0);
  path_0.quadraticBezierTo(size.width * 0.50, 0, (size.width * 0.50) + 5, 5);
  path_0.quadraticBezierTo(
    (size.width * 0.50) + 10,
    10,
    (size.width * 0.50) + 20,
    10,
  );

  path_0.lineTo(size.width * 0.87 - 5, 10);

  path_0.quadraticBezierTo(
    size.width * 0.87,
    10,
    (size.width * 0.87) + 5,
    5,
  );
  path_0.quadraticBezierTo(
    (size.width * 0.87) + 10,
    0,
    (size.width * 0.87) + 20,
    0,
  );

  path_0.lineTo(size.width - 15, 0);

  path_0.quadraticBezierTo(size.width, 0, size.width, 15);
  path_0.lineTo(size.width, size.height);
  path_0.lineTo(0, size.height);
  path_0.lineTo(0, 15);
  path_0.quadraticBezierTo(0, 0, 15, 0);
  path_0.close();

  return path_0;
}

class _KyberContainerCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintStroke0 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = decoColor;

    canvas.drawPath(_generateContainerPath(size), paintStroke0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _KyberContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return _generateContainerPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
