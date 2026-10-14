// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      productId: json['ProductId'] as String?,
      warehouseId: json['WarehouseId'] as String?,
      reservationDatepickerFrom: json['ReservationDatepickerFrom'] as String?,
      reservationDatepickerTo: json['ReservationDatepickerTo'] as String?,
      loadPicture: json['LoadPicture'] as bool? ?? false,
      attributes:
          (json['Attributes'] as List<dynamic>?)
              ?.map(
                (e) => CustomAttributeModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      if (instance.productId case final value?) 'ProductId': value,
      if (instance.warehouseId case final value?) 'WarehouseId': value,
      if (instance.reservationDatepickerFrom case final value?)
        'ReservationDatepickerFrom': value,
      if (instance.reservationDatepickerTo case final value?)
        'ReservationDatepickerTo': value,
      if (instance.loadPicture case final value?) 'LoadPicture': value,
      if (instance.attributes case final value?) 'Attributes': value,
    };
