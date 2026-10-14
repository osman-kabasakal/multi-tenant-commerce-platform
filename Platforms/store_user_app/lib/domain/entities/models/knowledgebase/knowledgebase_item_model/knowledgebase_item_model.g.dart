// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledgebase_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KnowledgebaseItemModelImpl _$$KnowledgebaseItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$KnowledgebaseItemModelImpl(
  name: json['Name'] as String?,
  seName: json['SeName'] as String?,
  isArticle: json['IsArticle'] as bool? ?? false,
  formattedBreadcrumbs: json['FormattedBreadcrumbs'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$KnowledgebaseItemModelImplToJson(
  _$KnowledgebaseItemModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.isArticle case final value?) 'IsArticle': value,
  if (instance.formattedBreadcrumbs case final value?)
    'FormattedBreadcrumbs': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
