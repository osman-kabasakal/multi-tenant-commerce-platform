import 'package:dio/dio.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/crashlytics/crashlytics_service.dart';

import '../../../models/errors/api_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    getIt.get<CrashlyticsService>().recordError(
      err,
      StackTrace.current,
      customKeys: {
        'url': err.requestOptions.uri.toString(),
        'method': err.requestOptions.method,
        'statusCode': err.response?.statusCode,
        'response': err.response?.data,
      },
    );
    final payload = err.response?.data;
    final errorBody = payload is Map ? payload : const <String, dynamic>{};
    final message = errorBody['message'] is String ? errorBody['message'] as String : null;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw NetworkException();

      case DioExceptionType.badResponse:
        throw BadResponseException(
          message: message,
          statusCode: err.response?.statusCode,
          data: err.response?.data,
        );
      default:
        switch (err.response?.statusCode) {
          case 401:
            throw UnauthorizedException(
              message: message,
            );
          case 404:
            throw NotFoundException(message: message);
          case 422:
            throw ValidationException(
              message: message,
              validationErrors: errorBody['errors'],
            );
          case 500:
          case 502:
          case 503:
            throw ServerException(message: message);
          default:
            throw ApiException(
              message:
                  message ??
                  err.message ??
                  'Unknown error',
              statusCode: err.response?.statusCode,
            );
        }
    }
  }
}
