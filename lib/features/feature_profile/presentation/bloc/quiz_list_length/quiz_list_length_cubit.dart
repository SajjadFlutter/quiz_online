import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:quiz_online/features/feature_profile/data/models/quiz_model.dart';
import 'package:quiz_online/features/feature_profile/presentation/screens/profile_screen.dart';

class QuizListLengthCubit extends Cubit<int> {
  QuizListLengthCubit() : super(0);

  void callQuizListLengthEvent() {
    ProfileScreen.quizeList.clear();
    Hive.box<QuizModel>('quizBox').values.forEach(
      (value) {
        ProfileScreen.quizeList.add(value);
        // print(quizesList.length);
      },
    );
    emit(ProfileScreen.quizeList.length);
  }
}
