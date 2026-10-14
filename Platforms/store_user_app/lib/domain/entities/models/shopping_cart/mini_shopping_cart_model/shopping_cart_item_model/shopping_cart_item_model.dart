import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../media/picture_model/picture_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'shopping_cart_item_model.freezed.dart';
part 'shopping_cart_item_model.g.dart';

@freezed
class ShoppingCartItemModel extends StoreJsonSerializable<ShoppingCartItemModel>
    with _$ShoppingCartItemModel {
  factory ShoppingCartItemModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'ProductUrl', includeIfNull: false) String? productUrl,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
      @JsonKey(name: 'AttributeInfo', includeIfNull: false)
      String? attributeInfo,
      @JsonKey(name: 'Picture', includeIfNull: false) PictureModel? picture,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ShoppingCartItemModel;

  factory ShoppingCartItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingCartItemModelFromJson(json);
}
