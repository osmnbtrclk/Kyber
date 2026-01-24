import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';

class KyberTabBar extends StatefulWidget {
  const KyberTabBar({
    required this.tabs,
    required this.selectedIndex,
    this.onChanged,
    this.direction = Axis.horizontal,
    super.key,
  });

  final Axis direction;
  final List<Widget> tabs;
  final ValueChanged<int>? onChanged;
  final int selectedIndex;

  @override
  State<KyberTabBar> createState() => _KyberTabBarState();
}

class _KyberTabBarState extends State<KyberTabBar> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in widget.tabs) ...[
            ButtonBuilder(
              builder: (context, hovered) {
                final color = hovered
                    ? kActiveColor
                    : widget.selectedIndex == widget.tabs.indexOf(item)
                    ? kInactiveColor
                    : decoColor;
                return AnimatedContainer(
                  margin: kDefaultButtonPadding,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7.5,
                  ).copyWith(top: 10),
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      kDefaultInnerBorderRadius,
                    ),
                    border: Border.all(
                      color: color,
                      width: kDefaultBorder.width,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    style: const TextStyle(
                      fontFamily: FontFamily.battlefrontUI,
                      fontSize: 15,
                      height: 0.9,
                    ),
                    child: item,
                  ),
                );
              },
              onClick: () {
                if (widget.onChanged == null) {
                  return;
                }

                widget.onChanged!(widget.tabs.indexOf(item));
              },
            ),
          ],
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: ColoredBox(
        color: Colors.black.withOpacity(.6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < widget.tabs.length; i++)
              Expanded(
                child: Builder(
                  builder: (context) {
                    final color = _hoveredIndex == i
                        ? kActiveColor
                        : widget.selectedIndex == i
                        ? kInactiveColor
                        : decoColor;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.onChanged != null
                                ? () => widget.onChanged!(i)
                                : null,
                            child: MouseRegion(
                              onEnter: widget.onChanged != null
                                  ? (event) => setState(() => _hoveredIndex = i)
                                  : null,
                              onExit: widget.onChanged != null
                                  ? (event) =>
                                        setState(() => _hoveredIndex = -1)
                                  : null,
                              cursor: SystemMouseCursors.click,
                              child: AnimatedContainer(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: i == 0
                                        ? BorderSide(color: color, width: 2)
                                        : BorderSide.none,
                                    top: BorderSide(color: color, width: 2),
                                    bottom: BorderSide(color: color, width: 2),
                                    right: i == widget.tabs.length - 1
                                        ? BorderSide(color: color, width: 2)
                                        : BorderSide.none,
                                  ),
                                  borderRadius:
                                      i == 0 || i == widget.tabs.length - 1
                                      ? BorderRadius.only(
                                          topLeft: i == 0
                                              ? const Radius.circular(6)
                                              : Radius.zero,
                                          bottomLeft: i == 0
                                              ? const Radius.circular(6)
                                              : Radius.zero,
                                          topRight: i == widget.tabs.length - 1
                                              ? const Radius.circular(6)
                                              : Radius.zero,
                                          bottomRight:
                                              i == widget.tabs.length - 1
                                              ? const Radius.circular(6)
                                              : Radius.zero,
                                        )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                duration: const Duration(milliseconds: 200),
                                child: Padding(
                                  padding: EdgeInsets.zero,
                                  child: DefaultTextStyle.merge(
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                    child: widget.tabs.elementAt(i),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (i != widget.tabs.length - 1)
                          _Divider(
                            index: i,
                            hoveredIndex: _hoveredIndex,
                            selectedIndex: widget.selectedIndex,
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({
    required this.index,
    required this.hoveredIndex,
    required this.selectedIndex,
  });

  final int index;
  final int hoveredIndex;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 2,
      color: (index == hoveredIndex || hoveredIndex - 1 == index)
          ? kActiveColor
          : (index == selectedIndex || selectedIndex - 1 == index)
          ? kInactiveColor
          : decoColor,
      duration: const Duration(milliseconds: 200),
    );
  }
}
