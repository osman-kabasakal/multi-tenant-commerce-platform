// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledgebase_home_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KnowledgebaseHomePageModelImpl _$$KnowledgebaseHomePageModelImplFromJson(
  Map<String, dynamic> json,
) => _$KnowledgebaseHomePageModelImpl(
  items:
      (json['Items'] as List<dynamic>?)
          ?.map(
            (e) => KnowledgebaseItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  categories:
      (json['Categories'] as List<dynamic>?)
          ?.map(
            (e) =>
                KnowledgebaseCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  currentCategoryId: json['CurrentCategoryId'] as String?,
  currentCategoryDescription: json['CurrentCategoryDescription'] as String?,
  currentCategoryMetaTitle: json['CurrentCategoryMetaTitle'] as String?,
  currentCategoryMetaDescription:
      json['CurrentCategoryMetaDescription'] as String?,
  currentCategoryMetaKeywords: json['CurrentCategoryMetaKeywords'] as String?,
  currentCategoryName: json['CurrentCategoryName'] as String?,
  currentCategorySeName: json['CurrentCategorySeName'] as String?,
  categoryBreadcrumb:
      (json['CategoryBreadcrumb'] as List<dynamic>?)
          ?.map(
            (e) =>
                KnowledgebaseCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  searchKeyword: json['SearchKeyword'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$KnowledgebaseHomePageModelImplToJson(
  _$KnowledgebaseHomePageModelImpl instance,
) => <String, dynamic>{
  if (instance.items case final value?) 'Items': value,
  if (instance.categories case final value?) 'Categories': value,
  if (instance.currentCategoryId case final value?) 'CurrentCategoryId': value,
  if (instance.currentCategoryDescription case final value?)
    'CurrentCategoryDescription': value,
  if (instance.currentCategoryMetaTitle case final value?)
    'CurrentCategoryMetaTitle': value,
  if (instance.currentCategoryMetaDescription case final value?)
    'CurrentCategoryMetaDescription': value,
  if (instance.currentCategoryMetaKeywords case final value?)
    'CurrentCategoryMetaKeywords': value,
  if (instance.currentCategoryName case final value?)
    'CurrentCategoryName': value,
  if (instance.currentCategorySeName case final value?)
    'CurrentCategorySeName': value,
  if (instance.categoryBreadcrumb case final value?)
    'CategoryBreadcrumb': value,
  if (instance.searchKeyword case final value?) 'SearchKeyword': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
