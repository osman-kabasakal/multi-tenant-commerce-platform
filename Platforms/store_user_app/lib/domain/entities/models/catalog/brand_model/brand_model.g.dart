// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrandModelImpl _$$BrandModelImplFromJson(
  Map<String, dynamic> json,
) => _$BrandModelImpl(
  name: json['Name'] as String?,
  description: json['Description'] as String?,
  bottomDescription: json['BottomDescription'] as String?,
  metaKeywords: json['MetaKeywords'] as String?,
  metaDescription: json['MetaDescription'] as String?,
  metaTitle: json['MetaTitle'] as String?,
  seName: json['SeName'] as String?,
  icon: json['Icon'] as String?,
  pictureModel:
      json['PictureModel'] == null
          ? null
          : PictureModel.fromJson(json['PictureModel'] as Map<String, dynamic>),
  pagingFilteringContext:
      json['PagingFilteringContext'] == null
          ? null
          : CatalogPagingFilteringModel.fromJson(
            json['PagingFilteringContext'] as Map<String, dynamic>,
          ),
  products:
      (json['Products'] as List<dynamic>?)
          ?.map((e) => ProductOverviewModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$BrandModelImplToJson(
  _$BrandModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.bottomDescription case final value?) 'BottomDescription': value,
  if (instance.metaKeywords case final value?) 'MetaKeywords': value,
  if (instance.metaDescription case final value?) 'MetaDescription': value,
  if (instance.metaTitle case final value?) 'MetaTitle': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.icon case final value?) 'Icon': value,
  if (instance.pictureModel case final value?) 'PictureModel': value,
  if (instance.pagingFilteringContext case final value?)
    'PagingFilteringContext': value,
  if (instance.products case final value?) 'Products': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
