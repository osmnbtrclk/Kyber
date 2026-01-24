import 'package:bloc/bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/core/routing/app_router.dart';
import 'package:kyber_launcher/features/tutorial/models/tutorials/tutorial_class.dart';
import 'package:kyber_launcher/features/tutorial/services/tutorial_service.dart';

part 'tutorial_state.dart';

class TutorialCubit extends Cubit<TutorialState> {
  TutorialCubit() : super(TutorialInitial());
  final TutorialService _tutorialService = TutorialService();
  OverlayEntry? _overlayEntry;

  void setEntry(OverlayEntry entry) => _overlayEntry = entry;

  Future<void> loadTutorial(Tutorial tutorial) async {
    emit(
      TutorialActive(
        tutorial: tutorial,
        currentStep: 0,
      ),
    );

    _showStep(0);
  }

  Future<void> _showStep(int index) async {
    await Future.delayed(const Duration(milliseconds: 50));

    final step = (state as TutorialActive).tutorial.steps[index];
    if (step.before != null && index != 0) {
      await step.before!();
    }

    final overlay = _tutorialService.buildOverlay(
      shellNavigatorKey.currentContext!,
      step.getKey(),
    );

    Overlay.of(shellNavigatorKey.currentContext!).insert(overlay);
  }

  void nextStep() {
    assert(_overlayEntry != null || state is! TutorialActive);
    _overlayEntry!.remove();

    final currentStep = (state as TutorialActive).currentStep;

    final step = (state as TutorialActive).tutorial.steps[currentStep];
    if (step.after != null) step.after!();

    if (currentStep >= (state as TutorialActive).tutorial.steps.length) {
      _overlayEntry!.remove();
      emit(TutorialInitial());
      return;
    }

    final nextStep = (state as TutorialActive).tutorial.steps[currentStep + 1];
    if (nextStep.before != null) nextStep.before!();

    _showStep(currentStep + 1);
    emit(
      TutorialActive(
        tutorial: (state as TutorialActive).tutorial,
        currentStep: currentStep + 1,
      ),
    );
  }

  void skip() {
    assert(_overlayEntry != null);
    _overlayEntry!.remove();
    emit(TutorialInitial());
  }
}
