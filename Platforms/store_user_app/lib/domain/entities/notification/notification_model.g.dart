// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationListResponseImpl _$$NotificationListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationListResponseImpl(
  data:
      (json['Data'] as List<dynamic>?)
          ?.map((e) => QueuedEmail.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['Total'] as num?)?.toInt(),
);

Map<String, dynamic> _$$NotificationListResponseImplToJson(
  _$NotificationListResponseImpl instance,
) => <String, dynamic>{'Data': instance.data, 'Total': instance.total};

_$NotificationDetailResponseImpl _$$NotificationDetailResponseImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationDetailResponseImpl(
  success: json['success'] as bool?,
  message:
      json['message'] == null
          ? null
          : QueuedEmail.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$NotificationDetailResponseImplToJson(
  _$NotificationDetailResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
