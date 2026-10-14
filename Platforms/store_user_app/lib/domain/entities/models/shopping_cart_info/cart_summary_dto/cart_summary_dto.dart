import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';


part 'cart_summary_dto.freezed.dart';
part 'cart_summary_dto.g.dart';

@freezed
class CartSummaryDto extends StoreJsonSerializable<CartSummaryDto> with _$CartSummaryDto {
  factory CartSummaryDto({ 
    @JsonKey(name: 'Subtotal', includeIfNull: false)
     double? subtotal,

    @JsonKey(name: 'FormattedSubtotal', includeIfNull: false)
     String? formattedSubtotal,

    @JsonKey(name: 'ItemCount', includeIfNull: false)
     int? itemCount,

    @JsonKey(name: 'CurrencyCode', includeIfNull: false)
     String? currencyCode
}) = _CartSummaryDto;

  factory CartSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryDtoFromJson(json);
}