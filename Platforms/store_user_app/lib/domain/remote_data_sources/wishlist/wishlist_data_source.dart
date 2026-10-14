import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/shopping_cart/mini_wishlist_model/mini_wishlist_model.dart';
import '../../entities/models/shopping_cart/wishlist_model/wishlist_model.dart';
import '../../entities/anonymous_type_2_fec469_e/anonymous_type_2_fec469_e.dart';
import '../../entities/anonymous_type_97_c14_fd8/anonymous_type_97_c14_fd8.dart';
import '../../entities/models/shopping_cart/wishlist_email_afriend_model/wishlist_email_afriend_model.dart';
import '../../entities/models/shopping_cart/update_quantity_model/update_quantity_model.dart';
import '../../entities/models/shopping_cart/add_cart_from_wishlist_model/add_cart_from_wishlist_model.dart';

part 'wishlist_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class WishlistDataSource {
  @factoryMethod
  factory WishlistDataSource(Dio dio) {
    return _WishlistDataSource(dio);
  }

  @GET('/Wishlist/SidebarWishlist')
  @Extra({'responseType': ApiResponse<MiniWishlistModel>()})
  Future<ApiResponse<MiniWishlistModel>> getWishlistSidebarWishlist();

  @GET('/wishlist')
  @Extra({'responseType': ApiResponse<WishlistModel>()})
  Future<ApiResponse<WishlistModel>> getWishlistIndex([
    @Query('customerGuid') String? customerGuid,
  ]);

  @POST('/Wishlist/UpdateQuantity')
  @Extra({'responseType': ApiResponse<AnonymousType_2FEC469E>(), 'csrf': true})
  Future<ApiResponse<AnonymousType_2FEC469E>> postWishlistUpdateQuantity(
    @Body() UpdateQuantityModel model,
  );

  @POST('/Wishlist/AddItemToCartFromWishlist')
  @Extra({'responseType': ApiResponse<AnonymousType_97C14FD8>()})
  Future<ApiResponse<AnonymousType_97C14FD8>>
  postWishlistAddItemToCartFromWishlist(@Body() AddCartFromWishlistModel model);

  @GET('/wishlist/deleteitemfromwishlist/{shoppingcartId}')
  @Extra({'responseType': ApiResponse<AnonymousType_97C14FD8>()})
  Future<ApiResponse<AnonymousType_97C14FD8>> getWishlistDeleteItemFromWishlist(
    @Path('shoppingcartId') String shoppingCartId,
  );

  @POST('/emailwishlist')
  @Extra({
    'responseType': ApiResponse<WishlistEmailAFriendModel>(),
    'csrf': true,
  })
  Future<ApiResponse<WishlistEmailAFriendModel>> postWishlistEmailWishlist(
    @Body() WishlistEmailAFriendModel model,
  );
}
