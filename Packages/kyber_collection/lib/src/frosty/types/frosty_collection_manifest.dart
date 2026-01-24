import 'package:freezed_annotation/freezed_annotation.dart';

part 'frosty_collection_manifest.freezed.dart';

part 'frosty_collection_manifest.g.dart';

@freezed
abstract class FrostyCollectionManifest with _$FrostyCollectionManifest {
  const factory FrostyCollectionManifest({
    required String link,
    required String title,
    required String author,
    required String version,
    required String description,
    required String category,
    required List<String> mods,
    required List<String> modVersions,
  }) = _FrostyCollectionManifest;

  factory FrostyCollectionManifest.fromJson(Map<String, Object?> json) => _$FrostyCollectionManifestFromJson(json);
}
