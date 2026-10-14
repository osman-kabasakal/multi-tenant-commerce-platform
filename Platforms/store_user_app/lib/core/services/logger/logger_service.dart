// lib/core/utils/logger.dart
import 'package:logger/logger.dart';

import '../../config/app_config.dart';

class LoggerService {
  static final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 1000,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    ),
  );

  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.instance.enableLogging) {
      logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.instance.enableLogging) {
      logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  static void warning(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (AppConfig.instance.enableLogging) {
      logger.w(message, error: error, stackTrace: stackTrace);
    }
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    // Hata logları her zaman loglanır
    logger.e(message, error: error, stackTrace: stackTrace);
  }
}
