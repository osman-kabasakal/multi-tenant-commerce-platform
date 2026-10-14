// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_simple_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategorySimpleModelImpl _$$CategorySimpleModelImplFromJson(
  Map<String, dynamic> json,
) => _$CategorySimpleModelImpl(
  name: json['Name'] as String?,
  flag: json['Flag'] as String?,
  flagStyle: json['FlagStyle'] as String?,
  icon: json['Icon'] as String?,
  imageUrl: json['ImageUrl'] as String?,
  seName: json['SeName'] as String?,
  numberOfProducts: (json['NumberOfProducts'] as num?)?.toInt() ?? null,
  includeInMenu: json['IncludeInMenu'] as bool? ?? false,
  subCategories:
      (json['SubCategories'] as List<dynamic>?)
          ?.map((e) => CategorySimpleModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CategorySimpleModelImplToJson(
  _$CategorySimpleModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.flag case final value?) 'Flag': value,
  if (instance.flagStyle case final value?) 'FlagStyle': value,
  if (instance.icon case final value?) 'Icon': value,
  if (instance.imageUrl case final value?) 'ImageUrl': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.numberOfProducts case final value?) 'NumberOfProducts': value,
  if (instance.includeInMenu case final value?) 'IncludeInMenu': value,
  if (instance.subCategories case final value?) 'SubCategories': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
