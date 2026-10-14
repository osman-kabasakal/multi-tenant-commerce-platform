import 'package:dio/dio.dart';
import '../../../services/logger/logger_service.dart';

/// Log request outcomes only. Headers, queries and bodies can contain credentials and personal data.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LoggerService.debug('HTTP request: ${options.method}');
    handler.next(options);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LoggerService.debug('HTTP response: ${response.statusCode}');
    handler.next(response);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LoggerService.error('HTTP failure: ${err.type.name}, status: ${err.response?.statusCode}');
    handler.next(err);
  }
}
