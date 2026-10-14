import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../catalog/product_overview_model/product_overview_model.dart';

import '../../catalog/category_model/category_model.dart';

import '../../catalog/brand_model/brand_model.dart';

import '../../pages/page_model/page_model.dart';

import '../../blogs/blog_post_model/blog_post_model.dart';

import '../../knowledgebase/knowledgebase_item_model/knowledgebase_item_model.dart';

import '../../../common/user_field/user_field.dart';

part 'sitemap_model.freezed.dart';
part 'sitemap_model.g.dart';

@freezed
class SitemapModel extends StoreJsonSerializable<SitemapModel>
    with _$SitemapModel {
  factory SitemapModel(
      {@JsonKey(name: 'Products', includeIfNull: false)
      @Default([])
      List<ProductOverviewModel>? products,
      @JsonKey(name: 'Categories', includeIfNull: false)
      @Default([])
      List<CategoryModel>? categories,
      @JsonKey(name: 'Brands', includeIfNull: false)
      @Default([])
      List<BrandModel>? brands,
      @JsonKey(name: 'Pages', includeIfNull: false)
      @Default([])
      List<PageModel>? pages,
      @JsonKey(name: 'BlogPosts', includeIfNull: false)
      @Default([])
      List<BlogPostModel>? blogPosts,
      @JsonKey(name: 'KnowledgebaseArticles', includeIfNull: false)
      @Default([])
      List<KnowledgebaseItemModel>? knowledgebaseArticles,
      @JsonKey(name: 'NewsEnabled', includeIfNull: false)
      @Default(false)
      bool? newsEnabled,
      @JsonKey(name: 'BlogEnabled', includeIfNull: false)
      @Default(false)
      bool? blogEnabled,
      @JsonKey(name: 'KnowledgebaseEnabled', includeIfNull: false)
      @Default(false)
      bool? knowledgebaseEnabled,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _SitemapModel;

  factory SitemapModel.fromJson(Map<String, dynamic> json) =>
      _$SitemapModelFromJson(json);
}
