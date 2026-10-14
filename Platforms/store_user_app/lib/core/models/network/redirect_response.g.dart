// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redirect_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RedirectResponseImpl _$$RedirectResponseImplFromJson(
  Map<String, dynamic> json,
) => _$RedirectResponseImpl(
  redirectUri:
      json['redirectUri'] == null
          ? null
          : Uri.parse(json['redirectUri'] as String),
  responseStatus: (json['responseStatus'] as num?)?.toInt() ?? null,
);

Map<String, dynamic> _$$RedirectResponseImplToJson(
  _$RedirectResponseImpl instance,
) => <String, dynamic>{
  if (instance.redirectUri?.toString() case final value?) 'redirectUri': value,
  if (instance.responseStatus case final value?) 'responseStatus': value,
};
