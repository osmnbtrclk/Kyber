import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/features/mods/services/mod_service.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class PreloadedModsHelper {
  static Future<List<String>> preloadMods() async {
    final modsToPreload = await sl<KyberGRPCService>().launcherClient
        .getPreloadedMods(Empty());
    var installedMods = sl.get<ModService>().mods;
    final installedPreloaded = installedMods
        .where((e) => dirname(e.filename).endsWith('preloadedMods'))
        .toList();

    for (final mod in installedPreloaded) {
      final shouldKeep = modsToPreload.mods.any(
        (m) => m.name == mod.details.name && m.version == mod.details.version,
      );
      if (!shouldKeep) {
        try {
          Logger.root.info(
            'Removing preloaded mod ${mod.details.name} v${mod.details.version}',
          );
          final basePath = ModService.getBasePath();
          await File(join(basePath, mod.filename)).delete();
        } catch (e) {
          Logger.root.warning(
            'Failed to remove preloaded mod ${mod.details.name} v${mod.details.version}: $e',
          );
        }
      }
    }

    for (final mod in modsToPreload.mods.toList()) {
      final localMod = installedMods.firstWhereOrNull(
        (m) => m.details.name == mod.name && m.details.version == mod.version,
      );

      if (localMod != null) {
        continue;
      }

      final modsPath = join(ModService.getBasePath(), 'preloadedMods');
      final uuid = const Uuid().v4();
      await Dio().download(mod.url, join(modsPath, '$uuid.fbmod'));
    }

    await sl<ModService>().refresh();
    installedMods = sl.get<ModService>().mods;

    final preloadedMods = modsToPreload.mods.map((mod) {
      final localMod = installedMods.firstWhere(
        (m) => m.details.name == mod.name && m.details.version == mod.version,
      );
      return localMod.filename;
    });

    return preloadedMods.toList();
  }
}
