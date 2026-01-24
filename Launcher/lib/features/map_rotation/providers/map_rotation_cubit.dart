import 'package:collection/collection.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/features/kyber/models/mode.dart';
import 'package:kyber_launcher/features/kyber/models/modes.dart';
import 'package:kyber_launcher/features/kyber/services/map_helper.dart';
import 'package:kyber_launcher/features/map_rotation/models/map_rotation_entry.dart';
import 'package:kyber_launcher/features/mods/services/level_declaration_service.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:kyber_launcher/main.dart';
import 'package:replay_bloc/replay_bloc.dart';

class MapRotationCubit extends ReplayCubit<MapRotationState> {
  MapRotationCubit() : super(MapRotationState(maps: [])) {
    if (mapRotationBox.containsKey('current')) {
      mapRotationBox
          .get('current')!
          .cast<MapRotationEntry>()
          .forEach(state.maps.add);
    } else {
      const initMode = 'PlanetaryBattles';
      final maps = MapHelper.getMapsForMode(initMode);
      state.maps.add(MapRotationEntry(map: maps.first.map, mode: initMode));
    }
  }

  void clear() {
    emit(MapRotationState(maps: []));
  }

  void shuffle() {
    final maps = List<MapRotationEntry>.from(state.maps)..shuffle();

    emit(MapRotationState(maps: maps));
  }

  void setMaps(List<MapRotationEntry> maps) {
    emit(MapRotationState(maps: maps));
  }

  void removeMap(MapRotationEntry map) {
    final list = List<MapRotationEntry>.from(state.maps)..remove(map);
    emit(MapRotationState(maps: list));
  }

  void addGameMode(Mode mode, ModCollectionMetaData collection) {
    final customMode =
        sl
            .get<LevelDeclarationService>()
            .getModesForCollection(collection)
            .firstWhereOrNull((e) => e.mode == mode.mode) ??
        mode;

    final list = List<MapRotationEntry>.from(state.maps);
    if (customMode.isCustom) {
      final maps = sl.get<LevelDeclarationService>().getMapsForMode(
        mode: customMode.mode,
        collection: collection,
      );

      for (final map in maps) {
        list.add(
          MapRotationEntry(map: map.map, mode: map.mode!, isCustom: true),
        );
      }
    } else {
      final mode = modes.firstWhere((e) => e.mode == customMode.mode);
      for (final map in mode.maps) {
        list.add(MapRotationEntry(map: map, mode: customMode.mode));
      }
    }

    emit(MapRotationState(maps: list));
  }

  void addMap(MapRotationEntry map) {
    final list = List<MapRotationEntry>.from(state.maps)..add(map);
    emit(MapRotationState(maps: list));
  }

  void moveMaps(
    int oldStartIndex,
    int oldEndIndex,
    int newStartIndex,
    int newEndIndex,
  ) {
    final list = List<MapRotationEntry>.from(state.maps);

    final items = list.sublist(oldStartIndex, oldEndIndex + 1);
    list.removeRange(oldStartIndex, oldEndIndex + 1);
    if (newStartIndex > list.length) {
      list.addAll(items);
    } else {
      list.insertAll(newStartIndex, items);
    }

    emit(MapRotationState(maps: list));
  }

  void moveMap(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final items = List<MapRotationEntry>.from(state.maps);
    final item = items.removeAt(oldIndex);
    if (newIndex > items.length) {
      items.add(item);
    } else {
      items.insert(newIndex, item);
    }
    emit(MapRotationState(maps: items));
  }
}

class MapRotationState {
  MapRotationState({
    required this.maps,
    /*, this.selectedGamemode*/
  });

  //int? selectedGamemode;
  List<MapRotationEntry> maps;
}
