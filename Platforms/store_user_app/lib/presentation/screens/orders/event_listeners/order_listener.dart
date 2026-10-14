import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_event_listener.dart';
import 'package:store_user_app/core/data/events/entity_updated_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/background_tasks/cancellation_token.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/domain/entities/models/orders/order_details_model/order_details_model.dart';
import 'package:store_user_app/domain/entities/models/orders/order_paging_model/order_paging_model.dart';
import 'package:store_user_app/domain/repositories/order/order_repository.dart';
import 'package:store_user_app/domain/usecases/orders/order_list_use_case.dart';

@Injectable(as: EntityEventListener<EntityCreatedEvent<OrderDetailsModel>>)
class OrderCreatedListener
    extends EntityEventListener<EntityCreatedEvent<OrderDetailsModel>> {
  @override
  Future<void> onEntityEvent(
    EntityCreatedEvent<OrderDetailsModel> event,
    CancellationToken cancellationToken,
  ) async {
    try {
      var boxName = (await getIt.getAsync<OrderRepository>()).generateCacheKey(
        "/Order/CustomerOrders",
        [OrderPagingModel(pageIndex: 0, pageNumber: 1, pageSize: 20)],
      );
      var remoteCache = await getIt.getAsync<CacheManager>();
      var oldOrders = await remoteCache.getAsync<List<OrderDetailsModel>>(
        boxName,
        () async => [],
      );

      await remoteCache.removeAsync(boxName);
      await remoteCache.setAsyncWithTime<List<OrderDetailsModel>>(
        boxName,
        () async => [event.entity, ...(oldOrders ?? [])],
        Duration(days: 360),
      );

      // late Box<Map<String, dynamic>> box;
      // if (!Hive.isBoxOpen(boxName)) {
      //   try {
      //     box = await Hive.openBox<Map<String, dynamic>>(boxName);
      //   } catch (e) {
      //     box = Hive.box<Map<String, dynamic>>(boxName);
      //   }
      // } else {
      //   box = Hive.box<Map<String, dynamic>>(boxName);
      // }

      // await box.put(
      //     event.entity.id,
      //     (jsonDecode(jsonEncode(event.entity.toJson()))
      //             as Map<String, dynamic>)
      //         .toDynamicMap());
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }
}

@Injectable(as: EntityEventListener<EntityUpdatedEvent<OrderDetailsModel>>)
class OrderUpdatedListener
    extends EntityEventListener<EntityUpdatedEvent<OrderDetailsModel>> {
  @override
  Future<void> onEntityEvent(
    EntityUpdatedEvent<OrderDetailsModel> event,
    CancellationToken cancellationToken,
  ) async {
    try {
      var boxName = (await getIt.getAsync<OrderRepository>()).generateCacheKey(
        "/Order/CustomerOrders",
        [OrderPagingModel(pageIndex: 0, pageNumber: 1, pageSize: 20)],
      );

      var remoteCache = await getIt.getAsync<CacheManager>();
      var oldOrders = await remoteCache.getAsync<List<OrderDetailsModel>>(
        boxName,
        () async => null,
      );

      var index = oldOrders?.indexWhere(
        (element) => element.id == event.entity.id,
      );
      if (index != null && index >= 0) {
        oldOrders![index] = event.entity;
      }

      await remoteCache.removeAsync(boxName);
      await remoteCache.setAsyncWithTime<List<OrderDetailsModel>>(
        boxName,
        () async => (oldOrders ?? []),
        Duration(days: 360),
      );

      // late Box<Map<String, dynamic>> box;
      // if (!Hive.isBoxOpen(boxName)) {
      //   try {
      //     box = await Hive.openBox<Map<String, dynamic>>(boxName);
      //   } catch (e) {
      //     box = Hive.box<Map<String, dynamic>>(boxName);
      //   }
      // } else {
      //   box = Hive.box<Map<String, dynamic>>(boxName);
      // }

      // await box.put(
      //     event.entity.id,
      //     (jsonDecode(jsonEncode(event.entity.toJson()))
      //             as Map<String, dynamic>)
      //         .toDynamicMap());
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }
}
