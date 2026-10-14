import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'specification_filter_model/specification_filter_model.dart';

import '../../../microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';

part 'catalog_paging_filtering_model.freezed.dart';
part 'catalog_paging_filtering_model.g.dart';

@freezed
class CatalogPagingFilteringModel
    extends StoreJsonSerializable<CatalogPagingFilteringModel>
    with _$CatalogPagingFilteringModel {
  factory CatalogPagingFilteringModel(
          {@JsonKey(name: 'SpecificationFilter', includeIfNull: false)
          SpecificationFilterModel? specificationFilter,
          @JsonKey(name: 'AllowProductSorting', includeIfNull: false)
          @Default(false)
          bool? allowProductSorting,
          @JsonKey(name: 'AvailableSortOptions', includeIfNull: false)
          @Default([])
          List<SelectListItem>? availableSortOptions,
          @JsonKey(name: 'AllowProductViewModeChanging', includeIfNull: false)
          @Default(false)
          bool? allowProductViewModeChanging,
          @JsonKey(name: 'AvailableViewModes', includeIfNull: false)
          @Default([])
          List<SelectListItem>? availableViewModes,
          @JsonKey(name: 'AllowCustomersToSelectPageSize', includeIfNull: false)
          @Default(false)
          bool? allowCustomersToSelectPageSize,
          @JsonKey(name: 'PageSizeOptions', includeIfNull: false)
          @Default([])
          List<SelectListItem>? pageSizeOptions,
          @JsonKey(name: 'OrderBy', includeIfNull: false)
          @Default(null)
          int? orderBy,
          @JsonKey(name: 'Rating', includeIfNull: false)
          @Default(null)
          double? rating,
          @JsonKey(name: 'RatingOptions', includeIfNull: false)
          @Default([])
          List<SelectListItem>? ratingOptions,
          @JsonKey(name: 'ViewMode', includeIfNull: false) String? viewMode,
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
      _CatalogPagingFilteringModel;

  factory CatalogPagingFilteringModel.fromJson(Map<String, dynamic> json) =>
      _$CatalogPagingFilteringModelFromJson(json);
}
