import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_reviews_model/product_reviews_model.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_navigation_model/account_navigation_enum/account_navigation_enum.dart';
import 'package:store_user_app/domain/entities/models/legal_text_message_template_component_model/legal_text_message_template_component_model.dart';
import 'package:store_user_app/domain/entities/models/pages/page_model/page_model.dart';
import 'package:store_user_app/domain/entities/models/push_notifications/public_info_model/public_info_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/wishlist_email_afriend_model/wishlist_email_afriend_model.dart';

import '../../entities/models/catalog/product_overview_model/product_overview_model.dart';
import '../../entities/models/common/footer_model/footer_model.dart';
import '../../entities/models/components/slider/public_info_model/public_info_model.dart';
import '../../entities/models/customer/customer_navigation_model/customer_navigation_model.dart';
import '../../remote_data_sources/component/component_data_source.dart';

@lazySingleton
class ComponentRepository extends BaseRepository {
  final ComponentDataSource _dataSource;

  ComponentRepository(this._dataSource, super.decorator, super.eventBus);

  Future<dynamic> getComponentIndex(String name) async {
    return await decorator.execute<dynamic>(
      operationName: "/Component/Index",
      cacheKey: generateCacheKey("/Component/Index", [name]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getComponentIndex(name);
      },
    );
  }

  Future<dynamic> postComponentIndex(
    String name,
    Map<String, Object> arguments,
  ) async {
    return await decorator.execute<dynamic>(
      operationName: "/Component/Index",
      cacheKey: generateCacheKey("/Component/Index", [name, arguments]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postComponentIndex(name, arguments);
      },
    );
  }

