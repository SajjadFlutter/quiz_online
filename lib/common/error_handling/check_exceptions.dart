

import 'package:dio/dio.dart';
import 'package:quiz_online/common/error_handling/app_exception.dart';
import 'package:quiz_online/common/resources/data_state.dart';

class CheckExceptions {
  static dynamic response(Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response: response);
      case 401:
        throw UnauthorisedException();
      case 404:
        throw NotFoundException();
      case 500:
        throw ServerException();
      default:
        throw FetchDataException(
            message: '${response.statusCode} fetch exception');
    }
  }

  static dynamic getError(AppException appException) async {
    switch (appException.runtimeType) {
      /// return error came from server
      case BadRequestException:
        return DataFailed(appException.message);

      case NotFoundException:
        return DataFailed(appException.message);

      /// get refresh token and call api again
      case UnauthorisedException:
        return DataFailed(appException.message);

      /// server error
      case ServerException:
        return DataFailed(appException.message);

      /// dio or timeout and etc error
      case FetchDataException:
        return DataFailed(appException.message);
    }
  }
}
