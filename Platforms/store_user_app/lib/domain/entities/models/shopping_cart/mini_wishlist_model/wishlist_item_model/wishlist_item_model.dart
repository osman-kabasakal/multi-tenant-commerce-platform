import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../media/picture_model/picture_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'wishlist_item_model.freezed.dart';
part 'wishlist_item_model.g.dart';

@freezed
class WishlistItemModel extends StoreJsonSerializable<WishlistItemModel>
    with _$WishlistItemModel {
  factory WishlistItemModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'ProductUrl', includeIfNull: false) String? productUrl,
      @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
      @JsonKey(name: 'UnitPriceValue', includeIfNull: false)
      double? unitPriceValue,
      @JsonKey(name: 'TaxRate', includeIfNull: false) double? taxRate,
      @JsonKey(name: 'AttributeInfo', includeIfNull: false)
      String? attributeInfo,
      @JsonKey(name: 'Picture', includeIfNull: false) PictureModel? picture,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _WishlistItemModel;

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemModelFromJson(json);
}
