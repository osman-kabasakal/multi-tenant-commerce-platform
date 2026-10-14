// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_bid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddBidModelImpl _$$AddBidModelImplFromJson(Map<String, dynamic> json) =>
    _$AddBidModelImpl(
      productId: json['ProductId'] as String?,
      highestBidValue: json['HighestBidValue'] as String?,
      warehouseId: json['WarehouseId'] as String?,
    );

Map<String, dynamic> _$$AddBidModelImplToJson(_$AddBidModelImpl instance) =>
    <String, dynamic>{
      if (instance.productId case final value?) 'ProductId': value,
      if (instance.highestBidValue case final value?) 'HighestBidValue': value,
      if (instance.warehouseId case final value?) 'WarehouseId': value,
    };
