// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserFieldImpl _$$UserFieldImplFromJson(Map<String, dynamic> json) =>
    _$UserFieldImpl(
      key: json['Key'] as String?,
      value: json['Value'] as String?,
      storeId: json['StoreId'] as String?,
    );

Map<String, dynamic> _$$UserFieldImplToJson(_$UserFieldImpl instance) =>
    <String, dynamic>{
      if (instance.key case final value?) 'Key': value,
      if (instance.value case final value?) 'Value': value,
      if (instance.storeId case final value?) 'StoreId': value,
    };
