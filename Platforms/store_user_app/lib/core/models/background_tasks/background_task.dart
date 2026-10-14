import 'package:store_user_app/core/models/background_tasks/cancellation_token.dart';
import 'package:uuid/uuid.dart';

typedef BackgroundTaskCallback =
    Future<void> Function(CancellationToken cancellationToken);

class BackgroundTask {
  final String id;
  final DateTime createdAt;
  final CancellationToken cancellationToken;
  final BackgroundTaskCallback callback;

  BackgroundTask({
    CancellationToken? cancellationToken,
    required this.callback,
    String? id,
  }) : id = id ?? const Uuid().v4(),
       createdAt = DateTime.now(),
       cancellationToken = cancellationToken ?? CancellationToken();

  Future<void> execute() async {
    await callback(cancellationToken);
  }
}
