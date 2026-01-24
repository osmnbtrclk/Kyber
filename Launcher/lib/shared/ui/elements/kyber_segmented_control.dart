import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';

// value class
class KyberSegmentedControlItem<T> {
  const KyberSegmentedControlItem({required this.title, required this.value});

  final String title;
  final T value;
}

class KyberSegmentedControl<T> extends StatefulWidget {
  const KyberSegmentedControl({
    required this.selectedIndex,
    required this.onSelected,
    required this.items,
    super.key,
  });

  final int selectedIndex;
  final List<KyberSegmentedControlItem<T>> items;
  final ValueChanged<int> onSelected;

  @override
  State<KyberSegmentedControl<T>> createState() =>
      _KyberSegmentedControlState<T>();
}

class _KyberSegmentedControlState<T> extends State<KyberSegmentedControl<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: kDefaultAllBorder,
        borderRadius: BorderRadius.circular(kDefaultInnerBorderRadius),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        spacing: 5,
        children: [
          for (var i = 0; i < widget.items.length; i++)
            ButtonBuilder(
              onClick: () => widget.onSelected(i),
              builder: (context, hovered) {
                return AnimatedContainer(
                  width: 120,
                  height: 30,
                  duration: kDefaultDuration,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: hovered
                        ? kActiveColor
                        : i == widget.selectedIndex
                        ? kWhiteColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      kDefaultInnerBorderRadius - 3,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: AnimatedDefaultTextStyle(
                    duration: kDefaultDuration,
                    style: TextStyle(
                      fontFamily: FontFamily.battlefrontUI,
                      fontSize: 15,
                      color: hovered || i == widget.selectedIndex
                          ? Colors.black
                          : Colors.white,
                    ),
                    child: Text(
                      widget.items[i].title.toUpperCase(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
