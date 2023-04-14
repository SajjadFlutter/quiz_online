import 'package:bloc/bloc.dart';

class ChangeOptionIndexCubit extends Cubit<int> {
  ChangeOptionIndexCubit() : super(-1);

  void changeOptionIndexEvent(newValue) {
    emit(-1);
    emit(newValue);
  }
}
