import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/elements/header/kyber_header.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';

class ModListHeader extends StatelessWidget {
  const ModListHeader({
    required this.selectedMods,
    required this.modCount,
    required this.onAllSelected,
    super.key,
  });

  final Set<String> selectedMods;
  final int modCount;
  final void Function(bool selected) onAllSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(
          vertical: kDefaultBorder,
        ),
      ),
      child: KyberHeader(
        headerPadding: EdgeInsets.zero,
        title: 'MY MODS',
        customTitle: ButtonBuilder(
          onClick: () => onAllSelected(selectedMods.length < modCount),
          builder: (_, __) => ColoredBox(
            color: Colors.transparent,
            child: Center(
              child: RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                  text: '${selectedMods.length}',
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontFamily: FontFamily.battlefrontUI,
                    fontSize: 14,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        headerLength: 51,
        sections: const [
          ExpandedHeaderSection(children: [SizedBox(width: 7.5), Text('NAME')]),
          FixedWidthHeaderSection(
            width: 160,
            children: [Text('CATEGORY')],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          FixedWidthHeaderSection(
            width: 78,
            children: [Text('SIZE')],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          FixedWidthHeaderSection(
            width: 120,
            children: [Text('TYPE')],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          FixedWidthHeaderSection(
            width: 57,
            children: [Text('ADD')],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );
  }
}
