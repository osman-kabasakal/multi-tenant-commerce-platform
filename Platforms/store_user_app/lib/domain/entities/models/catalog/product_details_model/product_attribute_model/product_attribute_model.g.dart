// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductAttributeModelImpl _$$ProductAttributeModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductAttributeModelImpl(
  productId: json['ProductId'] as String?,
  productAttributeId: json['ProductAttributeId'] as String?,
  name: json['Name'] as String?,
  description: json['Description'] as String?,
  textPrompt: json['TextPrompt'] as String?,
  isRequired: json['IsRequired'] as bool? ?? false,
  defaultValue: json['DefaultValue'] as String?,
  selectedDay: (json['SelectedDay'] as num?)?.toInt() ?? null,
  selectedMonth: (json['SelectedMonth'] as num?)?.toInt() ?? null,
  selectedYear: (json['SelectedYear'] as num?)?.toInt() ?? null,
  hasCondition: json['HasCondition'] as bool? ?? false,
  allowedFileExtensions:
      (json['AllowedFileExtensions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  attributeControlType:
      $enumDecodeNullable(
        _$AttributeControlTypeEnumMap,
        json['AttributeControlType'],
      ) ??
      AttributeControlType.dropdownList,
  values:
      (json['Values'] as List<dynamic>?)
          ?.map(
            (e) =>
                ProductAttributeValueModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductAttributeModelImplToJson(
  _$ProductAttributeModelImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productAttributeId case final value?)
    'ProductAttributeId': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.textPrompt case final value?) 'TextPrompt': value,
  if (instance.isRequired case final value?) 'IsRequired': value,
  if (instance.defaultValue case final value?) 'DefaultValue': value,
  if (instance.selectedDay case final value?) 'SelectedDay': value,
  if (instance.selectedMonth case final value?) 'SelectedMonth': value,
  if (instance.selectedYear case final value?) 'SelectedYear': value,
  if (instance.hasCondition case final value?) 'HasCondition': value,
  if (instance.allowedFileExtensions case final value?)
    'AllowedFileExtensions': value,
  if (_$AttributeControlTypeEnumMap[instance.attributeControlType]
      case final value?)
    'AttributeControlType': value,
  if (instance.values case final value?) 'Values': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};

const _$AttributeControlTypeEnumMap = {
  AttributeControlType.dropdownList: 1,
  AttributeControlType.radioList: 2,
  AttributeControlType.checkboxes: 3,
  AttributeControlType.textBox: 4,
  AttributeControlType.hidden: 5,
  AttributeControlType.multilineTextbox: 10,
  AttributeControlType.datepicker: 20,
  AttributeControlType.fileUpload: 30,
  AttributeControlType.colorSquares: 40,
  AttributeControlType.imageSquares: 45,
  AttributeControlType.readonlyCheckboxes: 50,
};
