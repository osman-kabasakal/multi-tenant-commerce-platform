import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../catalog/attribute_control_type/attribute_control_type.dart';

import '../customer_attribute_value_model/customer_attribute_value_model.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_attribute_model.freezed.dart';
part 'customer_attribute_model.g.dart';

@freezed
class CustomerAttributeModel
    extends StoreJsonSerializable<CustomerAttributeModel>
    with _$CustomerAttributeModel {
  factory CustomerAttributeModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'IsRequired', includeIfNull: false)
      @Default(false)
      bool? isRequired,
      @JsonKey(name: 'IsReadOnly', includeIfNull: false)
      @Default(false)
      bool? isReadOnly,
      @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
      @JsonKey(name: 'AttributeControlType', includeIfNull: false)
      @Default(AttributeControlType.dropdownList)
      AttributeControlType? attributeControlType,
      @JsonKey(name: 'Values', includeIfNull: false)
      @Default([])
      List<CustomerAttributeValueModel>? values,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerAttributeModel;

  factory CustomerAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerAttributeModelFromJson(json);
}
