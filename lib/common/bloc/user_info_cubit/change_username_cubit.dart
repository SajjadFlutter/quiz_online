import 'package:bloc/bloc.dart';

class ChangeUsernameCubit extends Cubit<String> {
  ChangeUsernameCubit() : super('assets/images/profile.svg');

  void changeUsernameEvent(String username){
    emit(username);
  }
}
