import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'order_item_model/order_item_model.dart';

import 'merchandise_return_reason_model/merchandise_return_reason_model.dart';

import 'merchandise_return_action_model/merchandise_return_action_model.dart';

import '../../common/address_model/address_model.dart';

import '../../../common/user_field/user_field.dart';

part 'merchandise_return_model.freezed.dart';
part 'merchandise_return_model.g.dart';

@freezed
class MerchandiseReturnModel
    extends StoreJsonSerializable<MerchandiseReturnModel>
    with _$MerchandiseReturnModel {
  factory MerchandiseReturnModel(
      {@JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
      @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
      @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
      @JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<OrderItemModel>? items,
      @JsonKey(name: 'AvailableReturnReasons', includeIfNull: false)
      @Default([])
      List<MerchandiseReturnReasonModel>? availableReturnReasons,
      @JsonKey(name: 'AvailableReturnActions', includeIfNull: false)
      @Default([])
      List<MerchandiseReturnActionModel>? availableReturnActions,
      @JsonKey(name: 'Comments', includeIfNull: false) String? comments,
      @JsonKey(name: 'PickupDate', includeIfNull: false)
      @Default(null)
      DateTime? pickupDate,
      @JsonKey(name: 'Result', includeIfNull: false) String? result,
      @JsonKey(name: 'Error', includeIfNull: false) String? error,
      @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
      @Default([])
      List<AddressModel>? existingAddresses,
      @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
      @Default(false)
      bool? newAddressPreselected,
      @JsonKey(name: 'MerchandiseReturnNewAddress', includeIfNull: false)
      AddressModel? merchandiseReturnNewAddress,
      @JsonKey(name: 'PickupAddressId', includeIfNull: false)
      String? pickupAddressId,
      @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
      @Default(false)
      bool? showPickupAddress,
      @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
      @Default(false)
      bool? showPickupDate,
      @JsonKey(name: 'PickupDateRequired', includeIfNull: false)
      @Default(false)
      bool? pickupDateRequired,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _MerchandiseReturnModel;

  factory MerchandiseReturnModel.fromJson(Map<String, dynamic> json) =>
      _$MerchandiseReturnModelFromJson(json);
}
