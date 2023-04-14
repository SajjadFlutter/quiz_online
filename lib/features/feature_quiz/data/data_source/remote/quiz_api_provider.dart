import 'package:dio/dio.dart';

class QuizApiProvider {
  static String className = '';
  final Dio dio;

  QuizApiProvider(this.dio);

  // dynamic callQuizData() async {
  //   try {
  //     Response response = await dio.get(
  //       'https://parseapi.back4app.com/classes/Question',
  //       options: Options(
  //         headers: {
  //           'X-Parse-Application-Id':
  //               'xul9v9enKgZxX7AziS31rjceue92DmJh8WVpZJvm',
  //           'X-Parse-REST-API-Key': 'EPlLOxZxOKZpL3JMfrE2b0nAxfSRF2mCEd99eysF',
  //         },
  //       ),
  //     );
  //     print(response);
  //     return response;
  //   } on DioError catch (e) {
  //     print(e);
  //     return await CheckExceptions.response(e.response!);
  //   }
  // }

  dynamic callQuizData() async {
    // print(className);
    Response response = await dio.get(
      'https://parseapi.back4app.com/classes/$className',
      options: Options(
        headers: {
          'X-Parse-Application-Id': 'xul9v9enKgZxX7AziS31rjceue92DmJh8WVpZJvm',
          'X-Parse-REST-API-Key': 'EPlLOxZxOKZpL3JMfrE2b0nAxfSRF2mCEd99eysF',
        },
      ),
    );
    // print(response);
    return response;
  }
}
