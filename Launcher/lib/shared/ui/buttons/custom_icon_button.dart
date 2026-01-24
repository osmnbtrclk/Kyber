import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:tinycolor2/tinycolor2.dart';

class KyberIconButton extends StatefulWidget {
  const KyberIconButton({
    required this.onPressed,
    super.key,
    this.iconData,
    this.path,
    this.size,
    this.initialColor,
  });

  final IconData? iconData;
  final String? path;
  final double? size;
  final Color? initialColor;
  final void Function()? onPressed;

  @override
  State<KyberIconButton> createState() => _KyberIconButtonState();
}

class _KyberIconButtonState extends State<KyberIconButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool hover = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _animation = (Tween(
      begin: 0.toDouble(),
      end: 1.toDouble(),
    ).animate(_controller)..addListener(() => setState(() {})));
    _controller.animateTo(0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onHover(bool hover) {
    this.hover = hover;
    setState(() {});
    if (hover) {
      _controller.animateTo(1);
    } else {
      _controller.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            border: Border.all(
              color: hover ? kActiveColor : (widget.initialColor ?? decoColor),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(4),
          child: widget.path != null
              ? SvgPicture.asset(
                  widget.path!,
                  color: ColorTween(
                    begin: widget.onPressed != null
                        ? kWhiteColor
                        : FluentTheme.of(
                            context,
                          ).typography.title!.color!.darken(70),
                    end: widget.onPressed != null
                        ? kActiveColor
                        : FluentTheme.of(
                            context,
                          ).typography.title!.color!.darken(70),
                  ).animate(_animation).value,
                  height: widget.size ?? 24,
                )
              : Icon(
                  widget.iconData,
                  size: widget.size ?? 24,
                  color: ColorTween(
                    begin: widget.onPressed != null
                        ? kWhiteColor
                        : FluentTheme.of(
                            context,
                          ).typography.title!.color!.darken(70),
                    end: widget.onPressed != null
                        ? kActiveColor
                        : FluentTheme.of(
                            context,
                          ).typography.title!.color!.darken(70),
                  ).animate(_animation).value,
                  shadows: [
                    if (hover && widget.onPressed != null)
                      BoxShadow(
                        color: kActiveColor.withOpacity(.25),
                        blurRadius: 8,
                        spreadRadius: 4,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    required this.onPressed,
    super.key,
    this.iconData,
    this.child,
    this.size,
    this.text,
    this.padding,
    this.color,
    this.hoverColor,
  });

  final IconData? iconData;
  final Widget? child;
  final double? size;
  final Color? color;
  final Color? hoverColor;
  final EdgeInsets? padding;
  final String? text;
  final void Function()? onPressed;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool hover = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _animation = (Tween(
      begin: 0.toDouble(),
      end: 1.toDouble(),
    ).animate(_controller)..addListener(() => setState(() {})));
    _controller.animateTo(0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onHover(bool hover) {
    this.hover = hover;
    setState(() {});
    if (hover) {
      _controller.animateTo(1);
    } else {
      _controller.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: Container(
          padding: widget.padding,
          //decoration: material.BoxDecoration(
          //  color: hover ? kActiveColor.withOpacity(.1) : Colors.transparent,
          //  borderRadius: const BorderRadius.all(Radius.circular(8)),
          //),
          child:
              widget.child ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.iconData,
                    size: widget.size ?? 24,
                    color: ColorTween(
                      begin: widget.onPressed != null
                          ? widget.color ?? kWhiteColor
                          : FluentTheme.of(
                              context,
                            ).typography.title!.color!.darken(70),
                      end: widget.onPressed != null
                          ? widget.hoverColor ?? kActiveColor
                          : FluentTheme.of(
                              context,
                            ).typography.title!.color!.darken(70),
                    ).animate(_animation).value,
                    shadows: [
                      if (hover && widget.onPressed != null)
                        BoxShadow(
                          color: kActiveColor.withOpacity(.25),
                          blurRadius: 8,
                          spreadRadius: 4,
                        ),
                    ],
                  ),
                  if (widget.text != null) ...[
                    const SizedBox(width: 5),
                    DefaultTextStyle.merge(
                      style: TextStyle(
                        color: ColorTween(
                          begin: widget.onPressed != null
                              ? widget.color ?? kWhiteColor
                              : FluentTheme.of(
                                  context,
                                ).typography.title!.color!.darken(70),
                          end: widget.onPressed != null
                              ? widget.hoverColor ?? kActiveColor
                              : FluentTheme.of(
                                  context,
                                ).typography.title!.color!.darken(70),
                        ).animate(_animation).value,
                        fontSize: 15,
                      ),
                      child: Text(widget.text ?? ''),
                    ),
                  ],
                ],
              ),
        ),
      ),
    );
  }
}

class CustomSvgButton extends StatefulWidget {
  const CustomSvgButton({
    required this.path,
    required this.onPressed,
    super.key,
    this.size,
    this.color,
    this.hoverColor,
    this.padding,
  });

  final String path;
  final Color? color;
  final Color? hoverColor;
  final double? size;
  final EdgeInsets? padding;
  final void Function()? onPressed;

  @override
  State<CustomSvgButton> createState() => _CustomSvgButtonState();
}

class _CustomSvgButtonState extends State<CustomSvgButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AbsorbPointer(
          child: Container(
            padding: widget.padding ?? EdgeInsets.zero,
            child: SvgPicture.asset(
              widget.path,
              color: hover
                  ? (widget.hoverColor ?? kActiveColor)
                  : (widget.color ?? kWhiteColor),
              height: widget.size ?? 24,
            ),
          ),
        ),
      ),
    );
  }
}
