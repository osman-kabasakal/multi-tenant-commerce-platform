import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../orders/shopping_cart_type/shopping_cart_type.dart';

import '../../custom_attribute_model/custom_attribute_model.dart';

part 'product_details_cart.freezed.dart';
part 'product_details_cart.g.dart';

@freezed
class ProductDetailsCart extends StoreJsonSerializable<ProductDetailsCart>
    with _$ProductDetailsCart {
  factory ProductDetailsCart(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
      @Default(ShoppingCartType.onHoldCart)
      ShoppingCartType? shoppingCartTypeId,
      @JsonKey(name: 'ShoppingCartItemId', includeIfNull: false)
      String? shoppingCartItemId,
      @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
      int? enteredQuantity,
      @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
      @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
      String? reservationDatepickerFrom,
      @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
      String? reservationDatepickerTo,
      @JsonKey(name: 'RecipientName', includeIfNull: false)
      String? recipientName,
      @JsonKey(name: 'RecipientEmail', includeIfNull: false)
      String? recipientEmail,
      @JsonKey(name: 'SenderName', includeIfNull: false) String? senderName,
      @JsonKey(name: 'SenderEmail', includeIfNull: false) String? senderEmail,
      @JsonKey(name: 'Message', includeIfNull: false) String? message,
      @JsonKey(name: 'Attributes', includeIfNull: false)
      @Default([])
      List<CustomAttributeModel>? attributes,
      @JsonKey(name: 'Reservation', includeIfNull: false) String? reservation,
      @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
      String? customerEnteredPrice}) = _ProductDetailsCart;

  factory ProductDetailsCart.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsCartFromJson(json);
}
