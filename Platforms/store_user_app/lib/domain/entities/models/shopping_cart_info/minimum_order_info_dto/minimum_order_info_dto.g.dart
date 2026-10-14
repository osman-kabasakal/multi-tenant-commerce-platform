// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minimum_order_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MinimumOrderInfoDtoImpl _$$MinimumOrderInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MinimumOrderInfoDtoImpl(
  minimumOrderAmount: (json['MinimumOrderAmount'] as num?)?.toDouble(),
  remainingAmount: (json['RemainingAmount'] as num?)?.toDouble(),
  isMet: json['IsMet'] as bool? ?? false,
  currencyCode: json['CurrencyCode'] as String?,
  formattedMinimumAmount: json['FormattedMinimumAmount'] as String?,
  formattedRemainingAmount: json['FormattedRemainingAmount'] as String?,
);

Map<String, dynamic> _$$MinimumOrderInfoDtoImplToJson(
  _$MinimumOrderInfoDtoImpl instance,
) => <String, dynamic>{
  if (instance.minimumOrderAmount case final value?)
    'MinimumOrderAmount': value,
  if (instance.remainingAmount case final value?) 'RemainingAmount': value,
  if (instance.isMet case final value?) 'IsMet': value,
  if (instance.currencyCode case final value?) 'CurrencyCode': value,
  if (instance.formattedMinimumAmount case final value?)
    'FormattedMinimumAmount': value,
  if (instance.formattedRemainingAmount case final value?)
    'FormattedRemainingAmount': value,
};
