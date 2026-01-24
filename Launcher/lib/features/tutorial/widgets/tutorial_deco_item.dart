import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';

class TutorialDecoItem extends StatefulWidget {
  const TutorialDecoItem({required this.type, super.key});

  final int type;

  @override
  State<TutorialDecoItem> createState() => _TutorialDecoItemState();
}

class _TutorialDecoItemState extends State<TutorialDecoItem> {
  bool fill = false;

  @override
  void initState() {
    changeStyle();
    super.initState();
  }

  void changeStyle() {
    if (!mounted) return;

    setState(() => fill = !fill);
    Future.delayed(
      Duration(seconds: 3 + Random().nextInt(4)),
      changeStyle,
    );
  }

  double get width {
    switch (widget.type) {
      case 0:
        return 7;
      case 1:
        return 22;
      case 2:
        return 10;
      default:
        return 0;
    }
  }

  double get height {
    switch (widget.type) {
      case 0:
      case 1:
        return 7;
      case 2:
        return 10;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: widget.type == 2 ? BorderRadius.circular(20) : null,
        border: Border.all(
          color: decoColor,
          width: widget.type == 2 ? 1.2 : 2,
        ),
        color: fill ? decoColor : Colors.transparent,
      ),
    );
  }
}
