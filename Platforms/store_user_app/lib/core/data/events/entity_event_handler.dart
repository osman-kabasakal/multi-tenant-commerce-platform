import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/events/common_event.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_deleted_event.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/data/events/entity_updated_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';

abstract class EntityEventHandler<T> {
  final EventBus _eventBus;

  late final StreamSubscription<EntityEvent> _subscription;

  EntityEventHandler(this._eventBus) {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    _subscription =
        _eventBus.stream.where((e) => e.entity is T).listen((event) async {
      if (event.entity is T) {
        if (event is EntityCreatedEvent) {
          await onEntityCreated(event as EntityCreatedEvent<T>);
        } else if (event is EntityUpdatedEvent) {
          await onEntityUpdated(event as EntityUpdatedEvent<T>);
        } else if (event is EntityDeletedEvent) {
          await onEntityDeleted(event as EntityDeletedEvent<T>);
        } else if (event is CommonEvent) {
          await onEntityEvent(event as CommonEvent<T>);
        }
      }
    });
  }

  Future<void> onEntityCreated(EntityCreatedEvent<T> event) async {}
  Future<void> onEntityUpdated(EntityUpdatedEvent<T> event) async {}
  Future<void> onEntityDeleted(EntityDeletedEvent<T> event) async {}

  Future<void> onEntityEvent(CommonEvent<T> event) async {}

  @disposeMethod
  void dispose() {
    _subscription.cancel();
  }
}
