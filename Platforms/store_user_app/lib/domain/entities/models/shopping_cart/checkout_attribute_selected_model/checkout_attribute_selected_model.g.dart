// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_attribute_selected_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutAttributeSelectedModelImpl
_$$CheckoutAttributeSelectedModelImplFromJson(Map<String, dynamic> json) =>
    _$CheckoutAttributeSelectedModelImpl(
      attributes:
          (json['Attributes'] as List<dynamic>?)
              ?.map(
                (e) => CustomAttributeModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CheckoutAttributeSelectedModelImplToJson(
  _$CheckoutAttributeSelectedModelImpl instance,
) => <String, dynamic>{
  if (instance.attributes case final value?) 'Attributes': value,
};
