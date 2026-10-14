import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/orders/customer_order_list_model/customer_order_list_model.dart';
import 'package:store_user_app/domain/entities/models/orders/customer_order_list_model/order_details_model/order_details_model.dart';

import 'package:store_user_app/domain/entities/models/orders/order_paging_model/order_paging_model.dart';

part 'order_list_view_model.freezed.dart';

@freezed
class OrderListViewModel with _$OrderListViewModel {
  const factory OrderListViewModel({
    @Default(true) bool isLoading,
    OrderPagingModel? pagingContext,
    @Default(<OrderDetailsModel>[]) List<OrderDetailsModel> orders,
    CustomerOrderListModel? customerOrderListModel,
  }) = _OrderListViewModel;
}
