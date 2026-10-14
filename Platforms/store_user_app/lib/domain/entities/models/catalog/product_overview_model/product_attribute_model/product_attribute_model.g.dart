// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductAttributeModelImpl _$$ProductAttributeModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductAttributeModelImpl(
  name: json['Name'] as String?,
  seName: json['SeName'] as String?,
  textPrompt: json['TextPrompt'] as String?,
  isRequired: json['IsRequired'] as bool? ?? false,
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
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductAttributeModelImplToJson(
  _$ProductAttributeModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.textPrompt case final value?) 'TextPrompt': value,
  if (instance.isRequired case final value?) 'IsRequired': value,
  if (_$AttributeControlTypeEnumMap[instance.attributeControlType]
      case final value?)
    'AttributeControlType': value,
  if (instance.values case final value?) 'Values': value,
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
