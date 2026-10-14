import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'shipping_option.freezed.dart';
part 'shipping_option.g.dart';

@freezed
class ShippingOption extends StoreJsonSerializable<ShippingOption>
    with _$ShippingOption {
  factory ShippingOption(
      {@JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
      String? shippingRateProviderSystemName,
      @JsonKey(name: 'Rate', includeIfNull: false) double? rate,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Description', includeIfNull: false)
      String? description}) = _ShippingOption;

  factory ShippingOption.fromJson(Map<String, dynamic> json) =>
      _$ShippingOptionFromJson(json);
}
