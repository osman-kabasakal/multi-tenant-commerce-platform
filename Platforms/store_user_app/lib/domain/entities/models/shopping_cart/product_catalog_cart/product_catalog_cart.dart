import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../orders/shopping_cart_type/shopping_cart_type.dart';

part 'product_catalog_cart.freezed.dart';
part 'product_catalog_cart.g.dart';

@freezed
class ProductCatalogCart extends StoreJsonSerializable<ProductCatalogCart>
    with _$ProductCatalogCart {
  factory ProductCatalogCart(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
      @Default(ShoppingCartType.onHoldCart)
      ShoppingCartType? shoppingCartTypeId,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'ForceRedirection', includeIfNull: false)
      @Default(false)
      bool? forceRedirection}) = _ProductCatalogCart;

  factory ProductCatalogCart.fromJson(Map<String, dynamic> json) =>
      _$ProductCatalogCartFromJson(json);
}
