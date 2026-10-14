import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';


part 'field_definition.freezed.dart';
part 'field_definition.g.dart';

@freezed
class FieldDefinition extends StoreJsonSerializable<FieldDefinition> with _$FieldDefinition {
  factory FieldDefinition({ 
    @JsonKey(name: 'Type', includeIfNull: false)
     String? type,

    @JsonKey(name: 'Label', includeIfNull: false)
     String? label,

    @JsonKey(name: 'Value', includeIfNull: false)
     Object? value,

    @JsonKey(name: 'Required', includeIfNull: false)
    @Default(false) bool? required,

    @JsonKey(name: 'Validations', includeIfNull: false)
    @Default({}) Map<String, Object>? validations,

    @JsonKey(name: 'ValidationMessages', includeIfNull: false)
    @Default({}) Map<String, String>? validationMessages
}) = _FieldDefinition;

  factory FieldDefinition.fromJson(Map<String, dynamic> json) =>
      _$FieldDefinitionFromJson(json);
}