// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_warehouse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductWarehouseModelImpl _$$ProductWarehouseModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductWarehouseModelImpl(
  use: json['Use'] as bool? ?? false,
  warehouseId: json['WarehouseId'] as String?,
  code: json['Code'] as String?,
  name: json['Name'] as String?,
  stockQuantity: (json['StockQuantity'] as num?)?.toInt(),
  reservedQuantity: (json['ReservedQuantity'] as num?)?.toInt(),
  selected: json['Selected'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductWarehouseModelImplToJson(
  _$ProductWarehouseModelImpl instance,
) => <String, dynamic>{
  if (instance.use case final value?) 'Use': value,
  if (instance.warehouseId case final value?) 'WarehouseId': value,
  if (instance.code case final value?) 'Code': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.stockQuantity case final value?) 'StockQuantity': value,
  if (instance.reservedQuantity case final value?) 'ReservedQuantity': value,
  if (instance.selected case final value?) 'Selected': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
