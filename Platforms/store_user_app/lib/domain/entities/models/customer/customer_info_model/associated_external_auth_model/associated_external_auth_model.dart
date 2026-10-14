import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'associated_external_auth_model.freezed.dart';
part 'associated_external_auth_model.g.dart';

@freezed
class AssociatedExternalAuthModel
    extends StoreJsonSerializable<AssociatedExternalAuthModel>
    with _$AssociatedExternalAuthModel {
  factory AssociatedExternalAuthModel(
      {@JsonKey(name: 'Email', includeIfNull: false) String? email,
      @JsonKey(name: 'ExternalIdentifier', includeIfNull: false)
      String? externalIdentifier,
      @JsonKey(name: 'AuthMethodName', includeIfNull: false)
      String? authMethodName,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _AssociatedExternalAuthModel;

  factory AssociatedExternalAuthModel.fromJson(Map<String, dynamic> json) =>
      _$AssociatedExternalAuthModelFromJson(json);
}
