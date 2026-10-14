import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'delete_cart_item_model.freezed.dart';
part 'delete_cart_item_model.g.dart';

@freezed
class DeleteCartItemModel extends StoreJsonSerializable<DeleteCartItemModel>
    with _$DeleteCartItemModel {
  factory DeleteCartItemModel(
      {@JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'ShoppingCartPage', includeIfNull: false)
      @Default(false)
      bool? shoppingCartPage}) = _DeleteCartItemModel;

  factory DeleteCartItemModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteCartItemModelFromJson(json);
}
