import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_event_handler.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_model/merchandise_return_model.dart';
import 'package:store_user_app/domain/repositories/merchandise_return/merchandise_return_repository.dart';

@singleton
class MerchandiseReturnEventHandler
    extends EntityEventHandler<MerchandiseReturnModel> {
  MerchandiseReturnEventHandler(super.eventBus);

  @override
  Future<void> onEntityCreated(
      EntityCreatedEvent<MerchandiseReturnModel> event) async {
    var cacheManager = getIt.get<CacheManager>();
    var merchandiseRepository =
        await getIt.getAsync<MerchandiseReturnRepository>();

    await cacheManager.removeByPrefix(merchandiseRepository
        .generateCachePrefixForRemoval('/MerchandiseReturn'));
  }
}
