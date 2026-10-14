import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';
import 'package:store_user_app/domain/entities/models/catalog/catalog_paging_filtering_model/catalog_paging_filtering_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/catalog_paging_filtering_model/specification_filter_item/specification_filter_item.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';

import 'shipping_filter_type.dart';

part 'filter_state.freezed.dart';

@freezed
class FilterState with _$FilterState {
  const factory FilterState({
    @Default('') String query,
    @Default(null) String? selectedCategory,
    @Default(null) CategoryModel? selectedCategoryModel,
    @Default(null) String? selectedCollectionId,
    @Default(null) double? maxPrice,
    @Default(null) double? minPrice,
    @Default(true) bool attributeFilterEnbaled,
    @Default([]) List<String> attributeFilters,
    @Default([]) List<SpecificationFilterItem> alreadyFilteredItems,
    @Default([]) List<SpecificationFilterItem> notFilteredItems,
    @Default([]) List<SelectListItem> availableCategories,
    @Default([]) List<CategoryModel> allCategories,
    @Default([]) List<SelectListItem> availableCollections,
    @Default([]) List<SelectListItem> availableVendors,
    @Default([]) List<SelectListItem> ratingOptions,
    @Default(false) bool sortOptionEnabled,
    @Default([]) List<SelectListItem> availableSortOptions,
    @Default(0) int orderBy,
    @Default(null) double? rating,
    @Default(ShippingFilterType.all) ShippingFilterType shippingFilter,
    @Default(null) String? vendorId,
    @Default(true) bool priceFilterEnebale,
    @Default(null) CatalogPagingFilteringModel? pagingFilterModel,
  }) = _FilterState;
}
