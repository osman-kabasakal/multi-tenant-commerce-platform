import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'sub_account_simple_model.freezed.dart';
part 'sub_account_simple_model.g.dart';

@freezed
class SubAccountSimpleModel extends StoreJsonSerializable<SubAccountSimpleModel>
    with _$SubAccountSimpleModel {
  factory SubAccountSimpleModel(
      {@JsonKey(name: 'Email', includeIfNull: false) String? email,
      @JsonKey(name: 'FirstName', includeIfNull: false) String? firstName,
      @JsonKey(name: 'LastName', includeIfNull: false) String? lastName,
      @JsonKey(name: 'Active', includeIfNull: false)
      @Default(false)
      bool? active,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _SubAccountSimpleModel;

  factory SubAccountSimpleModel.fromJson(Map<String, dynamic> json) =>
      _$SubAccountSimpleModelFromJson(json);
}
