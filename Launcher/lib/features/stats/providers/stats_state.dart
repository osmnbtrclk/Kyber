part of 'stats_cubit.dart';

@immutable
abstract class StatsState {}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  StatsLoaded({
    required this.stats,
    required this.playerStats,
    required this.statsSource,
    required this.selectedObject,
  });

  final StatsObject selectedObject;
  final StatsSource statsSource;
  final PlayerStats? playerStats;
  final Map<String, dynamic> stats;

  StatsLoaded copyWith({
    StatsObject? selectedObject,
    StatsSource? statsSource,
    PlayerStats? playerStats,
    Map<String, dynamic>? stats,
  }) {
    return StatsLoaded(
      selectedObject: selectedObject ?? this.selectedObject,
      statsSource: statsSource ?? this.statsSource,
      playerStats: playerStats ?? this.playerStats,
      stats: stats ?? this.stats,
    );
  }
}

class StatsError extends StatsState {
  StatsError(this.error);

  final String error;
}
