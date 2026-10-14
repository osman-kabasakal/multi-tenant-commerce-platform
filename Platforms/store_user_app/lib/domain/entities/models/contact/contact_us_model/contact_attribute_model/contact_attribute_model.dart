import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../catalog/attribute_control_type/attribute_control_type.dart';

import '../contact_attribute_value_model/contact_attribute_value_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'contact_attribute_model.freezed.dart';
part 'contact_attribute_model.g.dart';

@freezed
class ContactAttributeModel extends StoreJsonSerializable<ContactAttributeModel>
    with _$ContactAttributeModel {
  factory ContactAttributeModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
      @JsonKey(name: 'TextPrompt', includeIfNull: false) String? textPrompt,
      @JsonKey(name: 'IsRequired', includeIfNull: false)
      @Default(false)
      bool? isRequired,
      @JsonKey(name: 'SelectedDay', includeIfNull: false)
      @Default(null)
      int? selectedDay,
      @JsonKey(name: 'SelectedMonth', includeIfNull: false)
      @Default(null)
      int? selectedMonth,
      @JsonKey(name: 'SelectedYear', includeIfNull: false)
      @Default(null)
      int? selectedYear,
      @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
      @Default([])
      List<String>? allowedFileExtensions,
      @JsonKey(name: 'AttributeControlType', includeIfNull: false)
      @Default(AttributeControlType.dropdownList)
      AttributeControlType? attributeControlType,
      @JsonKey(name: 'Values', includeIfNull: false)
      @Default([])
      List<ContactAttributeValueModel>? values,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ContactAttributeModel;

  factory ContactAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$ContactAttributeModelFromJson(json);
}
