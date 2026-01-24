import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/shared/ui/borders/custom_border.dart';
import 'package:kyber_launcher/shared/ui/borders/kyber_events_border.dart';

class KyberEventContainer extends StatelessWidget {
  const KyberEventContainer({
    required this.child,
    super.key,
    this.padding,
    this.expand = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return CustomBorder(
      expand: expand,
      clipper: KyberEventsCustomBorderClipper(),
      painter: KyberEventsCustomBorderPainter(),
      padding: padding ?? const EdgeInsets.all(10),
      child: child,
    );
  }
}
