import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kyber_launcher/features/stats/models/stats_class.dart';
import 'package:kyber_launcher/features/stats/models/stats_hero.dart';
import 'package:kyber_launcher/features/stats/models/stats_vehicle.dart';

enum Unit {
  infantry,
  aerial,
  enforcer,
  infiltrator,
  heroes,
}

enum Vehicle {
  armour,
  artillery,
  speeder,
  //turrets,
  //mounts,
}

enum StarFighter {
  fighter,
  interceptor,
  bomber,
  hero,
}

class EntityStats {
  EntityStats({
    required this.portrait,
    required this.name,
    required this.timePlayed,
    this.rank,
  });

  final String name;
  final int? rank;
  final Duration timePlayed;
  final ImageProvider portrait;
}

class PlayerStats {
  PlayerStats({
    required this.totalPlaytime,
    required this.playerRank,
    required this.totalKills,
    required this.totalDeaths,
    required this.totalScore,
    required this.playedGames,
    required this.totalWins,
    required this.totalLosses,
    required this.totalDraws,
    required this.totalAssists,
    required this.heroes,
    required this.classes,
    required this.vehicles,
    required this.unitStats,
    required this.vehicleStats,
    required this.suicides,
    required this.eliminations,
    required this.starFighterStats,
  });

  factory PlayerStats.fromMap(Map<String, double> statsMap) {
    return PlayerStats(
      playerRank: statsMap['c___gr_ghva']?.toInt() ?? 0,
      totalKills: statsMap['c___k_gatt']?.toInt() ?? 0,
      totalDeaths: statsMap['c___d_gatt']?.toInt() ?? 0,
      totalAssists: statsMap['c___ka_gatt']?.toInt() ?? 0,
      totalScore: statsMap['c___pdax_gatt']?.toInt() ?? 0,
      eliminations: statsMap['c___ka_gatt']?.toInt() ?? 0,
      suicides: statsMap['c___s_gatt']?.toInt() ?? 0,
      playedGames: statsMap['c_aoc__oxc_gatt']?.toInt() ?? 0,
      totalWins: statsMap['c_gaw__oxc_gatt']?.toInt() ?? 0,
      totalLosses: statsMap['c_gal__oxc_gatt']?.toInt() ?? 0,
      totalDraws: statsMap['c_gad__oxc_gatt']?.toInt() ?? 0,
      heroes: _loadHeroes(statsMap),
      classes: _loadClasses(statsMap),
      vehicles: _loadVehicles(statsMap),
      totalPlaytime: Duration(seconds: statsMap['c___sap_gatt']?.toInt() ?? 0),
      unitStats: getUnitStats(statsMap),
      vehicleStats: getVehicleStats(statsMap),
      starFighterStats: getStarfighterStats(statsMap),
    );
  }

  final Duration totalPlaytime;
  final int playerRank;
  final int totalKills;
  final int totalDeaths;
  final int totalAssists;
  final int totalScore;
  final int playedGames;
  final int totalWins;
  final int totalLosses;
  final int totalDraws;
  final int suicides;
  final int eliminations;
  final List<HeroCharacter> heroes;
  final List<ClassCharacter> classes;
  final List<VehicleCharacter> vehicles;
  final Map<Unit, EntityStats> unitStats;
  final Map<Vehicle, EntityStats> vehicleStats;
  final Map<StarFighter, EntityStats> starFighterStats;

