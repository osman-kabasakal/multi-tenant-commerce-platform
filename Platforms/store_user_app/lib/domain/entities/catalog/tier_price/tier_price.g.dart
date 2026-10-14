// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TierPriceImpl _$$TierPriceImplFromJson(Map<String, dynamic> json) =>
    _$TierPriceImpl(
      storeId: json['StoreId'] as String?,
      customerGroupId: json['CustomerGroupId'] as String?,
      currencyCode: json['CurrencyCode'] as String?,
      quantity: (json['Quantity'] as num?)?.toInt(),
      price: (json['Price'] as num?)?.toDouble(),
      startDateTimeUtc:
          json['StartDateTimeUtc'] == null
              ? null
              : DateTime.parse(json['StartDateTimeUtc'] as String),
      endDateTimeUtc:
          json['EndDateTimeUtc'] == null
              ? null
              : DateTime.parse(json['EndDateTimeUtc'] as String),
      id: json['Id'] as String?,
    );

Map<String, dynamic> _$$TierPriceImplToJson(_$TierPriceImpl instance) =>
    <String, dynamic>{
      if (instance.storeId case final value?) 'StoreId': value,
      if (instance.customerGroupId case final value?) 'CustomerGroupId': value,
      if (instance.currencyCode case final value?) 'CurrencyCode': value,
      if (instance.quantity case final value?) 'Quantity': value,
      if (instance.price case final value?) 'Price': value,
      if (instance.startDateTimeUtc?.toIso8601String() case final value?)
        'StartDateTimeUtc': value,
      if (instance.endDateTimeUtc?.toIso8601String() case final value?)
        'EndDateTimeUtc': value,
      if (instance.id case final value?) 'Id': value,
    };
