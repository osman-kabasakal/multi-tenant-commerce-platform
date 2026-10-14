import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../order_paging_model/order_paging_model.dart';

import 'order_details_model/order_details_model.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_order_list_model.freezed.dart';
part 'customer_order_list_model.g.dart';

@freezed
class CustomerOrderListModel
    extends StoreJsonSerializable<CustomerOrderListModel>
    with _$CustomerOrderListModel {
  factory CustomerOrderListModel(
      {@JsonKey(name: 'PagingContext', includeIfNull: false)
      OrderPagingModel? pagingContext,
      @JsonKey(name: 'Orders', includeIfNull: false)
      @Default([])
      List<OrderDetailsModel>? orders,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerOrderListModel;

  factory CustomerOrderListModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerOrderListModelFromJson(json);
}
