import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';

import '../../../../orders/shopping_cart_type/shopping_cart_type.dart';

import '../../../../common/user_field/user_field.dart';

part 'add_to_cart_model.freezed.dart';
part 'add_to_cart_model.g.dart';

@freezed
class AddToCartModel extends StoreJsonSerializable<AddToCartModel>
    with _$AddToCartModel {
  factory AddToCartModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
      int? enteredQuantity,
      @JsonKey(name: 'MinimumQuantityNotification', includeIfNull: false)
      String? minimumQuantityNotification,
      @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
      @Default([])
      List<SelectListItem>? allowedQuantities,
      @JsonKey(name: 'EnteredPrice', includeIfNull: false)
      @Default(false)
      bool? enteredPrice,
      @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
      double? customerEnteredPrice,
      @JsonKey(name: 'CustomerEnteredPriceRange', includeIfNull: false)
      String? customerEnteredPriceRange,
      @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
      @Default(false)
      bool? disableBuyButton,
      @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
      @Default(false)
      bool? disableWishlistButton,
      @JsonKey(name: 'IsReservation', includeIfNull: false)
      @Default(false)
      bool? isReservation,
      @JsonKey(name: 'IsAuction', includeIfNull: false)
      @Default(false)
      bool? isAuction,
      @JsonKey(name: 'MeasureUnit', includeIfNull: false) String? measureUnit,
      @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
      @Default(false)
      bool? availableForPreOrder,
      @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
      @Default(null)
      DateTime? preOrderDateTimeUtc,
      @JsonKey(name: 'UpdatedShoppingCartItemId', includeIfNull: false)
      String? updatedShoppingCartItemId,
      @JsonKey(name: 'UpdateShoppingCartItemType', includeIfNull: false)
      @Default(null)
      ShoppingCartType? updateShoppingCartItemType,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _AddToCartModel;

  factory AddToCartModel.fromJson(Map<String, dynamic> json) =>
      _$AddToCartModelFromJson(json);
}
