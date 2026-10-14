import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../catalog/attribute_control_type/attribute_control_type.dart';

import '../address_attribute_value_model/address_attribute_value_model.dart';

import '../../../common/user_field/user_field.dart';

part 'address_attribute_model.freezed.dart';
part 'address_attribute_model.g.dart';

@freezed
class AddressAttributeModel extends StoreJsonSerializable<AddressAttributeModel>
    with _$AddressAttributeModel {
  factory AddressAttributeModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'IsRequired', includeIfNull: false)
      @Default(false)
      bool? isRequired,
      @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
      @JsonKey(name: 'AttributeControlType', includeIfNull: false)
      @Default(AttributeControlType.dropdownList)
      AttributeControlType? attributeControlType,
      @JsonKey(name: 'Values', includeIfNull: false)
      @Default([])
      List<AddressAttributeValueModel>? values,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _AddressAttributeModel;

  factory AddressAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$AddressAttributeModelFromJson(json);
}
