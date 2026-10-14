import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'product_warehouse_model.freezed.dart';
part 'product_warehouse_model.g.dart';

@freezed
class ProductWarehouseModel extends StoreJsonSerializable<ProductWarehouseModel>
    with _$ProductWarehouseModel {
  factory ProductWarehouseModel(
      {@JsonKey(name: 'Use', includeIfNull: false) @Default(false) bool? use,
      @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
      @JsonKey(name: 'Code', includeIfNull: false) String? code,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'StockQuantity', includeIfNull: false) int? stockQuantity,
      @JsonKey(name: 'ReservedQuantity', includeIfNull: false)
      int? reservedQuantity,
      @JsonKey(name: 'Selected', includeIfNull: false)
      @Default(false)
      bool? selected,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductWarehouseModel;

  factory ProductWarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductWarehouseModelFromJson(json);
}
