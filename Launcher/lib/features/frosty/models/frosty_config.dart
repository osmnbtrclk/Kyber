class FrostyConfig {
  FrostyConfig({
    required this.games,
    required this.globalOptions,
  });

  factory FrostyConfig.fromJson(Map<String, dynamic> json) => FrostyConfig(
    games:
        Map<String, dynamic>.from(
          json['Games'] as Map<String, dynamic>? ?? {},
        ).map(
          (k, v) => MapEntry<String, Game>(
            k,
            Game.fromJson(v as Map<String, dynamic>),
          ),
        ),
    globalOptions: GlobalOptions.fromJson(
      json['GlobalOptions'] as Map<String, dynamic>? ?? {},
    ),
  );

  Map<String, Game> games;
  GlobalOptions globalOptions;

  Map<String, dynamic> toJson() => {
    'Games': Map<String, dynamic>.from(
      games,
    ).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    'GlobalOptions': globalOptions.toJson(),
  };
}

class Game {
  Game({
    required this.gamePath,
    required this.bookmarkDb,
    required this.options,
    this.packs,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
    gamePath: json['GamePath'] as String,
    bookmarkDb: json['BookmarkDb'] as String,
    options: Options.fromJson(json['Options'] as Map<String, dynamic>? ?? {}),
    packs: Map.from(json['Packs'] as Map<String, dynamic>? ?? {}),
  );

  String gamePath;
  String bookmarkDb;
  Options options;
  Map<String, String>? packs;

  Map<String, dynamic> toJson() => {
    'GamePath': gamePath,
    'BookmarkDb': bookmarkDb,
    'Options': options.toJson(),
    'Packs': packs,
  };
}

class Options {
  Options({
    this.selectedPack,
    this.commandLineArgs,
    this.platform,
    this.platformLaunchingEnabled,
  });

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    selectedPack: json['SelectedPack'] as String?,
    commandLineArgs: json['CommandLineArgs'] as String?,
    platform: json['Platform'] as String?,
    platformLaunchingEnabled: json['PlatformLaunchingEnabled'] as bool?,
  );

  String? selectedPack;
  String? commandLineArgs;
  String? platform;
  bool? platformLaunchingEnabled;

  Map<String, dynamic> toJson() => {
    'SelectedPack': selectedPack,
    'CommandLineArgs': commandLineArgs,
    'Platform': platform,
    'PlatformLaunchingEnabled': platformLaunchingEnabled,
  };
}

class GlobalOptions {
  GlobalOptions({
    required this.useDefaultProfile,
    required this.defaultProfile,
  });

  factory GlobalOptions.fromJson(Map<String, dynamic> json) => GlobalOptions(
    useDefaultProfile: json['UseDefaultProfile'] as bool?,
    defaultProfile: json['DefaultProfile'] as String?,
  );

  bool? useDefaultProfile;
  String? defaultProfile;

  Map<String, dynamic> toJson() => {
    'UseDefaultProfile': useDefaultProfile,
    'DefaultProfile': defaultProfile,
  };
}
