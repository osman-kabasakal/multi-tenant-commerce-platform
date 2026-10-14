// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_downloadable_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerDownloadableProductsModelImpl
_$$CustomerDownloadableProductsModelImplFromJson(Map<String, dynamic> json) =>
    _$CustomerDownloadableProductsModelImpl(
      items:
          (json['Items'] as List<dynamic>?)
              ?.map(
                (e) => DownloadableProductsModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CustomerDownloadableProductsModelImplToJson(
  _$CustomerDownloadableProductsModelImpl instance,
) => <String, dynamic>{
  if (instance.items case final value?) 'Items': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
