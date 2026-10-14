import 'package:store_user_app/core/data/events/entity_event.dart';

class EntityUpdatedEvent<T> extends EntityEvent<T> {
  final T oldEntity;

  EntityUpdatedEvent({
    required super.entity,
    required this.oldEntity,
    super.userId,
  });
}
