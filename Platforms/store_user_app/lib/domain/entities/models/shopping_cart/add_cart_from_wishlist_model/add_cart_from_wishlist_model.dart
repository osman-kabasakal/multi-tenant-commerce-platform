import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'add_cart_from_wishlist_model.freezed.dart';
part 'add_cart_from_wishlist_model.g.dart';

@freezed
class AddCartFromWishlistModel
    extends StoreJsonSerializable<AddCartFromWishlistModel>
    with _$AddCartFromWishlistModel {
  factory AddCartFromWishlistModel(
      {@JsonKey(name: 'CustomerGuid', includeIfNull: false)
      @Default(null)
      String? customerGuid,
      @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
      String? shoppingCartId}) = _AddCartFromWishlistModel;

  factory AddCartFromWishlistModel.fromJson(Map<String, dynamic> json) =>
      _$AddCartFromWishlistModelFromJson(json);
}
