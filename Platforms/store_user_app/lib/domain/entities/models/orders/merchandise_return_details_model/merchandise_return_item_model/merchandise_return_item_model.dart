import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'merchandise_return_item_model.freezed.dart';
part 'merchandise_return_item_model.g.dart';

@freezed
class MerchandiseReturnItemModel
    extends StoreJsonSerializable<MerchandiseReturnItemModel>
    with _$MerchandiseReturnItemModel {
  factory MerchandiseReturnItemModel(
      {@JsonKey(name: 'OrderItemId', includeIfNull: false) String? orderItemId,
      @JsonKey(name: 'ReasonForReturn', includeIfNull: false)
      String? reasonForReturn,
      @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
      @JsonKey(name: 'RequestedAction', includeIfNull: false)
      String? requestedAction,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductPrice', includeIfNull: false) String? productPrice,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _MerchandiseReturnItemModel;

  factory MerchandiseReturnItemModel.fromJson(Map<String, dynamic> json) =>
      _$MerchandiseReturnItemModelFromJson(json);
}
