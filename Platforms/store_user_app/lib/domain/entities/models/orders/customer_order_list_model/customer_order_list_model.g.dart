// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerOrderListModelImpl _$$CustomerOrderListModelImplFromJson(
  Map<String, dynamic> json,
) => _$CustomerOrderListModelImpl(
  pagingContext:
      json['PagingContext'] == null
          ? null
          : OrderPagingModel.fromJson(
            json['PagingContext'] as Map<String, dynamic>,
          ),
  orders:
      (json['Orders'] as List<dynamic>?)
          ?.map((e) => OrderDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CustomerOrderListModelImplToJson(
  _$CustomerOrderListModelImpl instance,
) => <String, dynamic>{
  if (instance.pagingContext case final value?) 'PagingContext': value,
  if (instance.orders case final value?) 'Orders': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
