import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'custom_attribute.freezed.dart';
part 'custom_attribute.g.dart';

@freezed
class CustomAttribute extends StoreJsonSerializable<CustomAttribute>
    with _$CustomAttribute {
  factory CustomAttribute(
          {@JsonKey(name: 'Key', includeIfNull: false) String? key,
          @JsonKey(name: 'Value', includeIfNull: false) String? value}) =
      _CustomAttribute;

  factory CustomAttribute.fromJson(Map<String, dynamic> json) =>
      _$CustomAttributeFromJson(json);
}
