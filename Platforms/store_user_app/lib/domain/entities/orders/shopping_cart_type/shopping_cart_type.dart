import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum ShoppingCartType {
  
  @JsonValue(0)
  onHoldCart(0),
  @JsonValue(1)
  shoppingCart(1),
  @JsonValue(2)
  wishlist(2),
  @JsonValue(3)
  auctions(3);

  final int value;
  const ShoppingCartType(this.value);
}