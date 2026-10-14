import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/cache/cache_invalidate_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';

@singleton
class CacheInvalidationNotifier {
  final EventBus _eventBus;
  final StreamController<CacheInvalidateEvent> _invalidationController =
      StreamController<CacheInvalidateEvent>.broadcast();

  Stream<CacheInvalidateEvent> get invalidationStream =>
      _invalidationController.stream;

  CacheInvalidationNotifier(this._eventBus) {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _eventBus.stream.where((event) => event is CacheInvalidateEvent).listen((
      event,
    ) {
      _invalidationController.sink.add(event as CacheInvalidateEvent);
    });
  }

  @disposeMethod
  void dispose() {
    _invalidationController.close();
  }
}
