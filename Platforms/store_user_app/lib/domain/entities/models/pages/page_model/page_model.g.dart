// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PageModelImpl _$$PageModelImplFromJson(Map<String, dynamic> json) =>
    _$PageModelImpl(
      systemName: json['SystemName'] as String?,
      includeInSitemap: json['IncludeInSitemap'] as bool? ?? false,
      isPasswordProtected: json['IsPasswordProtected'] as bool? ?? false,
      password: json['Password'] as String?,
      title: json['Title'] as String?,
      body: json['Body'] as String?,
      metaKeywords: json['MetaKeywords'] as String?,
      metaDescription: json['MetaDescription'] as String?,
      metaTitle: json['MetaTitle'] as String?,
      seName: json['SeName'] as String?,
      pageLayoutId: json['PageLayoutId'] as String?,
      published: json['Published'] as bool? ?? false,
      startDate:
          json['StartDate'] == null
              ? null
              : DateTime.parse(json['StartDate'] as String),
      endDate:
          json['EndDate'] == null
              ? null
              : DateTime.parse(json['EndDate'] as String),
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PageModelImplToJson(
  _$PageModelImpl instance,
) => <String, dynamic>{
  if (instance.systemName case final value?) 'SystemName': value,
  if (instance.includeInSitemap case final value?) 'IncludeInSitemap': value,
  if (instance.isPasswordProtected case final value?)
    'IsPasswordProtected': value,
  if (instance.password case final value?) 'Password': value,
  if (instance.title case final value?) 'Title': value,
  if (instance.body case final value?) 'Body': value,
  if (instance.metaKeywords case final value?) 'MetaKeywords': value,
  if (instance.metaDescription case final value?) 'MetaDescription': value,
  if (instance.metaTitle case final value?) 'MetaTitle': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.pageLayoutId case final value?) 'PageLayoutId': value,
  if (instance.published case final value?) 'Published': value,
  if (instance.startDate?.toIso8601String() case final value?)
    'StartDate': value,
  if (instance.endDate?.toIso8601String() case final value?) 'EndDate': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
