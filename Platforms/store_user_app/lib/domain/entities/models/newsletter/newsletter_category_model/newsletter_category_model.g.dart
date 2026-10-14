// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newsletter_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsletterCategoryModelImpl _$$NewsletterCategoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$NewsletterCategoryModelImpl(
  newsletterEmailId: json['NewsletterEmailId'] as String?,
  category:
      (json['Category'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  newsletterCategories:
      (json['NewsletterCategories'] as List<dynamic>?)
          ?.map(
            (e) => NewsletterSimpleCategory.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$NewsletterCategoryModelImplToJson(
  _$NewsletterCategoryModelImpl instance,
) => <String, dynamic>{
  if (instance.newsletterEmailId case final value?) 'NewsletterEmailId': value,
  if (instance.category case final value?) 'Category': value,
  if (instance.newsletterCategories case final value?)
    'NewsletterCategories': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
