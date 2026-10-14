// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PictureModelImpl _$$PictureModelImplFromJson(Map<String, dynamic> json) =>
    _$PictureModelImpl(
      imageUrl: json['ImageUrl'] as String?,
      thumbImageUrl: json['ThumbImageUrl'] as String?,
      fullSizeImageUrl: json['FullSizeImageUrl'] as String?,
      title: json['Title'] as String?,
      alternateText: json['AlternateText'] as String?,
      style: json['Style'] as String?,
      extraField: json['ExtraField'] as String?,
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PictureModelImplToJson(
  _$PictureModelImpl instance,
) => <String, dynamic>{
  if (instance.imageUrl case final value?) 'ImageUrl': value,
  if (instance.thumbImageUrl case final value?) 'ThumbImageUrl': value,
  if (instance.fullSizeImageUrl case final value?) 'FullSizeImageUrl': value,
  if (instance.title case final value?) 'Title': value,
  if (instance.alternateText case final value?) 'AlternateText': value,
  if (instance.style case final value?) 'Style': value,
  if (instance.extraField case final value?) 'ExtraField': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
