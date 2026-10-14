// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorModelImpl _$$VendorModelImplFromJson(
  Map<String, dynamic> json,
) => _$VendorModelImpl(
  name: json['Name'] as String?,
  description: json['Description'] as String?,
  metaKeywords: json['MetaKeywords'] as String?,
  metaDescription: json['MetaDescription'] as String?,
  metaTitle: json['MetaTitle'] as String?,
  seName: json['SeName'] as String?,
  allowCustomersToContactVendors:
      json['AllowCustomersToContactVendors'] as bool? ?? false,
  renderCaptcha: json['RenderCaptcha'] as bool? ?? false,
  address:
      json['Address'] == null
          ? null
          : VendorAddressModel.fromJson(
            json['Address'] as Map<String, dynamic>,
          ),
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
  vendorReviewOverview:
      json['VendorReviewOverview'] == null
          ? null
          : VendorReviewOverviewModel.fromJson(
            json['VendorReviewOverview'] as Map<String, dynamic>,
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

Map<String, dynamic> _$$VendorModelImplToJson(_$VendorModelImpl instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'Name': value,
      if (instance.description case final value?) 'Description': value,
      if (instance.metaKeywords case final value?) 'MetaKeywords': value,
      if (instance.metaDescription case final value?) 'MetaDescription': value,
      if (instance.metaTitle case final value?) 'MetaTitle': value,
      if (instance.seName case final value?) 'SeName': value,
      if (instance.allowCustomersToContactVendors case final value?)
        'AllowCustomersToContactVendors': value,
      if (instance.renderCaptcha case final value?) 'RenderCaptcha': value,
      if (instance.address case final value?) 'Address': value,
      if (instance.pictureModel case final value?) 'PictureModel': value,
      if (instance.pagingFilteringContext case final value?)
        'PagingFilteringContext': value,
      if (instance.vendorReviewOverview case final value?)
        'VendorReviewOverview': value,
      if (instance.products case final value?) 'Products': value,
      if (instance.id case final value?) 'Id': value,
      if (instance.userFields case final value?) 'UserFields': value,
    };
