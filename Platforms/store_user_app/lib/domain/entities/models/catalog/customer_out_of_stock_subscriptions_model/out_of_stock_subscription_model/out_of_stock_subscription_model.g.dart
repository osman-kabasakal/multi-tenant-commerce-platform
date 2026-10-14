// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'out_of_stock_subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OutOfStockSubscriptionModelImpl _$$OutOfStockSubscriptionModelImplFromJson(
  Map<String, dynamic> json,
) => _$OutOfStockSubscriptionModelImpl(
  productId: json['ProductId'] as String?,
  productName: json['ProductName'] as String?,
  attributeDescription: json['AttributeDescription'] as String?,
  seName: json['SeName'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OutOfStockSubscriptionModelImplToJson(
  _$OutOfStockSubscriptionModelImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.attributeDescription case final value?)
    'AttributeDescription': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