  Future<PageModel?> postPageBlockComponent(String systemName) async {
    return await decorator.execute<PageModel>(
      operationName: "/Component/Index/PostPageBlockComponent",
      cacheKey: null,
      // generateCacheKey("/Component/Index/PostPageBlockComponent", [
      //   'PageBlock',
      //   {'systemName': systemName},
      // ]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.postComponentIndex('PageBlock', {
          'systemName': systemName,
        });
        return PageModel.fromJson(response);
      },
    );
  }

  Future<PublicInfoModel?> postHomePageSlideComponent(String widgetZone) async {
    return await decorator.execute<PublicInfoModel>(
      operationName: "/Component/Index/postHomePageSlideComponent",
      cacheKey: generateCacheKey(
        "/Component/Index/postHomePageSlideComponent",
        [
          'WidgetSlider',
          {'widgetZone': widgetZone},
        ],
      ),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.postComponentIndex('WidgetSlider', {
          'widgetZone': widgetZone,
        });
        return PublicInfoModel.fromJson(response);
      },
    );
  }

  Future<List<CategoryModel>?> getHomePageCategoriesComponent() async {
    return await decorator.execute<List<CategoryModel>>(
      operationName: "/Component/Index/getHomePageCategoriesComponent",
      cacheKey: generateCacheKey(
        "/Component/Index/getHomePageCategoriesComponent",
        ['HomePageCategories'],
      ),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getHomePageCategories();
        if (response == null) return null;
        return (response as List)
            .map((c) => CategoryModel.fromJson(c))
            .toList();
      },
    );
  }

  final getPersonalizedProductsCacheKeyPrefix =
      '/Component/Index/getPersonalizedProducts';
  Future<List<ProductOverviewModel>?> getPersonalizedProducts(
    int pictureSize,
  ) async {
    return await decorator.execute<List<ProductOverviewModel>>(
      operationName: "/Component/Index/getPersonalizedProducts",
      cacheKey: generateCacheKey("/Component/Index/getPersonalizedProducts", [
        'PersonalizedProducts',
        {'productThumbPictureSize': pictureSize},
      ]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getPersonalizedProducts(
          productThumbPictureSize: pictureSize,
        );
        if (response == null || response is! List) return null;
        return response.map((c) => ProductOverviewModel.fromJson(c)).toList();
      },
    );
  }

  final postCustomerRecommendedProductsCacheKeyPrefix =
      '/Component/Index/postCustomerRecommendedProducts';
  Future<List<ProductOverviewModel>?> postCustomerRecommendedProducts(
    int pictureSize,
  ) async {
    return await decorator.execute<List<ProductOverviewModel>>(
      operationName: "/Component/Index/postCustomerRecommendedProducts",
      cacheKey: generateCacheKey(
        "/Component/Index/postCustomerRecommendedProducts",
        [
          'CustomerRecommendedProducts',
          {'productThumbPictureSize': pictureSize},
        ],
      ),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getCustomerRecommendedProducts(
          productThumbPictureSize: pictureSize,
        );
        if (response == null || response is! List) return null;
        return response.map((c) => ProductOverviewModel.fromJson(c)).toList();
      },
    );
  }

  String get postSuggestedProductsCacheKeyPrefix =>
      '/Component/Index/postSuggestedProducts';
  Future<List<ProductOverviewModel>?> postSuggestedProducts(
    int pictureSize,
  ) async {
    return await decorator.execute<List<ProductOverviewModel>>(
      operationName: "/Component/Index/postSuggestedProducts",
      cacheKey: generateCacheKey("/Component/Index/postSuggestedProducts", [
        'SuggestedProducts',
        {'productThumbPictureSize': pictureSize},
      ]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getSuggestedProducts(
          productThumbPictureSize: pictureSize,
        );
        if (response == null || response is! List) return null;
        return response.map((c) => ProductOverviewModel.fromJson(c)).toList();
      },
    );
  }

  Future<List<ProductOverviewModel>?> postHomePageProducts(
    int pictureSize,
  ) async {
    return await decorator.execute<List<ProductOverviewModel>>(
      operationName: "/Component/Index/postHomePageProducts",
      cacheKey: generateCacheKey("/Component/Index/postHomePageProducts", [
        'HomePageProducts',
        {'productThumbPictureSize': pictureSize},
      ]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getHomePageProducts(
          productThumbPictureSize: pictureSize,
        );
        if (response == null || response is! List) return null;
        return response.map((c) => ProductOverviewModel.fromJson(c)).toList();
      },
    );
  }

  Future<List<ProductOverviewModel>?> postHomePageNewProducts(
    int pictureSize,
  ) async {
    return await decorator.execute<List<ProductOverviewModel>>(
      operationName: "/Component/Index/postHomePageNewProducts",
      cacheKey: generateCacheKey("/Component/Index/postHomePageNewProducts", [
        'HomePageNewProducts',
        {'productThumbPictureSize': pictureSize},
      ]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getHomePageNewProducts(
          productThumbPictureSize: pictureSize,
        );
        if (response == null || response is! List) return null;
        return response.map((c) => ProductOverviewModel.fromJson(c)).toList();
      },
    );
  }

  Future<List<ProductOverviewModel>?> postProductsAlsoPurchased(
    String productId,
    int pictureSize,
  ) async {
    return await decorator.execute<List<ProductOverviewModel>>(
      operationName: "/Component/Index/postProductsAlsoPurchased",
      cacheKey: generateCacheKey("/Component/Index/postProductsAlsoPurchased", [
        'ProductsAlsoPurchased',
        {'productId': productId, 'productThumbPictureSize': pictureSize},
      ]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getProductsAlsoPurchased(
          productId: productId,
          productThumbPictureSize: pictureSize,
        );
        if (response == null || response is! List) return null;
        return response.map((c) => ProductOverviewModel.fromJson(c)).toList();
      },
    );
  }

  Future<List<ProductOverviewModel>?> postRecentlyViewedProductsBlock(
    int productThumbPictureSize,
    bool preparePriceModel,
  ) async {
    return await decorator.execute<List<ProductOverviewModel>>(
      operationName: "/Component/Index/postRecentlyViewedProductsBlock",
      cacheKey: generateCacheKey(
        "/Component/Index/postRecentlyViewedProductsBlock",
        [
          'RecentlyViewedProductsBlock',
          {
            'productThumbPictureSize': productThumbPictureSize,
            'preparePriceModel': preparePriceModel,
          },
        ],
      ),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getRecentlyViewedProductsBlock(
          productThumbPictureSize: productThumbPictureSize,
          preparePriceModel: preparePriceModel,
        );
        if (response == null || response is! List) return null;
        return response.map((c) => ProductOverviewModel.fromJson(c)).toList();
      },
    );
  }

  Future<List<ProductOverviewModel>?> postRecommendedProducts(
    String productId,
    int productThumbPictureSize,
  ) async {
    return await decorator.execute<List<ProductOverviewModel>>(
      operationName: "/Component/Index/postRecommendedProducts",
      cacheKey: generateCacheKey("/Component/Index/postRecommendedProducts", [
        'RecommendedProducts',
        {
          'productId': productId,
          'productThumbPictureSize': productThumbPictureSize,
        },
      ]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getRecommendedProducts(
          productId: productId,
          productThumbPictureSize: productThumbPictureSize,
        );
        if (response == null || response is! List) return null;
        return response.map((c) => ProductOverviewModel.fromJson(c)).toList();
      },
    );
  }

  Future<List<ProductOverviewModel>?> postRelatedProducts(
    String productId,
    int productThumbPictureSize,
  ) async {
    return await decorator.execute<List<ProductOverviewModel>>(
      operationName: "/Component/Index/postRelatedProducts",
      cacheKey: generateCacheKey("/Component/Index/postRelatedProducts", [
        'RelatedProducts',
        {
          'productId': productId,
          'productThumbPictureSize': productThumbPictureSize,
        },
      ]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getRelatedProducts(
          productId: productId,
          productThumbPictureSize: productThumbPictureSize,
        );
        if (response == null || response is! List) return null;
        return response.map((c) => ProductOverviewModel.fromJson(c)).toList();
      },
    );
  }

  Future<List<ProductOverviewModel>?> postSimilarProducts(
    String productId,
    int productThumbPictureSize,
  ) async {
    return await decorator.execute<List<ProductOverviewModel>>(
      operationName: "/Component/Index/postSimilarProducts",
      cacheKey: generateCacheKey("/Component/Index/postSimilarProducts", [
        'SimilarProducts',
        {
          'productId': productId,
          'productThumbPictureSize': productThumbPictureSize,
        },
      ]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getSimilarProducts(
          productId: productId,
          productThumbPictureSize: productThumbPictureSize,
        );
        if (response == null || response is! List) return null;
        return response.map((c) => ProductOverviewModel.fromJson(c)).toList();
      },
    );
  }

  Future<List<CategoryModel>?> getCategoryFeaturedProducts(
    int pictureSize,
  ) async {
    return await decorator.execute<List<CategoryModel>>(
      operationName: "/Component/Index/getCategoryFeaturedProducts",
      cacheKey: generateCacheKey(
        "/Component/Index/getCategoryFeaturedProducts",
        [
          'CategoryFeaturedProducts',
          {'productThumbPictureSize': pictureSize},
        ],
      ),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getCategoryFeaturedProducts();
        if (response == null || response is! List) return null;
        return response.map((c) => CategoryModel.fromJson(c)).toList();
      },
    );
  }

  final postCustomerNavigationCacheKeyPrefix =
      '/Component/Index/postCustomerNavigation';
  Future<CustomerNavigationModel?> postCustomerNavigation(
    AccountNavigationEnum selectedTab,
  ) async {
    return await decorator.execute<CustomerNavigationModel>(
      operationName: "/Component/Index/postCustomerNavigation",
      cacheKey: generateCacheKey("/Component/Index/postCustomerNavigation", [
        'CustomerNavigation',
        {'selectedTabId': selectedTab},
      ]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.postComponentIndex(
          'CustomerNavigation',
          {},
        );
        if (response == null || response is! Map) return null;
        return CustomerNavigationModel.fromJson(
          response as Map<String, dynamic>,
        );
      },
    );
  }

  // final getFooterCacheKeyPrefix = '/Component/Index/getFooter';
  Future<FooterModel?> getFooter() async {
    return await decorator.execute<FooterModel>(
      operationName: "/Component/Index/getFooter",
      cacheKey: generateCacheKey("/Component/Index/getFooter", ['Footer']),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getComponentIndex('Footer');
        if (response == null || response is! Map) return null;
        return FooterModel.fromJson(response as Map<String, dynamic>);
      },
    );
  }

  Future<List<LegalTextMessageTemplateComponentModel>?> getLegalTexts(
    String categoryName,
  ) async {
    return await decorator.execute<
      List<LegalTextMessageTemplateComponentModel>
    >(
      operationName: "/Component/Index/LegalTextsView",
      cacheKey:
          null, //generateCacheKey("/Component/Index/LegalTextsView", [categoryName]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.postComponentIndex('LegalTextsView', {
          'categoryName': categoryName,
        });
        if (response == null || response is! List) return null;
        return response
            .map((c) => LegalTextMessageTemplateComponentModel.fromJson(c))
            .toList();
      },
    );
  }

  Future<ProductReviewsModel?> postProductReviewsModel(String productId) async {
    return await decorator.execute<ProductReviewsModel>(
      operationName: "/Component/Index/ProductReviews",
      cacheKey:
          null, //generateCacheKey("/Component/Index/LegalTextsView", [categoryName]),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.postComponentIndex('ProductReviews', {
          'productId': productId,
        });
        if (response == null || response is! Map) return null;
        return ProductReviewsModel.fromJson(response as Map<String, dynamic>);
      },
    );
  }

  Future<WishlistEmailAFriendModel?> getComponentWishlistEmailAFriend() async {
    return await decorator.execute<WishlistEmailAFriendModel>(
      operationName: "/Component/Index/EmailWishlist",
      cacheKey: generateCacheKey("/Component/Index/EmailWishlist"),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getComponentIndex('EmailWishlist');
        if (response == null || response is! Map) return null;
        return WishlistEmailAFriendModel.fromJson(
          response as Map<String, dynamic>,
        );
      },
    );
  }

  Future<PushNotificationsPublicInfoModel?>
  getPushNotificationsConfiguration() async {
    return await decorator.execute<PushNotificationsPublicInfoModel>(
      operationName: "/Component/Index/PushNotificationsRegistration",
      cacheKey: null,
      // generateCacheKey(
      //   "/Component/Index/PushNotificationsRegistration",
      // ),
      cacheDuration: null,
      operation: () async {
        var response = await _dataSource.getComponentIndex(
          'PushNotificationsRegistration',
        );
        if (response == null || response is! Map) return null;
        return PushNotificationsPublicInfoModel.fromJson(
          response as Map<String, dynamic>,
        );
      },
    );
  }
}
