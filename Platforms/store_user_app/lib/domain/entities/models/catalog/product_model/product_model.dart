import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../custom_attribute_model/custom_attribute_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel extends StoreJsonSerializable<ProductModel>
    with _$ProductModel {
  factory ProductModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
      @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
      String? reservationDatepickerFrom,
      @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
      String? reservationDatepickerTo,
      @JsonKey(name: 'LoadPicture', includeIfNull: false)
      @Default(false)
      bool? loadPicture,
      @JsonKey(name: 'Attributes', includeIfNull: false)
      @Default([])
      List<CustomAttributeModel>? attributes}) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
