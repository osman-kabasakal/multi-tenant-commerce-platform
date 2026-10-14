import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/catalog/catalog_data_source.dart';
import '../../entities/models/catalog/category_model/category_model.dart';
import '../../entities/models/catalog/category_list_model/category_list_model.dart';
import '../../entities/models/catalog/brand_model/brand_model.dart';
import '../../entities/models/catalog/brand_list_model/brand_list_model.dart';
import '../../entities/models/catalog/collection_model/collection_model.dart';
import '../../entities/models/catalog/collection_list_model/collection_list_model.dart';
import '../../entities/models/catalog/vendor_model/vendor_model.dart';
import '../../entities/models/catalog/vendor_list_model/vendor_list_model.dart';
import '../../entities/models/vendors/vendor_reviews_model/vendor_reviews_model.dart';
import '../../entities/anonymous_type_1_ede6_d30/anonymous_type_1_ede6_d30.dart';
import '../../entities/models/catalog/products_by_tag_model/products_by_tag_model.dart';
import '../../entities/models/catalog/popular_product_tags_model/popular_product_tags_model.dart';
import '../../entities/models/catalog/search_model/search_model.dart';
import '../../entities/models/catalog/search_auto_complete_model/search_auto_complete_model.dart';
import '../../entities/models/catalog/catalog_paging_filtering_model/catalog_paging_filtering_model.dart';
import '../../entities/models/catalog/category_paging_model/category_paging_model.dart';
import '../../entities/models/catalog/brand_paging_model/brand_paging_model.dart';
import '../../entities/models/catalog/collection_paging_model/collection_paging_model.dart';
import '../../entities/models/catalog/vendor_paging_model/vendor_paging_model.dart';

@lazySingleton
class CatalogRepository extends BaseRepository {
  final CatalogDataSource _dataSource;

