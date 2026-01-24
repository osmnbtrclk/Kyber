import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/main.dart';
import 'package:replay_bloc/replay_bloc.dart';

class ModCollectionCreatorCubit extends ReplayCubit<ModCollectionCreatorState> {
  ModCollectionCreatorCubit() : super(ModCollectionCreatorState());

  void setCollection(ModCollectionMetaData collection) {
    emit(state.copyWith(collection: collection));
    clearHistory();
  }

  void addMod(FrostyMod mod) {
    final mods = List<CollectionMod>.from(state.collection!.mods)
      ..add(mod.toCollectionMod());

    emit(state.copyWith(collection: state.collection!.copyWith(mods: mods)));
    //_saveCollection();
  }

  void moveMod(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final collection = state.collection!;
    final mods = List<CollectionMod>.from(collection.mods);
    final mod = mods.removeAt(oldIndex);
    mods.insert(newIndex, mod);

    emit(state.copyWith(collection: collection.copyWith(mods: mods)));
    //_saveCollection();
  }

  void removeMod(int index) {
    final mods = List<CollectionMod>.from(state.collection!.mods);
    mods.removeAt(index);

    emit(state.copyWith(collection: state.collection!.copyWith(mods: mods)));
    //_saveCollection();
  }

  void _saveCollection() {
    collectionBox.put(state.collection!.localId, state.collection!);
  }
}

class ModCollectionCreatorState {
  ModCollectionCreatorState({this.collection});

  ModCollectionMetaData? collection;

  ModCollectionCreatorState copyWith({ModCollectionMetaData? collection}) {
    return ModCollectionCreatorState(
      collection: collection ?? this.collection,
    );
  }
}
