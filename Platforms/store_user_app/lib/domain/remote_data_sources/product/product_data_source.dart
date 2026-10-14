import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
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

part 'product_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class ProductDataSource {
  @factoryMethod
  factory ProductDataSource(Dio dio) {
    return _ProductDataSource(dio);
  }

  @GET('/Product/RecentlyViewedProducts')
  @Extra({'responseType': ApiResponse<List<ProductOverviewModel>>()})
  Future<ApiResponse<List<ProductOverviewModel>>>
  getProductRecentlyViewedProducts();

  @GET('/Product/RelatedProducts')
  @Extra({'responseType': ApiResponse<List<ProductOverviewModel>>()})
  Future<ApiResponse<List<ProductOverviewModel>>> getProductRelatedProducts(
    @Query('productId') String productId,
    @Query('productThumbPictureSize') int productThumbPictureSize,
  );

  @GET('/Product/NewProducts')
  @Extra({'responseType': ApiResponse<List<ProductOverviewModel>>()})
  Future<ApiResponse<List<ProductOverviewModel>>> getProductNewProducts();

  @POST('/Product/ProductEmailAFriend')
  @Extra({
    'responseType': ApiResponse<ProductEmailAFriendModel>(),
    'csrf': true,
  })
  Future<ApiResponse<ProductEmailAFriendModel>> postProductProductEmailAFriend(
    @Body() ProductEmailAFriendModel model,
  );

  @POST('/Product/AskQuestionOnProduct')
  @Extra({'responseType': ApiResponse<AnonymousType_97C14FD8>(), 'csrf': true})
  Future<ApiResponse<AnonymousType_97C14FD8>> postProductAskQuestionOnProduct(
    @Body() ProductAskQuestionSimpleModel model,
  );

  @POST('/Product/GetDatesForMonth')
  @Extra({'responseType': ApiResponse<dynamic>()})
  Future<ApiResponse<dynamic>> postProductGetDatesForMonth(
    @Query('productId') String productId,
    @Query('month') int month,
    @Query('parameter') String parameter,
    @Query('year') int year,
  );

  @GET('/Product/ProductDetails')
  @Extra({'responseType': ApiResponse<ProductDetailsModel>()})
  Future<ApiResponse<ProductDetailsModel>> getProductProductDetails(
    @Query('productId') String productId,
  );

  @POST('/Product/ProductDetails_AttributeChange')
  @Extra({'responseType': ApiResponse<AnonymousType_0327C72F>()})
  Future<ApiResponse<AnonymousType_0327C72F>>
  postProductProductDetails_AttributeChange(@Body() ProductModel model);

  @POST('/Product/ProductDetails_WarehouseChange')
  @Extra({'responseType': ApiResponse<AnonymousType_262F1F09>()})
  Future<ApiResponse<AnonymousType_262F1F09>>
  postProductProductDetails_WarehouseChange(@Body() ProductModel model);

  @POST('/Product/UploadFileProductAttribute')
  @Extra({'responseType': ApiResponse<AnonymousType_5F706788>()})
  Future<ApiResponse<AnonymousType_5F706788>>
  postProductUploadFileProductAttribute(
    @Query('attributeId') String attributeId,
    @Query('productId') String productId,
    @Part() File file,
  );

  @GET('/Product/QuickView')
  @Extra({'responseType': ApiResponse<AnonymousType_97C14FD8>()})
  Future<ApiResponse<AnonymousType_97C14FD8>> getProductQuickView(
    @Query('productId') String productId,
  );

  @POST('/Product/ProductReviews')
  @Extra({'responseType': ApiResponse<ProductReviewsModel>(), 'csrf': true})
  Future<ApiResponse<ProductReviewsModel>> postProductProductReviews(
    @Body() ProductReviewsModel model,
  );

  @POST('/Product/SetProductReviewHelpfulness')
  @Extra({'responseType': ApiResponse<AnonymousType_1EDE6D30>()})
  Future<ApiResponse<AnonymousType_1EDE6D30>>
  postProductSetProductReviewHelpfulness(
    @Query('productReviewId') String productReviewId,
    @Query('productId') String productId,
    @Query('washelpful') bool washelpful,
  );

  @GET('/Product/SidebarCompareProducts')
  @Extra({'responseType': ApiResponse<CompareProductsModel>()})
  Future<ApiResponse<CompareProductsModel>> getProductSidebarCompareProducts();

  @GET('/Product/CompareProducts')
  @Extra({'responseType': ApiResponse<CompareProductsModel>()})
  Future<ApiResponse<CompareProductsModel>> getProductCompareProducts();
}
