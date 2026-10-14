import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../catalog/attribute_control_type/attribute_control_type.dart';

import '../product_attribute_value_model/product_attribute_value_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'product_attribute_model.freezed.dart';
part 'product_attribute_model.g.dart';

@freezed
class ProductAttributeModel extends StoreJsonSerializable<ProductAttributeModel>
    with _$ProductAttributeModel {
  factory ProductAttributeModel(
      {@JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductAttributeId', includeIfNull: false)
      String? productAttributeId,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'TextPrompt', includeIfNull: false) String? textPrompt,
      @JsonKey(name: 'IsRequired', includeIfNull: false)
      @Default(false)
      bool? isRequired,
      @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
      @JsonKey(name: 'SelectedDay', includeIfNull: false)
      @Default(null)
      int? selectedDay,
      @JsonKey(name: 'SelectedMonth', includeIfNull: false)
      @Default(null)
      int? selectedMonth,
      @JsonKey(name: 'SelectedYear', includeIfNull: false)
      @Default(null)
      int? selectedYear,
      @JsonKey(name: 'HasCondition', includeIfNull: false)
      @Default(false)
      bool? hasCondition,
      @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
      @Default([])
      List<String>? allowedFileExtensions,
      @JsonKey(name: 'AttributeControlType', includeIfNull: false)
      @Default(AttributeControlType.dropdownList)
      AttributeControlType? attributeControlType,
      @JsonKey(name: 'Values', includeIfNull: false)
      @Default([])
      List<ProductAttributeValueModel>? values,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductAttributeModel;

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAttributeModelFromJson(json);
}
