import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';

@lazySingleton
class LoggingAspect {
  static final LoggingAspect _instance = LoggingAspect._internal();
  factory LoggingAspect() => _instance;
  LoggingAspect._internal();

  Future<T?> logOperation<T>({
    required String operationName,
    required Future<T?> Function() operation,
  }) async {
    try {
      LoggerService.info('[$operationName] Başlıyor - ${DateTime.now()}');
      final stopwatch = Stopwatch()..start();

      final result = await operation();

      stopwatch.stop();
      LoggerService.info(
          '[$operationName] Tamamlandı - Süre: ${stopwatch.elapsedMilliseconds}ms');

      return result;
    } catch (error) {
      LoggerService.error(
          '[$operationName] Hata: $error', error, StackTrace.current);
      rethrow;
    }
  }
}
