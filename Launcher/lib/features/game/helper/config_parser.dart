import 'dart:io';

import 'package:kyber_launcher/features/game/models/game_config.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ConfigParser {
  static Future<GameConfig> parseConfig() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final bootConfigFile = File(
      join(
        documentsDir.path,
        'STAR WARS Battlefront II',
        'settings',
        'BootOptions',
      ),
    );
    if (!bootConfigFile.existsSync()) {
      return GameConfig();
    }

    final bootConfig = await bootConfigFile.readAsString();

    final enableDx12 = bootConfig.contains('GstRender.EnableDx12 1');

    return GameConfig(enableDx12: enableDx12);
  }
}
