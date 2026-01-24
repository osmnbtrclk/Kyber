import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/mod_browser/screens/mod_details.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';

class KyberSectionDropdown extends StatefulWidget {
  const KyberSectionDropdown({
    required this.title,
    required this.child,
    this.initialExpanded = false,
    this.onExpanded,
    this.expanded,
    super.key,
  });

  final String title;
  final bool? expanded;
  final bool initialExpanded;
  final Function(bool expanded)? onExpanded;
  final Widget child;

  @override
  State<KyberSectionDropdown> createState() => _KyberSectionDropdownState();
}

class _KyberSectionDropdownState extends State<KyberSectionDropdown> {
  late bool _expanded;

  @override
  void initState() {
    _expanded = widget.initialExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ButtonBuilder(
          onClick: () {
            if (widget.expanded != null) {
              widget.onExpanded!(!widget.expanded!);
            } else {
              setState(() {
                _expanded = !_expanded;
              });
            }
          },
          builder: (context, hovered) {
            return AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: TextStyle(
                fontFamily: FontFamily.battlefrontUI,
                color: hovered ? kActiveColor : kInactiveColor,
                shadows: hovered
                    ? [
                        Shadow(
                          color: kActiveColor.withOpacity(.4),
                          blurRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2.5,
                      ),
                      child: Text(
                        widget.title.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    widget.expanded ?? _expanded
                        ? mt.Icons.arrow_drop_up
                        : mt.Icons.arrow_drop_down,
                    color: hovered ? kActiveColor : kInactiveColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            );
          },
        ),
        if (widget.expanded ?? !_expanded) const ContainerSeparator(),
        if (widget.expanded ?? _expanded) widget.child,
      ],
    );
  }
}
