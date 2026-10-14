import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'merchandise_return_model.freezed.dart';
part 'merchandise_return_model.g.dart';

@freezed
class MerchandiseReturnModel
    extends StoreJsonSerializable<MerchandiseReturnModel>
    with _$MerchandiseReturnModel {
  factory MerchandiseReturnModel(
      {@JsonKey(name: 'ReturnNumber', includeIfNull: false) int? returnNumber,
      @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
      String? merchandiseReturnStatus,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'ProductsCount', includeIfNull: false) int? productsCount,
      @JsonKey(name: 'ReturnTotal', includeIfNull: false) String? returnTotal,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _MerchandiseReturnModel;

  factory MerchandiseReturnModel.fromJson(Map<String, dynamic> json) =>
      _$MerchandiseReturnModelFromJson(json);
}
