// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_attribute_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactAttributeValueModelImpl _$$ContactAttributeValueModelImplFromJson(
  Map<String, dynamic> json,
) => _$ContactAttributeValueModelImpl(
  name: json['Name'] as String?,
  displayOrder: (json['DisplayOrder'] as num?)?.toInt(),
  colorSquaresRgb: json['ColorSquaresRgb'] as String?,
  isPreSelected: json['IsPreSelected'] as bool? ?? false,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ContactAttributeValueModelImplToJson(
  _$ContactAttributeValueModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.displayOrder case final value?) 'DisplayOrder': value,
  if (instance.colorSquaresRgb case final value?) 'ColorSquaresRgb': value,
  if (instance.isPreSelected case final value?) 'IsPreSelected': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
