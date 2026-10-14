import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'shipment_item_model.freezed.dart';
part 'shipment_item_model.g.dart';

@freezed
class ShipmentItemModel extends StoreJsonSerializable<ShipmentItemModel>
    with _$ShipmentItemModel {
  factory ShipmentItemModel(
      {@JsonKey(name: 'Sku', includeIfNull: false) String? sku,
      @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'AttributeInfo', includeIfNull: false)
      String? attributeInfo,
      @JsonKey(name: 'RentalInfo', includeIfNull: false) String? rentalInfo,
      @JsonKey(name: 'QuantityOrdered', includeIfNull: false)
      int? quantityOrdered,
      @JsonKey(name: 'QuantityShipped', includeIfNull: false)
      int? quantityShipped,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ShipmentItemModel;

  factory ShipmentItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShipmentItemModelFromJson(json);
}
