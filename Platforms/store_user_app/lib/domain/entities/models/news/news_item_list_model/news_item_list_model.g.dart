// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsItemListModelImpl _$$NewsItemListModelImplFromJson(
  Map<String, dynamic> json,
) => _$NewsItemListModelImpl(
  workingLanguageId: json['WorkingLanguageId'] as String?,
  pagingFilteringContext:
      json['PagingFilteringContext'] == null
          ? null
          : NewsPagingFilteringModel.fromJson(
            json['PagingFilteringContext'] as Map<String, dynamic>,
          ),
  newsItems:
      (json['NewsItems'] as List<dynamic>?)
          ?.map((e) => NewsItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$NewsItemListModelImplToJson(
  _$NewsItemListModelImpl instance,
) => <String, dynamic>{
  if (instance.workingLanguageId case final value?) 'WorkingLanguageId': value,
  if (instance.pagingFilteringContext case final value?)
    'PagingFilteringContext': value,
  if (instance.newsItems case final value?) 'NewsItems': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
