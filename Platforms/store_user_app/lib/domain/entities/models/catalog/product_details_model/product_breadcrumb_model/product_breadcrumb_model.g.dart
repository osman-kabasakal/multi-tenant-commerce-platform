// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_breadcrumb_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductBreadcrumbModelImpl _$$ProductBreadcrumbModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductBreadcrumbModelImpl(
  id: (json['Id'] as num?)?.toInt(),
  enabled: json['Enabled'] as bool? ?? false,
  productId: json['ProductId'] as String?,
  productName: json['ProductName'] as String?,
  productSeName: json['ProductSeName'] as String?,
  categoryBreadcrumb:
      (json['CategoryBreadcrumb'] as List<dynamic>?)
          ?.map((e) => CategorySimpleModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductBreadcrumbModelImplToJson(
  _$ProductBreadcrumbModelImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'Id': value,
  if (instance.enabled case final value?) 'Enabled': value,
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.categoryBreadcrumb case final value?)
    'CategoryBreadcrumb': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
