import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class KyberSettingsCard extends StatefulWidget {
  const KyberSettingsCard({
    required this.leading,
    required this.trailing,
    super.key,
  });

  final Widget leading;
  final Widget trailing;

  @override
  State<KyberSettingsCard> createState() => _KyberSettingsCardState();
}

class _KyberSettingsCardState extends State<KyberSettingsCard> {
  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 4),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.4),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Card(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: DefaultTextStyle.merge(
                  style: (theme.typography.body ?? const TextStyle()).copyWith(
                    fontSize: 20,
                  ),
                  child: widget.leading,
                ),
              ),
              Expanded(
                child: widget.trailing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
