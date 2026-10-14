import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/order/order_data_source.dart';
import '../../entities/models/orders/customer_order_list_model/customer_order_list_model.dart';
import '../../entities/models/orders/order_details_model/order_details_model.dart';
import '../../entities/models/orders/add_order_note_model/add_order_note_model.dart';
import '../../entities/models/orders/shipment_details_model/shipment_details_model.dart';
import '../../entities/models/orders/customer_loyalty_points_model/customer_loyalty_points_model.dart';
import '../../entities/models/orders/order_paging_model/order_paging_model.dart';

@lazySingleton
class OrderRepository extends BaseRepository {
  final OrderDataSource _dataSource;

  OrderRepository(this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<CustomerOrderListModel>?> getOrderCustomerOrders(
      OrderPagingModel command) async {
    return await decorator.execute<ApiResponse<CustomerOrderListModel>>(
      operationName: "/Order/CustomerOrders",
      cacheKey: generateCacheKey("/Order/CustomerOrders", [command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getOrderCustomerOrders(command);
      },
    );
  }

  Future<ApiResponse<OrderDetailsModel>?> getOrderDetails(
      String orderId) async {
    return await decorator.execute<ApiResponse<OrderDetailsModel>>(
      operationName: "/Order/Details",
      cacheKey: generateCacheKey("/Order/Details", [orderId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getOrderDetails(orderId);
      },
    );
  }

  Future<ApiResponse<dynamic>?> getOrderCancelOrder(String orderId) async {
    return await decorator.execute<ApiResponse<dynamic>>(
      operationName: "/Order/CancelOrder",
      cacheKey: null, //generateCacheKey("/Order/CancelOrder", [orderId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getOrderCancelOrder(orderId);
      },
    );
  }

  Future<List<int>> getOrderGetPdfInvoice(String orderId) async {
    return await decorator.execute<dynamic>(
      operationName: "/Order/GetPdfInvoice",
      cacheKey: null, //generateCacheKey("/Order/GetPdfInvoice", [orderId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getOrderGetPdfInvoice(orderId);
      },
    );
  }

  Future<ApiResponse<AddOrderNoteModel>?> postOrderAddOrderNote(
      AddOrderNoteModel model) async {
    return await decorator.execute<ApiResponse<AddOrderNoteModel>>(
      operationName: "/Order/AddOrderNote",
      cacheKey: null, //generateCacheKey("/Order/AddOrderNote", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postOrderAddOrderNote(model);
      },
    );
  }

  Future<ApiResponse<bool>?> getOrderReOrder(String orderId) async {
    return await decorator.execute<ApiResponse<bool>>(
      operationName: "/Order/ReOrder",
      cacheKey: null, //generateCacheKey("/Order/ReOrder", [orderId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getOrderReOrder(orderId);
      },
    );
  }

  Future<ApiResponse<dynamic>?> postOrderRePostPayment(String orderId) async {
    return await decorator.execute<ApiResponse<dynamic>>(
      operationName: "/Order/RePostPayment",
      cacheKey: null, //generateCacheKey("/Order/RePostPayment", [orderId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postOrderRePostPayment(orderId);
      },
    );
  }

  Future<ApiResponse<ShipmentDetailsModel>?> getOrderShipmentDetails(
      String shipmentId) async {
    return await decorator.execute<ApiResponse<ShipmentDetailsModel>>(
      operationName: "/Order/ShipmentDetails",
      cacheKey: generateCacheKey("/Order/ShipmentDetails", [shipmentId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getOrderShipmentDetails(shipmentId);
      },
    );
  }

  Future<ApiResponse<CustomerLoyaltyPointsModel>?>
      getOrderCustomerLoyaltyPoints() async {
    return await decorator.execute<ApiResponse<CustomerLoyaltyPointsModel>>(
      operationName: "/Order/CustomerLoyaltyPoints",
      cacheKey: generateCacheKey("/Order/CustomerLoyaltyPoints", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getOrderCustomerLoyaltyPoints();
      },
    );
  }
}
