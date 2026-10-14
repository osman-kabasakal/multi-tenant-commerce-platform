import 'package:store_user_app/core/data/events/entity_event.dart';

class EntityCreatedEvent<T> extends EntityEvent<T> {
  EntityCreatedEvent({required super.entity, super.userId});
}
