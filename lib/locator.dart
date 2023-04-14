import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quiz_online/features/feature_quiz/data/data_source/remote/quiz_api_provider.dart';
import 'package:quiz_online/features/feature_quiz/repository/quiz_repository.dart';

GetIt locator = GetIt.instance;

Future<void> initLocator() async {
  // Dio
  locator.registerSingleton<Dio>(Dio());

  // api provider
  locator.registerSingleton<QuizApiProvider>(QuizApiProvider(locator()));

  // repository
  locator.registerSingleton<QuizRepository>(QuizRepository(locator()));
}
