import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/features/tutorial/widgets/tutorial_overlay_content.dart';

class TutorialOverlay extends StatefulWidget {
  const TutorialOverlay({
    required this.x,
    required this.y,
    required this.h,
    required this.w,
    super.key,
    this.padding = 0,
  });

  final double x;
  final double y;
  final double h;
  final double w;
  final num padding;

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  double x = 0;
  double y = 0;
  double h = 0;
  double w = 0;

  @override
  void initState() {
    formatPositions();
    super.initState();
  }

  @override
  void didUpdateWidget(TutorialOverlay oldWidget) {
    setState(formatPositions);
    super.didUpdateWidget(oldWidget);
  }

  void formatPositions() {
    h = (h == widget.h + (widget.padding * 2))
        ? widget.h - (widget.padding)
        : widget.h + (widget.padding * 2);
    w = (w == widget.w + (widget.padding * 2))
        ? widget.w - (widget.padding)
        : widget.w + (widget.padding * 2);
    x = (x == widget.x - widget.padding)
        ? widget.x + (widget.padding / 2)
        : widget.x - widget.padding;
    y = (y == widget.y - widget.padding)
        ? widget.y + (widget.padding / 2)
        : widget.y - widget.padding;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.8),
            BlendMode.srcOut,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: () {
                  // removeOverlay();
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
              ),
              Positioned(
                left: x,
                top: y,
                height: h == 0 ? MediaQuery.of(context).size.height : h,
                width: w == 0 ? MediaQuery.of(context).size.width : w,
                //duration: widget.duration,
                child: GestureDetector(
                  onTap: () async {
                    // if (enable) {
                    //   setState(() {
                    //     enable = false;
                    //   });
                    //   timer!.cancel();
                    //   setState(() {
                    //     h = MediaQuery.of(context).size.height;
                    //     w = MediaQuery.of(context).size.width;
                    //     x = 0;
                    //     y = 0;
                    //   });
                    //   await Future.delayed(Duration(seconds: 1));

                    //   widget.onTapNext!();
                    // }
                  },
                  child: Container(
                    height: h == 0 ? MediaQuery.of(context).size.height : h,
                    width: w == 0 ? MediaQuery.of(context).size.width : w,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      //borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        TutorialStepContent(x: x, y: y, h: h, w: w),
      ],
    );
  }
}
