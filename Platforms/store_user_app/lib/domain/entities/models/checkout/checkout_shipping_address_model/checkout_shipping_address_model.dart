import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../common/address_model/address_model.dart';

import '../checkout_pickup_point_model/checkout_pickup_point_model.dart';

import '../../../common/user_field/user_field.dart';

part 'checkout_shipping_address_model.freezed.dart';
part 'checkout_shipping_address_model.g.dart';

@freezed
class CheckoutShippingAddressModel
    extends StoreJsonSerializable<CheckoutShippingAddressModel>
    with _$CheckoutShippingAddressModel {
  factory CheckoutShippingAddressModel(
      {@JsonKey(name: 'ExistingAddresses', includeIfNull: false)
      @Default([])
      List<AddressModel>? existingAddresses,
      @JsonKey(name: 'Warnings', includeIfNull: false)
      @Default([])
      List<String>? warnings,
      @JsonKey(name: 'ShippingNewAddress', includeIfNull: false)
      AddressModel? shippingNewAddress,
      @JsonKey(name: 'ShippingAddressId', includeIfNull: false)
      String? shippingAddressId,
      @JsonKey(name: 'PickupPointId', includeIfNull: false)
      String? pickupPointId,
      @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
      @Default(false)
      bool? newAddressPreselected,
      @JsonKey(name: 'PickupPoints', includeIfNull: false)
      @Default([])
      List<CheckoutPickupPointModel>? pickupPoints,
      @JsonKey(name: 'BillToTheSameAddress', includeIfNull: false)
      @Default(false)
      bool? billToTheSameAddress,
      @JsonKey(name: 'AllowPickUpInStore', includeIfNull: false)
      @Default(false)
      bool? allowPickUpInStore,
      @JsonKey(name: 'PickUpInStore', includeIfNull: false)
      @Default(false)
      bool? pickUpInStore,
      @JsonKey(name: 'PickUpInStoreOnly', includeIfNull: false)
      @Default(false)
      bool? pickUpInStoreOnly,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CheckoutShippingAddressModel;

  factory CheckoutShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutShippingAddressModelFromJson(json);
}
