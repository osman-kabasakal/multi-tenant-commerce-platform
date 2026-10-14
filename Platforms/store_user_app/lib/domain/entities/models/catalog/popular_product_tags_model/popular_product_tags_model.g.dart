// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_product_tags_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PopularProductTagsModelImpl _$$PopularProductTagsModelImplFromJson(
  Map<String, dynamic> json,
) => _$PopularProductTagsModelImpl(
  totalTags: (json['TotalTags'] as num?)?.toInt(),
  tags:
      (json['Tags'] as List<dynamic>?)
          ?.map((e) => ProductTagModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PopularProductTagsModelImplToJson(
  _$PopularProductTagsModelImpl instance,
) => <String, dynamic>{
  if (instance.totalTags case final value?) 'TotalTags': value,
  if (instance.tags case final value?) 'Tags': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
