// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_by_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductsByTagModelImpl _$$ProductsByTagModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductsByTagModelImpl(
  tagName: json['TagName'] as String?,
  tagSeName: json['TagSeName'] as String?,
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

Map<String, dynamic> _$$ProductsByTagModelImplToJson(
  _$ProductsByTagModelImpl instance,
) => <String, dynamic>{
  if (instance.tagName case final value?) 'TagName': value,
  if (instance.tagSeName case final value?) 'TagSeName': value,
  if (instance.pagingFilteringContext case final value?)
    'PagingFilteringContext': value,
  if (instance.products case final value?) 'Products': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
