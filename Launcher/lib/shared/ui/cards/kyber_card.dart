import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';

class KyberCard extends StatefulWidget {
  const KyberCard({
    required this.leading,
    required this.trailing,
    super.key,
    this.flex,
  });

  final Widget leading;
  final Widget trailing;
  final int? flex;

  @override
  State<KyberCard> createState() => _KyberCardState();
}

class _KyberCardState extends State<KyberCard> {
  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: DefaultTextStyle.merge(
              style: (theme.typography.body ?? const TextStyle()).copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              child: widget.leading,
            ),
          ),
          Expanded(
            child: widget.trailing,
          ),
        ],
      ),
    );
  }
}
