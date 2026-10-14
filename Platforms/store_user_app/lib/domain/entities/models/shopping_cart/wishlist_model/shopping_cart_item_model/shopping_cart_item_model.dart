import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../media/picture_model/picture_model.dart';

import '../../../../microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';

import '../../../../common/user_field/user_field.dart';

part 'shopping_cart_item_model.freezed.dart';
part 'shopping_cart_item_model.g.dart';

@freezed
class ShoppingCartItemModel extends StoreJsonSerializable<ShoppingCartItemModel>
    with _$ShoppingCartItemModel {
  factory ShoppingCartItemModel(
      {@JsonKey(name: 'Sku', includeIfNull: false) String? sku,
      @JsonKey(name: 'Picture', includeIfNull: false) PictureModel? picture,
      @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'ProductUrl', includeIfNull: false) String? productUrl,
      @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
      @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
      @JsonKey(name: 'Discount', includeIfNull: false) String? discount,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
      @Default([])
      List<SelectListItem>? allowedQuantities,
      @JsonKey(name: 'AttributeInfo', includeIfNull: false)
      String? attributeInfo,
      @JsonKey(name: 'RecurringInfo', includeIfNull: false)
      String? recurringInfo,
      @JsonKey(name: 'RentalInfo', includeIfNull: false) String? rentalInfo,
      @JsonKey(name: 'AllowItemEditing', includeIfNull: false)
      @Default(false)
      bool? allowItemEditing,
      @JsonKey(name: 'Warnings', includeIfNull: false)
      @Default([])
      List<String>? warnings,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ShoppingCartItemModel;

  factory ShoppingCartItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingCartItemModelFromJson(json);
}
