// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_rate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaxRateImpl _$$TaxRateImplFromJson(Map<String, dynamic> json) =>
    _$TaxRateImpl(
      rate: json['Rate'] as String?,
      value: json['Value'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TaxRateImplToJson(_$TaxRateImpl instance) =>
    <String, dynamic>{
      if (instance.rate case final value?) 'Rate': value,
      if (instance.value case final value?) 'Value': value,
      if (instance.userFields case final value?) 'UserFields': value,
    };
