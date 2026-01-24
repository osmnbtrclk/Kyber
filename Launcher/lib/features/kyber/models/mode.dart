import 'dart:typed_data';

List<Mode> modesFromJson(List<Map<String, dynamic>> data) =>
    List<Mode>.from(data.map(Mode.fromJson));

class Mode {
  Mode({
    required this.mode,
    required this.name,
    required this.maps,
    required this.maxPlayers,
    this.mapOverrides,
    this.image,
    this.isCustom = false,
    this.alternativeModes = const [],
  });

  factory Mode.customMode() => Mode(
    mode: 'custom',
    name: 'Custom Mode',
    maxPlayers: -1,
    maps: [],
  );

  factory Mode.fromJson(Map<String, dynamic> json) => Mode(
    maxPlayers: json['maxPlayers'] == null ? -1 : json['maxPlayers'] as int,
    mode: json['mode'] as String,
    isCustom: json['isCustom'] == null ? false : json['isCustom'] as bool,
    name: json['name'] as String,
    maps: List<String>.from((json['maps'] as List<dynamic>).map((x) => x)),
    mapOverrides: json['mapOverrides'] == null
        ? null
        : List<MapOverride>.from(
            (json['mapOverrides'] as List<Map<String, dynamic>>).map(
              MapOverride.fromJson,
            ),
          ),
  );

  String mode;
  String name;
  int maxPlayers;
  bool isCustom;
  Uint8List? image;
  List<String> alternativeModes;
  List<String> maps;
  List<MapOverride>? mapOverrides;

  Map<String, dynamic> toJson() => {
    'isCustom': isCustom,
    'mode': mode,
    'maxPlayers': maxPlayers,
    'name': name,
    'maps': List<dynamic>.from(maps.map((x) => x)),
    'mapOverrides': mapOverrides == null
        ? null
        : List<dynamic>.from(mapOverrides?.map((x) => x.toJson()) ?? []),
  };
}

class MapOverride {
  MapOverride({
    required this.map,
    required this.name,
    this.modes = const [],
  });

  factory MapOverride.fromJson(Map<String, dynamic> json) => MapOverride(
    map: json['map'] as String,
    name: json['name'] as String,
    modes: json['modes'] == null
        ? []
        : List<String>.from(json['modes'].map((x) => x) as List<dynamic>),
  );

  String map;
  String name;
  List<String> modes;

  Map<String, dynamic> toJson() => {
    'map': map,
    'name': name,
    'modes': List<dynamic>.from(modes.map((x) => x)),
  };
}
