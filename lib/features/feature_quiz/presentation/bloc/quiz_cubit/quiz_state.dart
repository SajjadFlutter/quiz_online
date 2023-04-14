part of 'quiz_cubit.dart';

class QuizState {
  final QuizDataStatus quizDataStatus;

  QuizState({required this.quizDataStatus});

  QuizState copyWith({required QuizDataStatus? newQuizDataStatus}) {
    return QuizState(quizDataStatus: newQuizDataStatus ?? quizDataStatus);
  }
}
