import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'update_section_json_model.freezed.dart';
part 'update_section_json_model.g.dart';

@freezed
class UpdateSectionJsonModel
    extends StoreJsonSerializable<UpdateSectionJsonModel>
    with _$UpdateSectionJsonModel {
  factory UpdateSectionJsonModel(
      {@JsonKey(name: 'name', includeIfNull: false) String? name,
      @JsonKey(name: 'model', includeIfNull: false)
      Map<String, dynamic>? model}) = _UpdateSectionJsonModel;

  factory UpdateSectionJsonModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateSectionJsonModelFromJson(json);
}
