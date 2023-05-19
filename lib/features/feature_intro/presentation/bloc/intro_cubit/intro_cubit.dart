import 'package:bloc/bloc.dart';

part 'intro_state.dart';

class IntroCubit extends Cubit<IntroState> {
  IntroCubit() : super(IntroState(showGetStart: false));

  void changeGetStart(bool newValue) =>
      emit(state.copyWith(newShowGetStart: newValue));
}
