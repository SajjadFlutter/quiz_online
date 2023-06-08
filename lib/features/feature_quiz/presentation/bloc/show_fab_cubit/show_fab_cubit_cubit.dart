import 'package:bloc/bloc.dart';

class ShowFabCubit extends Cubit<bool> {
  ShowFabCubit() : super(true);

  void showFabEvent(newValue) => emit(newValue);
}
