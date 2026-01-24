import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/server_browser/widgets/server_list/server_list_header.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/buttons/custom_icon_button.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';

class KyberHeader extends StatelessWidget {
  const KyberHeader({
    required this.sections,
    this.title,
    super.key,
    this.headerPadding,
    this.headerLength,
    this.customTitle,
    this.headerFlex,
  });

  final String? title;
  final EdgeInsets? headerPadding;
  final Widget? customTitle;
  final int? headerFlex;
  final double? headerLength;
  final List<HeaderSection> sections;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyle(
        color: FluentTheme.of(context).inactiveColor,
        fontSize: 15,
        height: 1.1,
      ),
      child: SizedBox(
        height: 30,
        child: Row(
          children: [
            if (headerFlex != null && (title != null || customTitle != null))
              Expanded(
                flex: headerFlex!,
                child: Padding(
                  padding: headerPadding ?? const EdgeInsets.only(left: 15),
                  child: customTitle ?? Text(title!.toUpperCase()),
                ),
              ),
            if (headerFlex == null && (title != null || customTitle != null))
              SizedBox(
                width: headerLength,
                child: Padding(
                  padding:
                      headerPadding ??
                      const EdgeInsets.symmetric(horizontal: 15),
                  child: customTitle ?? Text(title!.toUpperCase(), maxLines: 1),
                ),
              ),
            if (sections.isNotEmpty && (title != null || customTitle != null))
              divider(),
            for (var i = 0; i != sections.length; i++) ...[
              if (sections[i] is FixedWidthHeaderSection) ...[
                SizedBox(
                  width: (sections[i] as FixedWidthHeaderSection).width,
                  child: Row(
                    mainAxisAlignment: (sections[i] as FixedWidthHeaderSection)
                        .mainAxisAlignment,
                    children: (sections[i] as FixedWidthHeaderSection).children,
                  ),
                ),
              ],
              if (sections[i] is HeaderSelector) ...[
                Builder(
                  builder: (context) {
                    final child = [
                      if ((sections[i] as HeaderSelector).title != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            (sections[i] as HeaderSelector).title!
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      for (
                        var j = 0;
                        j != (sections[i] as HeaderSelector).options.length;
                        j++
                      ) ...[
                        HeaderButton(
                          title: (sections[i] as HeaderSelector).options[j],
                          active:
                              j ==
                              (sections[i] as HeaderSelector).selectedIndex,
                          onClick: () =>
                              (sections[i] as HeaderSelector).onSelected(j),
                        ),
                        if (j !=
                            (sections[i] as HeaderSelector).options.length - 1)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: 18,
                            width: 2,
                            color: decoColor,
                          ),
                      ],
                    ];

                    if ((sections[i] as HeaderSelector).flex != null) {
                      return Expanded(
                        flex: (sections[i] as HeaderSelector).flex!,
                        child: Padding(
                          padding:
                              (sections[i] as HeaderSelector).padding ??
                              EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment:
                                (sections[i] as HeaderSelector)
                                    .mainAxisAlignment ??
                                MainAxisAlignment.center,
                            children: child,
                          ),
                        ),
                      );
                    }

                    if ((sections[i] as HeaderSelector).width != null) {
                      return SizedBox(
                        width: (sections[i] as HeaderSelector).width!
                            .toDouble(),
                        child: Padding(
                          padding:
                              (sections[i] as HeaderSelector).padding ??
                              EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment:
                                (sections[i] as HeaderSelector)
                                    .mainAxisAlignment ??
                                MainAxisAlignment.center,
                            children: child,
                          ),
                        ),
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: child,
                    );
                  },
                ),
              ],
              if (sections[i] is ExpandedHeaderSection) ...[
                Expanded(
                  flex: (sections[i] as ExpandedHeaderSection).flex ?? 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment:
                          (sections[i] as ExpandedHeaderSection)
                              .mainAxisAlignment ??
                          MainAxisAlignment.start,
                      children: (sections[i] as ExpandedHeaderSection).children,
                    ),
                  ),
                ),
              ],
              if (sections[i] is DefaultHeaderSection) ...[
                ...(sections[i] as DefaultHeaderSection).children,
              ],
              if (i != sections.length - 1 && sections[i].divider) divider(),
            ],
          ],
        ),
      ),
    );
  }

  Widget divider() => CustomPaint(
    size: const Size(2, 30),
    painter: DashedLineVerticalPainter(),
  );
}

abstract class HeaderSection {
  const HeaderSection({this.divider = true});

  final bool divider;
}

class FixedWidthHeaderSection extends HeaderSection {
  const FixedWidthHeaderSection({
    required this.width,
    required this.children,
    super.divider,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final MainAxisAlignment mainAxisAlignment;
  final double width;
  final List<Widget> children;
}

class ExpandedHeaderSection extends HeaderSection {
  const ExpandedHeaderSection({
    required this.children,
    super.divider,
    this.flex,
    this.mainAxisAlignment,
  });

  final int? flex;
  final List<Widget> children;
  final MainAxisAlignment? mainAxisAlignment;
}

class HeaderSelector extends HeaderSection {
  const HeaderSelector({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.flex,
    this.width,
    this.mainAxisAlignment,
    this.padding,
    this.title,
    super.divider,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsets? padding;
  final String? title;

  final int? flex;
  final int? width;
}

class DefaultHeaderSection extends HeaderSection {
  const DefaultHeaderSection({required this.children, super.divider});

  final List<Widget> children;
}

class HeaderDivider extends StatelessWidget {
  const HeaderDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      width: 2,
      color: decoColor,
      height: 100,
    );
  }
}

class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    required this.icon,
    required this.onClick,
    super.key,
  });

  final IconData icon;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      color: decoColor,
      onPressed: onClick,
      iconData: icon,
      size: 20,
    );
  }
}

class HeaderButton extends StatelessWidget {
  const HeaderButton({
    required this.title,
    required this.onClick,
    this.active = false,
    super.key,
  });

  final String title;
  final bool active;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return ButtonBuilder(
      onClick: onClick,
      builder: (context, hovered) {
        return AnimatedDefaultTextStyle(
          style: TextStyle(
            fontFamily: FontFamily.battlefrontUI,
            color: hovered
                ? kActiveColor
                : active
                ? Colors.white
                : decoColor,
          ),
          duration: const Duration(milliseconds: 150),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        );
      },
    );
  }
}
