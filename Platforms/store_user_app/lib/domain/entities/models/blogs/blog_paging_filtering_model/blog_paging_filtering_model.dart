import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'blog_paging_filtering_model.freezed.dart';
part 'blog_paging_filtering_model.g.dart';

@freezed
class BlogPagingFilteringModel
    extends StoreJsonSerializable<BlogPagingFilteringModel>
    with _$BlogPagingFilteringModel {
  factory BlogPagingFilteringModel(
          {@JsonKey(name: 'Month', includeIfNull: false) String? month,
          @JsonKey(name: 'Tag', includeIfNull: false) String? tag,
          @JsonKey(name: 'CategorySeName', includeIfNull: false)
          String? categorySeName,
          @JsonKey(name: 'SearchKeyword', includeIfNull: false)
          String? searchKeyword,
          @JsonKey(name: 'FirstItem', includeIfNull: false) int? firstItem,
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
      _BlogPagingFilteringModel;

  factory BlogPagingFilteringModel.fromJson(Map<String, dynamic> json) =>
      _$BlogPagingFilteringModelFromJson(json);
}
