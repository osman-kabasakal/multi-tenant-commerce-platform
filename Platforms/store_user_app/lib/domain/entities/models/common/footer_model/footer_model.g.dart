// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'footer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FooterModelImpl _$$FooterModelImplFromJson(Map<String, dynamic> json) =>
    _$FooterModelImpl(
      storeName: json['StoreName'] as String?,
      companyName: json['CompanyName'] as String?,
      companyEmail: json['CompanyEmail'] as String?,
      companyHours: json['CompanyHours'] as String?,
      companyAddress: json['CompanyAddress'] as String?,
      companyPhone: json['CompanyPhone'] as String?,
      facebookLink: json['FacebookLink'] as String?,
      twitterLink: json['TwitterLink'] as String?,
      youtubeLink: json['YoutubeLink'] as String?,
      instagramLink: json['InstagramLink'] as String?,
      linkedInLink: json['LinkedInLink'] as String?,
      pinterestLink: json['PinterestLink'] as String?,
      privacyPreference: json['PrivacyPreference'] as bool? ?? false,
      wishlistEnabled: json['WishlistEnabled'] as bool? ?? false,
      shoppingCartEnabled: json['ShoppingCartEnabled'] as bool? ?? false,
      sitemapEnabled: json['SitemapEnabled'] as bool? ?? false,
      blogEnabled: json['BlogEnabled'] as bool? ?? false,
      newsEnabled: json['NewsEnabled'] as bool? ?? false,
      recentlyViewedProductsEnabled:
          json['RecentlyViewedProductsEnabled'] as bool? ?? false,
      recommendedProductsEnabled:
          json['RecommendedProductsEnabled'] as bool? ?? false,
      newProductsEnabled: json['NewProductsEnabled'] as bool? ?? false,
      allowCustomersToApplyForVendorAccount:
          json['AllowCustomersToApplyForVendorAccount'] as bool? ?? false,
      inclTax: json['InclTax'] as bool? ?? false,
      knowledgebaseEnabled: json['KnowledgebaseEnabled'] as bool? ?? false,
      workingLanguageId: json['WorkingLanguageId'] as String?,
      pages:
          (json['Pages'] as List<dynamic>?)
              ?.map((e) => FooterPageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FooterModelImplToJson(
  _$FooterModelImpl instance,
) => <String, dynamic>{
  if (instance.storeName case final value?) 'StoreName': value,
  if (instance.companyName case final value?) 'CompanyName': value,
  if (instance.companyEmail case final value?) 'CompanyEmail': value,
  if (instance.companyHours case final value?) 'CompanyHours': value,
  if (instance.companyAddress case final value?) 'CompanyAddress': value,
  if (instance.companyPhone case final value?) 'CompanyPhone': value,
  if (instance.facebookLink case final value?) 'FacebookLink': value,
  if (instance.twitterLink case final value?) 'TwitterLink': value,
  if (instance.youtubeLink case final value?) 'YoutubeLink': value,
  if (instance.instagramLink case final value?) 'InstagramLink': value,
  if (instance.linkedInLink case final value?) 'LinkedInLink': value,
  if (instance.pinterestLink case final value?) 'PinterestLink': value,
  if (instance.privacyPreference case final value?) 'PrivacyPreference': value,
  if (instance.wishlistEnabled case final value?) 'WishlistEnabled': value,
  if (instance.shoppingCartEnabled case final value?)
    'ShoppingCartEnabled': value,
  if (instance.sitemapEnabled case final value?) 'SitemapEnabled': value,
  if (instance.blogEnabled case final value?) 'BlogEnabled': value,
  if (instance.newsEnabled case final value?) 'NewsEnabled': value,
  if (instance.recentlyViewedProductsEnabled case final value?)
    'RecentlyViewedProductsEnabled': value,
  if (instance.recommendedProductsEnabled case final value?)
    'RecommendedProductsEnabled': value,
  if (instance.newProductsEnabled case final value?)
    'NewProductsEnabled': value,
  if (instance.allowCustomersToApplyForVendorAccount case final value?)
    'AllowCustomersToApplyForVendorAccount': value,
  if (instance.inclTax case final value?) 'InclTax': value,
  if (instance.knowledgebaseEnabled case final value?)
    'KnowledgebaseEnabled': value,
  if (instance.workingLanguageId case final value?) 'WorkingLanguageId': value,
  if (instance.pages case final value?) 'Pages': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
