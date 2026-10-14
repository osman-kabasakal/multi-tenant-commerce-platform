// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressAttributeModelImpl _$$AddressAttributeModelImplFromJson(
  Map<String, dynamic> json,
) => _$AddressAttributeModelImpl(
  name: json['Name'] as String?,
  isRequired: json['IsRequired'] as bool? ?? false,
  defaultValue: json['DefaultValue'] as String?,
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
                AddressAttributeValueModel.fromJson(e as Map<String, dynamic>),
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

Map<String, dynamic> _$$AddressAttributeModelImplToJson(
  _$AddressAttributeModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.isRequired case final value?) 'IsRequired': value,
  if (instance.defaultValue case final value?) 'DefaultValue': value,
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
