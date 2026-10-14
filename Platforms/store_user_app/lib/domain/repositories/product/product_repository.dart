import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/product/product_data_source.dart';
import '../../entities/models/catalog/product_overview_model/product_overview_model.dart';
import '../../entities/models/catalog/product_email_afriend_model/product_email_afriend_model.dart';
import '../../entities/anonymous_type_97_c14_fd8/anonymous_type_97_c14_fd8.dart';
import '../../entities/models/catalog/product_details_model/product_details_model.dart';
import '../../entities/anonymous_type_0327_c72_f/anonymous_type_0327_c72_f.dart';
import '../../entities/anonymous_type_262_f1_f09/anonymous_type_262_f1_f09.dart';
import '../../entities/anonymous_type_5_f706788/anonymous_type_5_f706788.dart';
import '../../entities/models/catalog/product_reviews_model/product_reviews_model.dart';
import '../../entities/anonymous_type_1_ede6_d30/anonymous_type_1_ede6_d30.dart';
import '../../entities/models/catalog/compare_products_model/compare_products_model.dart';
import '../../entities/models/catalog/product_ask_question_simple_model/product_ask_question_simple_model.dart';
import '../../entities/models/catalog/product_model/product_model.dart';

@lazySingleton
class ProductRepository extends BaseRepository {
  final ProductDataSource _dataSource;

  ProductRepository(this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<List<ProductOverviewModel>>?>
      getProductRecentlyViewedProducts() async {
    return await decorator.execute<ApiResponse<List<ProductOverviewModel>>>(
      operationName: "/Product/RecentlyViewedProducts",
      cacheKey: null, //generateCacheKey("/Product/RecentlyViewedProducts", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getProductRecentlyViewedProducts();
      },
    );
  }

  Future<ApiResponse<List<ProductOverviewModel>>?> getProductRelatedProducts(
      String productId, int productThumbPictureSize) async {
    return await decorator.execute<ApiResponse<List<ProductOverviewModel>>>(
      operationName: "/Product/RelatedProducts",
      cacheKey: generateCacheKey(
          "/Product/RelatedProducts", [productId, productThumbPictureSize]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getProductRelatedProducts(
            productId, productThumbPictureSize);
      },
    );
  }

  Future<ApiResponse<List<ProductOverviewModel>>?>
      getProductNewProducts() async {
    return await decorator.execute<ApiResponse<List<ProductOverviewModel>>>(
      operationName: "/Product/NewProducts",
      cacheKey: generateCacheKey("/Product/NewProducts", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getProductNewProducts();
      },
    );
  }

  Future<ApiResponse<ProductEmailAFriendModel>?> postProductProductEmailAFriend(
      ProductEmailAFriendModel model) async {
    return await decorator.execute<ApiResponse<ProductEmailAFriendModel>>(
      operationName: "/Product/ProductEmailAFriend",
      cacheKey:
          null, // generateCacheKey("/Product/ProductEmailAFriend", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postProductProductEmailAFriend(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_97C14FD8>?> postProductAskQuestionOnProduct(
      ProductAskQuestionSimpleModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_97C14FD8>>(
      operationName: "/Product/AskQuestionOnProduct",
      cacheKey:
          null, // generateCacheKey("/Product/AskQuestionOnProduct", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postProductAskQuestionOnProduct(model);
      },
    );
  }

  Future<ApiResponse<dynamic>?> postProductGetDatesForMonth(
      String productId, int month, String parameter, int year) async {
    return await decorator.execute<ApiResponse<dynamic>>(
      operationName: "/Product/GetDatesForMonth",
      cacheKey: null,
      // generateCacheKey(
      //     "/Product/GetDatesForMonth", [productId, month, parameter, year]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postProductGetDatesForMonth(
            productId, month, parameter, year);
      },
    );
  }

  Future<ApiResponse<ProductDetailsModel>?> getProductProductDetails(
      String productId) async {
    return await decorator.execute<ApiResponse<ProductDetailsModel>>(
      operationName: "/Product/ProductDetails",
      cacheKey: generateCacheKey("/Product/ProductDetails", [productId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getProductProductDetails(productId);
      },
    );
  }

  Future<ApiResponse<AnonymousType_0327C72F>?>
      postProductProductDetails_AttributeChange(ProductModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_0327C72F>>(
      operationName: "/Product/ProductDetails_AttributeChange",
      cacheKey: null,
      // generateCacheKey("/Product/ProductDetails_AttributeChange", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .postProductProductDetails_AttributeChange(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_262F1F09>?>
      postProductProductDetails_WarehouseChange(ProductModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_262F1F09>>(
      operationName: "/Product/ProductDetails_WarehouseChange",
      cacheKey: null,
      // generateCacheKey("/Product/ProductDetails_WarehouseChange", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .postProductProductDetails_WarehouseChange(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_5F706788>?>
      postProductUploadFileProductAttribute(
          String attributeId, String productId, File file) async {
    return await decorator.execute<ApiResponse<AnonymousType_5F706788>>(
      operationName: "/Product/UploadFileProductAttribute",
      cacheKey: null,
      // generateCacheKey(
      //     "/Product/UploadFileProductAttribute", [attributeId, productId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postProductUploadFileProductAttribute(
            attributeId, productId, file);
      },
    );
  }

  Future<ApiResponse<AnonymousType_97C14FD8>?> getProductQuickView(
      String productId) async {
    return await decorator.execute<ApiResponse<AnonymousType_97C14FD8>>(
      operationName: "/Product/QuickView",
      cacheKey: generateCacheKey("/Product/QuickView", [productId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getProductQuickView(productId);
      },
    );
  }

  Future<ApiResponse<ProductReviewsModel>?> postProductProductReviews(
      ProductReviewsModel model) async {
    return await decorator.execute<ApiResponse<ProductReviewsModel>>(
      operationName: "/Product/ProductReviews",
      cacheKey: null, //generateCacheKey("/Product/ProductReviews", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postProductProductReviews(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_1EDE6D30>?>
      postProductSetProductReviewHelpfulness(
          String productReviewId, String productId, bool washelpful) async {
    return await decorator.execute<ApiResponse<AnonymousType_1EDE6D30>>(
      operationName: "/Product/SetProductReviewHelpfulness",
      cacheKey: null, //generateCacheKey("/Product/SetProductReviewHelpfulness",
      //[productReviewId, productId, washelpful]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postProductSetProductReviewHelpfulness(
            productReviewId, productId, washelpful);
      },
    );
  }

  Future<ApiResponse<CompareProductsModel>?>
      getProductSidebarCompareProducts() async {
    return await decorator.execute<ApiResponse<CompareProductsModel>>(
      operationName: "/Product/SidebarCompareProducts",
      cacheKey: generateCacheKey("/Product/SidebarCompareProducts", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getProductSidebarCompareProducts();
      },
    );
  }

  Future<ApiResponse<CompareProductsModel>?> getProductCompareProducts() async {
    return await decorator.execute<ApiResponse<CompareProductsModel>>(
      operationName: "/Product/CompareProducts",
      cacheKey: generateCacheKey("/Product/CompareProducts", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getProductCompareProducts();
      },
    );
  }
}
