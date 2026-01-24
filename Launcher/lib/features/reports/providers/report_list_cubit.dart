import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/core/services/notification_service.dart';
import 'package:kyber_launcher/features/reports/models/report_list_state.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:logging/logging.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial()) {
    filter = const .new(state: .all);
    loadReports(silent: true);
  }

  final _logger = Logger('ReportsCubit');
  late ReportFilter filter;
  Timer? _refreshTimer;

  void startAutoRefresh({Duration interval = const Duration(seconds: 30)}) {
    stopAutoRefresh();
    _refreshTimer = Timer.periodic(interval, (_) => loadReports(silent: true));
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> loadReports({bool silent = false}) async {
    try {
      final filter = switch (state) {
        ReportsLoaded(:final filter) => filter,
        _ => this.filter,
      };

      if (!silent || state is! ReportsLoaded) {
        emit(ReportsLoading());
      }

      final response = await sl
          .get<KyberGRPCService>()
          .reportServiceClient
          .listReports(Empty());

      final reports = response.reports.toList().sorted((a, b) {
        if (a.state == .OPEN && b.state != .OPEN) {
          return -1;
        } else if (a.state != .OPEN && b.state == .OPEN) {
          return 1;
        }

        return b.latestReportTime.compareTo(a.latestReportTime);
      });

      final filteredReports = List<PlayerReportSummary>.from(reports);
      if (filter.state != .all) {
        filteredReports.retainWhere((report) {
          return switch (filter.state) {
            .open => report.state == .OPEN,
            .closed => report.state == .CLOSED,
            .resolved => report.mostRecentStatus == .RESOLVED,
            .rejected => report.mostRecentStatus == .REJECTED,
            _ => true,
          };
        });
      }

      emit(
        ReportsLoaded(
          reports: reports,
          filteredReports: filteredReports,
          filter: filter,
          lastUpdated: DateTime.now(),
        ),
      );
    } on GrpcError catch (e, s) {
      _logger.severe('Failed to load reports', e, s);

      final errorMessage = 'Failed to load reports: ${e.message}';
      emit(ReportsError(message: errorMessage, error: e));
      NotificationService.error(message: errorMessage);
    } catch (e, s) {
      _logger.severe('Failed to load reports', e, s);

      final errorMessage = 'An unexpected error occurred: $e';
      emit(ReportsError(message: errorMessage, error: e));
      NotificationService.error(message: errorMessage);
    }
  }

  void setFilter(ReportFilter newFilter) {
    final currentState = state;
    if (currentState is ReportsLoaded) {
      var filteredReports = currentState.reports;

      if (newFilter.state != .all) {
        filteredReports = filteredReports.where((report) {
          return switch (newFilter.state) {
            .open => report.state == .OPEN,
            .closed => report.state == .CLOSED,
            .resolved => report.mostRecentStatus == .RESOLVED,
            .rejected => report.mostRecentStatus == .REJECTED,
            _ => true,
          };
        }).toList();
      } else {
        filteredReports = currentState.reports;
      }

      filter = newFilter;

      emit(
        ReportsLoaded(
          filter: newFilter,
          reports: currentState.reports,
          filteredReports: filteredReports,
          lastUpdated: currentState.lastUpdated,
        ),
      );
    }
  }

  Future<void> searchReports(String query) async {
    final currentState = state;
    if (currentState is ReportsLoaded) {
      final filteredReports = currentState.reports.where((report) {
        final lowerQuery = query.toLowerCase();

        final fields = [
          report.targetUsername.toLowerCase(),
          report.targetUserId.toLowerCase(),
        ];

        return fields.any((field) => field.contains(lowerQuery));
      }).toList();

      emit(
        ReportsLoaded(
          filter: currentState.filter,
          reports: currentState.reports,
          filteredReports: filteredReports,
          lastUpdated: currentState.lastUpdated,
        ),
      );
    }
  }

  Future<void> refreshReports() => loadReports();

  List<Report> getSortedReports({bool ascending = false}) {
    final currentState = state;
    if (currentState is ReportsLoaded) {
      final sorted = List<Report>.from(currentState.reports)
        ..sort((a, b) {
          final comparison = b.createdAt.compareTo(a.createdAt);
          return ascending ? -comparison : comparison;
        });
      return sorted;
    }
    return [];
  }

  @override
  Future<void> close() {
    stopAutoRefresh();
    return super.close();
  }
}
