// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_post_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlogPostListModelImpl _$$BlogPostListModelImplFromJson(
  Map<String, dynamic> json,
) => _$BlogPostListModelImpl(
  pictureModel:
      json['PictureModel'] == null
          ? null
          : PictureModel.fromJson(json['PictureModel'] as Map<String, dynamic>),
  workingLanguageId: json['WorkingLanguageId'] as String?,
  pagingFilteringContext:
      json['PagingFilteringContext'] == null
          ? null
          : BlogPagingFilteringModel.fromJson(
            json['PagingFilteringContext'] as Map<String, dynamic>,
          ),
  blogPosts:
      (json['BlogPosts'] as List<dynamic>?)
          ?.map((e) => BlogPostModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  searchKeyword: json['SearchKeyword'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$BlogPostListModelImplToJson(
  _$BlogPostListModelImpl instance,
) => <String, dynamic>{
  if (instance.pictureModel case final value?) 'PictureModel': value,
  if (instance.workingLanguageId case final value?) 'WorkingLanguageId': value,
  if (instance.pagingFilteringContext case final value?)
    'PagingFilteringContext': value,
  if (instance.blogPosts case final value?) 'BlogPosts': value,
  if (instance.searchKeyword case final value?) 'SearchKeyword': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
