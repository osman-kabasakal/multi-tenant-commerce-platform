import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'authenticate_model.freezed.dart';
part 'authenticate_model.g.dart';

@freezed
class AuthenticateModel extends StoreJsonSerializable<AuthenticateModel>
    with _$AuthenticateModel {
  factory AuthenticateModel(
          {@JsonKey(name: 'Id', includeIfNull: false) String? id,
          @JsonKey(name: 'Password', includeIfNull: false) String? password}) =
      _AuthenticateModel;

  factory AuthenticateModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateModelFromJson(json);
}
