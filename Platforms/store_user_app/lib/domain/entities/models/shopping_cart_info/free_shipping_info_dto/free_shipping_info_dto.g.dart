// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_shipping_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FreeShippingInfoDtoImpl _$$FreeShippingInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$FreeShippingInfoDtoImpl(
  isFreeShippingActive: json['IsFreeShippingActive'] as bool? ?? false,
  minimumAmountForFreeShipping:
      (json['MinimumAmountForFreeShipping'] as num?)?.toDouble() ?? null,
  remainingAmountForFreeShipping:
      (json['RemainingAmountForFreeShipping'] as num?)?.toDouble() ?? null,
  freeShippingDescription: json['FreeShippingDescription'] as String?,
  freeShippingSource: json['FreeShippingSource'] as String?,
  currencyCode: json['CurrencyCode'] as String?,
  formattedMinimumAmount: json['FormattedMinimumAmount'] as String?,
  formattedRemainingAmount: json['FormattedRemainingAmount'] as String?,
);

Map<String, dynamic> _$$FreeShippingInfoDtoImplToJson(
  _$FreeShippingInfoDtoImpl instance,
) => <String, dynamic>{
  if (instance.isFreeShippingActive case final value?)
    'IsFreeShippingActive': value,
  if (instance.minimumAmountForFreeShipping case final value?)
    'MinimumAmountForFreeShipping': value,
  if (instance.remainingAmountForFreeShipping case final value?)
    'RemainingAmountForFreeShipping': value,
  if (instance.freeShippingDescription case final value?)
    'FreeShippingDescription': value,
  if (instance.freeShippingSource case final value?)
    'FreeShippingSource': value,
  if (instance.currencyCode case final value?) 'CurrencyCode': value,
  if (instance.formattedMinimumAmount case final value?)
    'FormattedMinimumAmount': value,
  if (instance.formattedRemainingAmount case final value?)
    'FormattedRemainingAmount': value,
};
