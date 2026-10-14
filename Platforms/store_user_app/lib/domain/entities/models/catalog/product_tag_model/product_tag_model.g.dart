// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductTagModelImpl _$$ProductTagModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductTagModelImpl(
  name: json['Name'] as String?,
  seName: json['SeName'] as String?,
  productCount: (json['ProductCount'] as num?)?.toInt(),
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductTagModelImplToJson(
  _$ProductTagModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.productCount case final value?) 'ProductCount': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
