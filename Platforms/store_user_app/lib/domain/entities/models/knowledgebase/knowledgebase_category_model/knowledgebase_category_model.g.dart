// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledgebase_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KnowledgebaseCategoryModelImpl _$$KnowledgebaseCategoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$KnowledgebaseCategoryModelImpl(
  name: json['Name'] as String?,
  description: json['Description'] as String?,
  isCurrent: json['IsCurrent'] as bool? ?? false,
  children:
      (json['Children'] as List<dynamic>?)
          ?.map(
            (e) =>
                KnowledgebaseCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  parent:
      json['Parent'] == null
          ? null
          : KnowledgebaseCategoryModel.fromJson(
            json['Parent'] as Map<String, dynamic>,
          ),
  seName: json['SeName'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$KnowledgebaseCategoryModelImplToJson(
  _$KnowledgebaseCategoryModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.isCurrent case final value?) 'IsCurrent': value,
  if (instance.children case final value?) 'Children': value,
  if (instance.parent case final value?) 'Parent': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
