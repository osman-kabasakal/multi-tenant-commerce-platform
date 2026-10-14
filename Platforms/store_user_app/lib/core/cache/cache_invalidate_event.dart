import 'package:store_user_app/core/data/events/common_event.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/models/cache/cache_invalidate_model.dart';

class CacheInvalidateEvent extends EntityEvent<CacheInvalidateModel>
    with CommonEvent<CacheInvalidateModel> {
  CacheInvalidateEvent({required super.entity});
}
