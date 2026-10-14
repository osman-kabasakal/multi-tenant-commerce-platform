// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryModelImpl(
  parentCategoryId: json['ParentCategoryId'] as String?,
  name: json['Name'] as String?,
  description: json['Description'] as String?,
  bottomDescription: json['BottomDescription'] as String?,
  metaKeywords: json['MetaKeywords'] as String?,
  metaDescription: json['MetaDescription'] as String?,
  metaTitle: json['MetaTitle'] as String?,
  seName: json['SeName'] as String?,
  flag: json['Flag'] as String?,
  flagStyle: json['FlagStyle'] as String?,
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
  displayCategoryBreadcrumb:
      json['DisplayCategoryBreadcrumb'] as bool? ?? false,
  categoryBreadcrumb:
      (json['CategoryBreadcrumb'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  subCategories:
      (json['SubCategories'] as List<dynamic>?)
          ?.map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  featuredProducts:
      (json['FeaturedProducts'] as List<dynamic>?)
          ?.map((e) => ProductOverviewModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
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

Map<String, dynamic> _$$CategoryModelImplToJson(
  _$CategoryModelImpl instance,
) => <String, dynamic>{
  if (instance.parentCategoryId case final value?) 'ParentCategoryId': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.bottomDescription case final value?) 'BottomDescription': value,
  if (instance.metaKeywords case final value?) 'MetaKeywords': value,
  if (instance.metaDescription case final value?) 'MetaDescription': value,
  if (instance.metaTitle case final value?) 'MetaTitle': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.flag case final value?) 'Flag': value,
  if (instance.flagStyle case final value?) 'FlagStyle': value,
  if (instance.icon case final value?) 'Icon': value,
  if (instance.pictureModel case final value?) 'PictureModel': value,
  if (instance.pagingFilteringContext case final value?)
    'PagingFilteringContext': value,
  if (instance.displayCategoryBreadcrumb case final value?)
    'DisplayCategoryBreadcrumb': value,
  if (instance.categoryBreadcrumb case final value?)
    'CategoryBreadcrumb': value,
  if (instance.subCategories case final value?) 'SubCategories': value,
  if (instance.featuredProducts case final value?) 'FeaturedProducts': value,
  if (instance.products case final value?) 'Products': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
