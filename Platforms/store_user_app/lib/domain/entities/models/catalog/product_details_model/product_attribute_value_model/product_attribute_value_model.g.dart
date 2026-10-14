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
  priceAdjustment: json['PriceAdjustment'] as String?,
  priceAdjustmentValue: (json['PriceAdjustmentValue'] as num?)?.toDouble(),
  stockAvailability: json['StockAvailability'] as String?,
  isPreSelected: json['IsPreSelected'] as bool? ?? false,
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

Map<String, dynamic> _$$ProductAttributeValueModelImplToJson(
  _$ProductAttributeValueModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.colorSquaresRgb case final value?) 'ColorSquaresRgb': value,
  if (instance.imageSquaresPictureModel case final value?)
    'ImageSquaresPictureModel': value,
  if (instance.priceAdjustment case final value?) 'PriceAdjustment': value,
  if (instance.priceAdjustmentValue case final value?)
    'PriceAdjustmentValue': value,
  if (instance.stockAvailability case final value?) 'StockAvailability': value,
  if (instance.isPreSelected case final value?) 'IsPreSelected': value,
  if (instance.pictureModel case final value?) 'PictureModel': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
