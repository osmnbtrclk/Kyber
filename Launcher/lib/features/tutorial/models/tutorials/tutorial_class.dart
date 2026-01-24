import 'package:fluent_ui/fluent_ui.dart';

abstract class Tutorial {
  Tutorial(this.steps);

  List<TutorialStep> steps;
}

class TutorialStep {
  TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    this.after,
    this.before,
  });

  String id;
  String title;
  Widget description;
  void Function()? after;
  Future<void> Function()? before;

  GlobalObjectKey getKey() => GlobalObjectKey(id);
}
