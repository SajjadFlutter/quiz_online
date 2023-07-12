import 'package:bloc/bloc.dart';

class VisibleCubit extends Cubit<bool> {
  VisibleCubit() : super(true);

  void changeStateVisible(bool newValue) => emit(newValue);
}
