import 'package:bloc/bloc.dart';

class QuizTypeCubit extends Cubit<int> {
  QuizTypeCubit() : super(0);

  void changeIndexEvent(int newValue) => emit(newValue);
}
