import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../entities/models/catalog/category_model/category_model.dart';

part 'component_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class ComponentDataSource {
  @factoryMethod
  factory ComponentDataSource(Dio dio) {
    return _ComponentDataSource(dio);
  }

  @GET('/Component/Index')
  Future<dynamic> getComponentIndex(@Query('name') String name);

  @POST('/Component/Index')
  Future<dynamic> postComponentIndex(
    @Query('name') String name,
    @Body() Map<String, Object> arguments,
  );

  @GET('/Component/HomePageCategories')
  Future<dynamic> getHomePageCategories();

  @GET('/Component/CategoryFeaturedProducts')
  Future<dynamic> getCategoryFeaturedProducts();

  @GET('/Component/PersonalizedProducts')
  Future<dynamic> getPersonalizedProducts({
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/CustomerRecommendedProducts')
  Future<dynamic> getCustomerRecommendedProducts({
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/RecommendedProducts')
  Future<dynamic> getRecommendedProducts({
    @Query('productId') String? productId,
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/SuggestedProducts')
  Future<dynamic> getSuggestedProducts({
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/HomePageProducts')
  Future<dynamic> getHomePageProducts({
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/BlogCategories')
  Future<dynamic> getBlogCategories();

  @GET('/Component/BlogMonths')
  Future<dynamic> getBlogMonths();

  @GET('/Component/BlogTags')
  Future<dynamic> getBlogTags();

  @GET('/Component/CategoryNavigation')
  Future<dynamic> getCategoryNavigation({
    @Query('currentCategoryId') String? currentCategoryId,
    @Query('currentProductId') String? currentProductId,
  });

  @GET('/Component/CollectionFeaturedProducts')
  Future<dynamic> getCollectionFeaturedProducts();

  @GET('/Component/CollectionNavigation')
  Future<dynamic> getCollectionNavigation();

  @GET('/Component/HomePageBestSellers')
  Future<dynamic> getHomePageBestSellers({
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/HomePageBlog')
  Future<dynamic> getHomePageBlog();

  @GET('/Component/HomePageBrands')
  Future<dynamic> getHomePageBrands();

  @GET('/Component/HomePageCollections')
  Future<dynamic> getHomePageCollections();

  @GET('/Component/HomePageNewProducts')
  Future<dynamic> getHomePageNewProducts({
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/HomePageNews')
  Future<dynamic> getHomePageNews();

  @GET('/Component/PopularProductTags')
  Future<dynamic> getPopularProductTags();

  @GET('/Component/ProductsAlsoPurchased')
  Future<dynamic> getProductsAlsoPurchased({
    @Query('productId') required String productId,
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/RecentlyViewedProductsBlock')
  Future<dynamic> getRecentlyViewedProductsBlock({
    @Query('productThumbPictureSize') int? productThumbPictureSize,
    @Query('preparePriceModel') bool? preparePriceModel,
  });

  @GET('/Component/RelatedProducts')
  Future<dynamic> getRelatedProducts({
    @Query('productId') required String productId,
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/SimilarProducts')
  Future<dynamic> getSimilarProducts({
    @Query('productId') required String productId,
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/CrossSellProducts')
  Future<dynamic> getCrossSellProducts({
    @Query('productThumbPictureSize') int? productThumbPictureSize,
  });

  @GET('/Component/VendorNavigation')
  Future<dynamic> getVendorNavigation();
}
