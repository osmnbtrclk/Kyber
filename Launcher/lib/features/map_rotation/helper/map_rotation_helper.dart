import 'package:kyber_launcher/features/kyber/models/modes.dart';
import 'package:kyber_launcher/features/kyber/services/map_helper.dart';
import 'package:kyber_launcher/features/map_rotation/models/map_rotation_entry.dart';
import 'package:logging/logging.dart';

class MapRotationHelper {
  MapRotationHelper._();

  static String exportRotation(List<MapRotationEntry> rotation) {
    final sb = StringBuffer();

    for (final entry in rotation) {
      sb.writeln('${entry.mode}:${entry.map}');
    }

    return sb.toString();
  }

  static List<MapRotationEntry> loadRotationFromFile(String data) {
    final maps = <MapRotationEntry>[];

    if (data.isEmpty) {
      throw Exception('File is empty');
    }

    if (modes.where((element) => data.contains(element.mode)).isEmpty) {
      throw Exception('File does not contain any valid gamemode');
    }

    for (final line in data.split('\n')) {
      if (line.isEmpty || !line.contains(' ')) {
        continue;
      }

      final mode = line.split(':').last;
      final map = line.split(':').first;

      final convMode = modes.where((x) => x.mode == mode).firstOrNull;
      if (convMode == null) {
        Logger.root.warning('Could not find mode for $mode');
        continue;
      }

      final convMap = MapHelper.getMapsForMode(
        mode,
      ).where((x) => x.map == map).firstOrNull;
      if (convMap == null) {
        continue;
      }

      maps.add(MapRotationEntry(map: map, mode: mode));
    }

    return maps;
  }
}
