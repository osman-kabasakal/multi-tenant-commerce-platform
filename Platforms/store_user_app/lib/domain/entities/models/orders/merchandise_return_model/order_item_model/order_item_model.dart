import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
class OrderItemModel extends StoreJsonSerializable<OrderItemModel>
    with _$OrderItemModel {
  factory OrderItemModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
      @JsonKey(name: 'VendorName', includeIfNull: false) String? vendorName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'AttributeInfo', includeIfNull: false)
      String? attributeInfo,
      @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
      @JsonKey(name: 'IncludingTax', includeIfNull: false)
      @Default(false)
      bool? includingTax,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'MerchandiseReturnReasonId', includeIfNull: false)
      String? merchandiseReturnReasonId,
      @JsonKey(name: 'MerchandiseReturnActionId', includeIfNull: false)
      String? merchandiseReturnActionId,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}
