import 'package:bloc/bloc.dart';

class QuizYearCubit extends Cubit<int> {
  QuizYearCubit() : super(0);

  void changeIndexEvent(int newValue) => emit(newValue);
}
