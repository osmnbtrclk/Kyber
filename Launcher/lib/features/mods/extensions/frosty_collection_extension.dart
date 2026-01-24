import 'package:collection/collection.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/features/mods/services/mod_service.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:path/path.dart';

extension FrostyCollectionExtension on FrostyMod {
  List<String>? getMods() {
    final collectionDirName = dirname(filename);
    if (collectionDirName == '.') {
      return mods;
    }

    return mods?.map((e) => join(dirname(filename), e)).toList();
  }

  bool isCorrupted() {
    return getMods()!
        .map(
          (e) => sl
              .get<ModService>()
              .mods
              .firstWhereOrNull((element) => element.filename == e)
              ?.toCollectionMod(),
        )
        .contains(null);
  }
}
