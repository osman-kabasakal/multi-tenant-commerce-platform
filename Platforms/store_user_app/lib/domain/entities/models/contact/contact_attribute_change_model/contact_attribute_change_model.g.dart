// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_attribute_change_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContactAttributeChangeModelImpl _$$ContactAttributeChangeModelImplFromJson(
  Map<String, dynamic> json,
) => _$ContactAttributeChangeModelImpl(
  attributes:
      (json['Attributes'] as List<dynamic>?)
          ?.map((e) => CustomAttributeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ContactAttributeChangeModelImplToJson(
  _$ContactAttributeChangeModelImpl instance,
) => <String, dynamic>{
  if (instance.attributes case final value?) 'Attributes': value,
};
