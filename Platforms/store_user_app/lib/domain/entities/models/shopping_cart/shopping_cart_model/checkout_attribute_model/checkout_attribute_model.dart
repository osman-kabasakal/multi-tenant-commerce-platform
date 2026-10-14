import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../catalog/attribute_control_type/attribute_control_type.dart';

import '../checkout_attribute_value_model/checkout_attribute_value_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'checkout_attribute_model.freezed.dart';
part 'checkout_attribute_model.g.dart';

@freezed
class CheckoutAttributeModel
    extends StoreJsonSerializable<CheckoutAttributeModel>
    with _$CheckoutAttributeModel {
  factory CheckoutAttributeModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
      @JsonKey(name: 'TextPrompt', includeIfNull: false) String? textPrompt,
      @JsonKey(name: 'IsRequired', includeIfNull: false)
      @Default(false)
      bool? isRequired,
      @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
      @Default([])
      List<String>? allowedFileExtensions,
      @JsonKey(name: 'AttributeControlType', includeIfNull: false)
      @Default(AttributeControlType.dropdownList)
      AttributeControlType? attributeControlType,
      @JsonKey(name: 'Values', includeIfNull: false)
      @Default([])
      List<CheckoutAttributeValueModel>? values,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CheckoutAttributeModel;

  factory CheckoutAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutAttributeModelFromJson(json);
}
