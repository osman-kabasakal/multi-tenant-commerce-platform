// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompareProductsModelImpl _$$CompareProductsModelImplFromJson(
  Map<String, dynamic> json,
) => _$CompareProductsModelImpl(
  products:
      (json['Products'] as List<dynamic>?)
          ?.map((e) => ProductOverviewModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  includeShortDescriptionInCompareProducts:
      json['IncludeShortDescriptionInCompareProducts'] as bool? ?? false,
  includeFullDescriptionInCompareProducts:
      json['IncludeFullDescriptionInCompareProducts'] as bool? ?? false,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CompareProductsModelImplToJson(
  _$CompareProductsModelImpl instance,
) => <String, dynamic>{
  if (instance.products case final value?) 'Products': value,
  if (instance.includeShortDescriptionInCompareProducts case final value?)
    'IncludeShortDescriptionInCompareProducts': value,
  if (instance.includeFullDescriptionInCompareProducts case final value?)
    'IncludeFullDescriptionInCompareProducts': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
