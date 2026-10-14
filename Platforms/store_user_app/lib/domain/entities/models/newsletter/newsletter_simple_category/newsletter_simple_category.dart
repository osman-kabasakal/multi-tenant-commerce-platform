import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'newsletter_simple_category.freezed.dart';
part 'newsletter_simple_category.g.dart';

@freezed
class NewsletterSimpleCategory
    extends StoreJsonSerializable<NewsletterSimpleCategory>
    with _$NewsletterSimpleCategory {
  factory NewsletterSimpleCategory(
      {@JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'Selected', includeIfNull: false)
      @Default(false)
      bool? selected}) = _NewsletterSimpleCategory;

  factory NewsletterSimpleCategory.fromJson(Map<String, dynamic> json) =>
      _$NewsletterSimpleCategoryFromJson(json);
}
