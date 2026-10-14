import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';


part 'free_shipping_info_dto.freezed.dart';
part 'free_shipping_info_dto.g.dart';

@freezed
class FreeShippingInfoDto extends StoreJsonSerializable<FreeShippingInfoDto> with _$FreeShippingInfoDto {
  factory FreeShippingInfoDto({ 
    @JsonKey(name: 'IsFreeShippingActive', includeIfNull: false)
    @Default(false) bool? isFreeShippingActive,

    @JsonKey(name: 'MinimumAmountForFreeShipping', includeIfNull: false)
    @Default(null) double? minimumAmountForFreeShipping,

    @JsonKey(name: 'RemainingAmountForFreeShipping', includeIfNull: false)
    @Default(null) double? remainingAmountForFreeShipping,

    @JsonKey(name: 'FreeShippingDescription', includeIfNull: false)
     String? freeShippingDescription,

    @JsonKey(name: 'FreeShippingSource', includeIfNull: false)
     String? freeShippingSource,

    @JsonKey(name: 'CurrencyCode', includeIfNull: false)
     String? currencyCode,

    @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
     String? formattedMinimumAmount,

    @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
     String? formattedRemainingAmount
}) = _FreeShippingInfoDto;

  factory FreeShippingInfoDto.fromJson(Map<String, dynamic> json) =>
      _$FreeShippingInfoDtoFromJson(json);
}