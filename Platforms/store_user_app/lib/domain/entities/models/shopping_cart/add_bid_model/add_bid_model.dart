import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'add_bid_model.freezed.dart';
part 'add_bid_model.g.dart';

@freezed
class AddBidModel extends StoreJsonSerializable<AddBidModel>
    with _$AddBidModel {
  factory AddBidModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'HighestBidValue', includeIfNull: false)
      String? highestBidValue,
      @JsonKey(name: 'WarehouseId', includeIfNull: false)
      String? warehouseId}) = _AddBidModel;

  factory AddBidModel.fromJson(Map<String, dynamic> json) =>
      _$AddBidModelFromJson(json);
}
