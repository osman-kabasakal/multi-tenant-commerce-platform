// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoredNotificationImpl _$$StoredNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$StoredNotificationImpl(
  id: json['id'] as String,
  subject: json['subject'] as String?,
  sentOnUtc:
      json['sentOnUtc'] == null
          ? null
          : DateTime.parse(json['sentOnUtc'] as String),
  createdOnUtc:
      json['createdOnUtc'] == null
          ? null
          : DateTime.parse(json['createdOnUtc'] as String),
  notificationShown: json['notificationShown'] as bool? ?? false,
  seenByUser: json['seenByUser'] as bool? ?? false,
  readOnServer: json['readOnServer'] as bool? ?? false,
  lastUpdated: DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$$StoredNotificationImplToJson(
  _$StoredNotificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'subject': instance.subject,
  'sentOnUtc': instance.sentOnUtc?.toIso8601String(),
  'createdOnUtc': instance.createdOnUtc?.toIso8601String(),
  'notificationShown': instance.notificationShown,
  'seenByUser': instance.seenByUser,
  'readOnServer': instance.readOnServer,
  'lastUpdated': instance.lastUpdated.toIso8601String(),
};

_$NotificationStoreImpl _$$NotificationStoreImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationStoreImpl(
  notifications:
      (json['notifications'] as List<dynamic>?)
          ?.map((e) => StoredNotification.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  lastChecked:
      json['lastChecked'] == null
          ? null
          : DateTime.parse(json['lastChecked'] as String),
);

Map<String, dynamic> _$$NotificationStoreImplToJson(
  _$NotificationStoreImpl instance,
) => <String, dynamic>{
  'notifications': instance.notifications,
  'lastChecked': instance.lastChecked?.toIso8601String(),
};
