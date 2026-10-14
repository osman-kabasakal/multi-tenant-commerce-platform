import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/Security/connectivity_monitor.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/core/services/correlation/correlation_service.dart';

import '../../cache/cache_invalidate_event.dart';
import '../../constants/app_constants.dart';
import '../../models/cache/cache_invalidate_model.dart';
import '../../models/cache/cache_invalidate_type.dart';
import '../aspects/error_handling_aspect.dart';
import '../aspects/logging_aspect.dart';
import '../aspects/performance_aspect.dart';
import '../aspects/zoned_caching_aspect.dart';

@lazySingleton
class RepositoryDecorator {
  final CorrelationService _correlationService;
  final LoggingAspect _loggingAspect;
  final ZonedCachingAspect _cachingAspect;
  final ErrorHandlingAspect _errorHandlingAspect;
  final PerformanceAspect _performanceAspect;
  final ConnectivityMonitor _connectivityMonitor;
  final List<String> _waitingTasks = [];
  final EventBus _eventBus;

  RepositoryDecorator(
    this._correlationService,
    this._loggingAspect,
    this._cachingAspect,
    this._errorHandlingAspect,
    this._performanceAspect,
      this._connectivityMonitor,
      this._eventBus,
  ){
    _connectivityMonitor.connectionStatus.addListener((){
      if(_connectivityMonitor.connectionStatus.value.contains(ConnectivityResult.none)){
        getIt.get<BackgroundTaskQueue>().cancelAllTasks();
      }else{
       var tasks = _waitingTasks.toList();
        _waitingTasks.clear();
        if(tasks.isNotEmpty){
          _eventBus.publish(CacheInvalidateEvent(entity: CacheInvalidateModel(type: CacheInvalidateType.key, key: waitingTasksLockKey)));
        }
      }
    });
  }

  Future<R?> execute<R>({
    required String operationName,
    required Future<R?> Function() operation,
    String? cacheKey,
    Duration? cacheDuration,
  }) async {
    return _loggingAspect.logOperation(
      operationName: operationName,
      operation: () => _performanceAspect.measurePerformance(
        operationName: operationName,
        operation: () => _errorHandlingAspect.handleError(
          operation: () {
            if(_connectivityMonitor.connectionStatus.value.contains(ConnectivityResult.none)){
              _addCacheToCorrelation(waitingTasksLockKey);
              return Future.value(null);
            }
            var result = cacheKey != null
                ? _cachingAspect.cacheOperation(
                    key: cacheKey,
                    operation: operation,
                    duration: cacheDuration,
                  )
                : operation();

            _addCacheToCorrelation(cacheKey);
            return result;
          },
        ),
      ),
    );
  }

  void _addCacheToCorrelation(String? cacheKey){
    // If a cache key was used and there's an active correlation
    if (cacheKey != null) {
      final correlationId =
      _correlationService.getCurrentCorrelationId();
      if (correlationId != null) {
        // Register the cache key with the correlation service
        var zone = Zone.current;
        getIt.get<BackgroundTaskQueue>().enqueueTask(
              (cancellationToken) {
            if (cancellationToken.isCancelled) return Future.value();
            return zone.run(
                    () => _correlationService.setCurrentCacheKey(cacheKey));
          },
        );
      }
    }
  }
}
