// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_paging_filtering_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogPagingFilteringModelImpl _$$CatalogPagingFilteringModelImplFromJson(
  Map<String, dynamic> json,
) => _$CatalogPagingFilteringModelImpl(
  specificationFilter:
      json['SpecificationFilter'] == null
          ? null
          : SpecificationFilterModel.fromJson(
            json['SpecificationFilter'] as Map<String, dynamic>,
          ),
  allowProductSorting: json['AllowProductSorting'] as bool? ?? false,
  availableSortOptions:
      (json['AvailableSortOptions'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  allowProductViewModeChanging:
      json['AllowProductViewModeChanging'] as bool? ?? false,
  availableViewModes:
      (json['AvailableViewModes'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  allowCustomersToSelectPageSize:
      json['AllowCustomersToSelectPageSize'] as bool? ?? false,
  pageSizeOptions:
      (json['PageSizeOptions'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  orderBy: (json['OrderBy'] as num?)?.toInt() ?? null,
  rating: (json['Rating'] as num?)?.toDouble() ?? null,
  ratingOptions:
      (json['RatingOptions'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  viewMode: json['ViewMode'] as String?,
  firstItem: (json['FirstItem'] as num?)?.toInt(),
  hasNextPage: json['HasNextPage'] as bool? ?? false,
  hasPreviousPage: json['HasPreviousPage'] as bool? ?? false,
  lastItem: (json['LastItem'] as num?)?.toInt(),
  pageIndex: (json['PageIndex'] as num?)?.toInt(),
  pageNumber: (json['PageNumber'] as num?)?.toInt(),
  pageSize: (json['PageSize'] as num?)?.toInt(),
  totalItems: (json['TotalItems'] as num?)?.toInt(),
  totalPages: (json['TotalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$$CatalogPagingFilteringModelImplToJson(
  _$CatalogPagingFilteringModelImpl instance,
) => <String, dynamic>{
  if (instance.specificationFilter case final value?)
    'SpecificationFilter': value,
  if (instance.allowProductSorting case final value?)
    'AllowProductSorting': value,
  if (instance.availableSortOptions case final value?)
    'AvailableSortOptions': value,
  if (instance.allowProductViewModeChanging case final value?)
    'AllowProductViewModeChanging': value,
  if (instance.availableViewModes case final value?)
    'AvailableViewModes': value,
  if (instance.allowCustomersToSelectPageSize case final value?)
    'AllowCustomersToSelectPageSize': value,
  if (instance.pageSizeOptions case final value?) 'PageSizeOptions': value,
  if (instance.orderBy case final value?) 'OrderBy': value,
  if (instance.rating case final value?) 'Rating': value,
  if (instance.ratingOptions case final value?) 'RatingOptions': value,
  if (instance.viewMode case final value?) 'ViewMode': value,
  if (instance.firstItem case final value?) 'FirstItem': value,
  if (instance.hasNextPage case final value?) 'HasNextPage': value,
  if (instance.hasPreviousPage case final value?) 'HasPreviousPage': value,
  if (instance.lastItem case final value?) 'LastItem': value,
  if (instance.pageIndex case final value?) 'PageIndex': value,
  if (instance.pageNumber case final value?) 'PageNumber': value,
  if (instance.pageSize case final value?) 'PageSize': value,
  if (instance.totalItems case final value?) 'TotalItems': value,
  if (instance.totalPages case final value?) 'TotalPages': value,
};
