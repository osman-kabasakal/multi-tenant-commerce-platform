import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/orders/customer_order_list_model/customer_order_list_model.dart';
import '../../entities/models/orders/order_details_model/order_details_model.dart';
import '../../entities/models/orders/add_order_note_model/add_order_note_model.dart';
import '../../entities/models/orders/shipment_details_model/shipment_details_model.dart';
import '../../entities/models/orders/customer_loyalty_points_model/customer_loyalty_points_model.dart';
import '../../entities/models/orders/order_paging_model/order_paging_model.dart';

part 'order_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class OrderDataSource {
  @factoryMethod
  factory OrderDataSource(Dio dio) {
    return _OrderDataSource(dio);
  }

  @GET('/Order/CustomerOrders')
  @Extra({'responseType': ApiResponse<CustomerOrderListModel>()})
  Future<ApiResponse<CustomerOrderListModel>> getOrderCustomerOrders(
    @Field('command') OrderPagingModel command,
  );

  @GET('/Order/Details')
  @Extra({'responseType': ApiResponse<OrderDetailsModel>()})
  Future<ApiResponse<OrderDetailsModel>> getOrderDetails(
    @Query('orderId') String orderId,
  );

  @GET('/Order/CancelOrder')
  @Extra({'responseType': ApiResponse<dynamic>()})
  Future<ApiResponse<dynamic>> getOrderCancelOrder(
    @Query('orderId') String orderId,
  );

  @Headers(<String, String>{'accept': 'application/pdf'})
  @GET('/Order/GetPdfInvoice')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getOrderGetPdfInvoice(@Query('orderId') String orderId);

  @POST('/Order/AddOrderNote')
  @Extra({'responseType': ApiResponse<AddOrderNoteModel>(), 'csrf': true})
  Future<ApiResponse<AddOrderNoteModel>> postOrderAddOrderNote(
    @Body() AddOrderNoteModel model,
  );

  @GET('/Order/ReOrder')
  @Extra({'responseType': ApiResponse<bool>()})
  Future<ApiResponse<bool>> getOrderReOrder(@Query('orderId') String orderId);

  @POST('/Order/RePostPayment')
  @Extra({'responseType': ApiResponse<bool>(), 'csrf': true})
  Future<ApiResponse<bool>> postOrderRePostPayment(
    @Query('orderId') String orderId,
  );

  @GET('/Order/ShipmentDetails')
  @Extra({'responseType': ApiResponse<ShipmentDetailsModel>()})
  Future<ApiResponse<ShipmentDetailsModel>> getOrderShipmentDetails(
    @Query('shipmentId') String shipmentId,
  );

  @GET('/Order/CustomerLoyaltyPoints')
  @Extra({'responseType': ApiResponse<CustomerLoyaltyPointsModel>()})
  Future<ApiResponse<CustomerLoyaltyPointsModel>>
  getOrderCustomerLoyaltyPoints();
}
