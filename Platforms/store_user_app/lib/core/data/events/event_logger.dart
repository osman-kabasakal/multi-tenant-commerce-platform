import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';

import 'event_bus.dart';

@Singleton()
class EventLogger {
  final EventBus _eventBus;

  EventLogger(this._eventBus) {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _eventBus.stream.listen((event) {
      LoggerService.info('Event Log: ${event.runtimeType} - '
          'Entity: ${event.entity.runtimeType} - '
          'Time: ${event.timestamp} - '
          'User: ${event.userId ?? 'System'}');
    });
  }
}