  static Map<Unit, EntityStats> getUnitStats(Map<String, double> statsMap) {
    final classes = _loadClasses(statsMap);
    final heroes = _loadHeroes(statsMap);

    final infantry = EntityStats(
      portrait: classes.first.getThumbnailProvider(),
      name: 'Infantry',
      timePlayed: classes.fold(
        Duration.zero,
        (previousValue, element) =>
            previousValue + element.statistics.timePlayed,
      ),
    );

    final aerialStats = classes.firstWhere((e) => e.type == GameClass.aerial);
    final aerial = EntityStats(
      portrait: aerialStats.getThumbnailProvider(),
      name: 'Aerial',
      rank: aerialStats.statistics.rank,
      timePlayed: aerialStats.statistics.timePlayed,
    );

    final enforcerStats = classes.firstWhere(
      (e) => e.type == GameClass.enforcer,
    );
    final enforcer = EntityStats(
      portrait: enforcerStats.getThumbnailProvider(),
      name: 'Enforcer',
      rank: enforcerStats.statistics.rank,
      timePlayed: enforcerStats.statistics.timePlayed,
    );

    final infiltratorStats = classes.firstWhere(
      (e) => e.type == GameClass.infiltrator,
    );
    final infiltrator = EntityStats(
      portrait: infiltratorStats.getThumbnailProvider(),
      name: 'Infiltrator',
      rank: infiltratorStats.statistics.rank,
      timePlayed: infiltratorStats.statistics.timePlayed,
    );

    final heroesStats = EntityStats(
      portrait: heroes.first.getThumbnailProvider(),
      name: 'Heroes',
      timePlayed: heroes.fold(
        Duration.zero,
        (previousValue, element) =>
            previousValue + element.statistics.timePlayed,
      ),
    );

    return {
      Unit.infantry: infantry,
      Unit.aerial: aerial,
      Unit.enforcer: enforcer,
      Unit.infiltrator: infiltrator,
      Unit.heroes: heroesStats,
    };
  }

  static Map<StarFighter, EntityStats> getStarfighterStats(
    Map<String, double> statsMap,
  ) {
    final vehicles = _loadVehicles(statsMap);

    final armoredVehicles = vehicles.firstWhere(
      (e) => e.type == GameVehicle.fighter,
    );
    final armored = EntityStats(
      portrait: armoredVehicles.getThumbnailProvider(),
      name: 'Fighter',
      rank: armoredVehicles.statistics.rank,
      timePlayed: armoredVehicles.statistics.timePlayed,
    );

    final artilleryVehicles = vehicles.firstWhere(
      (e) => e.type == GameVehicle.interceptor,
    );
    final artillery = EntityStats(
      portrait: artilleryVehicles.getThumbnailProvider(),
      name: 'Interceptor',
      rank: artilleryVehicles.statistics.rank,
      timePlayed: artilleryVehicles.statistics.timePlayed,
    );

    final speederVehicles = vehicles.firstWhere(
      (e) => e.type == GameVehicle.bomber,
    );
    final speeder = EntityStats(
      portrait: speederVehicles.getThumbnailProvider(),
      name: 'Bomber',
      rank: speederVehicles.statistics.rank,
      timePlayed: speederVehicles.statistics.timePlayed,
    );

    return {
      StarFighter.fighter: armored,
      StarFighter.interceptor: artillery,
      StarFighter.bomber: speeder,
    };
  }

  static Map<Vehicle, EntityStats> getVehicleStats(
    Map<String, double> statsMap,
  ) {
    final vehicles = _loadVehicles(statsMap);

    final armoredVehicles = vehicles.firstWhere(
      (e) => e.type == GameVehicle.armor,
    );
    final armored = EntityStats(
      portrait: armoredVehicles.getThumbnailProvider(),
      name: 'Armored',
      rank: armoredVehicles.statistics.rank,
      timePlayed: armoredVehicles.statistics.timePlayed,
    );

    final artilleryVehicles = vehicles.firstWhere(
      (e) => e.type == GameVehicle.artillery,
    );
    final artillery = EntityStats(
      portrait: artilleryVehicles.getThumbnailProvider(),
      name: 'Artillery',
      rank: artilleryVehicles.statistics.rank,
      timePlayed: artilleryVehicles.statistics.timePlayed,
    );

    final speederVehicles = vehicles.firstWhere(
      (e) => e.type == GameVehicle.speeder,
    );
    final speeder = EntityStats(
      portrait: speederVehicles.getThumbnailProvider(),
      name: 'Speeder',
      rank: speederVehicles.statistics.rank,
      timePlayed: speederVehicles.statistics.timePlayed,
    );

    return {
      Vehicle.armour: armored,
      Vehicle.artillery: artillery,
      Vehicle.speeder: speeder,
    };
  }

  List<StatsObject<Object>> getCharactersByPlaytime() {
    final characters = <StatsObject<Object>>[...heroes, ...classes, ...vehicles]
      ..sort(
        (a, b) => b.statistics.timePlayed.compareTo(a.statistics.timePlayed),
      );

    return characters;
  }

  double getWinRate() {
    if (totalWins + totalLosses + totalDraws == 0) return 0;

    return (totalWins / (totalWins + totalLosses + totalDraws)) * 100;
  }

  double getKd() =>
      totalDeaths == 0 ? totalKills.toDouble() : totalKills / totalDeaths;

