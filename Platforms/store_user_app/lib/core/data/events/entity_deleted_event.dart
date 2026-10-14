import 'package:store_user_app/core/data/events/entity_event.dart';

class EntityDeletedEvent<T> extends EntityEvent<T> {
  EntityDeletedEvent({required super.entity, super.userId});
}
