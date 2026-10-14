import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/core/utils/extensions/collection_extensions.dart';
import 'package:store_user_app/core/utils/extensions/string_extensions.dart';
import 'package:store_user_app/domain/entities/microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';
import 'package:store_user_app/domain/entities/models/catalog/brand_model/brand_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/brand_paging_model/brand_paging_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/catalog_paging_filtering_model/catalog_paging_filtering_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/catalog_paging_filtering_model/specification_filter_item/specification_filter_item.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_paging_model/category_paging_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/collection_model/collection_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/collection_paging_model/collection_paging_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/search_model/search_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/vendor_model/vendor_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/vendor_paging_model/vendor_paging_model.dart';
import 'package:store_user_app/domain/repositories/catalog/catalog_repository.dart';
import 'package:store_user_app/presentation/widgets/products/view_models/catalog_state.dart';
import 'package:store_user_app/presentation/widgets/products/view_models/filter_state.dart';
import 'package:store_user_app/presentation/widgets/products/view_models/product_view_type.dart';

part 'product_catalog_controller.g.dart';

@riverpod
class ProductCatalogController extends _$ProductCatalogController
    with CacheInvalidationBase, CacheAwareAsyncFamilyProvider<CatalogState> {
  late CatalogRepository _catalogRepository;
  late NumberFormat _currencyFormatter;

  @override
  FutureOr<CatalogState> build({
    String? categoryId,
    String? vendorId,
    String? searchTerm,
    String? brandId,
    String? collectionId,
    bool priceFilterEnable = true,
    bool attributeFilterEnabled = true,
  }) async {
    await registerCorrelation();

    _catalogRepository = await getIt.getAsync<CatalogRepository>();
    _currencyFormatter = NumberFormat.currency(
      locale: 'tr_TR',
      name: '',
      decimalDigits: 2,
      symbol: '',
    );

    final initialFilter = FilterState(
      query: searchTerm ?? '',
      selectedCategory: categoryId,
      vendorId: vendorId,
      priceFilterEnebale: priceFilterEnable,
      attributeFilterEnbaled: attributeFilterEnabled,
    );

    return _getStateByDataSource(initialFilter);
  }

  ({SearchModel searchModel, Map<String, String> filterItemsMap})
  _prepareSearchModel(FilterState filterState) {
    final pageNumber = (filterState.pagingFilterModel?.pageNumber ?? 0) + 1;

    // Arama modelini oluştur
    final searchModel = SearchModel(
      searchCategoryId: categoryId,
      q: filterState.query.isEmptyOrNull ? null : filterState.query,
      adv: true,
      pf:
          filterState.minPrice != null && filterState.minPrice! > 0
              ? _currencyFormatter.format(filterState.minPrice)
              : null,
      pt:
          filterState.maxPrice != null && filterState.maxPrice! > 0
              ? _currencyFormatter.format(filterState.maxPrice)
              : null,
      box: true,
      cid:
          filterState.selectedCategory.isEmptyOrNull
              ? null
              : filterState.selectedCategory,
      vid: filterState.vendorId.isEmptyOrNull ? null : filterState.vendorId,
      isc: true,
      mid:
          filterState.selectedCollectionId.isEmptyOrNull
              ? null
              : filterState.selectedCollectionId,
      pagingFilteringContext: CatalogPagingFilteringModel(
        orderBy: filterState.orderBy,
        pageSize: 20,
        pageNumber: pageNumber,
        allowProductSorting: true,
        allowCustomersToSelectPageSize: true,
        allowProductViewModeChanging: true,
        availableViewModes: [],
        pageSizeOptions: [],
        ratingOptions: [],
        availableSortOptions: [],
        rating: (filterState.rating ?? 0) > 0 ? filterState.rating : null,
      ),
    );

    var filterItemMap = filterState.alreadyFilteredItems
        .groupBy((x) => x.specificationAttributeSeName!)
        .map(
          (g, l) => MapEntry(
            g,
            l.map((a) => a.specificationAttributeOptionSeName).join(','),
          ),
        );

    return (searchModel: searchModel, filterItemsMap: filterItemMap);
  }

  Future<CatalogState> _getCatalogState({
    List<ProductOverviewModel>? products,
    CatalogPagingFilteringModel? pagingFilteringContext,
    List<SelectListItem>? availableCategories,
    List<SelectListItem>? availableCollections,
    List<SelectListItem>? availableVendors,
    List<SelectListItem>? availableSortOptions,
    List<SelectListItem>? availableRatingOptions,
    bool? sepecificationFilterEnabled,
    bool? sortOptionEnabled,
    String? pf,
    String? pt,
    String? selectedCategoryId,
    CategoryModel? selectedCategoryModel,
    String? selectedVendorId,
    String? selectedSearchTerm,
    String? selectedCollectionId,
  }) async {
    var sortOption =
        (availableSortOptions ?? [])
            .where((s) => s.selected ?? false)
            .firstOrNull;
    if (state.valueOrNull != null) {
      return state.requireValue.copyWith(
        filter: FilterState(
          query: searchTerm ?? '',
          selectedCategory: selectedCategoryId,
          selectedCategoryModel: selectedCategoryModel,
          vendorId: selectedVendorId,
          selectedCollectionId: selectedCollectionId,
          priceFilterEnebale: priceFilterEnable,
          alreadyFilteredItems:
              pagingFilteringContext
                  ?.specificationFilter
                  ?.alreadyFilteredItems ??
              [],
          notFilteredItems:
              pagingFilteringContext?.specificationFilter?.notFilteredItems ??
              [],
          maxPrice: pt.toDoubleFromCurrency(),
          minPrice: pf.toDoubleFromCurrency(),
          availableCategories: availableCategories ?? [],
          availableCollections: availableCollections ?? [],
          availableVendors: availableVendors ?? [],
          availableSortOptions: availableSortOptions ?? [],
          attributeFilterEnbaled: sepecificationFilterEnabled ?? false,
          sortOptionEnabled: sortOptionEnabled ?? false,
          pagingFilterModel: pagingFilteringContext,
          rating: pagingFilteringContext?.rating,
          ratingOptions: pagingFilteringContext?.ratingOptions ?? [],
          orderBy:
              pagingFilteringContext?.orderBy ??
              (sortOption != null ? _mapSortOptionToOrderBy(sortOption) : 5),
          allCategories: state.requireValue.filter.allCategories,
        ),
        products:
            pagingFilteringContext?.pageNumber ==
                    ((state.requireValue.filter.pagingFilterModel?.pageNumber ??
                            1) +
                        1)
                ? [...(state.valueOrNull?.products ?? []), ...(products ?? [])]
                : (products ?? []),
        hasMore: pagingFilteringContext?.hasNextPage ?? true,
        totalProducts: pagingFilteringContext?.totalItems ?? 0,
      );
    }
    _setAllRequiredList();

    return CatalogState(
      products: products ?? [],
      filter: FilterState(
        query: searchTerm ?? '',
        selectedCategory: categoryId,
        selectedCategoryModel: selectedCategoryModel,
        vendorId: vendorId,
        selectedCollectionId: collectionId,
        priceFilterEnebale: priceFilterEnable,
        alreadyFilteredItems:
            pagingFilteringContext?.specificationFilter?.alreadyFilteredItems ??
            [],
        notFilteredItems:
            pagingFilteringContext?.specificationFilter?.notFilteredItems ?? [],
        maxPrice: pt.toDoubleFromCurrency(),
        minPrice: pf.toDoubleFromCurrency(),
        availableCategories: availableCategories ?? [],
        availableCollections: availableCollections ?? [],
        availableVendors: availableVendors ?? [],
        availableSortOptions: availableSortOptions ?? [],
        attributeFilterEnbaled: sepecificationFilterEnabled ?? false,
        sortOptionEnabled: sortOptionEnabled ?? false,
        pagingFilterModel: pagingFilteringContext,
        rating: pagingFilteringContext?.rating,
        ratingOptions: pagingFilteringContext?.ratingOptions ?? [],
        orderBy:
            pagingFilteringContext?.orderBy ??
            (sortOption != null ? _mapSortOptionToOrderBy(sortOption) : 5),
        allCategories: [],
      ),
      categories: [],
      brands: [],
      vendors: [],
      collections: [],
      totalProducts: pagingFilteringContext?.totalItems ?? 0,
      hasMore: pagingFilteringContext?.hasNextPage ?? true,
    );
  }

  Future<void> _setAllRequiredList() async {
    if (state.isLoading || !state.hasValue) {
      await Future.delayed(Duration(milliseconds: 100));
      return _setAllRequiredList();
    }

    var allList = await Future.wait([
      _allCategories(),
      _allBrands(),
      _allVendors(),
      _allCollections(),
    ]);
    var allcategories = allList[0] as List<CategoryModel>;
    var allbrands = allList[1] as List<BrandModel>;
    var allVendors = allList[2] as List<VendorModel>;
    var allCollections = allList[3] as List<CollectionModel>;

    state = AsyncValue.data(
      state.requireValue.copyWith(
        filter: state.requireValue.filter.copyWith(
          allCategories: allcategories,
        ),
        categories: allcategories,
        brands: allbrands,
        vendors: allVendors,
        collections: allCollections,
      ),
    );
  }

  Future<List<CategoryModel>> _allCategories() async {
    try {
      var categoriesResponse = await _catalogRepository.getCatalogCategoryAll(
        CategoryPagingModel(pageNumber: 1, pageSize: 1000),
      );
      if (categoriesResponse != null && categoriesResponse.data != null) {
        return (categoriesResponse.data!.categoriesModel ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<BrandModel>> _allBrands() async {
    try {
      var categoriesResponse = await _catalogRepository.getCatalogBrandAll(
        BrandPagingModel(pageNumber: 1, pageSize: 1000),
      );
      if (categoriesResponse != null && categoriesResponse.data != null) {
        return (categoriesResponse.data!.brandsModel ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<VendorModel>> _allVendors() async {
    try {
      var categoriesResponse = await _catalogRepository.getCatalogVendorAll(
        VendorPagingModel(pageNumber: 1, pageSize: 1000),
      );
      if (categoriesResponse != null && categoriesResponse.data != null) {
        return (categoriesResponse.data!.vendorsModel ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<CollectionModel>> _allCollections() async {
    try {
      var categoriesResponse = await _catalogRepository.getCatalogCollectionAll(
        CollectionPagingModel(pageNumber: 1, pageSize: 1000),
      );
      if (categoriesResponse != null && categoriesResponse.data != null) {
        return (categoriesResponse.data!.collectionModel ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<CatalogState> _getStateByDataSource(FilterState filter) async {
    try {
      final (:searchModel, :filterItemsMap) = _prepareSearchModel(filter);
      if (searchTerm != null) {
        var searchModelResponse = await correlationService
            .runRepositoryMethodWithCorrelation(
              correlationId,
              () async => await _catalogRepository.getCatalogSearch(
                filter.query,
                filterItemsMap,
                searchModel,
                searchModel.pagingFilteringContext!,
              ),
            );

        if (searchModelResponse != null && searchModelResponse.data != null) {
          var result = searchModelResponse.data!;
          return _getCatalogState(
            products: result.products,
            pagingFilteringContext: result.pagingFilteringContext,
            availableCategories: result.availableCategories,
            availableCollections: result.availableCollections,
            availableVendors: result.availableVendors,
            pf: result.pf,
            pt: result.pt,
            sortOptionEnabled:
                result.pagingFilteringContext?.allowProductSorting,
            availableSortOptions:
                result.pagingFilteringContext?.availableSortOptions,
            sepecificationFilterEnabled:
                result.pagingFilteringContext?.specificationFilter?.enabled,
            selectedCategoryId: result.cid,
            selectedVendorId: result.vid,
            selectedSearchTerm: result.q,
            selectedCollectionId: result.mid,
            availableRatingOptions:
                result.pagingFilteringContext?.ratingOptions,
          );
        }
      }

      if (categoryId != null) {
        var categoryModelResponse = await correlationService
            .runRepositoryMethodWithCorrelation(
              correlationId,
              () async => await _catalogRepository.getCatalogCategory(
                searchModel.cid ?? categoryId!,
                filterItemsMap,
                searchModel.pagingFilteringContext!,
              ),
            );
        if (categoryModelResponse != null &&
            categoryModelResponse.data != null) {
          return (await _getCatalogState(
            products: categoryModelResponse.data!.products,
            pagingFilteringContext:
                categoryModelResponse.data!.pagingFilteringContext,
            availableCategories:
                categoryModelResponse.data!.subCategories
                    ?.map(
                      (c) => SelectListItem(
                        disabled: false,
                        text: c.name,
                        value: c.id,
                      ),
                    )
                    .toList(),
            availableCollections: [],
            availableVendors: [],
            availableSortOptions:
                categoryModelResponse
                    .data!
                    .pagingFilteringContext
                    ?.availableSortOptions,
            sepecificationFilterEnabled:
                categoryModelResponse
                    .data!
                    .pagingFilteringContext
                    ?.specificationFilter
                    ?.enabled,
            sortOptionEnabled:
                categoryModelResponse
                    .data!
                    .pagingFilteringContext
                    ?.allowProductSorting,
            pf: null,
            pt: null,
            selectedCategoryId: categoryModelResponse.data!.id,
            selectedCategoryModel: categoryModelResponse.data!,
            selectedCollectionId: collectionId,
            selectedSearchTerm: searchTerm,
            selectedVendorId: vendorId,
            availableRatingOptions:
                categoryModelResponse
                    .data!
                    .pagingFilteringContext
                    ?.ratingOptions,
          ));
        }
      }

      if (vendorId != null) {
        var vendorModelResponse = await correlationService
            .runRepositoryMethodWithCorrelation(
              correlationId,
              () async => await _catalogRepository.getCatalogVendor(
                vendorId!,
                searchModel.pagingFilteringContext!,
              ),
            );
        if (vendorModelResponse != null && vendorModelResponse.data != null) {
          var result = vendorModelResponse.data!;
          return _getCatalogState(
            products: result.products,
            pagingFilteringContext: result.pagingFilteringContext,
            availableCategories: [],
            availableCollections: [],
            availableVendors: [],
            availableSortOptions:
                result.pagingFilteringContext?.availableSortOptions,
            sepecificationFilterEnabled:
                result.pagingFilteringContext?.specificationFilter?.enabled,
            sortOptionEnabled:
                result.pagingFilteringContext?.allowProductSorting,
            pf: null,
            pt: null,
            selectedCategoryId: categoryId,
            selectedCollectionId: collectionId,
            selectedSearchTerm: searchTerm,
            selectedVendorId: result.id,
            availableRatingOptions:
                result.pagingFilteringContext?.ratingOptions,
          );
        }
      }

      if (brandId != null) {
        var brandModelResponse = await correlationService
            .runRepositoryMethodWithCorrelation(
              correlationId,
              () async => await _catalogRepository.getCatalogBrand(
                brandId!,
                searchModel.pagingFilteringContext!,
              ),
            );
        if (brandModelResponse != null && brandModelResponse.data != null) {
          var result = brandModelResponse.data!;
          return _getCatalogState(
            products: result.products,
            pagingFilteringContext: result.pagingFilteringContext,
            availableCategories: [],
            availableCollections: [],
            availableVendors: [],
            availableSortOptions:
                result.pagingFilteringContext?.availableSortOptions,
            sepecificationFilterEnabled:
                result.pagingFilteringContext?.specificationFilter?.enabled,
            sortOptionEnabled:
                result.pagingFilteringContext?.allowProductSorting,
            pf: null,
            pt: null,
            selectedCategoryId: categoryId,
            selectedCollectionId: collectionId,
            selectedSearchTerm: searchTerm,
            selectedVendorId: vendorId,
            availableRatingOptions:
                result.pagingFilteringContext?.ratingOptions,
          );
        }
      }

      if (collectionId != null) {
        var collectionModelResponse = await correlationService
            .runRepositoryMethodWithCorrelation(
              correlationId,
              () async => await _catalogRepository.getCatalogCollection(
                collectionId!,
                searchModel.pagingFilteringContext!,
              ),
            );
        if (collectionModelResponse != null &&
            collectionModelResponse.data != null) {
          var result = collectionModelResponse.data!;
          return _getCatalogState(
            products: result.products,
            pagingFilteringContext: result.pagingFilteringContext,
            availableCategories: [],
            availableCollections: [],
            availableVendors: [],
            availableSortOptions:
                result.pagingFilteringContext?.availableSortOptions,
            sepecificationFilterEnabled:
                result.pagingFilteringContext?.specificationFilter?.enabled,
            sortOptionEnabled:
                result.pagingFilteringContext?.allowProductSorting,
            pf: null,
            pt: null,
            selectedCategoryId: categoryId,
            selectedCollectionId: result.id,
            selectedSearchTerm: searchTerm,
            selectedVendorId: vendorId,
            availableRatingOptions:
                result.pagingFilteringContext?.ratingOptions,
          );
        }
      }

      return _getCatalogState();
    } catch (e) {
      return CatalogState(error: e.toString(), filter: filter);
    }
  }

  Future<void> loadMoreProducts() async {
    try {
      if (state.isLoading || !state.hasValue) return;
      state = AsyncValue.loading();
      state = await AsyncValue.guard(
        () async => await _getStateByDataSource(state.requireValue.filter),
      );
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(error: e.toString()));
    }
  }

  void toggleViewType() {
    if (state.isLoading || !state.hasValue) return;
    final newViewType =
        state.value!.viewType == ProductViewType.grid
            ? ProductViewType.list
            : ProductViewType.grid;

    state = AsyncValue.data(state.value!.copyWith(viewType: newViewType));
  }

  int _mapSortOptionToOrderBy(SelectListItem sortOption) {
    var sortOptionUri = Uri.parse(
      '${AppConfig.instance.apiBaseUrl}/${sortOption.value}',
    );
    return int.tryParse(sortOptionUri.queryParameters['orderby']!) ?? 5;
  }

  Future<void> selectCategory(String? categoryId) async {
    try {
      if (state.isLoading || !state.hasValue) return;
      state = AsyncValue.data(state.requireValue.copyWith(products: []));
      state = AsyncValue.loading();
      state = await AsyncValue.guard(
        () async => await _getStateByDataSource(
          state.requireValue
              .copyWith(
                products: [],
                filter: state.requireValue.filter.copyWith(
                  selectedCategory: categoryId,
                  pagingFilterModel: state.requireValue.filter.pagingFilterModel
                      ?.copyWith(pageNumber: 0),
                ),
              )
              .filter,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(error: e.toString()));
    }
  }

  Future<void> selectCollection(String? collectionId) async {
    try {
      if (state.isLoading || !state.hasValue) return;
      state = AsyncValue.data(state.requireValue.copyWith(products: []));
      state = AsyncValue.loading();
      state = await AsyncValue.guard(
        () async => await _getStateByDataSource(
          state.requireValue
              .copyWith(
                products: [],
                filter: state.requireValue.filter.copyWith(
                  selectedCollectionId: collectionId,
                  pagingFilterModel: state.requireValue.filter.pagingFilterModel
                      ?.copyWith(pageNumber: 0),
                ),
              )
              .filter,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(error: e.toString()));
    }
  }

  Future<void> selectVendor(String? vendorId) async {
    try {
      if (state.isLoading || !state.hasValue) return;
      state = AsyncValue.data(state.requireValue.copyWith(products: []));
      state = AsyncValue.loading();
      state = await AsyncValue.guard(
        () async => await _getStateByDataSource(
          state.requireValue
              .copyWith(
                products: [],
                filter: state.requireValue.filter.copyWith(
                  vendorId: vendorId,
                  pagingFilterModel: state.requireValue.filter.pagingFilterModel
                      ?.copyWith(pageNumber: 0),
                ),
              )
              .filter,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(error: e.toString()));
    }
  }

  Future<void> setSearchText(String searchText) async {
    try {
      if (state.isLoading || !state.hasValue) return;
      state = AsyncValue.data(state.requireValue.copyWith(products: []));
      state = AsyncValue.loading();
      state = await AsyncValue.guard(
        () async => await _getStateByDataSource(
          state.requireValue
              .copyWith(
                products: [],
                filter: state.requireValue.filter.copyWith(
                  query: searchText,
                  pagingFilterModel: state.requireValue.filter.pagingFilterModel
                      ?.copyWith(pageNumber: 0),
                ),
              )
              .filter,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(error: e.toString()));
    }
  }

  Future<void> updateSortOption(SelectListItem sortOption) async {
    try {
      if (state.isLoading || !state.hasValue) return;
      state = AsyncValue.data(state.requireValue.copyWith(products: []));
      state = AsyncValue.loading();
      state = await AsyncValue.guard(
        () async => await _getStateByDataSource(
          state.requireValue
              .copyWith(
                filter: state.requireValue.filter.copyWith(
                  orderBy: _mapSortOptionToOrderBy(sortOption),
                  pagingFilterModel: state.requireValue.filter.pagingFilterModel
                      ?.copyWith(pageNumber: 0),
                ),
              )
              .filter,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(error: e.toString()));
    }
  }

  void setRatingFilter(double? rating) {
    if (state.isLoading || !state.hasValue) return;

    state = AsyncValue.data(
      state.requireValue.copyWith(
        products: [],
        filter: state.requireValue.filter.copyWith(
          rating: rating,
          pagingFilterModel: state.requireValue.filter.pagingFilterModel
              ?.copyWith(pageNumber: 0, rating: rating),
        ),
      ),
    );
  }

  void filterByPriceRange(double? minPrice, double? maxPrice) {
    if (state.isLoading || !state.hasValue) return;

    state = AsyncValue.data(
      state.requireValue.copyWith(
        products: [],
        filter: state.requireValue.filter.copyWith(
          minPrice: minPrice,
          maxPrice: maxPrice,
          pagingFilterModel: state.requireValue.filter.pagingFilterModel
              ?.copyWith(pageNumber: 0),
        ),
      ),
    );
  }

  Future<void> filterBySpecifications({
    String? categoryId,
    String? collectionId,
    String? vendorId,
    double? rating,
    double? minPrice,
    double? maxPrice,
    List<SpecificationFilterItem>? filters,
  }) async {
    try {
      if (state.isLoading || !state.hasValue) return;
      state = AsyncValue.data(state.requireValue.copyWith(products: []));
      state = AsyncValue.loading();
      state = await AsyncValue.guard(
        () async => await _getStateByDataSource(
          state.requireValue
              .copyWith(
                products: [],
                filter: state.requireValue.filter.copyWith(
                  alreadyFilteredItems:
                      filters ?? state.requireValue.filter.alreadyFilteredItems,
                  selectedCategory:
                      categoryId ?? state.requireValue.filter.selectedCategory,
                  selectedCollectionId:
                      collectionId ??
                      state.requireValue.filter.selectedCollectionId,
                  vendorId: vendorId ?? state.requireValue.filter.vendorId,
                  rating: rating ?? state.requireValue.filter.rating,
                  minPrice: minPrice ?? state.requireValue.filter.minPrice,
                  maxPrice: maxPrice ?? state.requireValue.filter.maxPrice,
                  pagingFilterModel: state.requireValue.filter.pagingFilterModel
                      ?.copyWith(pageNumber: 0),
                ),
              )
              .filter,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(error: e.toString()));
    }
  }

  Future<void> clearAllFilters() async {
    try {
      if (state.isLoading || !state.hasValue) return;
      state = AsyncValue.data(state.requireValue.copyWith(products: []));
      state = AsyncValue.loading();
      state = await AsyncValue.guard(
        () async => await _getStateByDataSource(
          state.requireValue
              .copyWith(
                products: [],
                filter: state.requireValue.filter.copyWith(
                  alreadyFilteredItems: [],
                  notFilteredItems: [],
                  maxPrice: null,
                  minPrice: null,
                  selectedCategory: null,
                  selectedCollectionId: null,
                  vendorId: null,
                  rating: null,
                  pagingFilterModel: state.requireValue.filter.pagingFilterModel
                      ?.copyWith(pageNumber: 0, rating: null),
                ),
              )
              .filter,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(error: e.toString()));
    }
  }
}
