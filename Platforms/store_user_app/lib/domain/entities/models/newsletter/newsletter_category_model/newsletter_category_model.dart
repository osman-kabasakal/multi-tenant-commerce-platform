import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../newsletter_simple_category/newsletter_simple_category.dart';

import '../../../common/user_field/user_field.dart';

part 'newsletter_category_model.freezed.dart';
part 'newsletter_category_model.g.dart';

@freezed
class NewsletterCategoryModel
    extends StoreJsonSerializable<NewsletterCategoryModel>
    with _$NewsletterCategoryModel {
  factory NewsletterCategoryModel(
      {@JsonKey(name: 'NewsletterEmailId', includeIfNull: false)
      String? newsletterEmailId,
      @JsonKey(name: 'Category', includeIfNull: false)
      @Default([])
      List<String>? category,
      @JsonKey(name: 'NewsletterCategories', includeIfNull: false)
      @Default([])
      List<NewsletterSimpleCategory>? newsletterCategories,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _NewsletterCategoryModel;

  factory NewsletterCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$NewsletterCategoryModelFromJson(json);
}
