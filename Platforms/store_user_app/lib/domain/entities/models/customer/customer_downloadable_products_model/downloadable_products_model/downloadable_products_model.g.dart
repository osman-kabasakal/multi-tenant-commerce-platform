// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloadable_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DownloadableProductsModelImpl _$$DownloadableProductsModelImplFromJson(
  Map<String, dynamic> json,
) => _$DownloadableProductsModelImpl(
  orderItemGuid: json['OrderItemGuid'] as String?,
  orderId: json['OrderId'] as String?,
  orderNumber: (json['OrderNumber'] as num?)?.toInt(),
  productId: json['ProductId'] as String?,
  productName: json['ProductName'] as String?,
  productSeName: json['ProductSeName'] as String?,
  productAttributes: json['ProductAttributes'] as String?,
  downloadId: json['DownloadId'] as String?,
  licenseId: json['LicenseId'] as String?,
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

Map<String, dynamic> _$$DownloadableProductsModelImplToJson(
  _$DownloadableProductsModelImpl instance,
) => <String, dynamic>{
  if (instance.orderItemGuid case final value?) 'OrderItemGuid': value,
  if (instance.orderId case final value?) 'OrderId': value,
  if (instance.orderNumber case final value?) 'OrderNumber': value,
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.productAttributes case final value?) 'ProductAttributes': value,
  if (instance.downloadId case final value?) 'DownloadId': value,
  if (instance.licenseId case final value?) 'LicenseId': value,
  if (instance.createdOn?.toIso8601String() case final value?)
    'CreatedOn': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
