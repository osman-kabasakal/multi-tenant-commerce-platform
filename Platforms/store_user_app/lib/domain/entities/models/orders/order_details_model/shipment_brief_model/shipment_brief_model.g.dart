// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_brief_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShipmentBriefModelImpl _$$ShipmentBriefModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShipmentBriefModelImpl(
  trackingNumber: json['TrackingNumber'] as String?,
  shipmentNumber: (json['ShipmentNumber'] as num?)?.toInt(),
  shippedDate:
      json['ShippedDate'] == null
          ? null
          : DateTime.parse(json['ShippedDate'] as String),
  deliveryDate:
      json['DeliveryDate'] == null
          ? null
          : DateTime.parse(json['DeliveryDate'] as String),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ShipmentBriefModelImplToJson(
  _$ShipmentBriefModelImpl instance,
) => <String, dynamic>{
  if (instance.trackingNumber case final value?) 'TrackingNumber': value,
  if (instance.shipmentNumber case final value?) 'ShipmentNumber': value,
  if (instance.shippedDate?.toIso8601String() case final value?)
    'ShippedDate': value,
  if (instance.deliveryDate?.toIso8601String() case final value?)
    'DeliveryDate': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
