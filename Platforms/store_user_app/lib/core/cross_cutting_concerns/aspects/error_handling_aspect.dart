import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/models/errors/api_exceptions.dart';
import 'package:store_user_app/core/services/Security/connectivity_monitor.dart';
import 'package:store_user_app/core/services/crashlytics/crashlytics_service.dart';

import '../../constants/app_constants.dart';
import '../../di/injection_container.dart';
import '../../services/background_task_queue/background_task_queue.dart';
import '../../services/correlation/correlation_service.dart';

@lazySingleton
class ErrorHandlingAspect {
  ErrorHandlingAspect();

  Future<T?> handleError<T>({
    required Future<T?> Function() operation,
    String? context,
    Function(String title, String message)? showError,
  }) async {
    try {
      return await operation();
    } on ApiException catch (e) {
      if (e is NetworkException) {
        if (getIt.get<ConnectivityMonitor>().connectionStatus.value.contains(
          ConnectivityResult.none,
        )) {
          var correlationService = getIt.get<CorrelationService>();
          final correlationId = correlationService.getCurrentCorrelationId();
          if (correlationId != null) {
            // Register the cache key with the correlation service
            var zone = Zone.current;
            getIt.get<BackgroundTaskQueue>().enqueueTask((cancellationToken) {
              if (cancellationToken.isCancelled) return Future.value();
              return zone.run(
                    () =>
                    correlationService.setCurrentCacheKey(waitingTasksLockKey),
              );
            });
          }
        }
      }
      _showApiException(e, showError);
      rethrow;
    } catch (e) {
      _showErrorMessage('Error', e.toString(), showError);
      await getIt.get<CrashlyticsService>().recordError(e, StackTrace.current);
      rethrow;
    }
  }

  void _showErrorMessage(
      String title,
      String message,
      Function(String title, String message)? showError,
      ) {
    showError?.call(title, message);
  }

  void _showApiException(
      ApiException error,
      Function(String title, String message)? showError,
      ) {
    showError?.call(error.code ?? 'Error', error.message);
  }
}
