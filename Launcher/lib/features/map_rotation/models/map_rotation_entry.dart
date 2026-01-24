import 'package:hive_ce/hive.dart';

part 'map_rotation_entry.g.dart';

@HiveType(typeId: 21)
class MapRotationEntry extends HiveObject {
  MapRotationEntry({
    required this.map,
    required this.mode,
    this.isCustom = false,
  });

  @HiveField(0)
  final String map;

  @HiveField(1)
  final String mode;

  @HiveField(2)
  final bool isCustom;
  /*

  const factory MapRotationEntry({
    @HiveField(0) required String map,
    @HiveField(1) required String mode,
  }) = _MapRotationMap;

  const MapRotationEntry._();

  factory MapRotationEntry.fromJson(Map<String, dynamic> json) => _$MapRotationEntryFromJson(json);
   */
}
