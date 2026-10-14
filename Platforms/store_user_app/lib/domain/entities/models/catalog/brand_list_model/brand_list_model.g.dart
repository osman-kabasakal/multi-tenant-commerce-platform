// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrandListModelImpl _$$BrandListModelImplFromJson(Map<String, dynamic> json) =>
    _$BrandListModelImpl(
      pagingModel:
          json['PagingModel'] == null
              ? null
              : BrandPagingModel.fromJson(
                json['PagingModel'] as Map<String, dynamic>,
              ),
      brandsModel:
          (json['BrandsModel'] as List<dynamic>?)
              ?.map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BrandListModelImplToJson(
  _$BrandListModelImpl instance,
) => <String, dynamic>{
  if (instance.pagingModel case final value?) 'PagingModel': value,
  if (instance.brandsModel case final value?) 'BrandsModel': value,
};
