import 'dart:convert';
import 'dart:io';

import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/features/frosty/models/frosty_config.dart';
import 'package:kyber_launcher/features/frosty/models/frosty_pack.dart';
import 'package:kyber_launcher/features/mods/helper/mod_helper.dart';
import 'package:kyber_launcher/main.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class FrostyMigrationHelper {
  static Future<FrostyConfig> readFrostyConfig({
    required Directory frostyDirectory,
  }) {
    final file = File('${frostyDirectory.path}/config.json');
    final newConfig = File(
      '${Platform.environment['LOCALAPPDATA']}\\Frosty\\manager_config.json',
    );
    if (newConfig.existsSync()) {
      return Future.value(
        FrostyConfig.fromJson(
          jsonDecode(newConfig.readAsStringSync()) as Map<String, dynamic>,
        ),
      );
    } else if (file.existsSync()) {
      return Future.value(
        FrostyConfig.fromJson(
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
        ),
      );
    }

    throw Exception('Frosty config not found');
  }

  static Future<void> importFrostyPacks({
    required List<FrostyPack> packs,
  }) async {
    for (final pack in packs) {
      final collection = ModCollectionMetaData(
        localId: const Uuid().v4(),
        title: pack.packName,
        mods: pack.mods.map((e) {
          final localMod = ModHelper.getModByFileName(
            join('frosty_import', e.filename),
          );

          return localMod?.toCollectionMod() ??
              CollectionMod(
                name: '-',
                version: '-',
                link: '',
                filename: join('frosty_import', e.filename),
              );
        }).toList(),
      );

      await collectionBox.put(collection.localId, collection);
    }
  }
}
