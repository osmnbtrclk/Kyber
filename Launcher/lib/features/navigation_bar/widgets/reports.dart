import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:logging/logging.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  late Timer _timer;
  int reports = 0;

  @override
  void initState() {
    loadReports();
    _timer = Timer.periodic(
      const Duration(minutes: 15),
      (timer) async => loadReports(),
    );
    super.initState();
  }

  Future<void> loadReports() async {
    try {
      final req = await sl
          .get<KyberGRPCService>()
          .reportServiceClient
          .listReports(Empty());

      reports = req.reports.where((e) => e.state == ReportState.OPEN).length;
    } catch (e, s) {
      Logger.root.severe('Failed to request reports', e, s);
      reports = -1;
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 7.5,
      children: [
        const Icon(Icons.report_outlined),
        Text(reports.toString()),
      ],
    );
  }
}
