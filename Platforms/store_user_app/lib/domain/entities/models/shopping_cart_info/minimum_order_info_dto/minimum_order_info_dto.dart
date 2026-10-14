import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';


part 'minimum_order_info_dto.freezed.dart';
part 'minimum_order_info_dto.g.dart';

@freezed
class MinimumOrderInfoDto extends StoreJsonSerializable<MinimumOrderInfoDto> with _$MinimumOrderInfoDto {
  factory MinimumOrderInfoDto({ 
    @JsonKey(name: 'MinimumOrderAmount', includeIfNull: false)
     double? minimumOrderAmount,

    @JsonKey(name: 'RemainingAmount', includeIfNull: false)
     double? remainingAmount,

    @JsonKey(name: 'IsMet', includeIfNull: false)
    @Default(false) bool? isMet,

    @JsonKey(name: 'CurrencyCode', includeIfNull: false)
     String? currencyCode,

    @JsonKey(name: 'FormattedMinimumAmount', includeIfNull: false)
     String? formattedMinimumAmount,

    @JsonKey(name: 'FormattedRemainingAmount', includeIfNull: false)
     String? formattedRemainingAmount
}) = _MinimumOrderInfoDto;

  factory MinimumOrderInfoDto.fromJson(Map<String, dynamic> json) =>
      _$MinimumOrderInfoDtoFromJson(json);
}