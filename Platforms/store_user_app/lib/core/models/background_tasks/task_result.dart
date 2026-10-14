import 'package:store_user_app/core/models/background_tasks/task_status.dart';

class TaskResult {
  final String taskId;
  final TaskStatus status;
  final dynamic error;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  TaskResult({
    required this.taskId,
    required this.status,
    this.error,
    this.stackTrace,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
