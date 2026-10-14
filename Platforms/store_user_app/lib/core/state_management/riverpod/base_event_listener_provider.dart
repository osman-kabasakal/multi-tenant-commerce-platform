import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import '../../data/events/entity_event.dart';
import '../../data/events/event_bus.dart';

mixin BaseEventListenerProvider<T> on AutoDisposeAsyncNotifier<T> {
  StreamSubscription<EntityEvent>? _eventSubscription;

  void initListenar() {
    _eventSubscription = getIt<EventBus>().stream.listen((event) {
      handleEvent(event);
    });
    ref.onDispose(dispose);
  }

  void dispose() {
    _eventSubscription?.cancel();
  }

  void handleEvent(EntityEvent event);
}
