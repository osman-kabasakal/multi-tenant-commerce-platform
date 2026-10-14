import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/models/background_tasks/cancellation_token.dart';

abstract class EntityEventListener<T extends EntityEvent> {
  Future<void> onEntityEvent(T event, CancellationToken cancellationToken);
}
