// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollectionListModelImpl _$$CollectionListModelImplFromJson(
  Map<String, dynamic> json,
) => _$CollectionListModelImpl(
  pagingModel:
      json['PagingModel'] == null
          ? null
          : CollectionPagingModel.fromJson(
            json['PagingModel'] as Map<String, dynamic>,
          ),
  collectionModel:
      (json['CollectionModel'] as List<dynamic>?)
          ?.map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CollectionListModelImplToJson(
  _$CollectionListModelImpl instance,
) => <String, dynamic>{
  if (instance.pagingModel case final value?) 'PagingModel': value,
  if (instance.collectionModel case final value?) 'CollectionModel': value,
};
