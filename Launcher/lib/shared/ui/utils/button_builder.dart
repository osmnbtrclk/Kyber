import 'package:fluent_ui/fluent_ui.dart';

class ButtonBuilder extends StatefulWidget {
  const ButtonBuilder({
    required this.builder,
    this.onClick,
    super.key,
    this.onDoubleClick,
    this.onEvent,
    this.hoverEffectOnly = false,
  });

  final Widget Function(BuildContext context, bool hovered) builder;
  final void Function(bool hovered)? onEvent;
  final bool hoverEffectOnly;
  final VoidCallback? onClick;
  final VoidCallback? onDoubleClick;

  @override
  State<ButtonBuilder> createState() => _ButtonBuilderState();
}

class _ButtonBuilderState extends State<ButtonBuilder> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.hoverEffectOnly) {
      return MouseRegion(
        onEnter: (event) {
          widget.onEvent?.call(true);
          setState(() => hovered = true);
        },
        onExit: (event) {
          widget.onEvent?.call(false);
          setState(() => hovered = false);
        },
        child: widget.builder(context, hovered),
      );
    }

    return MouseRegion(
      cursor: widget.onClick != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (event) {
        widget.onEvent?.call(true);
        setState(() => hovered = true);
      },
      onExit: (event) {
        widget.onEvent?.call(false);
        setState(() => hovered = false);
      },
      child: GestureDetector(
        onTap: widget.onClick,
        onDoubleTap: widget.onDoubleClick,
        child: widget.builder(context, hovered),
      ),
    );
  }
}
