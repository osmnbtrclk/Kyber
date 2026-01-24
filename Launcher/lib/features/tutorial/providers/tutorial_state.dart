part of 'tutorial_cubit.dart';

@immutable
abstract class TutorialState {}

class TutorialInitial extends TutorialState {}

class TutorialActive extends TutorialState {
  TutorialActive({
    required this.tutorial,
    required this.currentStep,
  });

  final Tutorial tutorial;
  final int currentStep;
}