  int get getRoundsPlayed => totalWins + totalLosses + totalDraws;

  static List<HeroCharacter> _loadHeroes(Map<String, double> statsMap) {
    return GameHero.values.map((hero) {
      return HeroCharacter(hero: hero, statsMap: statsMap);
    }).toList();
  }

  static List<ClassCharacter> _loadClasses(Map<String, double> statsMap) {
    return GameClass.values.map((gameClass) {
      return ClassCharacter(gameClass: gameClass, statsMap: statsMap);
    }).toList();
  }

  static List<VehicleCharacter> _loadVehicles(Map<String, double> statsMap) {
    return GameVehicle.values.map((vehicle) {
      return VehicleCharacter(vehicle: vehicle, statsMap: statsMap);
    }).toList();
  }
}

class StatsObject<T> {
  StatsObject({
    required this.type,
    required Map<String, double> statsMap,
  }) {
    statistics = Statistics.fromMap(
      statsMap,
      prefix,
      isVehicle: type is GameVehicle,
    );
  }

  final T type;
  late final Statistics statistics;

  String get name {
    if (type is GameHero) return (type as GameHero).name;
    if (type is GameClass) return (type as GameClass).name;
    if (type is GameVehicle) return (type as GameVehicle).name;
    return '';
  }

  String get prefix {
    if (type is GameHero) return (type as GameHero).prefix;
    if (type is GameClass) return (type as GameClass).prefix;
    if (type is GameVehicle) return (type as GameVehicle).prefix;
    return '';
  }

  String get portraitPath {
    if (type is GameHero) return (type as GameHero).portrait.path;
    if (type is GameClass) return (type as GameClass).icon.path;
    if (type is GameVehicle) return (type as GameVehicle).icon.path;
    return '';
  }

  String get thumbnailPath {
    if (type is GameHero) return (type as GameHero).thumbnail;
    if (type is GameClass) return (type as GameClass).thumbnail;
    if (type is GameVehicle) return (type as GameVehicle).thumbnail;

    return '';
  }

  Widget getPortraitWidget() {
    if (portraitPath.endsWith('.svg')) {
      return SvgPicture.asset(portraitPath);
    } else {
      return Image.asset(portraitPath, fit: BoxFit.contain);
    }
  }

  ImageProvider getThumbnailProvider() {
    if (thumbnailPath.startsWith('http')) {
      return CachedNetworkImageProvider(thumbnailPath);
    }

    return AssetImage(thumbnailPath);
  }
}

class HeroCharacter extends StatsObject<GameHero> {
  HeroCharacter({
    required GameHero hero,
    required super.statsMap,
  }) : super(type: hero);
}

class ClassCharacter extends StatsObject<GameClass> {
  ClassCharacter({
    required GameClass gameClass,
    required super.statsMap,
  }) : super(type: gameClass);
}

class VehicleCharacter extends StatsObject<GameVehicle> {
  VehicleCharacter({
    required GameVehicle vehicle,
    required super.statsMap,
  }) : super(type: vehicle);
}

class Statistics {
  Statistics({
    required this.kills,
    required this.deaths,
    required this.score,
    required this.rank,
    required this.timePlayed,
    required this.assists,
  });

  factory Statistics.fromMap(
    Map<String, double> statsMap,
    String prefix, {
    bool isVehicle = false,
  }) {
    return Statistics(
      kills:
          statsMap[!isVehicle ? '${prefix}_kax_gatt' : '${prefix}_kix_gatt']
              ?.toInt() ??
          0,
      assists: 0,
      deaths: 0,
      timePlayed: Duration(
        seconds:
            statsMap[!isVehicle ? '${prefix}_sax_gatt' : '${prefix}_six_gatt']
                ?.toInt() ??
            0,
      ),
      rank: statsMap['${prefix}_crax_ghva']?.toInt() ?? 0,
      score: statsMap['${prefix}_scax_gatt']?.toInt() ?? 0,
    );
  }

  final int kills;
  final int assists;
  final int deaths;
  final int score;
  final int rank;
  final Duration timePlayed;

  String getTimePlayed() {
    if (timePlayed.inMinutes < 60) {
      return '${timePlayed.inMinutes} MINS';
    }

    return '${timePlayed.inHours} HRS';
  }

  double getKd() {
    return deaths == 0 ? kills.toDouble() : kills / deaths;
  }
}
