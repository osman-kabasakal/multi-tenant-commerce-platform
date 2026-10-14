// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_status_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShipmentStatusEventModelImpl _$$ShipmentStatusEventModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShipmentStatusEventModelImpl(
  eventName: json['EventName'] as String?,
  location: json['Location'] as String?,
  country: json['Country'] as String?,
  date: json['Date'] == null ? null : DateTime.parse(json['Date'] as String),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ShipmentStatusEventModelImplToJson(
  _$ShipmentStatusEventModelImpl instance,
) => <String, dynamic>{
  if (instance.eventName case final value?) 'EventName': value,
  if (instance.location case final value?) 'Location': value,
  if (instance.country case final value?) 'Country': value,
  if (instance.date?.toIso8601String() case final value?) 'Date': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
