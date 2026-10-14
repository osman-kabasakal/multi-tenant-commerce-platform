import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../shipping/shipping_option/shipping_option.dart';

import '../../../../common/user_field/user_field.dart';

part 'shipping_method_model.freezed.dart';
part 'shipping_method_model.g.dart';

@freezed
class ShippingMethodModel extends StoreJsonSerializable<ShippingMethodModel>
    with _$ShippingMethodModel {
  factory ShippingMethodModel(
      {@JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
      String? shippingRateProviderSystemName,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'Fee', includeIfNull: false) String? fee,
      @JsonKey(name: 'Selected', includeIfNull: false)
      @Default(false)
      bool? selected,
      @JsonKey(name: 'ShippingOption', includeIfNull: false)
      ShippingOption? shippingOption,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ShippingMethodModel;

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingMethodModelFromJson(json);
}
