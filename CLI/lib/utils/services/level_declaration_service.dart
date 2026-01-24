import 'dart:typed_data';

import 'package:kyber/kyber.dart';
import 'package:kyber_cli/utils/mod_helper.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:path/path.dart';

class LevelDeclarationService {
  final Map<String, ModEntry> _modEntries = {};

  void set(Map<String, ModEntry> modEntries) {
    _modEntries
      ..clear()
      ..addAll(modEntries);
  }

  List<String> _expandModPaths(List<FrostyMod> mods) {
    final paths = <String>[];
    for (final mod in mods) {
      if (!mod.isCollection) {
        paths.add(mod.filename);
      } else {
        paths.addAll(ModHelper.getCollectionMods(mod));
      }
    }

    return paths;
  }

  KyberMap? getMapByMode({
    required String map,
    required String mode,
    required List<FrostyMod> mods,
  }) {
    for (final filename in mods.map((e) => e.filename)) {
      final modEntry = _modEntries[filename];
      if (modEntry == null) {
        continue;
      }

      for (final customMap in modEntry.maps) {
        if (customMap.map != map || !customMap.supportedModes.contains(mode)) {
          continue;
        }

        return KyberMap(
          name: customMap.name,
          map: customMap.map,
          mode: mode,
          isCustom: true,
        );
      }
    }

    return null;
  }

  String? getModeName({
    required String mode,
    required List<FrostyMod> mods,
  }) {
    String? modeName;
    for (final filename in mods.map((e) => e.filename)) {
      final modEntry = _modEntries[filename];
      if (modEntry == null) {
        continue;
      }

      if (modEntry.mapNameOverrides.containsKey(mode)) {
        modeName = modEntry.mapNameOverrides[mode];
      }

      for (final customMode in modEntry.modes) {
        if (customMode.mode == mode) {
          modeName = customMode.name;
        }
      }
    }

    return modeName;
  }
}

class ModEntry {
  ModEntry(this.maps, this.modes, this.modeMappings, this.mapNameOverrides);

  final List<CustomMap> maps;
  final List<CustomMode> modes;
  final Map<String, String> modeMappings;
  final Map<String, String> mapNameOverrides;
}

class CustomMode {
  CustomMode(this.name, this.mode, this.maxPlayers, this.image);

  final String name;
  final String mode;
  final int maxPlayers;
  final Uint8List? image;
}

class CustomMap {
  CustomMap(this.name, this.map, this.supportedModes, this.image);

  final String name;
  final String map;
  final List<String> supportedModes;
  final Uint8List? image;
}
