abstract class EntityEvent<T> {
  final T entity;
  final DateTime timestamp;
  final String? userId;

  EntityEvent({
    required this.entity,
    String? userId,
  })  : timestamp = DateTime.now(),
        userId = userId;
}
