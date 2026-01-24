import 'package:freezed_annotation/freezed_annotation.dart';

part 'raw_mods.freezed.dart';

part 'raw_mods.g.dart';

@freezed
abstract class RawMods with _$RawMods {
  const factory RawMods({
    required String basePath,
    required List<String> modPaths,
  }) = _RawMods;

  factory RawMods.fromJson(Map<String, Object?> json) => _$RawModsFromJson(json);
}
