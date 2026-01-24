import 'dart:convert';
import 'dart:io';

import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/features/kyber/models/maps.dart' as mp;
import 'package:kyber_launcher/features/kyber/models/mode.dart';
import 'package:kyber_launcher/features/kyber/models/modes.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

class KyberMapService {
  final _logger = Logger('custom_rotation');
  static final List<Mode> _gameModes = List.from(modes);
  static final List<Map<String, String>> _maps = List.from(mp.maps);

  static List<Mode> get gameModes => List.unmodifiable(_gameModes);

  static List<Map<String, String>> get maps => List.unmodifiable(_maps);

  Future<KyberMapService> getInstance() async {
    await _load();
    return this;
  }

  Future<void> _load() async {
    return;
    final file = File(
      join(FileHelper.getLauncherDirectory().path, 'custom_maps.json'),
    );
    if (!file.existsSync()) {
      return;
    }

    _logger.info('Loading custom maps from ${file.path}');
    final json = jsonDecode(await file.readAsString());
    if (json is! Map<String, dynamic>) {
      _logger.warning('Invalid JSON format');
      return;
    }

    final gameModes = json['GamemodeOverrides'] as List<dynamic>?;
    final levelOverrides = json['LevelOverrides'] as List<dynamic>?;
    final overrides = levelOverrides
        ?.map(
          (e) => MapOverride(
            map: e['LevelId'] as String,
            name: e['Name'] as String,
            modes: List<String>.from(e['ModeIds'] as List<dynamic>),
          ),
        )
        .toList();

    for (final item in ((overrides ?? []) as List<MapOverride>)) {
      if (_maps.where((e) => e['map'] == item.map).isNotEmpty) {
        _logger.warning('Map with id ${item.map} already exists');
        continue;
      }

      _maps.add({'map': item.map, 'name': item.name});
    }

    for (final item in gameModes ?? []) {
      if (modes.where((e) => e.mode == item['ModeId']).isNotEmpty) {
        _logger.warning('Game mode with id ${item['ModeId']} already exists');
        continue;
      }

      final mode = Mode(
        mode: item['ModeId'] as String,
        name: item['Name'] as String,
        maps:
            overrides
                ?.where((e) => e.modes.contains(item['ModeId']))
                .map((e) => e.map)
                .toList() ??
            [],
        maxPlayers: item['PlayerCount'] as int,
      );
      _logger.info(
        'Loaded custom mode ${mode.name} with ${mode.maps.length} maps',
      );
      _gameModes.add(mode);
    }

    for (final item in List<Mode>.from(modes)) {
      final modeOverrides = overrides!.where(
        (e) => e.modes.contains(item.mode),
      );
      if (modeOverrides.isEmpty) {
        continue;
      }

      for (final override in modeOverrides) {
        if (item.maps.contains(override.map)) {
          if (item.mapOverrides == null) {
            item.mapOverrides = [];
          } else {
            item.mapOverrides!.removeWhere((e) => e.map == override.map);
            item.mapOverrides!.add(override);
          }
        } else {
          item.maps.add(override.map);
        }
      }
      _logger.info(
        'Loaded ${modeOverrides.length} custom maps for mode ${item.name}',
      );
      _gameModes
        ..removeWhere((e) => e.mode == item.mode)
        ..add(item);
    }
  }
}
