import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/events/common_event.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_deleted_event.dart';
import 'package:store_user_app/core/data/events/entity_event_listener.dart';
import 'package:store_user_app/core/data/events/entity_updated_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';

import 'entity_event.dart';

@singleton
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final _controller = StreamController<EntityEvent>.broadcast(
    onCancel: () {
      debugPrint('EventBus stream cancelled');
    },
  );

  Stream<EntityEvent> get stream => _controller.stream;

  void publish<T>(EntityEvent<T> event) {
    _controller.sink.add(event);

    _publishEvent<T>(event);
  }

  void _publishEvent<T>(EntityEvent<T> event) {
    try {
      if (event is EntityCreatedEvent) {
        onEntityCreated(event as EntityCreatedEvent<T>);
      } else if (event is EntityUpdatedEvent) {
        onEntityUpdated(event as EntityUpdatedEvent<T>);
      } else if (event is EntityDeletedEvent) {
        onEntityDeleted(event as EntityDeletedEvent<T>);
      } else if (event is CommonEvent) {
        onEntityEvent(event as CommonEvent<T>);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  void onEntityCreated<T>(EntityCreatedEvent<T> event) {
    try {
      if (!getIt.isRegistered<EntityEventListener<EntityCreatedEvent<T>>>()) {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      return;
    }

    var listeners = getIt.getAll<EntityEventListener<EntityCreatedEvent<T>>>();
    for (var listener in listeners) {
      getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
        await listener.onEntityEvent(event, cancellationToken);
      });
    }
  }

  void onEntityUpdated<T>(EntityUpdatedEvent<T> event) {
    try {
      if (!getIt.isRegistered<EntityEventListener<EntityUpdatedEvent<T>>>()) {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      return;
    }

    var listeners = getIt.getAll<EntityEventListener<EntityUpdatedEvent<T>>>();
    for (var listener in listeners) {
      getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
        await listener.onEntityEvent(event, cancellationToken);
      });
    }
  }

  void onEntityDeleted<T>(EntityDeletedEvent<T> event) {
    try {
      if (!getIt.isRegistered<EntityEventListener<EntityDeletedEvent<T>>>()) {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      return;
    }

    var listeners = getIt.getAll<EntityEventListener<EntityDeletedEvent<T>>>();
    for (var listener in listeners) {
      getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
        await listener.onEntityEvent(event, cancellationToken);
      });
    }
  }

  void onEntityEvent<T>(CommonEvent<T> event) {
    try {
      if (!getIt.isRegistered<EntityEventListener<CommonEvent<T>>>()) return;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
      return;
    }

    var listeners = getIt.getAll<EntityEventListener<CommonEvent<T>>>();
    for (var listener in listeners) {
      getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
        await listener.onEntityEvent(event, cancellationToken);
      });
    }
  }

  @disposeMethod
  void dispose() {
    _controller.close();
  }
}
