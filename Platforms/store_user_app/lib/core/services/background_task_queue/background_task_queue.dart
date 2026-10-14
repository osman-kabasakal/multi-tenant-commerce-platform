import 'dart:async';
import 'dart:collection';

import 'package:injectable/injectable.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/models/background_tasks/background_task.dart';
import 'package:store_user_app/core/models/background_tasks/cancellation_token.dart';
import 'package:store_user_app/core/models/background_tasks/task_result.dart';
import 'package:store_user_app/core/models/background_tasks/task_status.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:synchronized/synchronized.dart';

@singleton
class BackgroundTaskQueue {
  final _taskQueue = Queue<BackgroundTask>();
  final _scheduledTaskQueue = <DateTime, BackgroundTask>{};
  final _lock = Lock();
  final _results = <String, TaskResult>{};
  final _runningTasks = <String, BackgroundTask>{};

  bool _isProcessing = false;
  final _processingCompleter = Completer<void>();

  final int maxConcurrentTasks;
  final Duration? timeout;

  BackgroundTaskQueue({this.maxConcurrentTasks = 3, this.timeout});

  @factoryMethod
  static BackgroundTaskQueue factorySingleton() {
    return BackgroundTaskQueue(
      maxConcurrentTasks: 3,
      timeout:
          AppConfig.instance.environment == 'development'
              ? null
              : Duration(seconds: 5),
    );
  }

  /// Görevi kuyruğa ekleme
  void enqueueTask(BackgroundTaskCallback task) {
    var bgTask = BackgroundTask(
      cancellationToken: CancellationToken(),
      callback: task,
    );
    _taskQueue.add(bgTask);
    _results[bgTask.id] = TaskResult(
      taskId: bgTask.id,
      status: TaskStatus.queued,
    );
    _processQueue();
  }

  Completer<void>? _scheduleCompleter = null;

  Future<void> scheduleTask(
    BackgroundTaskCallback task, {
    required DateTime scheduleTime,
    required String id,
  }) async {
    if (_results[id] != null) {
      if (_results[id]!.status == TaskStatus.queued) {
        LoggerService.info("Remove queued task from queue");
        _results.remove(id);
      } else if (_results[id]!.status == TaskStatus.running) {
        LoggerService.info("Task is already running");
        // Eğer görev zaten çalışıyorsa, yeni bir görev eklemeye gerek yok
        return;
      }
    }
    if (_lock.locked) {
      if (_scheduleCompleter != null &&
          _scheduleCompleter!.isCompleted == false) {
        await _scheduleCompleter!.future;
      }
    }
    _scheduleCompleter = Completer<void>();
    return await _lock.synchronized(() async {
      var bgTask = BackgroundTask(
        cancellationToken: CancellationToken(),
        callback: task,
        id: id,
      );
      _scheduledTaskQueue.addAll({scheduleTime: bgTask});
      _processScheduledTasks();
      _scheduleCompleter!.complete();
    });
  }

  bool _schedulerProcessing = false;

  Future<void> _processScheduledTasks() async {
    if (_schedulerProcessing || _scheduledTaskQueue.isEmpty) return;
    _schedulerProcessing = true;
    while (_scheduledTaskQueue.isNotEmpty) {
      final now = DateTime.now();
      var entries = _scheduledTaskQueue.keys.toList();
      for (var entry in entries) {
        if (entry.isBefore(now)) {
          var bgTask = _scheduledTaskQueue[entry];

          _taskQueue.add(bgTask!);
          _results[bgTask.id] = TaskResult(
            taskId: bgTask.id,
            status: TaskStatus.queued,
          );
          _processQueue();
          //enqueueTask(entry.value.callback);
          _scheduledTaskQueue.remove(entry);
        }
      }

      await Future.delayed(Duration(seconds: 3));
    }
    _schedulerProcessing = false;
  }

  /// Kuyruk işleme
  Future<void> _processQueue() async {
    if (_isProcessing || _taskQueue.isEmpty) return;
    _isProcessing = true;
    try {
      while (_taskQueue.isNotEmpty &&
          _runningTasks.length < maxConcurrentTasks) {
        final task = _taskQueue.first;
        _taskQueue.removeFirst();
        if (_results[task.id] == null) {
          continue;
        }
        if (task.cancellationToken.isCancelled) {
          _results[task.id] = TaskResult(
            taskId: task.id,
            status: TaskStatus.cancelled,
          );
          continue;
        }

        _processTask(task);
      }
    } finally {
      _isProcessing = false;
      if (_taskQueue.isEmpty && _runningTasks.isEmpty) {
        _processingCompleter.complete();
      }
    }
  }

  /// Tekil görev işleme
  Future<void> _processTask(BackgroundTask task) async {
    _runningTasks[task.id] = task;

    _results[task.id] = TaskResult(taskId: task.id, status: TaskStatus.running);

    try {
      Future<void> taskExecution = task.execute();

      if (timeout != null) {
        taskExecution = taskExecution.timeout(timeout!);
      }

      await Future.any([taskExecution, task.cancellationToken.cancelled]);

      if (task.cancellationToken.isCancelled) {
        _results[task.id] = TaskResult(
          taskId: task.id,
          status: TaskStatus.cancelled,
        );
      } else {
        _results[task.id] = TaskResult(
          taskId: task.id,
          status: TaskStatus.completed,
        );
      }
    } catch (error, stackTrace) {
      _results[task.id] = TaskResult(
        taskId: task.id,
        status: TaskStatus.failed,
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _runningTasks.remove(task.id);
      _processQueue();
    }
  }

  /// Çalışan görev var mı kontrolü
  bool get hasRunningTasks => _runningTasks.isNotEmpty;

  /// Tüm görevlerin tamamlanmasını bekleme
  Future<void> waitForCompletion() => _processingCompleter.future;

  /// Görevi iptal etme
  void cancelTask(String taskId) {
    final runningTask = _runningTasks[taskId];
    if (runningTask != null) {
      runningTask.cancellationToken.cancel();
    }
  }

  /// Tüm görevleri iptal etme
  void cancelAllTasks() {
    for (final task in _runningTasks.values) {
      task.cancellationToken.cancel();
    }
  }

  @disposeMethod
  Future<void> dispose() async {
    if (hasRunningTasks) {
      cancelAllTasks();
      await waitForCompletion();
    }
  }
}
