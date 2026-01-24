import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';

class BackgroundBlur extends StatefulWidget {
  const BackgroundBlur({
    required this.child,
    super.key,
    this.borderRadius = BorderRadius.zero,
    this.blurColor,
    this.blurColorOpacity = 0.4,
    this.blurIntensity = 6,
    this.enableBlur = true,
  });

  final Widget child;
  final Color? blurColor;
  final double blurIntensity;
  final double blurColorOpacity;
  final BorderRadius borderRadius;
  final bool enableBlur;

  @override
  State<BackgroundBlur> createState() => _BackgroundBlurState();
}

class _BackgroundBlurState extends State<BackgroundBlur> {
  late ImageFilter _cachedFilter;
  late Color _cachedColor;

  @override
  void initState() {
    super.initState();
    _updateCachedValues();
  }

  @override
  void didUpdateWidget(BackgroundBlur oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.blurIntensity != widget.blurIntensity ||
        oldWidget.blurColor != widget.blurColor ||
        oldWidget.blurColorOpacity != widget.blurColorOpacity) {
      _updateCachedValues();
    }
  }

  void _updateCachedValues() {
    _cachedFilter = ImageFilter.blur(
      sigmaX: widget.blurIntensity,
      sigmaY: widget.blurIntensity,
      tileMode: TileMode.decal,
    );
    _cachedColor = (widget.blurColor ?? Colors.black).withOpacity(
      widget.blurColorOpacity,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableBlur) {
      return widget.child;
    }

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: BackdropFilter(
        filter: _cachedFilter,
        child: ColoredBox(
          color: _cachedColor,
          child: widget.child,
        ),
      ),
    );
  }
}
