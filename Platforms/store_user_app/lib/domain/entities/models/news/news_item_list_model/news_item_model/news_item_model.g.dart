// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsItemModelImpl _$$NewsItemModelImplFromJson(Map<String, dynamic> json) =>
    _$NewsItemModelImpl(
      id: json['Id'] as String?,
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
      createdOn:
          json['CreatedOn'] == null
              ? null
              : DateTime.parse(json['CreatedOn'] as String),
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NewsItemModelImplToJson(_$NewsItemModelImpl instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'Id': value,
      if (instance.seName case final value?) 'SeName': value,
      if (instance.title case final value?) 'Title': value,
      if (instance.pictureModel case final value?) 'PictureModel': value,
      if (instance.short case final value?) 'Short': value,
      if (instance.full case final value?) 'Full': value,
      if (instance.createdOn?.toIso8601String() case final value?)
        'CreatedOn': value,
      if (instance.userFields case final value?) 'UserFields': value,
    };
