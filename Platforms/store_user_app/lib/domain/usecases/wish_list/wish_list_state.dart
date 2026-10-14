import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/wishlist_model/shopping_cart_item_model/shopping_cart_item_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/wishlist_model/wishlist_model.dart';

part 'wish_list_state.freezed.dart';

@freezed
class WishListState with _$WishListState {
  const factory WishListState({
    @Default(null) String? error,
    WishlistModel? wishList,
    @Default({}) Map<String, ShoppingCartItemModel> wishListItems,
    @Default(false) bool wisListEnabled,
  }) = _WishListState;
}
