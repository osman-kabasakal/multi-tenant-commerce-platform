import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'wishlist_item_model/wishlist_item_model.dart';

import '../../../common/user_field/user_field.dart';

part 'mini_wishlist_model.freezed.dart';
part 'mini_wishlist_model.g.dart';

@freezed
class MiniWishlistModel extends StoreJsonSerializable<MiniWishlistModel>
    with _$MiniWishlistModel {
  factory MiniWishlistModel(
      {@JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<WishlistItemModel>? items,
      @JsonKey(name: 'TotalProducts', includeIfNull: false) int? totalProducts,
      @JsonKey(name: 'ShowProductImages', includeIfNull: false)
      @Default(false)
      bool? showProductImages,
      @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
      @Default(false)
      bool? emailWishlistEnabled,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _MiniWishlistModel;

  factory MiniWishlistModel.fromJson(Map<String, dynamic> json) =>
      _$MiniWishlistModelFromJson(json);
}
