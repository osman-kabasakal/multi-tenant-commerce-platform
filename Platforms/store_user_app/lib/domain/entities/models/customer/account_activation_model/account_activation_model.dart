import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'account_activation_model.freezed.dart';
part 'account_activation_model.g.dart';

@freezed
class AccountActivationModel
    extends StoreJsonSerializable<AccountActivationModel>
    with _$AccountActivationModel {
  factory AccountActivationModel(
      {@JsonKey(name: 'Result', includeIfNull: false) String? result,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _AccountActivationModel;

  factory AccountActivationModel.fromJson(Map<String, dynamic> json) =>
      _$AccountActivationModelFromJson(json);
}
