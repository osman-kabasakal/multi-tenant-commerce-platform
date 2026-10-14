import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_0327_c72_f.freezed.dart';
part 'anonymous_type_0327_c72_f.g.dart';

@freezed
class AnonymousType_0327C72F
    extends StoreJsonSerializable<AnonymousType_0327C72F>
    with _$AnonymousType_0327C72F {
  factory AnonymousType_0327C72F(
      {@JsonKey(name: 'gtin', includeIfNull: false) String? gtin,
      @JsonKey(name: 'mpn', includeIfNull: false) String? mpn,
      @JsonKey(name: 'sku', includeIfNull: false) String? sku,
      @JsonKey(name: 'price', includeIfNull: false) String? price,
      @JsonKey(name: 'stockAvailability', includeIfNull: false)
      String? stockAvailability,
      @JsonKey(name: 'outOfStockSubscription', includeIfNull: false)
      @Default(false)
      bool? outOfStockSubscription,
      @JsonKey(name: 'buttonTextOutOfStockSubscription', includeIfNull: false)
      String? buttonTextOutOfStockSubscription,
      @JsonKey(name: 'enabledattributemappingids', includeIfNull: false)
      @Default([])
      List<String>? enabledattributemappingids,
      @JsonKey(name: 'disabledattributemappingids', includeIfNull: false)
      @Default([])
      List<String>? disabledattributemappingids,
      @JsonKey(name: 'notAvailableAttributeMappingids', includeIfNull: false)
      @Default([])
      List<String>? notAvailableAttributeMappingids,
      @JsonKey(name: 'pictureFullSizeUrl', includeIfNull: false)
      String? pictureFullSizeUrl,
      @JsonKey(name: 'pictureDefaultSizeUrl', includeIfNull: false)
      String? pictureDefaultSizeUrl}) = _AnonymousType_0327C72F;

  factory AnonymousType_0327C72F.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_0327C72FFromJson(json);
}
