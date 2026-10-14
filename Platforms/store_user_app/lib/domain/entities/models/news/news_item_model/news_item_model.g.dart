// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsItemModelImpl _$$NewsItemModelImplFromJson(Map<String, dynamic> json) =>
    _$NewsItemModelImpl(
      newsItemId: json['NewsItemId'] as String?,
      metaKeywords: json['MetaKeywords'] as String?,
      metaDescription: json['MetaDescription'] as String?,
      metaTitle: json['MetaTitle'] as String?,
      seName: json['SeName'] as String?,
      title: json['Title'] as String?,
      pictureModel:
          json['PictureModel'] == null
              ? null
              : PictureModel.fromJson(
                json['PictureModel'] as Map<String, dynamic>,
              ),
      short: json['Short'] as String?,
      full: json['Full'] as String?,
      allowComments: json['AllowComments'] as bool? ?? false,
      numberOfComments: (json['NumberOfComments'] as num?)?.toInt(),
      createdOn:
          json['CreatedOn'] == null
              ? null
              : DateTime.parse(json['CreatedOn'] as String),
      comments:
          (json['Comments'] as List<dynamic>?)
              ?.map((e) => NewsCommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      addNewComment:
          json['AddNewComment'] == null
              ? null
              : AddNewsCommentModel.fromJson(
                json['AddNewComment'] as Map<String, dynamic>,
              ),
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NewsItemModelImplToJson(
  _$NewsItemModelImpl instance,
) => <String, dynamic>{
  if (instance.newsItemId case final value?) 'NewsItemId': value,
  if (instance.metaKeywords case final value?) 'MetaKeywords': value,
  if (instance.metaDescription case final value?) 'MetaDescription': value,
  if (instance.metaTitle case final value?) 'MetaTitle': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.title case final value?) 'Title': value,
  if (instance.pictureModel case final value?) 'PictureModel': value,
  if (instance.short case final value?) 'Short': value,
  if (instance.full case final value?) 'Full': value,
  if (instance.allowComments case final value?) 'AllowComments': value,
  if (instance.numberOfComments case final value?) 'NumberOfComments': value,
  if (instance.createdOn?.toIso8601String() case final value?)
    'CreatedOn': value,
  if (instance.comments case final value?) 'Comments': value,
  if (instance.addNewComment case final value?) 'AddNewComment': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
