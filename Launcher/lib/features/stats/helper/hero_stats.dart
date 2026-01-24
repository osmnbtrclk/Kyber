import 'package:kyber_launcher/features/stats/models/stats_hero.dart';
import 'package:kyber_launcher/features/stats/providers/stats_cubit.dart';

class HeroStats {
  HeroStats({
    required this.hero,
    required this.playtime,
    required this.rank,
    this.eliminations = 0,
    this.deaths = 0,
  });

  factory HeroStats.fromStats({
    required GameHero hero,
    required GStatsResponse stats,
  }) {
    return HeroStats(
      hero: hero,
      playtime: stats['${hero.prefix}_sax_gatt'] as double? ?? 0,
      rank: (stats['${hero.prefix}_crax_ghva'] as double? ?? 0).toInt(),
      eliminations: (stats['${hero.prefix}_sax_gatt'] as double? ?? 0).toInt(),
      deaths: (stats['${hero.prefix}_eax_gatt'] as double? ?? 0).toInt(),
    );
  }

  final GameHero hero;
  final double playtime;
  final int rank;
  final int eliminations;
  final int deaths;
}
