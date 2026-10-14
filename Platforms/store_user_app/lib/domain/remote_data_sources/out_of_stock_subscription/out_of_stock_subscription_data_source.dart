import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/anonymous_type__f3_e1_e574/anonymous_type__f3_e1_e574.dart';
import '../../entities/models/catalog/customer_out_of_stock_subscriptions_model/customer_out_of_stock_subscriptions_model.dart';
import '../../entities/models/catalog/product_model/product_model.dart';

part 'out_of_stock_subscription_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class OutOfStockSubscriptionDataSource {
  @factoryMethod
  factory OutOfStockSubscriptionDataSource(Dio dio) {
    return _OutOfStockSubscriptionDataSource(dio);
  }

  @GET('/OutOfStockSubscription/SubscribeButton')
  Future<String> getOutOfStockSubscriptionSubscribeButton(
      @Query('productId') String productId,
      @Query('warehouseId') String warehouseId);

  @POST('/OutOfStockSubscription/SubscribePopup')
  @Extra({'responseType': ApiResponse<AnonymousType_F3E1E574>()})
  Future<ApiResponse<AnonymousType_F3E1E574>>
      postOutOfStockSubscriptionSubscribePopup(@Body() ProductModel model);

  @GET('/OutOfStockSubscription/CustomerSubscriptions')
  @Extra({'responseType': ApiResponse<CustomerOutOfStockSubscriptionsModel>()})
  Future<ApiResponse<CustomerOutOfStockSubscriptionsModel>>
      getOutOfStockSubscriptionCustomerSubscriptions(
          @Query('pageNumber') int pageNumber);

  @POST('/OutOfStockSubscription/CustomerSubscriptions')
  @Extra({'responseType': ApiResponse<CustomerOutOfStockSubscriptionsModel>()})
  Future<ApiResponse<CustomerOutOfStockSubscriptionsModel>>
      postOutOfStockSubscriptionCustomerSubscriptions(
          @Body() List<String> subscriptions);
}
