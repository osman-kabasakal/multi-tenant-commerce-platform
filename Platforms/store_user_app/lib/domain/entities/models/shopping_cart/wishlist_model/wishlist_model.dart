import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'shopping_cart_item_model/shopping_cart_item_model.dart';

import '../../../common/user_field/user_field.dart';

part 'wishlist_model.freezed.dart';
part 'wishlist_model.g.dart';

@freezed
class WishlistModel extends StoreJsonSerializable<WishlistModel>
    with _$WishlistModel {
  factory WishlistModel(
      {@JsonKey(name: 'CustomerGuid', includeIfNull: false)
      String? customerGuid,
      @JsonKey(name: 'CustomerFullname', includeIfNull: false)
      String? customerFullname,
      @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
      @Default(false)
      bool? emailWishlistEnabled,
      @JsonKey(name: 'ShowSku', includeIfNull: false)
      @Default(false)
      bool? showSku,
      @JsonKey(name: 'ShowProductImages', includeIfNull: false)
      @Default(false)
      bool? showProductImages,
      @JsonKey(name: 'IsEditable', includeIfNull: false)
      @Default(false)
      bool? isEditable,
      @JsonKey(name: 'DisplayAddToCart', includeIfNull: false)
      @Default(false)
      bool? displayAddToCart,
      @JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<ShoppingCartItemModel>? items,
      @JsonKey(name: 'Warnings', includeIfNull: false)
      @Default([])
      List<String>? warnings,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _WishlistModel;

  factory WishlistModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistModelFromJson(json);
}
