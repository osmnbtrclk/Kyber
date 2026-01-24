import 'package:freezed_annotation/freezed_annotation.dart';

part 'frosty_custom_data.g.dart';

@JsonSerializable()
class CustomFrostyData {
  @JsonKey(name: 'version')
  int version;
  @JsonKey(name: 'maps')
  List<MapElement> maps;
  @JsonKey(name: 'modes')
  List<MapElement> modes;
  @JsonKey(name: 'modeMappings')
  Map<String, String>? modeMappings;
  @JsonKey(name: 'modeNameOverrides')
  Map<String, String>? modeNameOverrides;

  CustomFrostyData({
    required this.version,
    required this.maps,
    required this.modes,
    this.modeMappings,
    this.modeNameOverrides,
  });

  factory CustomFrostyData.fromJson(Map<String, dynamic> json) => _$CustomFrostyDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomFrostyDataToJson(this);
}

@JsonSerializable()
class MapElement {
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'image')
  String image;
  @JsonKey(name: 'supportedModes')
  List<String>? supportedModes;
  @JsonKey(name: 'maxPlayers')
  int? maxPlayers;

  MapElement({
    required this.name,
    required this.id,
    required this.image,
    this.supportedModes,
    this.maxPlayers,
  });

  factory MapElement.fromJson(Map<String, dynamic> json) => _$MapElementFromJson(json);

  Map<String, dynamic> toJson() => _$MapElementToJson(this);
}
