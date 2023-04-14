import 'package:dio/dio.dart';
import 'package:quiz_online/common/resources/data_state.dart';
import 'package:quiz_online/features/feature_quiz/data/data_source/remote/quiz_api_provider.dart';
import 'package:quiz_online/features/feature_quiz/data/models/question_model.dart';

class QuizRepository {
  final QuizApiProvider apiProvider;

  QuizRepository(this.apiProvider);

  // Future<dynamic> fetchQuizData() async {
  //   try {
  //     Response response = await apiProvider.callQuizData();
  //     QuestionModel questionModel = QuestionModel.fromJson(response.data);
  //     return DataSuccess(questionModel);
  //   } on AppException catch (e) {
  //     return CheckExceptions.getError(e);
  //   }
  // }

  Future<dynamic> fetchQuizData() async {
    try {
      Response response = await apiProvider.callQuizData();
      if (response.statusCode == 200) {
        QuestionModel questionModel = QuestionModel.fromJson(response.data);
        return DataSuccess(questionModel);
      } else {
        return const DataFailed('مشکلی پیش آمده، لطفا دوباره امتحان کنید.');
      }
    } catch (e) {
      return const DataFailed('لطفا اتصال خود را به اینترنت چک کنید.');
    }
  }
}
