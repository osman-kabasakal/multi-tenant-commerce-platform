import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../checkout_billing_address_model/checkout_billing_address_model.dart';

import '../checkout_shipping_address_model/checkout_shipping_address_model.dart';

import '../../../common/user_field/user_field.dart';

part 'checkout_model.freezed.dart';
part 'checkout_model.g.dart';

@freezed
class CheckoutModel extends StoreJsonSerializable<CheckoutModel>
    with _$CheckoutModel {
  factory CheckoutModel(
      {@JsonKey(name: 'ShippingRequired', includeIfNull: false)
      @Default(false)
      bool? shippingRequired,
      @JsonKey(name: 'BillingAddress', includeIfNull: false)
      CheckoutBillingAddressModel? billingAddress,
      @JsonKey(name: 'ShippingAddress', includeIfNull: false)
      CheckoutShippingAddressModel? shippingAddress,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CheckoutModel;

  factory CheckoutModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutModelFromJson(json);
}
