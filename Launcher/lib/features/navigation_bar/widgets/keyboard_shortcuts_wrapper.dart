import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/app_shortcuts.dart';

class KeyboardShortcutsWrapper extends StatelessWidget {
  const KeyboardShortcutsWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: AppShortcuts.getNavigationShortcuts(context),
      child: child,
    );
  }
}
