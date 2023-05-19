part of 'intro_cubit.dart';

class IntroState {
  final bool showGetStart;

  IntroState({required this.showGetStart});

  IntroState copyWith({required bool? newShowGetStart}) {
    return IntroState(showGetStart: newShowGetStart ?? showGetStart);
  }
}
