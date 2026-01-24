import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/services/app_settings.dart';
import 'package:kyber_launcher/features/mods/widgets/collection_list/collection_icon.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/main.dart';
import 'package:kyber_launcher/shared/ui/buttons/button.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';
import 'package:kyber_launcher/shared/ui/elements/dropdown/kyber_dropdown.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_tab_bar.dart';

class FrostyPackSelectorDialog extends StatefulWidget {
  const FrostyPackSelectorDialog({super.key});

  @override
  State<FrostyPackSelectorDialog> createState() =>
      _FrostyPackSelectorDialogState();
}

class _FrostyPackSelectorDialogState extends State<FrostyPackSelectorDialog> {
  bool withoutMods = false;
  bool isExpanded = false;
  List<ModCollectionMetaData> collections = collectionBox.values.toList();
  ModCollectionMetaData? selectedCollection;

  @override
  void initState() {
    selectedCollection = collections.firstOrNull;

    if (Preferences.general.lastSelectedGameCollection != null) {
      final collection = collections.firstWhereOrNull(
        (element) =>
            element.localId == Preferences.general.lastSelectedGameCollection,
      );
      if (collection != null) {
        selectedCollection = collection;
      }
    }

    withoutMods = Preferences.general.gameWithoutMods;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: Text('Start Game'.toUpperCase()),
      constraints: const BoxConstraints(
        maxHeight: 550,
        maxWidth: 650,
      ),
      content: SizedBox(
        width: 550,
        child: Column(
          children: [
            const Text('PLAY WITH OR WITHOUT MODS'),
            const Text(
              'Select an option to load the game with or without mods.',
              style: TextStyle(
                color: kWhiteColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 35,
              child: KyberTabBar(
                onChanged: (index) {
                  Preferences.general.gameWithoutMods = index == 1;
                  setState(() {
                    withoutMods = index == 1;
                  });
                },
                tabs:
                    [
                          'WITH MODS',
                          'WITHOUT MODS',
                        ]
                        .map(
                          (e) => Text(
                            e,
                            style: const TextStyle(
                              fontFamily: FontFamily.battlefrontUI,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        )
                        .toList(),
                selectedIndex: withoutMods ? 1 : 0,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (!withoutMods) ...[
              const Text('SELECT A MOD COLLECTION'),
              const Text(
                'WARNING: Mods may unexpectedly interfere with normal online gameplay.',
                style: TextStyle(
                  color: kWhiteColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              KyberDropdown<ModCollectionMetaData>(
                onChanged: (value) =>
                    setState(() => selectedCollection = value),
                itemBuilder: (DropdownItem<dynamic> item) {
                  item as DropdownItem<ModCollectionMetaData>;
                  return Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CollectionIcon(collection: item.value),
                      ),
                      Container(width: 2, height: 40, color: decoColor),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            item.value.title,
                            style: const TextStyle(
                              fontFamily: FontFamily.battlefrontUI,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                items: collections
                    .map((e) => DropdownItem(value: e, label: e.title))
                    .toList(),
                selectedItem: selectedCollection,
                placeholder: 'SELECT A COLLECTION',
              ),
            ],
          ],
        ),
      ),
      actions: [
        KyberButton(
          text: 'CANCEL',
          onPressed: () => Navigator.of(context).pop(),
        ),
        KyberButton(
          text: 'LAUNCH',
          onPressed: () {
            Navigator.of(context).pop(
              withoutMods
                  ? ModCollectionMetaData.noMods()
                  : selectedCollection ?? ModCollectionMetaData.noMods(),
            );
          },
        ),
      ],
    );
  }
}

class _CustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path_0 = Path();
    path_0.moveTo(0, 18);
    path_0.lineTo(size.width, 18);

    path_0.moveTo(0, size.height - 18);
    path_0.lineTo(size.width, size.height - 18);
    // dash border on the left side. 10 pixels long, 4 pixels apart
    for (var i = 0; i < size.height; i += 20) {
      path_0.moveTo(12, i.toDouble());
      path_0.lineTo(12, i.toDouble() + 10);
    }

    for (var i = 0; i < size.height; i += 20) {
      path_0.moveTo(size.width - 60, i.toDouble());
      path_0.lineTo(size.width - 60, i.toDouble() + 10);
    }

    final paint_0 = Paint()
      ..color = kGrayColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
