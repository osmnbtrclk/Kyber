import 'package:fluent_ui/fluent_ui.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveListener<T> extends StatefulWidget {
  const HiveListener({
    required this.box,
    required this.builder,
    super.key,
    this.keys,
  });

  final Box<T> box;
  final List<String>? keys;
  final Widget Function(Box<T> bx) builder;

  @override
  _HiveListenerState createState() => _HiveListenerState();
}

class _HiveListenerState<T> extends State<HiveListener<T>> {
  late Box<T> _box;
  bool _boxOpened = false;

  void _valueChanged() {
    _box = widget.box;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    _box = widget.box;
    _boxOpened = Hive.isBoxOpen(_box.name);
    if (_boxOpened) {
      _box.listenable(keys: widget.keys).addListener(_valueChanged);
    } else {
      Hive.openBox<T>(_box.name).then((value) {
        _box = value;
        _boxOpened = _box.isOpen;
        _box.listenable(keys: widget.keys).addListener(_valueChanged);
        if (mounted) setState(() {});
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    if (_boxOpened) {
      _box.listenable(keys: widget.keys).removeListener(_valueChanged);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_boxOpened) {
      return const SizedBox.shrink();
    }

    return widget.builder(_box);
  }
}
