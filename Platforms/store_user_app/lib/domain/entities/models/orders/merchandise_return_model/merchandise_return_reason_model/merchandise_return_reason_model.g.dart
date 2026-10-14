// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_reason_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MerchandiseReturnReasonModelImpl _$$MerchandiseReturnReasonModelImplFromJson(
  Map<String, dynamic> json,
) => _$MerchandiseReturnReasonModelImpl(
  name: json['Name'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MerchandiseReturnReasonModelImplToJson(
  _$MerchandiseReturnReasonModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
