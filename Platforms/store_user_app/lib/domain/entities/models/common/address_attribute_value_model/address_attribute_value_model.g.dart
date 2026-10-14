// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_attribute_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressAttributeValueModelImpl _$$AddressAttributeValueModelImplFromJson(
  Map<String, dynamic> json,
) => _$AddressAttributeValueModelImpl(
  name: json['Name'] as String?,
  isPreSelected: json['IsPreSelected'] as bool? ?? false,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AddressAttributeValueModelImplToJson(
  _$AddressAttributeValueModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.isPreSelected case final value?) 'IsPreSelected': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
