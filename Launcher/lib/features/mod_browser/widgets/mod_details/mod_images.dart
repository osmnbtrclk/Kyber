import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';
import 'package:nexus_bridge/nexus_bridge.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class ModImages extends StatefulWidget {
  const ModImages({
    required this.images,
    required this.id,
    this.onImageSelected,
    this.selectedImage,
    this.controller,
    this.scrollController,
    super.key,
  });

  final int? selectedImage;
  final void Function(int)? onImageSelected;
  final String id;
  final List<WSNexusModImage> images;
  final ListController? controller;
  final ScrollController? scrollController;

  @override
  State<ModImages> createState() => _ModImagesState();
}

class _ModImagesState extends State<ModImages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SuperListView.builder(
      listController: widget.controller,
      controller: widget.scrollController,
      itemCount: widget.images.length,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      itemBuilder: (context, index) {
        final item = widget.images[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (index != 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomPaint(
                  painter: DashedLinePainter(),
                  child: const SizedBox(height: 2),
                ),
              ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ButtonBuilder(
                onClick: widget.onImageSelected != null
                    ? () => widget.onImageSelected!(index)
                    : () {},
                builder: (context, hovered) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hovered
                            ? kActiveColor
                            : widget.selectedImage == index
                            ? kInactiveColor
                            : decoColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        item.url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 4;
    const double dashSpace = 4;
    double startX = 0;
    final paint = Paint()
      ..color = kWhiteBackgroundColor
      ..strokeWidth = 2;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
