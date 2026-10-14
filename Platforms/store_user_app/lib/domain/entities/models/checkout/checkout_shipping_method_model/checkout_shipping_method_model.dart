import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'shipping_method_model/shipping_method_model.dart';

import '../../../common/user_field/user_field.dart';

part 'checkout_shipping_method_model.freezed.dart';
part 'checkout_shipping_method_model.g.dart';

@freezed
class CheckoutShippingMethodModel
    extends StoreJsonSerializable<CheckoutShippingMethodModel>
    with _$CheckoutShippingMethodModel {
  factory CheckoutShippingMethodModel(
      {@JsonKey(name: 'ShippingMethods', includeIfNull: false)
      @Default([])
      List<ShippingMethodModel>? shippingMethods,
      @JsonKey(name: 'ShippingOption', includeIfNull: false)
      String? shippingOption,
      @JsonKey(name: 'Data', includeIfNull: false)
      @Default({})
      Map<String, String>? data,
      @JsonKey(name: 'Warnings', includeIfNull: false)
      @Default([])
      List<String>? warnings,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CheckoutShippingMethodModel;

  factory CheckoutShippingMethodModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutShippingMethodModelFromJson(json);
}
