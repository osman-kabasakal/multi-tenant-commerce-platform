import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/out_of_stock_subscription/out_of_stock_subscription_data_source.dart';
import '../../entities/anonymous_type__f3_e1_e574/anonymous_type__f3_e1_e574.dart';
import '../../entities/models/catalog/customer_out_of_stock_subscriptions_model/customer_out_of_stock_subscriptions_model.dart';
import '../../entities/models/catalog/product_model/product_model.dart';

@lazySingleton
class OutOfStockSubscriptionRepository extends BaseRepository {
  final OutOfStockSubscriptionDataSource _dataSource;

  OutOfStockSubscriptionRepository(
      this._dataSource, super.decorator, super.eventBus);

  // ignore: unnecessary_question_mark
  Future<String?> getOutOfStockSubscriptionSubscribeButton(
      String productId, String warehouseId) async {
    return await decorator.execute<String>(
      operationName: "/OutOfStockSubscription/SubscribeButton",
      cacheKey: generateCacheKey(
          "/OutOfStockSubscription/SubscribeButton", [productId, warehouseId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getOutOfStockSubscriptionSubscribeButton(
            productId, warehouseId);
      },
    );
  }

  Future<ApiResponse<AnonymousType_F3E1E574>?>
      postOutOfStockSubscriptionSubscribePopup(ProductModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_F3E1E574>>(
      operationName: "/OutOfStockSubscription/SubscribePopup",
      cacheKey: null,
      // generateCacheKey("/OutOfStockSubscription/SubscribePopup", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .postOutOfStockSubscriptionSubscribePopup(model);
      },
    );
  }

  Future<ApiResponse<CustomerOutOfStockSubscriptionsModel>?>
      getOutOfStockSubscriptionCustomerSubscriptions(int pageNumber) async {
    return await decorator
        .execute<ApiResponse<CustomerOutOfStockSubscriptionsModel>>(
      operationName: "/OutOfStockSubscription/CustomerSubscriptions",
      cacheKey: null,
      // generateCacheKey(
      //     "/OutOfStockSubscription/CustomerSubscriptions", [pageNumber]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .getOutOfStockSubscriptionCustomerSubscriptions(pageNumber);
      },
    );
  }

  Future<ApiResponse<CustomerOutOfStockSubscriptionsModel>?>
      postOutOfStockSubscriptionCustomerSubscriptions(
          List<String> subscriptions) async {
    return await decorator
        .execute<ApiResponse<CustomerOutOfStockSubscriptionsModel>>(
      operationName: "/OutOfStockSubscription/CustomerSubscriptions",
      cacheKey: null,
      // generateCacheKey(
      //     "/OutOfStockSubscription/CustomerSubscriptions", [subscriptions]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .postOutOfStockSubscriptionCustomerSubscriptions(subscriptions);
      },
    );
  }
}
