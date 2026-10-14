import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/address_model/address_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel extends StoreJsonSerializable<OrderModel> with _$OrderModel {
  factory OrderModel(
      {@JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
      @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
      @JsonKey(name: 'ShippingMethod', includeIfNull: false)
      String? shippingMethod,
      @JsonKey(name: 'PickUpInStore', includeIfNull: false)
      @Default(false)
      bool? pickUpInStore,
      @JsonKey(name: 'PickupAddress', includeIfNull: false)
      AddressModel? pickupAddress,
      @JsonKey(name: 'ShippingAddress', includeIfNull: false)
      AddressModel? shippingAddress,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
