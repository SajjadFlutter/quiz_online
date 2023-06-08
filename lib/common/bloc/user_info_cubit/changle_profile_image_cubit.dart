import 'package:bloc/bloc.dart';

class ChangeProfileImageCubit extends Cubit<String> {
  ChangeProfileImageCubit() : super('assets/images/profile.svg');

  void changeUserInfoEvent(String imagePath){
    emit(imagePath);
  }
}
