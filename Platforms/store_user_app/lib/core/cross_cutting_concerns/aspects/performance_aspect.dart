import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';

@lazySingleton
class PerformanceAspect {
  final Map<String, List<int>> _metrics = {};

  Future<T?> measurePerformance<T>({
    required String operationName,
    required Future<T?> Function() operation,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      return await operation();
    } finally {
      stopwatch.stop();
      _recordMetric(operationName, stopwatch.elapsedMilliseconds);
    }
  }

  void _recordMetric(String operation, int duration) {
    _metrics.putIfAbsent(operation, () => []).add(duration);

    final metrics = _metrics[operation]!;
    final average = metrics.reduce((a, b) => a + b) / metrics.length;

    LoggerService.info('Performance [$operation]: '
        'Last: ${duration}ms, '
        'Avg: ${average.toStringAsFixed(2)}ms, '
        'Count: ${metrics.length}');
  }
}
