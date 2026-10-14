// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductOverviewModelImpl _$$ProductOverviewModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductOverviewModelImpl(
  name: json['Name'] as String?,
  shortDescription: json['ShortDescription'] as String?,
  fullDescription: json['FullDescription'] as String?,
  seName: json['SeName'] as String?,
  url: json['Url'] as String?,
  productType:
      $enumDecodeNullable(_$ProductTypeEnumMap, json['ProductType']) ??
      ProductType.simpleProduct,
  markAsNew: json['MarkAsNew'] as bool? ?? false,
  sku: json['Sku'] as String?,
  flag: json['Flag'] as String?,
  gtin: json['Gtin'] as String?,
  mpn: json['Mpn'] as String?,
  brandName: json['BrandName'] as String?,
  isFreeShipping: json['IsFreeShipping'] as bool? ?? false,
  showSku: json['ShowSku'] as bool? ?? false,
  showQty: json['ShowQty'] as bool? ?? false,
  lowStock: json['LowStock'] as bool? ?? false,
  endTime:
      json['EndTime'] == null
          ? null
          : DateTime.parse(json['EndTime'] as String),
  endTimeLocalTime:
      json['EndTimeLocalTime'] == null
          ? null
          : DateTime.parse(json['EndTimeLocalTime'] as String),
  taxDisplayType:
      $enumDecodeNullable(_$TaxDisplayTypeEnumMap, json['TaxDisplayType']) ??
      TaxDisplayType.includingTax,
  interval: (json['Interval'] as num?)?.toInt(),
  intervalUnitId:
      $enumDecodeNullable(_$IntervalUnitEnumMap, json['IntervalUnitId']) ??
      IntervalUnit.minute,
  productPrice:
      json['ProductPrice'] == null
          ? null
          : ProductPriceModel.fromJson(
            json['ProductPrice'] as Map<String, dynamic>,
          ),
  defaultPictureModel:
      json['DefaultPictureModel'] == null
          ? null
          : PictureModel.fromJson(
            json['DefaultPictureModel'] as Map<String, dynamic>,
          ),
  secondPictureModel:
      json['SecondPictureModel'] == null
          ? null
          : PictureModel.fromJson(
            json['SecondPictureModel'] as Map<String, dynamic>,
          ),
  specificationAttributeModels:
      (json['SpecificationAttributeModels'] as List<dynamic>?)
          ?.map(
            (e) =>
                ProductSpecificationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  productAttributeModels:
      (json['ProductAttributeModels'] as List<dynamic>?)
          ?.map(
            (e) => ProductAttributeModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  reviewOverviewModel:
      json['ReviewOverviewModel'] == null
          ? null
          : ProductReviewOverviewModel.fromJson(
            json['ReviewOverviewModel'] as Map<String, dynamic>,
          ),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductOverviewModelImplToJson(
  _$ProductOverviewModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.shortDescription case final value?) 'ShortDescription': value,
  if (instance.fullDescription case final value?) 'FullDescription': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.url case final value?) 'Url': value,
  if (_$ProductTypeEnumMap[instance.productType] case final value?)
    'ProductType': value,
  if (instance.markAsNew case final value?) 'MarkAsNew': value,
  if (instance.sku case final value?) 'Sku': value,
  if (instance.flag case final value?) 'Flag': value,
  if (instance.gtin case final value?) 'Gtin': value,
  if (instance.mpn case final value?) 'Mpn': value,
  if (instance.brandName case final value?) 'BrandName': value,
  if (instance.isFreeShipping case final value?) 'IsFreeShipping': value,
  if (instance.showSku case final value?) 'ShowSku': value,
  if (instance.showQty case final value?) 'ShowQty': value,
  if (instance.lowStock case final value?) 'LowStock': value,
  if (instance.endTime?.toIso8601String() case final value?) 'EndTime': value,
  if (instance.endTimeLocalTime?.toIso8601String() case final value?)
    'EndTimeLocalTime': value,
  if (_$TaxDisplayTypeEnumMap[instance.taxDisplayType] case final value?)
    'TaxDisplayType': value,
  if (instance.interval case final value?) 'Interval': value,
  if (_$IntervalUnitEnumMap[instance.intervalUnitId] case final value?)
    'IntervalUnitId': value,
  if (instance.productPrice case final value?) 'ProductPrice': value,
  if (instance.defaultPictureModel case final value?)
    'DefaultPictureModel': value,
  if (instance.secondPictureModel case final value?)
    'SecondPictureModel': value,
  if (instance.specificationAttributeModels case final value?)
    'SpecificationAttributeModels': value,
  if (instance.productAttributeModels case final value?)
    'ProductAttributeModels': value,
  if (instance.reviewOverviewModel case final value?)
    'ReviewOverviewModel': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};

const _$ProductTypeEnumMap = {
  ProductType.simpleProduct: 0,
  ProductType.groupedProduct: 10,
  ProductType.reservation: 20,
  ProductType.bundledProduct: 30,
  ProductType.auction: 40,
};

const _$TaxDisplayTypeEnumMap = {
  TaxDisplayType.includingTax: 0,
  TaxDisplayType.excludingTax: 10,
};

const _$IntervalUnitEnumMap = {
  IntervalUnit.minute: 0,
  IntervalUnit.hour: 5,
  IntervalUnit.day: 10,
};
