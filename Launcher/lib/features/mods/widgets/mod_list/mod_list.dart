import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/mods/helper/frosty_mod_extension.dart';
import 'package:kyber_launcher/features/mods/services/mod_service.dart';
import 'package:kyber_launcher/features/mods/widgets/mod_list/mod_list_entry.dart';
import 'package:kyber_launcher/injection_container.dart';

class ModList extends StatefulWidget {
  const ModList({
    required this.mods,
    required this.onModSelected,
    required this.activeMod,
    required this.onModTap,
    required this.selectedMods,
    super.key,
  });

  final List<FrostyMod> mods;
  final FrostyMod? activeMod;
  final Set<String> selectedMods;
  final void Function(FrostyMod mod) onModTap;
  final void Function(FrostyMod mod) onModSelected;

  @override
  State<ModList> createState() => _ModListState();
}

class _ModListState extends State<ModList> {
  int? hoverIndex;
  int? expandedIndex;
  List<FrostyMod> expandedChildren = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ModList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mods != widget.mods) {
      setState(() {
        hoverIndex = null;
        expandedIndex = null;
        expandedChildren.clear();
      });
    }
  }

  Map<String, List<FrostyMod>> filterByCategory() {
    final mods = widget.mods;
    final filteredMods = <String, List<FrostyMod>>{};

    for (final mod in mods) {
      if (filteredMods.containsKey(mod.details.category)) {
        filteredMods[mod.details.category]!.add(mod);
      } else {
        filteredMods[mod.details.category] = [mod];
      }
    }

    return filteredMods;
  }

  void toggleExpand(int index, FrostyMod mod) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
        expandedChildren.clear();
      } else {
        expandedIndex = index;
        expandedChildren = mod.getCollectionMods();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            addAutomaticKeepAlives: false,
            (context, index) {
              if (index == 0) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 2,
                  color: hoverIndex == 0 ? kActiveColor : kWhiteBackgroundColor,
                );
              }

              index--;
              if (expandedIndex != null &&
                  index > expandedIndex! &&
                  index <= expandedIndex! + expandedChildren.length) {
                final childMod = expandedChildren[index - expandedIndex! - 1];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () => widget.onModTap(childMod),
                      child: ModListEntry(
                        onExpandCollection: () => toggleExpand(index, childMod),
                        mod: childMod,
                        selected: widget.selectedMods.contains(
                          childMod.filename,
                        ),
                        index: index,
                        isLastSubItem:
                            index == expandedIndex! + expandedChildren.length,
                        subIndex: index - expandedIndex! - 1,
                        hovered: hoverIndex == index,
                        expanded: false,
                        onSelected: () {
                          widget.onModSelected(childMod);
                        },
                        onHover: (value) {
                          setState(() => hoverIndex = value ? index : null);
                        },
                      ),
                    ),
                    if (index - expandedIndex! == expandedChildren.length)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 2,
                        color: index + 1 == hoverIndex || hoverIndex == index
                            ? kActiveColor
                            : kWhiteBackgroundColor,
                      )
                    else
                      Row(
                        children: [
                          AnimatedContainer(
                            width: 106,
                            duration: const Duration(milliseconds: 150),
                            height: 2,
                            color:
                                index + 1 == hoverIndex || hoverIndex == index
                                ? kActiveColor
                                : kWhiteBackgroundColor,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 1.5,
                              width: 20,
                              child: CustomPaint(
                                painter: _CustomBorder(
                                  index + 1 == hoverIndex || hoverIndex == index
                                      ? kActiveColor
                                      : kWhiteBackgroundColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              }

              final adjustedIndex =
                  (expandedIndex != null && index > expandedIndex!)
                  ? (index - expandedChildren.length)
                  : index;
              final mod = widget.mods.elementAt(adjustedIndex);

              final child = GestureDetector(
                onTap: () => widget.onModTap(mod),
                child: ModListEntry(
                  onExpandCollection: () => toggleExpand(adjustedIndex, mod),
                  mod: mod,
                  selected: widget.selectedMods.contains(mod.filename),
                  index: adjustedIndex,
                  isLastSubItem: false,
                  hovered: hoverIndex == index,
                  expanded: expandedIndex == adjustedIndex,
                  onSelected: () => widget.onModSelected(mod),
                  subIndex: expandedIndex == index ? -1 : null,
                  onHover: (value) {
                    setState(() => hoverIndex = value ? index : null);
                  },
                ),
              );

              return Column(
                children: [
                  child,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 2,
                    color: hoverIndex == index + 1 || hoverIndex == index
                        ? kActiveColor
                        : kWhiteBackgroundColor,
                  ),
                ],
              );
            },
            childCount: widget.mods.length + 2 + (expandedChildren.length - 1),
          ),
        ),
      ],
    );
  }
}

class _CustomBorder extends CustomPainter {
  _CustomBorder(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double dashHeight = 4;
    const double dashSpace = 4;
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    final stopX = size.width;
    while (startX < stopX) {
      canvas.drawLine(
        Offset(startX, 0.75),
        Offset(startX + dashHeight, 0.75),
        paint,
      );
      startX += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
