import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import './merchandise_return_model/merchandise_return_model.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_merchandise_returns_model.freezed.dart';
part 'customer_merchandise_returns_model.g.dart';

@freezed
class CustomerMerchandiseReturnsModel
    extends StoreJsonSerializable<CustomerMerchandiseReturnsModel>
    with _$CustomerMerchandiseReturnsModel {
  factory CustomerMerchandiseReturnsModel(
      {@JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<MerchandiseReturnModel>? items,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerMerchandiseReturnsModel;

  factory CustomerMerchandiseReturnsModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerMerchandiseReturnsModelFromJson(json);
}
