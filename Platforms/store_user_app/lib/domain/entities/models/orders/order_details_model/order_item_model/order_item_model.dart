import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../media/picture_model/picture_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
class OrderItemModel extends StoreJsonSerializable<OrderItemModel>
    with _$OrderItemModel {
  factory OrderItemModel(
      {@JsonKey(name: 'OrderItemGuid', includeIfNull: false)
      String? orderItemGuid,
      @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
      @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'Picture', includeIfNull: false) PictureModel? picture,
      @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
      @JsonKey(name: 'UnitPriceIncludingTax', includeIfNull: false)
      @Default(false)
      bool? unitPriceIncludingTax,
      @JsonKey(name: 'UnitPriceValue', includeIfNull: false)
      double? unitPriceValue,
      @JsonKey(name: 'UnitPriceWithoutDiscount', includeIfNull: false)
      String? unitPriceWithoutDiscount,
      @JsonKey(name: 'UnitPriceWithoutDiscountValue', includeIfNull: false)
      double? unitPriceWithoutDiscountValue,
      @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
      @JsonKey(name: 'Discount', includeIfNull: false) String? discount,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'AttributeInfo', includeIfNull: false)
      String? attributeInfo,
      @JsonKey(name: 'RentalInfo', includeIfNull: false) String? rentalInfo,
      @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
      @JsonKey(name: 'LicenseId', includeIfNull: false) String? licenseId,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}