  CatalogRepository(this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<CategoryModel>?> getCatalogCategory(
      String categoryId,
      Map<String, String>? filterItems,
      CatalogPagingFilteringModel command) async {
    return await decorator.execute<ApiResponse<CategoryModel>>(
      operationName: "/Catalog/Category",
      cacheKey: generateCacheKey(
          "/Catalog/Category", [categoryId, filterItems, command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogCategory(
            categoryId: categoryId, filterItems: filterItems, command: command);
      },
    );
  }

  Future<ApiResponse<CategoryListModel>?> getCatalogCategoryAll(
      CategoryPagingModel command) async {
    return await decorator.execute<ApiResponse<CategoryListModel>>(
      operationName: "/Catalog/CategoryAll",
      cacheKey: generateCacheKey("/Catalog/CategoryAll", [command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogCategoryAll(command);
      },
    );
  }

  Future<ApiResponse<BrandModel>?> getCatalogBrand(
      String brandId, CatalogPagingFilteringModel command) async {
    return await decorator.execute<ApiResponse<BrandModel>>(
      operationName: "/Catalog/Brand",
      cacheKey: generateCacheKey("/Catalog/Brand", [brandId, command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogBrand(brandId, command);
      },
    );
  }

  Future<ApiResponse<BrandListModel>?> getCatalogBrandAll(
      BrandPagingModel command) async {
    return await decorator.execute<ApiResponse<BrandListModel>>(
      operationName: "/Catalog/BrandAll",
      cacheKey: generateCacheKey("/Catalog/BrandAll", [command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogBrandAll(command);
      },
    );
  }

  Future<ApiResponse<CollectionModel>?> getCatalogCollection(
      String collectionId, CatalogPagingFilteringModel command) async {
    return await decorator.execute<ApiResponse<CollectionModel>>(
      operationName: "/Catalog/Collection",
      cacheKey:
          generateCacheKey("/Catalog/Collection", [collectionId, command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogCollection(collectionId, command);
      },
    );
  }

  Future<ApiResponse<CollectionListModel>?> getCatalogCollectionAll(
      CollectionPagingModel command) async {
    return await decorator.execute<ApiResponse<CollectionListModel>>(
      operationName: "/Catalog/CollectionAll",
      cacheKey: generateCacheKey("/Catalog/CollectionAll", [command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogCollectionAll(command);
      },
    );
  }

  Future<ApiResponse<VendorModel>?> getCatalogVendor(
      String vendorId, CatalogPagingFilteringModel command) async {
    return await decorator.execute<ApiResponse<VendorModel>>(
      operationName: "/Catalog/Vendor",
      cacheKey: generateCacheKey("/Catalog/Vendor", [vendorId, command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogVendor(vendorId, command);
      },
    );
  }

  Future<ApiResponse<VendorListModel>?> getCatalogVendorAll(
      VendorPagingModel command) async {
    return await decorator.execute<ApiResponse<VendorListModel>>(
      operationName: "/Catalog/VendorAll",
      cacheKey: generateCacheKey("/Catalog/VendorAll", [command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogVendorAll(command);
      },
    );
  }

  Future<ApiResponse<VendorReviewsModel>?> postCatalogVendorReviews(
      VendorReviewsModel model) async {
    return await decorator.execute<ApiResponse<VendorReviewsModel>>(
      operationName: "/Catalog/VendorReviews",
      cacheKey: generateCacheKey("/Catalog/VendorReviews", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCatalogVendorReviews(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_1EDE6D30>?>
      postCatalogSetVendorReviewHelpfulness(
          String VendorReviewId, String vendorId, bool washelpful) async {
    return await decorator.execute<ApiResponse<AnonymousType_1EDE6D30>>(
      operationName: "/Catalog/SetVendorReviewHelpfulness",
      cacheKey: generateCacheKey("/Catalog/SetVendorReviewHelpfulness",
          [VendorReviewId, vendorId, washelpful]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCatalogSetVendorReviewHelpfulness(
            VendorReviewId, vendorId, washelpful);
      },
    );
  }

  Future<ApiResponse<ProductsByTagModel>?> getCatalogProductsByTag(
      String productTagId, CatalogPagingFilteringModel command) async {
    return await decorator.execute<ApiResponse<ProductsByTagModel>>(
      operationName: "/Catalog/ProductsByTag",
      cacheKey:
          generateCacheKey("/Catalog/ProductsByTag", [productTagId, command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogProductsByTag(productTagId, command);
      },
    );
  }

  Future<ApiResponse<ProductsByTagModel>?> getCatalogProductsByTagName(
      String seName, CatalogPagingFilteringModel command) async {
    return await decorator.execute<ApiResponse<ProductsByTagModel>>(
      operationName: "/Catalog/ProductsByTagName",
      cacheKey:
          generateCacheKey("/Catalog/ProductsByTagName", [seName, command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogProductsByTagName(seName, command);
      },
    );
  }

  Future<ApiResponse<PopularProductTagsModel>?>
      getCatalogProductTagsAll() async {
    return await decorator.execute<ApiResponse<PopularProductTagsModel>>(
      operationName: "/Catalog/ProductTagsAll",
      cacheKey: generateCacheKey("/Catalog/ProductTagsAll", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogProductTagsAll();
      },
    );
  }

  Future<ApiResponse<SearchModel>?> getCatalogSearch(
      String query,
      Map<String, String>? filterItems,
      SearchModel model,
      CatalogPagingFilteringModel command) async {
    return await decorator.execute<ApiResponse<SearchModel>>(
      operationName: "/Catalog/Search",
      cacheKey: generateCacheKey(
          "/Catalog/Search", [query, filterItems, model, command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogSearch(
            query: query,
            model: model,
            command: command,
            filterItems: filterItems);
      },
    );
  }

  Future<ApiResponse<List<SearchAutoCompleteModel>>?>
      getCatalogSearchTermAutoComplete(String term, String categoryId) async {
    return await decorator.execute<ApiResponse<List<SearchAutoCompleteModel>>>(
      operationName: "/Catalog/SearchTermAutoComplete",
      cacheKey: generateCacheKey(
          "/Catalog/SearchTermAutoComplete", [term, categoryId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCatalogSearchTermAutoComplete(
            term, categoryId);
      },
    );
  }
}
