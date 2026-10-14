// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newsletter_simple_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsletterSimpleCategoryImpl _$$NewsletterSimpleCategoryImplFromJson(
  Map<String, dynamic> json,
) => _$NewsletterSimpleCategoryImpl(
  id: json['Id'] as String?,
  name: json['Name'] as String?,
  description: json['Description'] as String?,
  selected: json['Selected'] as bool? ?? false,
);

Map<String, dynamic> _$$NewsletterSimpleCategoryImplToJson(
  _$NewsletterSimpleCategoryImpl instance,
) => <String, dynamic>{
  if (instance.id case final value?) 'Id': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.description case final value?) 'Description': value,
  if (instance.selected case final value?) 'Selected': value,
};
