import 'package:kyber_launcher/features/stats/helper/class_stats.dart';
import 'package:kyber_launcher/features/stats/helper/hero_stats.dart';
import 'package:kyber_launcher/features/stats/models/stats_class.dart';
import 'package:kyber_launcher/features/stats/models/stats_hero.dart';
import 'package:kyber_launcher/features/stats/providers/stats_cubit.dart';

class StatsHelper {
  StatsHelper._();

  static String formatDuration(int seconds) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      if (hours < 10) {
        return '${twoDigits(hours)}h ${twoDigits(minutes)}m';
      }

      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  static List<ClassStats> parseClassStats(GStatsResponse stats) {
    final classStats = <ClassStats>[];
    for (final gameClass in GameClass.values) {
      classStats.add(ClassStats.fromStats(gameClass: gameClass, stats: stats));
    }

    return classStats;
  }

  static List<HeroStats> parseHeroStats(GStatsResponse stats) {
    final heroStats = <HeroStats>[];
    for (final hero in GameHero.values) {
      heroStats.add(HeroStats.fromStats(hero: hero, stats: stats));
    }

    return heroStats;
  }
}
