// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TierPriceModelImpl _$$TierPriceModelImplFromJson(Map<String, dynamic> json) =>
    _$TierPriceModelImpl(
      price: json['Price'] as String?,
      quantity: (json['Quantity'] as num?)?.toInt(),
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TierPriceModelImplToJson(
  _$TierPriceModelImpl instance,
) => <String, dynamic>{
  if (instance.price case final value?) 'Price': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
