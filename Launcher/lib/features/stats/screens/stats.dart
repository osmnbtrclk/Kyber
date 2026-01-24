import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/features/stats/screens/personal/stats_overview.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const UserStats();
  }
}
