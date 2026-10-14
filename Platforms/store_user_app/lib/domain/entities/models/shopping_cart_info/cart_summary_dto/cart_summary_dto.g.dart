// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartSummaryDtoImpl _$$CartSummaryDtoImplFromJson(Map<String, dynamic> json) =>
    _$CartSummaryDtoImpl(
      subtotal: (json['Subtotal'] as num?)?.toDouble(),
      formattedSubtotal: json['FormattedSubtotal'] as String?,
      itemCount: (json['ItemCount'] as num?)?.toInt(),
      currencyCode: json['CurrencyCode'] as String?,
    );

Map<String, dynamic> _$$CartSummaryDtoImplToJson(
  _$CartSummaryDtoImpl instance,
) => <String, dynamic>{
  if (instance.subtotal case final value?) 'Subtotal': value,
  if (instance.formattedSubtotal case final value?) 'FormattedSubtotal': value,
  if (instance.itemCount case final value?) 'ItemCount': value,
  if (instance.currencyCode case final value?) 'CurrencyCode': value,
};
