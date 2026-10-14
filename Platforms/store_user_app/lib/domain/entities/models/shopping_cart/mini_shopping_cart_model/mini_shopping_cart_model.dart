import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'shopping_cart_item_model/shopping_cart_item_model.dart';

import '../../../common/user_field/user_field.dart';

part 'mini_shopping_cart_model.freezed.dart';
part 'mini_shopping_cart_model.g.dart';

@freezed
class MiniShoppingCartModel extends StoreJsonSerializable<MiniShoppingCartModel>
    with _$MiniShoppingCartModel {
  factory MiniShoppingCartModel(
      {@JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<ShoppingCartItemModel>? items,
      @JsonKey(name: 'TotalProducts', includeIfNull: false) int? totalProducts,
      @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
      @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
      @Default(false)
      bool? subTotalIncludingTax,
      @JsonKey(name: 'DisplayShoppingCartButton', includeIfNull: false)
      @Default(false)
      bool? displayShoppingCartButton,
      @JsonKey(name: 'DisplayCheckoutButton', includeIfNull: false)
      @Default(false)
      bool? displayCheckoutButton,
      @JsonKey(name: 'CurrentCustomerIsGuest', includeIfNull: false)
      @Default(false)
      bool? currentCustomerIsGuest,
      @JsonKey(name: 'AnonymousCheckoutAllowed', includeIfNull: false)
      @Default(false)
      bool? anonymousCheckoutAllowed,
      @JsonKey(name: 'ShowProductImages', includeIfNull: false)
      @Default(false)
      bool? showProductImages,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _MiniShoppingCartModel;

  factory MiniShoppingCartModel.fromJson(Map<String, dynamic> json) =>
      _$MiniShoppingCartModelFromJson(json);
}
