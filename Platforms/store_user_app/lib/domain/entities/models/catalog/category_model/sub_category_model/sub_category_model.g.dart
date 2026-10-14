// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubCategoryModelImpl _$$SubCategoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$SubCategoryModelImpl(
  name: json['Name'] as String?,
  seName: json['SeName'] as String?,
  description: json['Description'] as String?,
  flag: json['Flag'] as String?,
  flagStyle: json['FlagStyle'] as String?,
  pictureModel:
      json['PictureModel'] == null
          ? null
          : PictureModel.fromJson(json['PictureModel'] as Map<String, dynamic>),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$SubCategoryModelImplToJson(
  _$SubCategoryModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.flag case final value?) 'Flag': value,
  if (instance.flagStyle case final value?) 'FlagStyle': value,
  if (instance.pictureModel case final value?) 'PictureModel': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
