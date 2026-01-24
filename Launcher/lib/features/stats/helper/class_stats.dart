import 'package:kyber_launcher/features/stats/models/stats_class.dart';
import 'package:kyber_launcher/features/stats/providers/stats_cubit.dart';

class ClassStats {
  ClassStats({
    required this.gameClass,
    required this.playtime,
  });

  factory ClassStats.fromStats({
    required GameClass gameClass,
    required GStatsResponse stats,
  }) {
    return ClassStats(
      gameClass: gameClass,
      playtime: stats['${gameClass.prefix}_sax_gatt'] as double? ?? 0,
    );
  }

  final GameClass gameClass;
  final double playtime;
}
