import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/wishlist/wishlist_data_source.dart';
import '../../entities/models/shopping_cart/mini_wishlist_model/mini_wishlist_model.dart';
import '../../entities/models/shopping_cart/wishlist_model/wishlist_model.dart';
import '../../entities/anonymous_type_2_fec469_e/anonymous_type_2_fec469_e.dart';
import '../../entities/anonymous_type_97_c14_fd8/anonymous_type_97_c14_fd8.dart';
import '../../entities/models/shopping_cart/wishlist_email_afriend_model/wishlist_email_afriend_model.dart';
import '../../entities/models/shopping_cart/update_quantity_model/update_quantity_model.dart';
import '../../entities/models/shopping_cart/add_cart_from_wishlist_model/add_cart_from_wishlist_model.dart';

@lazySingleton
class WishlistRepository extends BaseRepository {
  final WishlistDataSource _dataSource;

  WishlistRepository(this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<MiniWishlistModel>?> getWishlistSidebarWishlist() async {
    return await decorator.execute<ApiResponse<MiniWishlistModel>>(
      operationName: "/Wishlist/SidebarWishlist",
      cacheKey: generateCacheKey("/Wishlist/SidebarWishlist", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getWishlistSidebarWishlist();
      },
    );
  }

  Future<ApiResponse<WishlistModel>?> getWishlistIndex(
      [String? customerGuid]) async {
    return await decorator.execute<ApiResponse<WishlistModel>>(
      operationName: "/Wishlist/Index",
      cacheKey: generateCacheKey("/Wishlist/Index", [customerGuid]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getWishlistIndex(customerGuid);
      },
    );
  }

  Future<ApiResponse<AnonymousType_2FEC469E>?> postWishlistUpdateQuantity(
      UpdateQuantityModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_2FEC469E>>(
      operationName: "/Wishlist/UpdateQuantity",
      cacheKey: null, //generateCacheKey("/Wishlist/UpdateQuantity", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postWishlistUpdateQuantity(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_97C14FD8>?>
      postWishlistAddItemToCartFromWishlist(
          AddCartFromWishlistModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_97C14FD8>>(
      operationName: "/Wishlist/AddItemToCartFromWishlist",
      cacheKey: null,
      // generateCacheKey("/Wishlist/AddItemToCartFromWishlist", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postWishlistAddItemToCartFromWishlist(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_97C14FD8>?>
      getWishlistDeleteItemFromWishlist(String shoppingCartId) async {
    return await decorator.execute<ApiResponse<AnonymousType_97C14FD8>>(
      operationName: "/Wishlist/DeleteItemFromWishlist",
      cacheKey:
          null, //generateCacheKey("/Wishlist/DeleteItemFromWishlist", [shoppingCartId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .getWishlistDeleteItemFromWishlist(shoppingCartId);
      },
    );
  }

  Future<ApiResponse<WishlistEmailAFriendModel>?> postWishlistEmailWishlist(
      WishlistEmailAFriendModel model) async {
    return await decorator.execute<ApiResponse<WishlistEmailAFriendModel>>(
      operationName: "/Wishlist/EmailWishlist",
      cacheKey: null, //generateCacheKey("/Wishlist/EmailWishlist", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postWishlistEmailWishlist(model);
      },
    );
  }
}
