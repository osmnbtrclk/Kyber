import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber_launcher/features/nexusmods/services/nexusmods_service.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:nexus_bridge/nexus_bridge.dart';

class ModCubit extends Cubit<ModState> {
  ModCubit(this.id) : super(const ModInitial()) {
    fetchMod();
  }

  final String id;

  Future<void> fetchMod({bool showLoading = true}) async {
    if (showLoading) {
      emit(const ModLoading());
    }

    //final results = await Future.wait([
    //  sl.get<NexusModsService>().nexusBridge.apiClient.getMod(bfGameId, int.parse(id)),
    //  sl.get<NexusModsService>().nexusBridge.fetchMod(id),
    //]);

    //print((results.first as NexusMod).description);
    //var description = await convertBbcode(input: (results.first as NexusMod).description.replaceAll('<br />', ''));
    //description = description.replaceAll('&ltbr /&gt', '');

    //emit(
    //  ModLoaded(
    //    mod: results.first as NexusMod,
    //    webData: results.last as WSNexusMod,
    //    description: description,
    //  ),
    //);
  }

  Future<void> endorseMod() async {
    try {
      await sl.get<NexusModsService>().nexusBridge.apiClient.endorseMod(
        bfGameId,
        int.parse(id),
      );
      await cacheOptions.store?.deleteFromPath(
        RegExp(
          'https://api.nexusmods.com/v1/games/starwarsbattlefront22017/mods/$id.json',
        ),
      );
      await fetchMod(showLoading: false);
    } catch (e) {
      emit(ModError(e.toString()));
    }
  }
}

abstract class ModState {
  const ModState();
}

class ModInitial extends ModState {
  const ModInitial();
}

class ModLoading extends ModState {
  const ModLoading();
}

class ModError extends ModState {
  const ModError(this.message);

  final String message;
}

class ModLoaded extends ModState {
  const ModLoaded({
    required this.mod,
    required this.webData,
    required this.description,
  });

  final NexusMod mod;
  final String description;
  final WSNexusMod webData;
}
