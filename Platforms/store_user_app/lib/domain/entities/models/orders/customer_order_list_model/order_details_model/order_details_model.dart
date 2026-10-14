import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'order_details_model.freezed.dart';
part 'order_details_model.g.dart';

@freezed
class OrderDetailsModel extends StoreJsonSerializable<OrderDetailsModel>
    with _$OrderDetailsModel {
  factory OrderDetailsModel(
      {@JsonKey(name: 'OrderTotal', includeIfNull: false) String? orderTotal,
      @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
      @Default(false)
      bool? isMerchandiseReturnAllowed,
      @JsonKey(name: 'OrderStatusId', includeIfNull: false) int? orderStatusId,
      @JsonKey(name: 'OrderStatus', includeIfNull: false) String? orderStatus,
      @JsonKey(name: 'PaymentStatus', includeIfNull: false)
      String? paymentStatus,
      @JsonKey(name: 'ShippingStatus', includeIfNull: false)
      String? shippingStatus,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
      @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
      @JsonKey(name: 'CustomerEmail', includeIfNull: false)
      String? customerEmail,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _OrderDetailsModel;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsModelFromJson(json);
}
