// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'footer_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FooterPageModelImpl _$$FooterPageModelImplFromJson(
  Map<String, dynamic> json,
) => _$FooterPageModelImpl(
  name: json['Name'] as String?,
  seName: json['SeName'] as String?,
  includeInFooterRow1: json['IncludeInFooterRow1'] as bool? ?? false,
  includeInFooterRow2: json['IncludeInFooterRow2'] as bool? ?? false,
  includeInFooterRow3: json['IncludeInFooterRow3'] as bool? ?? false,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$FooterPageModelImplToJson(
  _$FooterPageModelImpl instance,
) => <String, dynamic>{
  if (instance.name case final value?) 'Name': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.includeInFooterRow1 case final value?)
    'IncludeInFooterRow1': value,
  if (instance.includeInFooterRow2 case final value?)
    'IncludeInFooterRow2': value,
  if (instance.includeInFooterRow3 case final value?)
    'IncludeInFooterRow3': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
