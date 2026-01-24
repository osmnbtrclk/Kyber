import 'package:equatable/equatable.dart';
import 'package:kyber/kyber.dart';

enum ReportFilterStatus {
  all,
  open,
  closed,
  resolved,
  rejected,
}

class ReportFilter {
  final ReportFilterStatus state;

  const ReportFilter({
    required this.state,
  });

  ReportFilter copyWith({
    ReportFilterStatus? state,
  }) {
    return ReportFilter(
      state: state ?? this.state,
    );
  }
}

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<PlayerReportSummary> reports;
  final List<PlayerReportSummary> filteredReports;
  final DateTime lastUpdated;
  final ReportFilter filter;

  const ReportsLoaded({
    required this.reports,
    required this.lastUpdated,
    required this.filteredReports,
    required this.filter,
  });

  @override
  List<Object?> get props => [reports, lastUpdated, filteredReports, filter];
}

class ReportsError extends ReportsState {
  final String message;
  final Object? error;

  const ReportsError({
    required this.message,
    this.error,
  });

  @override
  List<Object?> get props => [message, error];
}

class ReportListEntry {}
