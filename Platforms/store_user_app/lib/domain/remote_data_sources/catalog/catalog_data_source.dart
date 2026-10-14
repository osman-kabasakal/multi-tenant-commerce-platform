import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
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

part 'catalog_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class CatalogDataSource {
  @factoryMethod
  factory CatalogDataSource(Dio dio) {
    return _CatalogDataSource(dio);
  }

  @GET('/Catalog/Category')
  @Extra({'responseType': ApiResponse<CategoryModel>()})
  Future<ApiResponse<CategoryModel>> getCatalogCategory({
    @Query('categoryId') required String categoryId,
    @Field('command') CatalogPagingFilteringModel? command,
    @Queries() Map<String, String>? filterItems,
  });

  @GET('/Catalog/CategoryAll')
  @Extra({'responseType': ApiResponse<CategoryListModel>()})
  Future<ApiResponse<CategoryListModel>> getCatalogCategoryAll(
    @Field('command') CategoryPagingModel command,
  );

  @GET('/Catalog/Brand')
  @Extra({'responseType': ApiResponse<BrandModel>()})
  Future<ApiResponse<BrandModel>> getCatalogBrand(
    @Query('brandId') String brandId,
    @Field('command') CatalogPagingFilteringModel command,
  );

  @GET('/Catalog/BrandAll')
  @Extra({'responseType': ApiResponse<BrandListModel>()})
  Future<ApiResponse<BrandListModel>> getCatalogBrandAll(
    @Field('command') BrandPagingModel command,
  );

  @GET('/Catalog/Collection')
  @Extra({'responseType': ApiResponse<CollectionModel>()})
  Future<ApiResponse<CollectionModel>> getCatalogCollection(
    @Query('collectionId') String collectionId,
    @Field('command') CatalogPagingFilteringModel command,
  );

  @GET('/Catalog/CollectionAll')
  @Extra({'responseType': ApiResponse<CollectionListModel>()})
  Future<ApiResponse<CollectionListModel>> getCatalogCollectionAll(
    @Field('command') CollectionPagingModel command,
  );

  @GET('/Catalog/Vendor')
  @Extra({'responseType': ApiResponse<VendorModel>()})
  Future<ApiResponse<VendorModel>> getCatalogVendor(
    @Query('vendorId') String vendorId,
    @Field('command') CatalogPagingFilteringModel command,
  );

  @GET('/Catalog/VendorAll')
  @Extra({'responseType': ApiResponse<VendorListModel>()})
  Future<ApiResponse<VendorListModel>> getCatalogVendorAll(
    @Field('command') VendorPagingModel command,
  );

  @POST('/Catalog/VendorReviews')
  @Extra({'responseType': ApiResponse<VendorReviewsModel>(), 'csrf': true})
  Future<ApiResponse<VendorReviewsModel>> postCatalogVendorReviews(
    @Body() VendorReviewsModel model,
  );

  @POST('/Catalog/SetVendorReviewHelpfulness')
  @Extra({'responseType': ApiResponse<AnonymousType_1EDE6D30>()})
  Future<ApiResponse<AnonymousType_1EDE6D30>>
  postCatalogSetVendorReviewHelpfulness(
    @Query('VendorReviewId') String VendorReviewId,
    @Query('vendorId') String vendorId,
    @Query('washelpful') bool washelpful,
  );

  @GET('/Catalog/ProductsByTag')
  @Extra({'responseType': ApiResponse<ProductsByTagModel>()})
  Future<ApiResponse<ProductsByTagModel>> getCatalogProductsByTag(
    @Query('productTagId') String productTagId,
    @Field('command') CatalogPagingFilteringModel command,
  );

  @GET('/Catalog/ProductsByTagName')
  @Extra({'responseType': ApiResponse<ProductsByTagModel>()})
  Future<ApiResponse<ProductsByTagModel>> getCatalogProductsByTagName(
    @Query('seName') String seName,
    @Field('command') CatalogPagingFilteringModel command,
  );

  @GET('/Catalog/ProductTagsAll')
  @Extra({'responseType': ApiResponse<PopularProductTagsModel>()})
  Future<ApiResponse<PopularProductTagsModel>> getCatalogProductTagsAll();

  @GET('/Catalog/Search')
  @Extra({'responseType': ApiResponse<SearchModel>()})
  Future<ApiResponse<SearchModel>> getCatalogSearch({
    @Query('q') required String query,
    @Queries() required Map<String, String>? filterItems,
    @Field('model') required SearchModel model,
    @Field('command') required CatalogPagingFilteringModel command,
  });

  @GET('/Catalog/SearchTermAutoComplete')
  @Extra({'responseType': ApiResponse<List<SearchAutoCompleteModel>>()})
  Future<ApiResponse<List<SearchAutoCompleteModel>>>
  getCatalogSearchTermAutoComplete(
    @Query('term') String term,
    @Query('categoryId') String categoryId,
  );
}
