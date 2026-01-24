import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/cards/kyber_container.dart';
import 'package:kyber_launcher/shared/ui/utils/background_blur.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';

class DropdownOption {
  DropdownOption({
    required this.label,
    required this.icon,
    required this.onClick,
    this.baseColor,
  });

  final String label;
  final Widget icon;
  final VoidCallback onClick;
  final Color? baseColor;
}

class KyberDropdownSelector extends StatefulWidget {
  const KyberDropdownSelector({
    required this.items,
    required this.placeholder,
    super.key,
  });

  final List<DropdownOption> items;
  final String placeholder;

  @override
  State<KyberDropdownSelector> createState() => _KyberDropdownSelectorState();
}

class _KyberDropdownSelectorState extends State<KyberDropdownSelector>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() {
      isOpen = true;
    });
  }

  void _closeDropdown() {
    _animationController.reverse().then((value) {
      _removeOverlay();
      setState(() {
        isOpen = false;
      });
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              width: size.width,
              left: position.dx,
              top: position.dy + size.height,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(kDefaultInnerBorderRadius),
                  ),
                  child: BackgroundBlur(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: kDefaultBorder,
                          left: kDefaultBorder,
                          right: kDefaultBorder,
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(kDefaultInnerBorderRadius),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(
                            kDefaultInnerBorderRadius - 2,
                          ),
                        ),
                        child: SizeTransition(
                          sizeFactor: _animation,
                          axisAlignment: 1,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 300,
                            ),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const CardSection(),
                              itemCount: widget.items.length,
                              itemBuilder: (context, index) => ButtonBuilder(
                                onClick: () {
                                  widget.items[index].onClick();
                                  _closeDropdown();
                                },
                                builder: (context, hovered) {
                                  final item = widget.items[index];
                                  return MouseRegion(
                                    child: SizedBox(
                                      height: 35,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const .symmetric(
                                              horizontal: 10,
                                            ),
                                            child: item.icon,
                                          ),
                                          const VCardSection(),
                                          Expanded(
                                            child: Container(
                                              padding: const .symmetric(
                                                horizontal: 10,
                                              ),
                                              alignment: Alignment.centerLeft,
                                              child: AnimatedDefaultTextStyle(
                                                duration: const Duration(
                                                  milliseconds: 150,
                                                ),
                                                style: TextStyle(
                                                  fontFamily: FontFamily.battlefrontUI,
                                                  color: hovered
                                                      ? kActiveColor
                                                      : item.baseColor ??
                                                            Colors.white,
                                                  fontSize: 15,
                                                  height: 1.2,
                                                ),
                                                child: SizedBox(
                                                  child: AutoSizeText(
                                                    widget.items[index].label,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ButtonBuilder(
        onClick: _toggleDropdown,
        builder: (context, hovered) {
          return AnimatedContainer(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: Colors.black38,
              border: Border.all(
                color: hovered ? kActiveColor : kDefaultBorder.color,
                width: kDefaultBorder.width,
              ),
              borderRadius: !isOpen
                  ? BorderRadius.circular(kDefaultInnerBorderRadius)
                  : const BorderRadius.vertical(
                      top: Radius.circular(kDefaultInnerBorderRadius),
                    ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    widget.placeholder,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Icon(
                  isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
