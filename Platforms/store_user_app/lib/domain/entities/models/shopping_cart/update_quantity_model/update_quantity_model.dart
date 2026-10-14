import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../orders/shopping_cart_type/shopping_cart_type.dart';

part 'update_quantity_model.freezed.dart';
part 'update_quantity_model.g.dart';

@freezed
class UpdateQuantityModel extends StoreJsonSerializable<UpdateQuantityModel>
    with _$UpdateQuantityModel {
  factory UpdateQuantityModel(
      {@JsonKey(name: 'ShoppingCartId', includeIfNull: false)
      String? shoppingCartId,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'ShoppingCartType', includeIfNull: false)
      @Default(ShoppingCartType.onHoldCart)
      ShoppingCartType? shoppingCartType}) = _UpdateQuantityModel;

  factory UpdateQuantityModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateQuantityModelFromJson(json);
}
