// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_attribute_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutAttributeValueModelImpl _$$CheckoutAttributeValueModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutAttributeValueModelImpl(
  name: json['Name'] as String?,
  colorSquaresRgb: json['ColorSquaresRgb'] as String?,
  priceAdjustment: json['PriceAdjustment'] as String?,
  isPreSelected: json['IsPreSelected'] as bool? ?? false,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CheckoutAttributeValueModelImplToJson(
  _$CheckoutAttributeValueModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.colorSquaresRgb case final value?) 'ColorSquaresRgb': value,
  if (instance.priceAdjustment case final value?) 'PriceAdjustment': value,
  if (instance.isPreSelected case final value?) 'IsPreSelected': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
