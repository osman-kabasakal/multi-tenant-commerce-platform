// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_out_of_stock_subscriptions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerOutOfStockSubscriptionsModelImpl
_$$CustomerOutOfStockSubscriptionsModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerOutOfStockSubscriptionsModelImpl(
  subscriptions:
      (json['Subscriptions'] as List<dynamic>?)
          ?.map(
            (e) =>
                OutOfStockSubscriptionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  pagerModel:
      json['PagerModel'] == null
          ? null
          : PagerModel.fromJson(json['PagerModel'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$CustomerOutOfStockSubscriptionsModelImplToJson(
  _$CustomerOutOfStockSubscriptionsModelImpl instance,
) => <String, dynamic>{
  if (instance.subscriptions case final value?) 'Subscriptions': value,
  if (instance.pagerModel case final value?) 'PagerModel': value,
};
