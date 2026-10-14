import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../common/address_model/address_model.dart';

import '../../../common/user_field/user_field.dart';

part 'checkout_billing_address_model.freezed.dart';
part 'checkout_billing_address_model.g.dart';

@freezed
class CheckoutBillingAddressModel
    extends StoreJsonSerializable<CheckoutBillingAddressModel>
    with _$CheckoutBillingAddressModel {
  factory CheckoutBillingAddressModel(
      {@JsonKey(name: 'ExistingAddresses', includeIfNull: false)
      @Default([])
      List<AddressModel>? existingAddresses,
      @JsonKey(name: 'BillingNewAddress', includeIfNull: false)
      AddressModel? billingNewAddress,
      @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
      @Default(false)
      bool? newAddressPreselected,
      @JsonKey(name: 'BillingAddressId', includeIfNull: false)
      String? billingAddressId,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CheckoutBillingAddressModel;

  factory CheckoutBillingAddressModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutBillingAddressModelFromJson(json);
}
