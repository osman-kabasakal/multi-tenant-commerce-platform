// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitemap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SitemapModelImpl _$$SitemapModelImplFromJson(
  Map<String, dynamic> json,
) => _$SitemapModelImpl(
  products:
      (json['Products'] as List<dynamic>?)
          ?.map((e) => ProductOverviewModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  categories:
      (json['Categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  brands:
      (json['Brands'] as List<dynamic>?)
          ?.map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pages:
      (json['Pages'] as List<dynamic>?)
          ?.map((e) => PageModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  blogPosts:
      (json['BlogPosts'] as List<dynamic>?)
          ?.map((e) => BlogPostModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  knowledgebaseArticles:
      (json['KnowledgebaseArticles'] as List<dynamic>?)
          ?.map(
            (e) => KnowledgebaseItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  newsEnabled: json['NewsEnabled'] as bool? ?? false,
  blogEnabled: json['BlogEnabled'] as bool? ?? false,
  knowledgebaseEnabled: json['KnowledgebaseEnabled'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$SitemapModelImplToJson(_$SitemapModelImpl instance) =>
    <String, dynamic>{
      if (instance.products case final value?) 'Products': value,
      if (instance.categories case final value?) 'Categories': value,
      if (instance.brands case final value?) 'Brands': value,
      if (instance.pages case final value?) 'Pages': value,
      if (instance.blogPosts case final value?) 'BlogPosts': value,
      if (instance.knowledgebaseArticles case final value?)
        'KnowledgebaseArticles': value,
      if (instance.newsEnabled case final value?) 'NewsEnabled': value,
      if (instance.blogEnabled case final value?) 'BlogEnabled': value,
      if (instance.knowledgebaseEnabled case final value?)
        'KnowledgebaseEnabled': value,
      if (instance.userFields case final value?) 'UserFields': value,
    };
