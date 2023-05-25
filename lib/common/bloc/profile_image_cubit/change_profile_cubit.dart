import 'package:bloc/bloc.dart';

class ChangeProfileCubit extends Cubit<String> {
  ChangeProfileCubit() : super('assets/images/profile.svg');

  void changeProfileImageEvent(newValue) {
    emit(newValue);
  }
}
