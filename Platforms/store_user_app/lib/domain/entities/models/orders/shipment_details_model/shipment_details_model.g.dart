// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShipmentDetailsModelImpl _$$ShipmentDetailsModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShipmentDetailsModelImpl(
  shipmentNumber: (json['ShipmentNumber'] as num?)?.toInt(),
  trackingNumber: json['TrackingNumber'] as String?,
  trackingNumberUrl: json['TrackingNumberUrl'] as String?,
  shippedDate:
      json['ShippedDate'] == null
          ? null
          : DateTime.parse(json['ShippedDate'] as String),
  deliveryDate:
      json['DeliveryDate'] == null
          ? null
          : DateTime.parse(json['DeliveryDate'] as String),
  shipmentStatusEvents:
      (json['ShipmentStatusEvents'] as List<dynamic>?)
          ?.map(
            (e) => ShipmentStatusEventModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  showSku: json['ShowSku'] as bool? ?? false,
  items:
      (json['Items'] as List<dynamic>?)
          ?.map((e) => ShipmentItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  shipmentNotes:
      (json['ShipmentNotes'] as List<dynamic>?)
          ?.map((e) => ShipmentNote.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  order:
      json['Order'] == null
          ? null
          : OrderModel.fromJson(json['Order'] as Map<String, dynamic>),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ShipmentDetailsModelImplToJson(
  _$ShipmentDetailsModelImpl instance,
) => <String, dynamic>{
  if (instance.shipmentNumber case final value?) 'ShipmentNumber': value,
  if (instance.trackingNumber case final value?) 'TrackingNumber': value,
  if (instance.trackingNumberUrl case final value?) 'TrackingNumberUrl': value,
  if (instance.shippedDate?.toIso8601String() case final value?)
    'ShippedDate': value,
  if (instance.deliveryDate?.toIso8601String() case final value?)
    'DeliveryDate': value,
  if (instance.shipmentStatusEvents case final value?)
    'ShipmentStatusEvents': value,
  if (instance.showSku case final value?) 'ShowSku': value,
  if (instance.items case final value?) 'Items': value,
  if (instance.shipmentNotes case final value?) 'ShipmentNotes': value,
  if (instance.order case final value?) 'Order': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
