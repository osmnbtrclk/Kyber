import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/shared/ui/ui.dart';

class KyberTableItem<T> extends StatefulWidget {
  const KyberTableItem._({
    required this.title,
    required this.builder,
    super.key,
    this.onClick,
    this.disabled = false,
  });

  factory KyberTableItem.custom({
    required String title,
    required Widget Function(bool hovered) builder,
    VoidCallback? onClick,
  }) => KyberTableItem._(
    title: title,
    builder: builder,
    onClick: onClick,
  );

  factory KyberTableItem.slider({
    required String title,
    required int min,
    required int max,
    required int value,
    required ValueChanged<int> onChanged,
  }) => KyberTableItem._(
    title: title,
    builder: (hovered) => KyberTableSlider(
      onChanged: onChanged,
      hover: hovered,
      min: min,
      max: max,
      value: value,
    ),
  );

  factory KyberTableItem.button({
    required String title,
    String? text,
    Widget? widget,
    required VoidCallback? onClick,
  }) => KyberTableItem._(
    title: title,
    builder: (hovered) => KyberTableButton(
      onPressed: onClick,
      text: text,
      widget: widget,
      hover: hovered,
    ),
    onClick: onClick,
    disabled: onClick == null,
  );

  factory KyberTableItem.input({
    required String title,
    TextEditingController? controller,
    String? placeholder,
  }) => KyberTableItem._(
    title: title,
    builder: (hovered) => KyberInput(
      controller: controller,
      placeholder: placeholder,
    ),
  );

  factory KyberTableItem.selector({
    required String title,
    required List<KyberSelectorItem<T>> items,
    ValueChanged<T>? onChange,
    T? value,
  }) => KyberTableItem<T>._(
    title: title,
    builder: (hovered) => KyberTableSelector<T>(
      items: items,
      onChanged: onChange,
      hover: hovered,
      value: value,
    ),
  );

  factory KyberTableItem.switchButton({
    required String title,
    ValueChanged<bool>? onChange,
    String? disabledText,
    String? enabledText,
    bool? value,
  }) => KyberTableItem._(
    title: title,
    builder: (hovered) => KyberTableSwitch(
      onChanged: onChange,
      hover: hovered,
      disabledText: disabledText,
      enabledText: enabledText,
      value: value,
    ),
    onClick: onChange != null ? () => onChange(!value!) : null,
  );

  final String title;
  final Widget Function(bool hovered) builder;
  final VoidCallback? onClick;
  final bool disabled;

  @override
  State<KyberTableItem<T>> createState() => _KyberTableItemState<T>();
}

class _KyberTableItemState<T> extends State<KyberTableItem<T>> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final style = FluentTheme.of(context).typography.body;

    return SizedBox(
      height: 48,
      child: MouseRegion(
        onEnter: (_) => setState(() => hovered = true),
        onExit: (_) => setState(() => hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onClick != null ? () => widget.onClick!.call() : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: Border(
                left: kDefaultBorder.copyWith(
                  color: hovered ? kActiveColor : decoColor,
                ),
                right: kDefaultBorder.copyWith(
                  color: hovered ? kActiveColor : decoColor,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    height: 48,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 100),
                      style: style!.copyWith(
                        color: widget.disabled
                            ? kWhiteBackgroundColor
                            : hovered
                            ? kActiveColor
                            : FluentTheme.of(context).typography.body?.color,
                      ),
                      child: Text(
                        widget.title.toUpperCase(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: style.fontSize == 20 ? 2 : 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: widget.builder.call(hovered),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
