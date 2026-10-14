import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'collection_paging_model.freezed.dart';
part 'collection_paging_model.g.dart';

@freezed
class CollectionPagingModel extends StoreJsonSerializable<CollectionPagingModel>
    with _$CollectionPagingModel {
  factory CollectionPagingModel(
          {@JsonKey(name: 'FirstItem', includeIfNull: false) int? firstItem,
          @JsonKey(name: 'HasNextPage', includeIfNull: false)
          @Default(false)
          bool? hasNextPage,
          @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
          @Default(false)
          bool? hasPreviousPage,
          @JsonKey(name: 'LastItem', includeIfNull: false) int? lastItem,
          @JsonKey(name: 'PageIndex', includeIfNull: false) int? pageIndex,
          @JsonKey(name: 'PageNumber', includeIfNull: false) int? pageNumber,
          @JsonKey(name: 'PageSize', includeIfNull: false) int? pageSize,
          @JsonKey(name: 'TotalItems', includeIfNull: false) int? totalItems,
          @JsonKey(name: 'TotalPages', includeIfNull: false) int? totalPages}) =
      _CollectionPagingModel;

  factory CollectionPagingModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionPagingModelFromJson(json);
}
