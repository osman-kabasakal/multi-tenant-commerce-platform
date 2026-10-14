import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'footer_page_model/footer_page_model.dart';

import '../../../common/user_field/user_field.dart';

part 'footer_model.freezed.dart';
part 'footer_model.g.dart';

@freezed
class FooterModel extends StoreJsonSerializable<FooterModel>
    with _$FooterModel {
  factory FooterModel(
      {@JsonKey(name: 'StoreName', includeIfNull: false) String? storeName,
      @JsonKey(name: 'CompanyName', includeIfNull: false) String? companyName,
      @JsonKey(name: 'CompanyEmail', includeIfNull: false) String? companyEmail,
      @JsonKey(name: 'CompanyHours', includeIfNull: false) String? companyHours,
      @JsonKey(name: 'CompanyAddress', includeIfNull: false)
      String? companyAddress,
      @JsonKey(name: 'CompanyPhone', includeIfNull: false) String? companyPhone,
      @JsonKey(name: 'FacebookLink', includeIfNull: false) String? facebookLink,
      @JsonKey(name: 'TwitterLink', includeIfNull: false) String? twitterLink,
      @JsonKey(name: 'YoutubeLink', includeIfNull: false) String? youtubeLink,
      @JsonKey(name: 'InstagramLink', includeIfNull: false)
      String? instagramLink,
      @JsonKey(name: 'LinkedInLink', includeIfNull: false) String? linkedInLink,
      @JsonKey(name: 'PinterestLink', includeIfNull: false)
      String? pinterestLink,
      @JsonKey(name: 'PrivacyPreference', includeIfNull: false)
      @Default(false)
      bool? privacyPreference,
      @JsonKey(name: 'WishlistEnabled', includeIfNull: false)
      @Default(false)
      bool? wishlistEnabled,
      @JsonKey(name: 'ShoppingCartEnabled', includeIfNull: false)
      @Default(false)
      bool? shoppingCartEnabled,
      @JsonKey(name: 'SitemapEnabled', includeIfNull: false)
      @Default(false)
      bool? sitemapEnabled,
      @JsonKey(name: 'BlogEnabled', includeIfNull: false)
      @Default(false)
      bool? blogEnabled,
      @JsonKey(name: 'NewsEnabled', includeIfNull: false)
      @Default(false)
      bool? newsEnabled,
      @JsonKey(name: 'RecentlyViewedProductsEnabled', includeIfNull: false)
      @Default(false)
      bool? recentlyViewedProductsEnabled,
      @JsonKey(name: 'RecommendedProductsEnabled', includeIfNull: false)
      @Default(false)
      bool? recommendedProductsEnabled,
      @JsonKey(name: 'NewProductsEnabled', includeIfNull: false)
      @Default(false)
      bool? newProductsEnabled,
      @JsonKey(
          name: 'AllowCustomersToApplyForVendorAccount', includeIfNull: false)
      @Default(false)
      bool? allowCustomersToApplyForVendorAccount,
      @JsonKey(name: 'InclTax', includeIfNull: false)
      @Default(false)
      bool? inclTax,
      @JsonKey(name: 'KnowledgebaseEnabled', includeIfNull: false)
      @Default(false)
      bool? knowledgebaseEnabled,
      @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
      String? workingLanguageId,
      @JsonKey(name: 'Pages', includeIfNull: false)
      @Default([])
      List<FooterPageModel>? pages,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _FooterModel;

  factory FooterModel.fromJson(Map<String, dynamic> json) =>
      _$FooterModelFromJson(json);
}
