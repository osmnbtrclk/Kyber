import 'package:fluent_ui/fluent_ui.dart';

class UnorderedList extends StatelessWidget {
  const UnorderedList(
    this.texts, {
    super.key,
    this.textStyle,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
  });

  final List<String> texts;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[];
    for (final text in texts) {
      widgetList
        ..add(
          _UnorderedListItem(
            text,
            textStyle ?? const TextStyle(),
            crossAxisAlignment ?? CrossAxisAlignment.start,
            mainAxisAlignment ?? MainAxisAlignment.start,
          ),
        )
        ..add(const SizedBox(height: 5));
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: widgetList,
    );
  }
}

class _UnorderedListItem extends StatelessWidget {
  const _UnorderedListItem(
    this.text,
    this.textStyle,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
  );

  final String text;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        const Text('• '),
        Expanded(
          child: Text(
            text,
            style: textStyle.copyWith(fontSize: 15),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
