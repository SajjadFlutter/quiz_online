import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quiz_online/common/prefs/prefs_operator.dart';
import 'package:quiz_online/features/feature_quiz/data/data_source/remote/quiz_api_provider.dart';
import 'package:quiz_online/features/feature_quiz/repository/quiz_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

Future<void> initLocator() async {
  // SharedPreferences
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);
  locator.registerSingleton<PrefsOperator>(PrefsOperator());

  // Dio
  locator.registerSingleton<Dio>(Dio());

  // api provider
  locator.registerSingleton<QuizApiProvider>(QuizApiProvider(locator()));

  // repository
  locator.registerSingleton<QuizRepository>(QuizRepository(locator()));
}
