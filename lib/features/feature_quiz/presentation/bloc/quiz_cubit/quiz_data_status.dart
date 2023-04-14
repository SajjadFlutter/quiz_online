part of 'quiz_cubit.dart';

@immutable
abstract class QuizDataStatus {}

class QuizDataLoading extends QuizDataStatus {}

class QuizDataCompleted extends QuizDataStatus {
  final QuestionModel questionModel;

  QuizDataCompleted(this.questionModel);
}

class QuizDataError extends QuizDataStatus {
  final String errorMessage;

  QuizDataError(this.errorMessage);
}
