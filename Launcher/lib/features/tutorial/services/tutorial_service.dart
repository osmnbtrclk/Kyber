import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:kyber_launcher/features/tutorial/models/tutorials/tutorial_class.dart';
import 'package:kyber_launcher/features/tutorial/providers/tutorial_cubit.dart';
import 'package:kyber_launcher/features/tutorial/widgets/tutorial_overlay.dart';

class TutorialService {
  Future<void> show(BuildContext context, Tutorial tutorial) async {
    await Future.delayed(const Duration(milliseconds: 50));
    Timer.run(() {
      final firstGlobalKey = tutorial.steps.first.getKey();
      Overlay.of(context).insert(buildOverlay(context, firstGlobalKey));
    });
  }

  double? x;
  double? y;
  double? h;
  double? w;

  (RenderBox, Offset) _getKeyOffset(GlobalKey value) {
    final box = value.currentContext!.findRenderObject()! as RenderBox;
    return (box, box.localToGlobal(Offset.zero));
  }

  OverlayEntry buildOverlay(
    BuildContext context,
    GlobalKey<State<StatefulWidget>> key,
  ) {
    final step = (context.read<TutorialCubit>().state as TutorialActive)
        .tutorial
        .steps[0];
    if (step.before != null) {
      step.before!();
    }

    final entry = OverlayEntry(
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final (box, offset) = _getKeyOffset(key);
            x = offset.dx;
            y = offset.dy;
            h = box.size.height;
            w = box.size.width;
            return FadeIn(
              child: TutorialOverlay(
                x: x!,
                y: y!,
                h: h!,
                w: w!,
              ),
            );
          },
        );
      },
    );

    context.read<TutorialCubit>().setEntry(entry);

    return entry;
  }
}
