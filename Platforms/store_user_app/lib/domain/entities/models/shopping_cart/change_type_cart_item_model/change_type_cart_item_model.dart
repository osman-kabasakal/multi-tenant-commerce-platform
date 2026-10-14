import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'change_type_cart_item_model.freezed.dart';
part 'change_type_cart_item_model.g.dart';

@freezed
class ChangeTypeCartItemModel
    extends StoreJsonSerializable<ChangeTypeCartItemModel>
    with _$ChangeTypeCartItemModel {
  factory ChangeTypeCartItemModel(
      {@JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'Status', includeIfNull: false)
      @Default(false)
      bool? status}) = _ChangeTypeCartItemModel;

  factory ChangeTypeCartItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeTypeCartItemModelFromJson(json);
}
