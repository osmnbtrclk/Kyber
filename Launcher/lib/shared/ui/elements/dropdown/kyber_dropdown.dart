import 'package:flutter/material.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/cards/kyber_container.dart';
import 'package:kyber_launcher/shared/ui/utils/background_blur.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';

class DropdownItem<T> {
  DropdownItem({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

class KyberDropdown<T> extends StatefulWidget {
  const KyberDropdown({
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemBuilder,
    super.key,
    this.placeholder,
  });

  final List<DropdownItem<T>> items;
  final T? selectedItem;
  final String? placeholder;
  final ValueChanged<T> onChanged;
  final Widget Function(DropdownItem<T> item) itemBuilder;

  @override
  _KyberDropdownState<T> createState() => _KyberDropdownState<T>();
}

class _KyberDropdownState<T> extends State<KyberDropdown<T>>
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
                                  widget.onChanged(widget.items[index].value);
                                  _closeDropdown();
                                },
                                builder: (context, hovered) {
                                  return AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 150),
                                    style: TextStyle(
                                      fontFamily: FontFamily.battlefrontUI,
                                      color: hovered
                                          ? kActiveColor
                                          : Colors.white,
                                    ),
                                    child: ColoredBox(
                                      color: Colors.black38,
                                      child: SizedBox(
                                        child: widget.itemBuilder.call(
                                          widget.items[index],
                                        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                    widget.selectedItem != null
                        ? widget.items
                              .firstWhere(
                                (element) =>
                                    element.value == widget.selectedItem,
                              )
                              .label
                        : widget.placeholder ?? 'SELECT AN ITEM',
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
