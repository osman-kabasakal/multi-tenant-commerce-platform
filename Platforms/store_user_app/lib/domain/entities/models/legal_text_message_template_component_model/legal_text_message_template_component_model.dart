import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../common/user_field/user_field.dart';


part 'legal_text_message_template_component_model.freezed.dart';
part 'legal_text_message_template_component_model.g.dart';

@freezed
class LegalTextMessageTemplateComponentModel extends StoreJsonSerializable<LegalTextMessageTemplateComponentModel> with _$LegalTextMessageTemplateComponentModel {
  factory LegalTextMessageTemplateComponentModel({ 
    @JsonKey(name: 'Name', includeIfNull: false)
     String? name,

    @JsonKey(name: 'TemplateText', includeIfNull: false)
     String? templateText,

    @JsonKey(name: 'Order', includeIfNull: false)
     int? order,

    @JsonKey(name: 'Category', includeIfNull: false)
     String? category,

    @JsonKey(name: 'IsRequired', includeIfNull: false)
    @Default(false) bool? isRequired,

    @JsonKey(name: 'IsActive', includeIfNull: false)
    @Default(false) bool? isActive,

    @JsonKey(name: 'UserFields', includeIfNull: false)
    @Default([]) List<UserField>? userFields
}) = _LegalTextMessageTemplateComponentModel;

  factory LegalTextMessageTemplateComponentModel.fromJson(Map<String, dynamic> json) =>
      _$LegalTextMessageTemplateComponentModelFromJson(json);
}