import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/services/app_settings.dart';
import 'package:kyber_launcher/features/kyber/models/mode.dart';
import 'package:kyber_launcher/features/kyber/services/map_helper.dart';
import 'package:kyber_launcher/features/mods/services/level_declaration_service.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:kyber_launcher/main.dart';

class HostCollectionCubit extends Cubit<HostCollectionState> {
  HostCollectionCubit()
    : super(HostCollectionState(ModCollectionMetaData.noMods(), [])) {
    var selectedCollection = ModCollectionMetaData.noMods();
    final savedCollection = Preferences.hostServer.collection;
    if (savedCollection != null) {
      selectedCollection =
          collectionBox.get(savedCollection) ?? selectedCollection;
    }

    selectCollection(selectedCollection);
  }

  void selectCollection(ModCollectionMetaData collection) {
    final modes = _getModes(collection);
    emit(HostCollectionState(collection, modes));
    Preferences.hostServer.collection = collection.localId;
  }

  List<KyberMap> getMaps(String mode) {
    final maps = MapHelper.getMapsForMode(mode);
    final collection = state.selectedModCollection;
    final customMaps = sl.get<LevelDeclarationService>().getMapsForMode(
      mode: mode,
      collection: collection,
    );

    return <KyberMap>[...maps, ...customMaps];
  }

  List<Mode> _getModes(ModCollectionMetaData collection) {
    final customModes = sl.get<LevelDeclarationService>().getModesForCollection(
      collection,
      includeDefaults: true,
    );

    return customModes.sorted((a, b) => b.maxPlayers.compareTo(a.maxPlayers));
  }
}

class HostCollectionState {
  HostCollectionState(this.selectedModCollection, this.modes);

  final List<Mode> modes;

  final ModCollectionMetaData selectedModCollection;

  Mode getMode(String id) {
    return modes.firstWhereOrNull(
          (mode) => mode.mode == id || mode.alternativeModes.contains(id),
        ) ??
        Mode(
          mode: id,
          name: 'Custom Mode',
          maps: [],
          maxPlayers: 0,
          image: null,
        );
  }
}
