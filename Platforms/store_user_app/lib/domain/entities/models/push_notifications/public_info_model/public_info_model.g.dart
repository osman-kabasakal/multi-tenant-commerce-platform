// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PushNotificationsPublicInfoModelImpl
_$$PushNotificationsPublicInfoModelImplFromJson(Map<String, dynamic> json) =>
    _$PushNotificationsPublicInfoModelImpl(
      senderId: json['SenderId'] as String?,
      publicApiKey: json['PublicApiKey'] as String?,
      authDomain: json['AuthDomain'] as String?,
      databaseUrl: json['DatabaseUrl'] as String?,
      projectId: json['ProjectId'] as String?,
      storageBucket: json['StorageBucket'] as String?,
      appId: json['AppId'] as String?,
    );

Map<String, dynamic> _$$PushNotificationsPublicInfoModelImplToJson(
  _$PushNotificationsPublicInfoModelImpl instance,
) => <String, dynamic>{
  'SenderId': instance.senderId,
  'PublicApiKey': instance.publicApiKey,
  'AuthDomain': instance.authDomain,
  'DatabaseUrl': instance.databaseUrl,
  'ProjectId': instance.projectId,
  'StorageBucket': instance.storageBucket,
  'AppId': instance.appId,
};
