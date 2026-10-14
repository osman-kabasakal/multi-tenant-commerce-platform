// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubjectImpl _$$SubjectImplFromJson(Map<String, dynamic> json) =>
    _$SubjectImpl(
      name: json['Name'] as String?,
      displayOrder: (json['DisplayOrder'] as num?)?.toInt(),
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SubjectImplToJson(_$SubjectImpl instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'Name': value,
      if (instance.displayOrder case final value?) 'DisplayOrder': value,
      if (instance.id case final value?) 'Id': value,
      if (instance.userFields case final value?) 'UserFields': value,
    };
