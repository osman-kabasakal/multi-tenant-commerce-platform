// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_attribute_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductAttributeValueModelImpl _$$ProductAttributeValueModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductAttributeValueModelImpl(
  name: json['Name'] as String?,
  colorSquaresRgb: json['ColorSquaresRgb'] as String?,
  imageSquaresPictureModel:
      json['ImageSquaresPictureModel'] == null
          ? null
          : PictureModel.fromJson(
            json['ImageSquaresPictureModel'] as Map<String, dynamic>,
          ),
  pictureModel:
      json['PictureModel'] == null
          ? null
          : PictureModel.fromJson(json['PictureModel'] as Map<String, dynamic>),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductAttributeValueModelImplToJson(
  _$ProductAttributeValueModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.colorSquaresRgb case final value?) 'ColorSquaresRgb': value,
  if (instance.imageSquaresPictureModel case final value?)
    'ImageSquaresPictureModel': value,
  if (instance.pictureModel case final value?) 'PictureModel': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
