import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/settings/screens/settings_list.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, int> proxyPings = {};
  String selectedProxy = '';
  final String prefix = 'settings';
  bool disabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SettingsList();
  }
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(8).copyWith(left: 20).copyWith(top: 30 + 8),
      child: Text(
        title.toUpperCase(),
        style: FluentTheme.of(context).typography.title!.copyWith(
          fontWeight: FontWeight.bold,
          color: kInactiveColor,
          fontFamily: FontFamily.battlefrontUI,
        ),
      ),
    );
  }
}
