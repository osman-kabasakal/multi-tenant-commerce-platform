import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'tier_price.freezed.dart';
part 'tier_price.g.dart';

@freezed
class TierPrice extends StoreJsonSerializable<TierPrice> with _$TierPrice {
  factory TierPrice(
      {@JsonKey(name: 'StoreId', includeIfNull: false) String? storeId,
      @JsonKey(name: 'CustomerGroupId', includeIfNull: false)
      String? customerGroupId,
      @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'Price', includeIfNull: false) double? price,
      @JsonKey(name: 'StartDateTimeUtc', includeIfNull: false)
      @Default(null)
      DateTime? startDateTimeUtc,
      @JsonKey(name: 'EndDateTimeUtc', includeIfNull: false)
      @Default(null)
      DateTime? endDateTimeUtc,
      @JsonKey(name: 'Id', includeIfNull: false) String? id}) = _TierPrice;

  factory TierPrice.fromJson(Map<String, dynamic> json) =>
      _$TierPriceFromJson(json);
}
