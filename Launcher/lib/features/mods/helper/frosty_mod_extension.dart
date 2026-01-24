import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/features/mods/extensions/frosty_collection_extension.dart';
import 'package:kyber_launcher/features/mods/services/mod_service.dart';
import 'package:kyber_launcher/injection_container.dart';

extension LocalModsExtension on FrostyMod {
  List<FrostyMod> getCollectionMods() {
    if (!isCollection) {
      throw Exception('This is not a collection');
    }

    final mods = <FrostyMod>[];
    final localMods = sl.get<ModService>().mods;
    for (final mod in getMods()!) {
      final localMod = localMods.where(
        (element) {
          return element.filename == mod;
        },
      ).firstOrNull;
      if (localMod != null) {
        mods.add(localMod);
      }
    }

    return mods;
  }
}
