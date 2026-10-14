import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'merchandise_return_action_model.freezed.dart';
part 'merchandise_return_action_model.g.dart';

@freezed
class MerchandiseReturnActionModel
    extends StoreJsonSerializable<MerchandiseReturnActionModel>
    with _$MerchandiseReturnActionModel {
  factory MerchandiseReturnActionModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _MerchandiseReturnActionModel;

  factory MerchandiseReturnActionModel.fromJson(Map<String, dynamic> json) =>
      _$MerchandiseReturnActionModelFromJson(json);
}
