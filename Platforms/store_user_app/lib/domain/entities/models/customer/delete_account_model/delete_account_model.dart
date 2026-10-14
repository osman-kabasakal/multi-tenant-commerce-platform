import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'delete_account_model.freezed.dart';
part 'delete_account_model.g.dart';

@freezed
class DeleteAccountModel extends StoreJsonSerializable<DeleteAccountModel>
    with _$DeleteAccountModel {
  factory DeleteAccountModel(
      {@JsonKey(name: 'Password', includeIfNull: false) String? password,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _DeleteAccountModel;

  factory DeleteAccountModel.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountModelFromJson(json);
}
