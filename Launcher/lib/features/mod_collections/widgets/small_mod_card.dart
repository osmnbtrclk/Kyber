import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/frosty/widgets/mod_icon.dart';
import 'package:kyber_launcher/features/settings/dialogs/chromium_download_dialog.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class SmallModCard extends StatelessWidget {
  const SmallModCard({
    required this.mod,
    super.key,
    this.name,
  });

  final String? name;
  final FrostyMod? mod;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: decoColor,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 5,
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              padding: const EdgeInsets.only(right: 10),
              child: ModIcon(mod: mod),
            ),
            if (mod == null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  FluentIcons.warning,
                  color: Colors.red,
                  size: 16,
                ),
              ),
            if (mod == null)
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$name',
                      style: const TextStyle(
                        height: 1.1,
                        fontFamily: FontFamily.battlefrontUI,
                        color: kWhiteColor,
                        fontSize: 17,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(
                      ' not found',
                      style: TextStyle(
                        height: 1.1,
                        fontFamily: FontFamily.battlefrontUI,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            if (mod != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${mod!.details.name} (${mod!.details.version})',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        height: 1.1,
                        fontFamily: FontFamily.battlefrontUI,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            if (mod != null)
              SizedBox(
                width: 70,
                child: Text(
                  formatBytes(mod!.size, 1),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontFamily: FontFamily.battlefrontUI,
                    color: kButtonBorder,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
