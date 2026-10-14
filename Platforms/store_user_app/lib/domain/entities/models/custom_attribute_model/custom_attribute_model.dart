import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'custom_attribute_model.freezed.dart';
part 'custom_attribute_model.g.dart';

@freezed
class CustomAttributeModel extends StoreJsonSerializable<CustomAttributeModel>
    with _$CustomAttributeModel {
  factory CustomAttributeModel(
          {@JsonKey(name: 'Key', includeIfNull: false) String? key,
          @JsonKey(name: 'Value', includeIfNull: false) String? value}) =
      _CustomAttributeModel;

  factory CustomAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$CustomAttributeModelFromJson(json);
}
