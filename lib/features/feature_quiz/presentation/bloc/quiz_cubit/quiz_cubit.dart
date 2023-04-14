// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiz_online/common/resources/data_state.dart';
import 'package:quiz_online/features/feature_quiz/data/models/question_model.dart';
import 'package:quiz_online/features/feature_quiz/repository/quiz_repository.dart';

part 'quiz_state.dart';
part 'quiz_data_status.dart';

class QuizCubit extends Cubit<QuizState> {
  final QuizRepository quizRepository;
  QuizCubit(this.quizRepository)
      : super(QuizState(quizDataStatus: QuizDataLoading()));

  Future<void> callQuizDataEvent() async {
    // emit loading
    emit(state.copyWith(newQuizDataStatus: QuizDataLoading()));

    final DataState dataState = await quizRepository.fetchQuizData();

    if (dataState is DataSuccess) {
      // emit completed
      emit(
          state.copyWith(newQuizDataStatus: QuizDataCompleted(dataState.data)));
    }

    if (dataState is DataFailed) {
      // emit error
      emit(state.copyWith(newQuizDataStatus: QuizDataError(dataState.error!)));
    }
  }
}
