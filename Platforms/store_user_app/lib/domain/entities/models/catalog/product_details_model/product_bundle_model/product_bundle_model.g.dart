// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_bundle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductBundleModelImpl _$$ProductBundleModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductBundleModelImpl(
  productId: json['ProductId'] as String?,
  name: json['Name'] as String?,
  seName: json['SeName'] as String?,
  shortDescription: json['ShortDescription'] as String?,
  sku: json['Sku'] as String?,
  mpn: json['Mpn'] as String?,
  gtin: json['Gtin'] as String?,
  quantity: (json['Quantity'] as num?)?.toInt(),
  price: json['Price'] as String?,
  priceValue: (json['PriceValue'] as num?)?.toDouble(),
  defaultPictureModel:
      json['DefaultPictureModel'] == null
          ? null
          : PictureModel.fromJson(
            json['DefaultPictureModel'] as Map<String, dynamic>,
          ),
  productAttributes:
      (json['ProductAttributes'] as List<dynamic>?)
          ?.map(
            (e) => ProductAttributeModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductBundleModelImplToJson(
  _$ProductBundleModelImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.shortDescription case final value?) 'ShortDescription': value,
  if (instance.sku case final value?) 'Sku': value,
  if (instance.mpn case final value?) 'Mpn': value,
  if (instance.gtin case final value?) 'Gtin': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (instance.price case final value?) 'Price': value,
  if (instance.priceValue case final value?) 'PriceValue': value,
  if (instance.defaultPictureModel case final value?)
    'DefaultPictureModel': value,
  if (instance.productAttributes case final value?) 'ProductAttributes': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
