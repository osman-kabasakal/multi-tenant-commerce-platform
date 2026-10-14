// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryListModelImpl _$$CategoryListModelImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryListModelImpl(
  pagingModel:
      json['PagingModel'] == null
          ? null
          : CategoryPagingModel.fromJson(
            json['PagingModel'] as Map<String, dynamic>,
          ),
  categoriesModel:
      (json['CategoriesModel'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CategoryListModelImplToJson(
  _$CategoryListModelImpl instance,
) => <String, dynamic>{
  if (instance.pagingModel case final value?) 'PagingModel': value,
  if (instance.categoriesModel case final value?) 'CategoriesModel': value,
};
