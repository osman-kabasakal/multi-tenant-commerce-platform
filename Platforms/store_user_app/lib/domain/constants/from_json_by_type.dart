import 'package:store_user_app/core/models/network/api_response.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';
import 'package:store_user_app/core/utils/json_converters/api_response_converter.dart';
import 'package:store_user_app/core/utils/json_converters/list_converter.dart';
import 'package:store_user_app/core/utils/json_converters/store_json_serializable_converter.dart';
import 'package:store_user_app/domain/entities/messages/queued_email/queued_email.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_confirm_model/checkout_confirm_model.dart';
import 'package:store_user_app/domain/entities/models/common/footer_model/footer_model.dart';
import 'package:store_user_app/domain/entities/models/common/state_province_model/state_province_model.dart';
import 'package:store_user_app/domain/entities/models/components/slider/public_info_model/public_info_model.dart';
import 'package:store_user_app/domain/entities/notification/notification_model.dart';

import '../../core/utils/json_converters/json_converter.dart';
import '../../presentation/screens/checkout/view_models/checkout_step_response.dart';
import '../entities/models/checkout/checkout_model/checkout_model.dart';
import '../entities/anonymous_type_83_eff621/anonymous_type_83_eff621.dart';
import '../entities/anonymous_type__f238_a175/anonymous_type__f238_a175.dart';
import '../entities/anonymous_type__da179_d76/anonymous_type__da179_d76.dart';
import '../entities/anonymous_type_55_b93_bb6/anonymous_type_55_b93_bb6.dart';
import '../entities/models/checkout/checkout_completed_model/checkout_completed_model.dart';
import '../entities/anonymous_type_2_fbe9_f46/anonymous_type_2_fbe9_f46.dart';
import '../entities/models/checkout/checkout_billing_address_model/checkout_billing_address_model.dart';
import '../entities/models/checkout/checkout_shipping_address_model/checkout_shipping_address_model.dart';
import '../entities/models/checkout/checkout_shipping_method_model/checkout_shipping_method_model.dart';
import '../entities/models/checkout/checkout_payment_method_model/checkout_payment_method_model.dart';
import '../entities/models/blogs/blog_post_list_model/blog_post_list_model.dart';
import '../entities/models/blogs/blog_post_model/blog_post_model.dart';
import '../entities/models/blogs/blog_paging_filtering_model/blog_paging_filtering_model.dart';
import '../entities/models/blogs/add_blog_comment_model/add_blog_comment_model.dart';
import '../entities/models/catalog/category_model/category_model.dart';
import '../entities/models/catalog/category_list_model/category_list_model.dart';
import '../entities/models/catalog/brand_model/brand_model.dart';
import '../entities/models/catalog/brand_list_model/brand_list_model.dart';
import '../entities/models/catalog/collection_model/collection_model.dart';
import '../entities/models/catalog/collection_list_model/collection_list_model.dart';
import '../entities/models/catalog/vendor_model/vendor_model.dart';
import '../entities/models/catalog/vendor_list_model/vendor_list_model.dart';
import '../entities/models/components/slider/public_info_model/slider/slider.dart';
import '../entities/models/customer/LoginModel/loginModel.dart';
import '../entities/models/customer/customer_navigation_model/customer_navigation_model.dart';
import '../entities/models/icaptcha_valid_model/icaptcha_valid_model.dart';
import '../entities/models/legal_text_message_template_component_model/legal_text_message_template_component_model.dart';
import '../entities/models/shopping_cart_info/cart_summary_dto/cart_summary_dto.dart';
import '../entities/models/shopping_cart_info/free_shipping_info_dto/free_shipping_info_dto.dart';
import '../entities/models/shopping_cart_info/minimum_order_info_dto/minimum_order_info_dto.dart';
import '../entities/models/shopping_cart_info/shopping_cart_info_response/shopping_cart_info_response.dart';
import '../entities/models/vendors/vendor_reviews_model/vendor_reviews_model.dart';
import '../entities/anonymous_type_1_ede6_d30/anonymous_type_1_ede6_d30.dart';
import '../entities/models/catalog/products_by_tag_model/products_by_tag_model.dart';
import '../entities/models/catalog/popular_product_tags_model/popular_product_tags_model.dart';
import '../entities/models/catalog/search_model/search_model.dart';
import '../entities/models/catalog/search_auto_complete_model/search_auto_complete_model.dart';
import '../entities/models/catalog/catalog_paging_filtering_model/catalog_paging_filtering_model.dart';
import '../entities/models/catalog/category_paging_model/category_paging_model.dart';
import '../entities/models/catalog/brand_paging_model/brand_paging_model.dart';
import '../entities/models/catalog/collection_paging_model/collection_paging_model.dart';
import '../entities/models/catalog/vendor_paging_model/vendor_paging_model.dart';
import '../entities/anonymous_type_2_f40_fb16/anonymous_type_2_f40_fb16.dart';
import '../entities/anonymous_type__d4_a20723/anonymous_type__d4_a20723.dart';
import '../entities/models/newsletter/newsletter_category_model/newsletter_category_model.dart';
import '../entities/models/customer/customer_auctions_model/customer_auctions_model.dart';
import '../entities/models/customer/customer_notes_model/customer_notes_model.dart';
import '../entities/models/customer/documents_model/documents_model.dart';
import '../entities/models/customer/customer_product_reviews_model/customer_product_reviews_model.dart';
import '../entities/models/customer/courses_model/courses_model.dart';
import '../entities/models/customer/password_recovery_model/password_recovery_model.dart';
import '../entities/models/customer/password_recovery_confirm_model/password_recovery_confirm_model.dart';
import '../entities/models/customer/register_model/register_model.dart';
import '../entities/anonymous_type__af73_d8_d8/anonymous_type__af73_d8_d8.dart';
import '../entities/models/customer/account_activation_model/account_activation_model.dart';
import '../entities/models/customer/customer_info_model/customer_info_model.dart';
import '../entities/anonymous_type__fa6_c6_c9_f/anonymous_type__fa6_c6_c9_f.dart';
import '../entities/models/customer/customer_address_list_model/customer_address_list_model.dart';
import '../entities/models/customer/customer_address_edit_model/customer_address_edit_model.dart';
import '../entities/models/customer/customer_downloadable_products_model/customer_downloadable_products_model.dart';
import '../entities/models/customer/change_password_model/change_password_model.dart';
import '../entities/models/customer/delete_account_model/delete_account_model.dart';
import '../entities/models/customer/sub_account_simple_model/sub_account_simple_model.dart';
import '../entities/models/customer/sub_account_create_model/sub_account_create_model.dart';
import '../entities/models/customer/sub_account_edit_model/sub_account_edit_model.dart';
import '../entities/anonymous_type_50_e263_dc/anonymous_type_50_e263_dc.dart';
import '../entities/models/customer/document_paging_model/document_paging_model.dart';
import '../entities/models/pages/page_model/page_model.dart';
import '../entities/anonymous_type_10783450/anonymous_type_10783450.dart';
import '../entities/models/pages/authenticate_model/authenticate_model.dart';
import '../entities/models/orders/customer_order_list_model/customer_order_list_model.dart';
import '../entities/models/orders/order_details_model/order_details_model.dart';
import '../entities/models/orders/add_order_note_model/add_order_note_model.dart';
import '../entities/models/orders/shipment_details_model/shipment_details_model.dart';
import '../entities/models/orders/customer_loyalty_points_model/customer_loyalty_points_model.dart';
import '../entities/models/orders/order_paging_model/order_paging_model.dart';
import '../entities/models/shopping_cart/mini_shopping_cart_model/mini_shopping_cart_model.dart';
import '../entities/anonymous_type__a25_e79_e1/anonymous_type__a25_e79_e1.dart';
import '../entities/anonymous_type_5_f706788/anonymous_type_5_f706788.dart';
import '../entities/models/shopping_cart/shopping_cart_model/shopping_cart_model.dart';
import '../entities/models/shopping_cart/order_totals_model/order_totals_model.dart';
import '../entities/anonymous_type_6_f488518/anonymous_type_6_f488518.dart';
import '../entities/anonymous_type_845_badbc/anonymous_type_845_badbc.dart';
import '../entities/anonymous_type__f96_d6_eb9/anonymous_type__f96_d6_eb9.dart';
import '../entities/anonymous_type__ef661507/anonymous_type__ef661507.dart';
import '../entities/models/shopping_cart/checkout_attribute_selected_model/checkout_attribute_selected_model.dart';
import '../entities/models/shopping_cart/update_quantity_model/update_quantity_model.dart';
import '../entities/models/shopping_cart/delete_cart_item_model/delete_cart_item_model.dart';
import '../entities/models/shopping_cart/change_type_cart_item_model/change_type_cart_item_model.dart';
import '../entities/models/shopping_cart/discount_coupon_model/discount_coupon_model.dart';
import '../entities/models/shopping_cart/gift_voucher_coupon_model/gift_voucher_coupon_model.dart';
import '../entities/models/shopping_cart/estimate_shipping_model/estimate_shipping_model.dart';
import '../entities/models/orders/customer_merchandise_returns_model/customer_merchandise_returns_model.dart';
import '../entities/models/orders/merchandise_return_model/merchandise_return_model.dart';
import '../entities/models/orders/merchandise_return_details_model/merchandise_return_details_model.dart';
import '../entities/models/vendors/apply_vendor_model/apply_vendor_model.dart';
import '../entities/models/vendors/contact_vendor_model/contact_vendor_model.dart';
import '../entities/models/contact/contact_us_model/contact_us_model.dart';
import '../entities/anonymous_type_84_f04_ecc/anonymous_type_84_f04_ecc.dart';
import '../entities/models/contact/contact_attribute_change_model/contact_attribute_change_model.dart';
import '../entities/anonymous_type__f3_e1_e574/anonymous_type__f3_e1_e574.dart';
import '../entities/models/catalog/customer_out_of_stock_subscriptions_model/customer_out_of_stock_subscriptions_model.dart';
import '../entities/models/catalog/product_model/product_model.dart';
import '../entities/models/knowledgebase/knowledgebase_home_page_model/knowledgebase_home_page_model.dart';
import '../entities/models/knowledgebase/knowledgebase_article_model/knowledgebase_article_model.dart';
import '../entities/anonymous_type_97_c14_fd8/anonymous_type_97_c14_fd8.dart';
import '../entities/anonymous_type_01_fa76_b1/anonymous_type_01_fa76_b1.dart';
import '../entities/models/shopping_cart/product_catalog_cart/product_catalog_cart.dart';
import '../entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import '../entities/models/shopping_cart/add_bid_model/add_bid_model.dart';
import '../entities/models/course/course_model/course_model.dart';
import '../entities/models/course/lesson_model/lesson_model.dart';
import '../entities/anonymous_type_3037_ab66/anonymous_type_3037_ab66.dart';
import '../entities/models/news/news_item_list_model/news_item_list_model.dart';
import '../entities/models/news/news_item_model/news_item_model.dart';
import '../entities/anonymous_type_03_ad2_c00/anonymous_type_03_ad2_c00.dart';
import '../entities/models/news/news_paging_filtering_model/news_paging_filtering_model.dart';
import '../entities/models/news/add_news_comment_model/add_news_comment_model.dart';
import '../entities/models/shopping_cart/mini_wishlist_model/mini_wishlist_model.dart';
import '../entities/models/shopping_cart/wishlist_model/wishlist_model.dart';
import '../entities/anonymous_type_2_fec469_e/anonymous_type_2_fec469_e.dart';
import '../entities/models/shopping_cart/wishlist_email_afriend_model/wishlist_email_afriend_model.dart';
import '../entities/models/shopping_cart/add_cart_from_wishlist_model/add_cart_from_wishlist_model.dart';
import '../entities/models/catalog/product_overview_model/product_overview_model.dart';
import '../entities/models/catalog/product_email_afriend_model/product_email_afriend_model.dart';
import '../entities/models/catalog/product_details_model/product_details_model.dart';
import '../entities/anonymous_type_0327_c72_f/anonymous_type_0327_c72_f.dart';
import '../entities/anonymous_type_262_f1_f09/anonymous_type_262_f1_f09.dart';
import '../entities/models/catalog/product_reviews_model/product_reviews_model.dart';
import '../entities/models/catalog/compare_products_model/compare_products_model.dart';
import '../entities/models/catalog/product_ask_question_simple_model/product_ask_question_simple_model.dart';
import '../entities/models/install/install_model/install_model.dart';
import '../entities/models/common/sitemap_model/sitemap_model.dart';
import '../entities/anonymous_type__b6395690/anonymous_type__b6395690.dart';
import '../entities/anonymous_type_343_f9_e63/anonymous_type_343_f9_e63.dart';
import '../entities/models/common/location_model/location_model.dart';
import '../entities/models/orders/customer_order_list_model/order_details_model/order_details_model.dart'
    as customer_order_list_model;

T? getJsonType<T>(Map<String, dynamic> json) {
  if (fromJsonByType.containsKey(T)) return fromJsonByType[T]!(json) as T?;
  return null;
}

dynamic getJsonByType(Type type, Map<String, dynamic> json) {
  return fromJsonByType[type]!(json);
}

final fromJsonByType = <
  Type,
  StoreJsonSerializable Function(Map<String, dynamic> json)
>{
  CheckoutModel: (json) => CheckoutModel.fromJson(json),
  AnonymousType_83EFF621: (json) => AnonymousType_83EFF621.fromJson(json),
  AnonymousType_F238A175: (json) => AnonymousType_F238A175.fromJson(json),
  AnonymousType_DA179D76: (json) => AnonymousType_DA179D76.fromJson(json),
  AnonymousType_55B93BB6: (json) => AnonymousType_55B93BB6.fromJson(json),
  CheckoutCompletedModel: (json) => CheckoutCompletedModel.fromJson(json),
  AnonymousType_2FBE9F46: (json) => AnonymousType_2FBE9F46.fromJson(json),
  CheckoutBillingAddressModel:
      (json) => CheckoutBillingAddressModel.fromJson(json),
  CheckoutShippingAddressModel:
      (json) => CheckoutShippingAddressModel.fromJson(json),
  CheckoutShippingMethodModel:
      (json) => CheckoutShippingMethodModel.fromJson(json),
  CheckoutPaymentMethodModel:
      (json) => CheckoutPaymentMethodModel.fromJson(json),
  BlogPostListModel: (json) => BlogPostListModel.fromJson(json),
  BlogPostModel: (json) => BlogPostModel.fromJson(json),
  BlogPagingFilteringModel: (json) => BlogPagingFilteringModel.fromJson(json),
  AddBlogCommentModel: (json) => AddBlogCommentModel.fromJson(json),
  CategoryModel: (json) => CategoryModel.fromJson(json),
  CategoryListModel: (json) => CategoryListModel.fromJson(json),
  BrandModel: (json) => BrandModel.fromJson(json),
  BrandListModel: (json) => BrandListModel.fromJson(json),
  CollectionModel: (json) => CollectionModel.fromJson(json),
  CollectionListModel: (json) => CollectionListModel.fromJson(json),
  VendorModel: (json) => VendorModel.fromJson(json),
  VendorListModel: (json) => VendorListModel.fromJson(json),
  VendorReviewsModel: (json) => VendorReviewsModel.fromJson(json),
  AnonymousType_1EDE6D30: (json) => AnonymousType_1EDE6D30.fromJson(json),
  ProductsByTagModel: (json) => ProductsByTagModel.fromJson(json),
  PopularProductTagsModel: (json) => PopularProductTagsModel.fromJson(json),
  SearchModel: (json) => SearchModel.fromJson(json),
  SearchAutoCompleteModel: (json) => SearchAutoCompleteModel.fromJson(json),
  CatalogPagingFilteringModel:
      (json) => CatalogPagingFilteringModel.fromJson(json),
  CategoryPagingModel: (json) => CategoryPagingModel.fromJson(json),
  BrandPagingModel: (json) => BrandPagingModel.fromJson(json),
  CollectionPagingModel: (json) => CollectionPagingModel.fromJson(json),
  VendorPagingModel: (json) => VendorPagingModel.fromJson(json),
  AnonymousType_2F40FB16: (json) => AnonymousType_2F40FB16.fromJson(json),
  AnonymousType_D4A20723: (json) => AnonymousType_D4A20723.fromJson(json),
  NewsletterCategoryModel: (json) => NewsletterCategoryModel.fromJson(json),
  CustomerAuctionsModel: (json) => CustomerAuctionsModel.fromJson(json),
  CustomerNotesModel: (json) => CustomerNotesModel.fromJson(json),
  DocumentsModel: (json) => DocumentsModel.fromJson(json),
  CustomerProductReviewsModel:
      (json) => CustomerProductReviewsModel.fromJson(json),
  CoursesModel: (json) => CoursesModel.fromJson(json),
  PasswordRecoveryModel: (json) => PasswordRecoveryModel.fromJson(json),
  PasswordRecoveryConfirmModel:
      (json) => PasswordRecoveryConfirmModel.fromJson(json),
  RegisterModel: (json) => RegisterModel.fromJson(json),
  AnonymousType_AF73D8D8: (json) => AnonymousType_AF73D8D8.fromJson(json),
  AccountActivationModel: (json) => AccountActivationModel.fromJson(json),
  CustomerInfoModel: (json) => CustomerInfoModel.fromJson(json),
  AnonymousType_FA6C6C9F: (json) => AnonymousType_FA6C6C9F.fromJson(json),
  CustomerAddressListModel: (json) => CustomerAddressListModel.fromJson(json),
  CustomerAddressEditModel: (json) => CustomerAddressEditModel.fromJson(json),
  CustomerDownloadableProductsModel:
      (json) => CustomerDownloadableProductsModel.fromJson(json),
  ChangePasswordModel: (json) => ChangePasswordModel.fromJson(json),
  DeleteAccountModel: (json) => DeleteAccountModel.fromJson(json),
  SubAccountSimpleModel: (json) => SubAccountSimpleModel.fromJson(json),
  SubAccountCreateModel: (json) => SubAccountCreateModel.fromJson(json),
  SubAccountEditModel: (json) => SubAccountEditModel.fromJson(json),
  AnonymousType_50E263DC: (json) => AnonymousType_50E263DC.fromJson(json),
  DocumentPagingModel: (json) => DocumentPagingModel.fromJson(json),
  PageModel: (json) => PageModel.fromJson(json),
  AnonymousType_10783450: (json) => AnonymousType_10783450.fromJson(json),
  AuthenticateModel: (json) => AuthenticateModel.fromJson(json),
  CustomerOrderListModel: (json) => CustomerOrderListModel.fromJson(json),
  OrderDetailsModel: (json) => OrderDetailsModel.fromJson(json),
  AddOrderNoteModel: (json) => AddOrderNoteModel.fromJson(json),
  ShipmentDetailsModel: (json) => ShipmentDetailsModel.fromJson(json),
  CustomerLoyaltyPointsModel:
      (json) => CustomerLoyaltyPointsModel.fromJson(json),
  OrderPagingModel: (json) => OrderPagingModel.fromJson(json),
  MiniShoppingCartModel: (json) => MiniShoppingCartModel.fromJson(json),
  AnonymousType_A25E79E1: (json) => AnonymousType_A25E79E1.fromJson(json),
  AnonymousType_5F706788: (json) => AnonymousType_5F706788.fromJson(json),
  ShoppingCartModel: (json) => ShoppingCartModel.fromJson(json),
  OrderTotalsModel: (json) => OrderTotalsModel.fromJson(json),
  AnonymousType_6F488518: (json) => AnonymousType_6F488518.fromJson(json),
  AnonymousType_845BADBC: (json) => AnonymousType_845BADBC.fromJson(json),
  AnonymousType_F96D6EB9: (json) => AnonymousType_F96D6EB9.fromJson(json),
  AnonymousType_EF661507: (json) => AnonymousType_EF661507.fromJson(json),
  CheckoutAttributeSelectedModel:
      (json) => CheckoutAttributeSelectedModel.fromJson(json),
  UpdateQuantityModel: (json) => UpdateQuantityModel.fromJson(json),
  DeleteCartItemModel: (json) => DeleteCartItemModel.fromJson(json),
  ChangeTypeCartItemModel: (json) => ChangeTypeCartItemModel.fromJson(json),
  DiscountCouponModel: (json) => DiscountCouponModel.fromJson(json),
  GiftVoucherCouponModel: (json) => GiftVoucherCouponModel.fromJson(json),
  EstimateShippingModel: (json) => EstimateShippingModel.fromJson(json),
  CustomerMerchandiseReturnsModel:
      (json) => CustomerMerchandiseReturnsModel.fromJson(json),
  MerchandiseReturnModel: (json) => MerchandiseReturnModel.fromJson(json),
  MerchandiseReturnDetailsModel:
      (json) => MerchandiseReturnDetailsModel.fromJson(json),
  ApplyVendorModel: (json) => ApplyVendorModel.fromJson(json),
  ContactVendorModel: (json) => ContactVendorModel.fromJson(json),
  ContactUsModel: (json) => ContactUsModel.fromJson(json),
  AnonymousType_84F04ECC: (json) => AnonymousType_84F04ECC.fromJson(json),
  ContactAttributeChangeModel:
      (json) => ContactAttributeChangeModel.fromJson(json),
  AnonymousType_F3E1E574: (json) => AnonymousType_F3E1E574.fromJson(json),
  CustomerOutOfStockSubscriptionsModel:
      (json) => CustomerOutOfStockSubscriptionsModel.fromJson(json),
  ProductModel: (json) => ProductModel.fromJson(json),
  KnowledgebaseHomePageModel:
      (json) => KnowledgebaseHomePageModel.fromJson(json),
  KnowledgebaseArticleModel: (json) => KnowledgebaseArticleModel.fromJson(json),
  AnonymousType_97C14FD8: (json) => AnonymousType_97C14FD8.fromJson(json),
  AnonymousType_01FA76B1: (json) => AnonymousType_01FA76B1.fromJson(json),
  ProductCatalogCart: (json) => ProductCatalogCart.fromJson(json),
  ProductDetailsCart: (json) => ProductDetailsCart.fromJson(json),
  AddBidModel: (json) => AddBidModel.fromJson(json),
  CourseModel: (json) => CourseModel.fromJson(json),
  LessonModel: (json) => LessonModel.fromJson(json),
  AnonymousType_3037AB66: (json) => AnonymousType_3037AB66.fromJson(json),
  NewsItemListModel: (json) => NewsItemListModel.fromJson(json),
  NewsItemModel: (json) => NewsItemModel.fromJson(json),
  AnonymousType_03AD2C00: (json) => AnonymousType_03AD2C00.fromJson(json),
  NewsPagingFilteringModel: (json) => NewsPagingFilteringModel.fromJson(json),
  AddNewsCommentModel: (json) => AddNewsCommentModel.fromJson(json),
  MiniWishlistModel: (json) => MiniWishlistModel.fromJson(json),
  WishlistModel: (json) => WishlistModel.fromJson(json),
  AnonymousType_2FEC469E: (json) => AnonymousType_2FEC469E.fromJson(json),
  WishlistEmailAFriendModel: (json) => WishlistEmailAFriendModel.fromJson(json),
  AddCartFromWishlistModel: (json) => AddCartFromWishlistModel.fromJson(json),
  ProductOverviewModel: (json) => ProductOverviewModel.fromJson(json),
  ProductEmailAFriendModel: (json) => ProductEmailAFriendModel.fromJson(json),
  ProductDetailsModel: (json) => ProductDetailsModel.fromJson(json),
  AnonymousType_0327C72F: (json) => AnonymousType_0327C72F.fromJson(json),
  AnonymousType_262F1F09: (json) => AnonymousType_262F1F09.fromJson(json),
  ProductReviewsModel: (json) => ProductReviewsModel.fromJson(json),
  CompareProductsModel: (json) => CompareProductsModel.fromJson(json),
  ProductAskQuestionSimpleModel:
      (json) => ProductAskQuestionSimpleModel.fromJson(json),
  InstallModel: (json) => InstallModel.fromJson(json),
  SitemapModel: (json) => SitemapModel.fromJson(json),
  AnonymousType_B6395690: (json) => AnonymousType_B6395690.fromJson(json),
  AnonymousType_343F9E63: (json) => AnonymousType_343F9E63.fromJson(json),
  LocationModel: (json) => LocationModel.fromJson(json),
  PublicInfoModel: (json) => PublicInfoModel.fromJson(json),
  Slider: (json) => Slider.fromJson(json),
  CustomerNavigationModel: (json) => CustomerNavigationModel.fromJson(json),
  CheckoutConfirmModel: (json) => CheckoutConfirmModel.fromJson(json),
  CheckoutStepResponse: (json) => CheckoutStepResponse.fromJson(json),
  StateProvinceModel: (json) => StateProvinceModel.fromJson(json),
  FooterModel: (json) => FooterModel.fromJson(json),
  LegalTextMessageTemplateComponentModel:
      (json) => LegalTextMessageTemplateComponentModel.fromJson(json),
  customer_order_list_model.OrderDetailsModel:
      (json) => customer_order_list_model.OrderDetailsModel.fromJson(json),
  ICaptchaValidModel: (json) => ICaptchaValidModel.fromJson(json),
  LoginModel: (json) => LoginModel.fromJson(json),
  QueuedEmail: (json) => QueuedEmail.fromJson(json),
  NotificationListResponse: (json) => NotificationListResponse.fromJson(json),
  NotificationDetailResponse:
      (json) => NotificationDetailResponse.fromJson(json),

  CartSummaryDto: (json) => CartSummaryDto.fromJson(json),
  FreeShippingInfoDto: (json) => FreeShippingInfoDto.fromJson(json),
  MinimumOrderInfoDto: (json) => MinimumOrderInfoDto.fromJson(json),
  ShoppingCartInfoResponse: (json) => ShoppingCartInfoResponse.fromJson(json),
};

StoreJsonSerializableConverter<T>
getStoreJsonSerializebleConverter<T extends StoreJsonSerializable>() {
  return StoreJsonSerializableConverter<T>((json) => getJsonType<T>(json)!);
}

ListConverter<T> getListConverter<T extends StoreJsonSerializable>() {
  return ListConverter<T>(getStoreJsonSerializebleConverter<T>());
}

ApiResponseConverter<T>
getApiResponseConverter<T extends StoreJsonSerializable>() {
  return ApiResponseConverter<T>(getStoreJsonSerializebleConverter<T>());
}

ApiResponseConverter<List<T>>
getListApiResponseConverter<T extends StoreJsonSerializable>() {
  return ApiResponseConverter<List<T>>(getListConverter<T>());
}

final Map<Type, JsonConverter> jsonConverters = {
  CheckoutModel: getStoreJsonSerializebleConverter<CheckoutModel>(),
  List<CheckoutModel>: getListConverter<CheckoutModel>(),
  ApiResponse<CheckoutModel>: getApiResponseConverter<CheckoutModel>(),
  ApiResponse<List<CheckoutModel>>:
      getListApiResponseConverter<CheckoutModel>(),
  AnonymousType_83EFF621:
      getStoreJsonSerializebleConverter<AnonymousType_83EFF621>(),
  List<AnonymousType_83EFF621>: getListConverter<AnonymousType_83EFF621>(),
  ApiResponse<AnonymousType_83EFF621>:
      getApiResponseConverter<AnonymousType_83EFF621>(),
  ApiResponse<List<AnonymousType_83EFF621>>:
      getListApiResponseConverter<AnonymousType_83EFF621>(),
  AnonymousType_F238A175:
      getStoreJsonSerializebleConverter<AnonymousType_F238A175>(),
  List<AnonymousType_F238A175>: getListConverter<AnonymousType_F238A175>(),
  ApiResponse<AnonymousType_F238A175>:
      getApiResponseConverter<AnonymousType_F238A175>(),
  ApiResponse<List<AnonymousType_F238A175>>:
      getListApiResponseConverter<AnonymousType_F238A175>(),
  AnonymousType_DA179D76:
      getStoreJsonSerializebleConverter<AnonymousType_DA179D76>(),
  List<AnonymousType_DA179D76>: getListConverter<AnonymousType_DA179D76>(),
  ApiResponse<AnonymousType_DA179D76>:
      getApiResponseConverter<AnonymousType_DA179D76>(),
  ApiResponse<List<AnonymousType_DA179D76>>:
      getListApiResponseConverter<AnonymousType_DA179D76>(),
  AnonymousType_55B93BB6:
      getStoreJsonSerializebleConverter<AnonymousType_55B93BB6>(),
  List<AnonymousType_55B93BB6>: getListConverter<AnonymousType_55B93BB6>(),
  ApiResponse<AnonymousType_55B93BB6>:
      getApiResponseConverter<AnonymousType_55B93BB6>(),
  ApiResponse<List<AnonymousType_55B93BB6>>:
      getListApiResponseConverter<AnonymousType_55B93BB6>(),
  CheckoutCompletedModel:
      getStoreJsonSerializebleConverter<CheckoutCompletedModel>(),
  List<CheckoutCompletedModel>: getListConverter<CheckoutCompletedModel>(),
  ApiResponse<CheckoutCompletedModel>:
      getApiResponseConverter<CheckoutCompletedModel>(),
  ApiResponse<List<CheckoutCompletedModel>>:
      getListApiResponseConverter<CheckoutCompletedModel>(),
  AnonymousType_2FBE9F46:
      getStoreJsonSerializebleConverter<AnonymousType_2FBE9F46>(),
  List<AnonymousType_2FBE9F46>: getListConverter<AnonymousType_2FBE9F46>(),
  ApiResponse<AnonymousType_2FBE9F46>:
      getApiResponseConverter<AnonymousType_2FBE9F46>(),
  ApiResponse<List<AnonymousType_2FBE9F46>>:
      getListApiResponseConverter<AnonymousType_2FBE9F46>(),
  CheckoutBillingAddressModel:
      getStoreJsonSerializebleConverter<CheckoutBillingAddressModel>(),
  List<CheckoutBillingAddressModel>:
      getListConverter<CheckoutBillingAddressModel>(),
  ApiResponse<CheckoutBillingAddressModel>:
      getApiResponseConverter<CheckoutBillingAddressModel>(),
  ApiResponse<List<CheckoutBillingAddressModel>>:
      getListApiResponseConverter<CheckoutBillingAddressModel>(),
  CheckoutShippingAddressModel:
      getStoreJsonSerializebleConverter<CheckoutShippingAddressModel>(),
  List<CheckoutShippingAddressModel>:
      getListConverter<CheckoutShippingAddressModel>(),
  ApiResponse<CheckoutShippingAddressModel>:
      getApiResponseConverter<CheckoutShippingAddressModel>(),
  ApiResponse<List<CheckoutShippingAddressModel>>:
      getListApiResponseConverter<CheckoutShippingAddressModel>(),
  CheckoutShippingMethodModel:
      getStoreJsonSerializebleConverter<CheckoutShippingMethodModel>(),
  List<CheckoutShippingMethodModel>:
      getListConverter<CheckoutShippingMethodModel>(),
  ApiResponse<CheckoutShippingMethodModel>:
      getApiResponseConverter<CheckoutShippingMethodModel>(),
  ApiResponse<List<CheckoutShippingMethodModel>>:
      getListApiResponseConverter<CheckoutShippingMethodModel>(),
  CheckoutPaymentMethodModel:
      getStoreJsonSerializebleConverter<CheckoutPaymentMethodModel>(),
  List<CheckoutPaymentMethodModel>:
      getListConverter<CheckoutPaymentMethodModel>(),
  ApiResponse<CheckoutPaymentMethodModel>:
      getApiResponseConverter<CheckoutPaymentMethodModel>(),
  ApiResponse<List<CheckoutPaymentMethodModel>>:
      getListApiResponseConverter<CheckoutPaymentMethodModel>(),
  BlogPostListModel: getStoreJsonSerializebleConverter<BlogPostListModel>(),
  List<BlogPostListModel>: getListConverter<BlogPostListModel>(),
  ApiResponse<BlogPostListModel>: getApiResponseConverter<BlogPostListModel>(),
  ApiResponse<List<BlogPostListModel>>:
      getListApiResponseConverter<BlogPostListModel>(),
  BlogPostModel: getStoreJsonSerializebleConverter<BlogPostModel>(),
  List<BlogPostModel>: getListConverter<BlogPostModel>(),
  ApiResponse<BlogPostModel>: getApiResponseConverter<BlogPostModel>(),
  ApiResponse<List<BlogPostModel>>:
      getListApiResponseConverter<BlogPostModel>(),
  BlogPagingFilteringModel:
      getStoreJsonSerializebleConverter<BlogPagingFilteringModel>(),
  List<BlogPagingFilteringModel>: getListConverter<BlogPagingFilteringModel>(),
  ApiResponse<BlogPagingFilteringModel>:
      getApiResponseConverter<BlogPagingFilteringModel>(),
  ApiResponse<List<BlogPagingFilteringModel>>:
      getListApiResponseConverter<BlogPagingFilteringModel>(),
  AddBlogCommentModel: getStoreJsonSerializebleConverter<AddBlogCommentModel>(),
  List<AddBlogCommentModel>: getListConverter<AddBlogCommentModel>(),
  ApiResponse<AddBlogCommentModel>:
      getApiResponseConverter<AddBlogCommentModel>(),
  ApiResponse<List<AddBlogCommentModel>>:
      getListApiResponseConverter<AddBlogCommentModel>(),
  CategoryModel: getStoreJsonSerializebleConverter<CategoryModel>(),
  List<CategoryModel>: getListConverter<CategoryModel>(),
  ApiResponse<CategoryModel>: getApiResponseConverter<CategoryModel>(),
  ApiResponse<List<CategoryModel>>:
      getListApiResponseConverter<CategoryModel>(),
  CategoryListModel: getStoreJsonSerializebleConverter<CategoryListModel>(),
  List<CategoryListModel>: getListConverter<CategoryListModel>(),
  ApiResponse<CategoryListModel>: getApiResponseConverter<CategoryListModel>(),
  ApiResponse<List<CategoryListModel>>:
      getListApiResponseConverter<CategoryListModel>(),
  BrandModel: getStoreJsonSerializebleConverter<BrandModel>(),
  List<BrandModel>: getListConverter<BrandModel>(),
  ApiResponse<BrandModel>: getApiResponseConverter<BrandModel>(),
  ApiResponse<List<BrandModel>>: getListApiResponseConverter<BrandModel>(),
  BrandListModel: getStoreJsonSerializebleConverter<BrandListModel>(),
  List<BrandListModel>: getListConverter<BrandListModel>(),
  ApiResponse<BrandListModel>: getApiResponseConverter<BrandListModel>(),
  ApiResponse<List<BrandListModel>>:
      getListApiResponseConverter<BrandListModel>(),
  CollectionModel: getStoreJsonSerializebleConverter<CollectionModel>(),
  List<CollectionModel>: getListConverter<CollectionModel>(),
  ApiResponse<CollectionModel>: getApiResponseConverter<CollectionModel>(),
  ApiResponse<List<CollectionModel>>:
      getListApiResponseConverter<CollectionModel>(),
  CollectionListModel: getStoreJsonSerializebleConverter<CollectionListModel>(),
  List<CollectionListModel>: getListConverter<CollectionListModel>(),
  ApiResponse<CollectionListModel>:
      getApiResponseConverter<CollectionListModel>(),
  ApiResponse<List<CollectionListModel>>:
      getListApiResponseConverter<CollectionListModel>(),
  VendorModel: getStoreJsonSerializebleConverter<VendorModel>(),
  List<VendorModel>: getListConverter<VendorModel>(),
  ApiResponse<VendorModel>: getApiResponseConverter<VendorModel>(),
  ApiResponse<List<VendorModel>>: getListApiResponseConverter<VendorModel>(),
  VendorListModel: getStoreJsonSerializebleConverter<VendorListModel>(),
  List<VendorListModel>: getListConverter<VendorListModel>(),
  ApiResponse<VendorListModel>: getApiResponseConverter<VendorListModel>(),
  ApiResponse<List<VendorListModel>>:
      getListApiResponseConverter<VendorListModel>(),
  VendorReviewsModel: getStoreJsonSerializebleConverter<VendorReviewsModel>(),
  List<VendorReviewsModel>: getListConverter<VendorReviewsModel>(),
  ApiResponse<VendorReviewsModel>:
      getApiResponseConverter<VendorReviewsModel>(),
  ApiResponse<List<VendorReviewsModel>>:
      getListApiResponseConverter<VendorReviewsModel>(),
  AnonymousType_1EDE6D30:
      getStoreJsonSerializebleConverter<AnonymousType_1EDE6D30>(),
  List<AnonymousType_1EDE6D30>: getListConverter<AnonymousType_1EDE6D30>(),
  ApiResponse<AnonymousType_1EDE6D30>:
      getApiResponseConverter<AnonymousType_1EDE6D30>(),
  ApiResponse<List<AnonymousType_1EDE6D30>>:
      getListApiResponseConverter<AnonymousType_1EDE6D30>(),
  ProductsByTagModel: getStoreJsonSerializebleConverter<ProductsByTagModel>(),
  List<ProductsByTagModel>: getListConverter<ProductsByTagModel>(),
  ApiResponse<ProductsByTagModel>:
      getApiResponseConverter<ProductsByTagModel>(),
  ApiResponse<List<ProductsByTagModel>>:
      getListApiResponseConverter<ProductsByTagModel>(),
  PopularProductTagsModel:
      getStoreJsonSerializebleConverter<PopularProductTagsModel>(),
  List<PopularProductTagsModel>: getListConverter<PopularProductTagsModel>(),
  ApiResponse<PopularProductTagsModel>:
      getApiResponseConverter<PopularProductTagsModel>(),
  ApiResponse<List<PopularProductTagsModel>>:
      getListApiResponseConverter<PopularProductTagsModel>(),
  SearchModel: getStoreJsonSerializebleConverter<SearchModel>(),
  List<SearchModel>: getListConverter<SearchModel>(),
  ApiResponse<SearchModel>: getApiResponseConverter<SearchModel>(),
  ApiResponse<List<SearchModel>>: getListApiResponseConverter<SearchModel>(),
  SearchAutoCompleteModel:
      getStoreJsonSerializebleConverter<SearchAutoCompleteModel>(),
  List<SearchAutoCompleteModel>: getListConverter<SearchAutoCompleteModel>(),
  ApiResponse<SearchAutoCompleteModel>:
      getApiResponseConverter<SearchAutoCompleteModel>(),
  ApiResponse<List<SearchAutoCompleteModel>>:
      getListApiResponseConverter<SearchAutoCompleteModel>(),
  CatalogPagingFilteringModel:
      getStoreJsonSerializebleConverter<CatalogPagingFilteringModel>(),
  List<CatalogPagingFilteringModel>:
      getListConverter<CatalogPagingFilteringModel>(),
  ApiResponse<CatalogPagingFilteringModel>:
      getApiResponseConverter<CatalogPagingFilteringModel>(),
  ApiResponse<List<CatalogPagingFilteringModel>>:
      getListApiResponseConverter<CatalogPagingFilteringModel>(),
  CategoryPagingModel: getStoreJsonSerializebleConverter<CategoryPagingModel>(),
  List<CategoryPagingModel>: getListConverter<CategoryPagingModel>(),
  ApiResponse<CategoryPagingModel>:
      getApiResponseConverter<CategoryPagingModel>(),
  ApiResponse<List<CategoryPagingModel>>:
      getListApiResponseConverter<CategoryPagingModel>(),
  BrandPagingModel: getStoreJsonSerializebleConverter<BrandPagingModel>(),
  List<BrandPagingModel>: getListConverter<BrandPagingModel>(),
  ApiResponse<BrandPagingModel>: getApiResponseConverter<BrandPagingModel>(),
  ApiResponse<List<BrandPagingModel>>:
      getListApiResponseConverter<BrandPagingModel>(),
  CollectionPagingModel:
      getStoreJsonSerializebleConverter<CollectionPagingModel>(),
  List<CollectionPagingModel>: getListConverter<CollectionPagingModel>(),
  ApiResponse<CollectionPagingModel>:
      getApiResponseConverter<CollectionPagingModel>(),
  ApiResponse<List<CollectionPagingModel>>:
      getListApiResponseConverter<CollectionPagingModel>(),
  VendorPagingModel: getStoreJsonSerializebleConverter<VendorPagingModel>(),
  List<VendorPagingModel>: getListConverter<VendorPagingModel>(),
  ApiResponse<VendorPagingModel>: getApiResponseConverter<VendorPagingModel>(),
  ApiResponse<List<VendorPagingModel>>:
      getListApiResponseConverter<VendorPagingModel>(),
  AnonymousType_2F40FB16:
      getStoreJsonSerializebleConverter<AnonymousType_2F40FB16>(),
  List<AnonymousType_2F40FB16>: getListConverter<AnonymousType_2F40FB16>(),
  ApiResponse<AnonymousType_2F40FB16>:
      getApiResponseConverter<AnonymousType_2F40FB16>(),
  ApiResponse<List<AnonymousType_2F40FB16>>:
      getListApiResponseConverter<AnonymousType_2F40FB16>(),
  AnonymousType_D4A20723:
      getStoreJsonSerializebleConverter<AnonymousType_D4A20723>(),
  List<AnonymousType_D4A20723>: getListConverter<AnonymousType_D4A20723>(),
  ApiResponse<AnonymousType_D4A20723>:
      getApiResponseConverter<AnonymousType_D4A20723>(),
  ApiResponse<List<AnonymousType_D4A20723>>:
      getListApiResponseConverter<AnonymousType_D4A20723>(),
  NewsletterCategoryModel:
      getStoreJsonSerializebleConverter<NewsletterCategoryModel>(),
  List<NewsletterCategoryModel>: getListConverter<NewsletterCategoryModel>(),
  ApiResponse<NewsletterCategoryModel>:
      getApiResponseConverter<NewsletterCategoryModel>(),
  ApiResponse<List<NewsletterCategoryModel>>:
      getListApiResponseConverter<NewsletterCategoryModel>(),
  CustomerAuctionsModel:
      getStoreJsonSerializebleConverter<CustomerAuctionsModel>(),
  List<CustomerAuctionsModel>: getListConverter<CustomerAuctionsModel>(),
  ApiResponse<CustomerAuctionsModel>:
      getApiResponseConverter<CustomerAuctionsModel>(),
  ApiResponse<List<CustomerAuctionsModel>>:
      getListApiResponseConverter<CustomerAuctionsModel>(),
  CustomerNotesModel: getStoreJsonSerializebleConverter<CustomerNotesModel>(),
  List<CustomerNotesModel>: getListConverter<CustomerNotesModel>(),
  ApiResponse<CustomerNotesModel>:
      getApiResponseConverter<CustomerNotesModel>(),
  ApiResponse<List<CustomerNotesModel>>:
      getListApiResponseConverter<CustomerNotesModel>(),
  DocumentsModel: getStoreJsonSerializebleConverter<DocumentsModel>(),
  List<DocumentsModel>: getListConverter<DocumentsModel>(),
  ApiResponse<DocumentsModel>: getApiResponseConverter<DocumentsModel>(),
  ApiResponse<List<DocumentsModel>>:
      getListApiResponseConverter<DocumentsModel>(),
  CustomerProductReviewsModel:
      getStoreJsonSerializebleConverter<CustomerProductReviewsModel>(),
  List<CustomerProductReviewsModel>:
      getListConverter<CustomerProductReviewsModel>(),
  ApiResponse<CustomerProductReviewsModel>:
      getApiResponseConverter<CustomerProductReviewsModel>(),
  ApiResponse<List<CustomerProductReviewsModel>>:
      getListApiResponseConverter<CustomerProductReviewsModel>(),
  CoursesModel: getStoreJsonSerializebleConverter<CoursesModel>(),
  List<CoursesModel>: getListConverter<CoursesModel>(),
  ApiResponse<CoursesModel>: getApiResponseConverter<CoursesModel>(),
  ApiResponse<List<CoursesModel>>: getListApiResponseConverter<CoursesModel>(),
  PasswordRecoveryModel:
      getStoreJsonSerializebleConverter<PasswordRecoveryModel>(),
  List<PasswordRecoveryModel>: getListConverter<PasswordRecoveryModel>(),
  ApiResponse<PasswordRecoveryModel>:
      getApiResponseConverter<PasswordRecoveryModel>(),
  ApiResponse<List<PasswordRecoveryModel>>:
      getListApiResponseConverter<PasswordRecoveryModel>(),
  PasswordRecoveryConfirmModel:
      getStoreJsonSerializebleConverter<PasswordRecoveryConfirmModel>(),
  List<PasswordRecoveryConfirmModel>:
      getListConverter<PasswordRecoveryConfirmModel>(),
  ApiResponse<PasswordRecoveryConfirmModel>:
      getApiResponseConverter<PasswordRecoveryConfirmModel>(),
  ApiResponse<List<PasswordRecoveryConfirmModel>>:
      getListApiResponseConverter<PasswordRecoveryConfirmModel>(),
  RegisterModel: getStoreJsonSerializebleConverter<RegisterModel>(),
  List<RegisterModel>: getListConverter<RegisterModel>(),
  ApiResponse<RegisterModel>: getApiResponseConverter<RegisterModel>(),
  ApiResponse<List<RegisterModel>>:
      getListApiResponseConverter<RegisterModel>(),
  AnonymousType_AF73D8D8:
      getStoreJsonSerializebleConverter<AnonymousType_AF73D8D8>(),
  List<AnonymousType_AF73D8D8>: getListConverter<AnonymousType_AF73D8D8>(),
  ApiResponse<AnonymousType_AF73D8D8>:
      getApiResponseConverter<AnonymousType_AF73D8D8>(),
  ApiResponse<List<AnonymousType_AF73D8D8>>:
      getListApiResponseConverter<AnonymousType_AF73D8D8>(),
  AccountActivationModel:
      getStoreJsonSerializebleConverter<AccountActivationModel>(),
  List<AccountActivationModel>: getListConverter<AccountActivationModel>(),
  ApiResponse<AccountActivationModel>:
      getApiResponseConverter<AccountActivationModel>(),
  ApiResponse<List<AccountActivationModel>>:
      getListApiResponseConverter<AccountActivationModel>(),
  CustomerInfoModel: getStoreJsonSerializebleConverter<CustomerInfoModel>(),
  List<CustomerInfoModel>: getListConverter<CustomerInfoModel>(),
  ApiResponse<CustomerInfoModel>: getApiResponseConverter<CustomerInfoModel>(),
  ApiResponse<List<CustomerInfoModel>>:
      getListApiResponseConverter<CustomerInfoModel>(),
  AnonymousType_FA6C6C9F:
      getStoreJsonSerializebleConverter<AnonymousType_FA6C6C9F>(),
  List<AnonymousType_FA6C6C9F>: getListConverter<AnonymousType_FA6C6C9F>(),
  ApiResponse<AnonymousType_FA6C6C9F>:
      getApiResponseConverter<AnonymousType_FA6C6C9F>(),
  ApiResponse<List<AnonymousType_FA6C6C9F>>:
      getListApiResponseConverter<AnonymousType_FA6C6C9F>(),
  CustomerAddressListModel:
      getStoreJsonSerializebleConverter<CustomerAddressListModel>(),
  List<CustomerAddressListModel>: getListConverter<CustomerAddressListModel>(),
  ApiResponse<CustomerAddressListModel>:
      getApiResponseConverter<CustomerAddressListModel>(),
  ApiResponse<List<CustomerAddressListModel>>:
      getListApiResponseConverter<CustomerAddressListModel>(),
  CustomerAddressEditModel:
      getStoreJsonSerializebleConverter<CustomerAddressEditModel>(),
  List<CustomerAddressEditModel>: getListConverter<CustomerAddressEditModel>(),
  ApiResponse<CustomerAddressEditModel>:
      getApiResponseConverter<CustomerAddressEditModel>(),
  ApiResponse<List<CustomerAddressEditModel>>:
      getListApiResponseConverter<CustomerAddressEditModel>(),
  CustomerDownloadableProductsModel:
      getStoreJsonSerializebleConverter<CustomerDownloadableProductsModel>(),
  List<CustomerDownloadableProductsModel>:
      getListConverter<CustomerDownloadableProductsModel>(),
  ApiResponse<CustomerDownloadableProductsModel>:
      getApiResponseConverter<CustomerDownloadableProductsModel>(),
  ApiResponse<List<CustomerDownloadableProductsModel>>:
      getListApiResponseConverter<CustomerDownloadableProductsModel>(),
  ChangePasswordModel: getStoreJsonSerializebleConverter<ChangePasswordModel>(),
  List<ChangePasswordModel>: getListConverter<ChangePasswordModel>(),
  ApiResponse<ChangePasswordModel>:
      getApiResponseConverter<ChangePasswordModel>(),
  ApiResponse<List<ChangePasswordModel>>:
      getListApiResponseConverter<ChangePasswordModel>(),
  DeleteAccountModel: getStoreJsonSerializebleConverter<DeleteAccountModel>(),
  List<DeleteAccountModel>: getListConverter<DeleteAccountModel>(),
  ApiResponse<DeleteAccountModel>:
      getApiResponseConverter<DeleteAccountModel>(),
  ApiResponse<List<DeleteAccountModel>>:
      getListApiResponseConverter<DeleteAccountModel>(),
  SubAccountSimpleModel:
      getStoreJsonSerializebleConverter<SubAccountSimpleModel>(),
  List<SubAccountSimpleModel>: getListConverter<SubAccountSimpleModel>(),
  ApiResponse<SubAccountSimpleModel>:
      getApiResponseConverter<SubAccountSimpleModel>(),
  ApiResponse<List<SubAccountSimpleModel>>:
      getListApiResponseConverter<SubAccountSimpleModel>(),
  SubAccountCreateModel:
      getStoreJsonSerializebleConverter<SubAccountCreateModel>(),
  List<SubAccountCreateModel>: getListConverter<SubAccountCreateModel>(),
  ApiResponse<SubAccountCreateModel>:
      getApiResponseConverter<SubAccountCreateModel>(),
  ApiResponse<List<SubAccountCreateModel>>:
      getListApiResponseConverter<SubAccountCreateModel>(),
  SubAccountEditModel: getStoreJsonSerializebleConverter<SubAccountEditModel>(),
  List<SubAccountEditModel>: getListConverter<SubAccountEditModel>(),
  ApiResponse<SubAccountEditModel>:
      getApiResponseConverter<SubAccountEditModel>(),
  ApiResponse<List<SubAccountEditModel>>:
      getListApiResponseConverter<SubAccountEditModel>(),
  AnonymousType_50E263DC:
      getStoreJsonSerializebleConverter<AnonymousType_50E263DC>(),
  List<AnonymousType_50E263DC>: getListConverter<AnonymousType_50E263DC>(),
  ApiResponse<AnonymousType_50E263DC>:
      getApiResponseConverter<AnonymousType_50E263DC>(),
  ApiResponse<List<AnonymousType_50E263DC>>:
      getListApiResponseConverter<AnonymousType_50E263DC>(),
  DocumentPagingModel: getStoreJsonSerializebleConverter<DocumentPagingModel>(),
  List<DocumentPagingModel>: getListConverter<DocumentPagingModel>(),
  ApiResponse<DocumentPagingModel>:
      getApiResponseConverter<DocumentPagingModel>(),
  ApiResponse<List<DocumentPagingModel>>:
      getListApiResponseConverter<DocumentPagingModel>(),
  PageModel: getStoreJsonSerializebleConverter<PageModel>(),
  List<PageModel>: getListConverter<PageModel>(),
  ApiResponse<PageModel>: getApiResponseConverter<PageModel>(),
  ApiResponse<List<PageModel>>: getListApiResponseConverter<PageModel>(),
  AnonymousType_10783450:
      getStoreJsonSerializebleConverter<AnonymousType_10783450>(),
  List<AnonymousType_10783450>: getListConverter<AnonymousType_10783450>(),
  ApiResponse<AnonymousType_10783450>:
      getApiResponseConverter<AnonymousType_10783450>(),
  ApiResponse<List<AnonymousType_10783450>>:
      getListApiResponseConverter<AnonymousType_10783450>(),
  AuthenticateModel: getStoreJsonSerializebleConverter<AuthenticateModel>(),
  List<AuthenticateModel>: getListConverter<AuthenticateModel>(),
  ApiResponse<AuthenticateModel>: getApiResponseConverter<AuthenticateModel>(),
  ApiResponse<List<AuthenticateModel>>:
      getListApiResponseConverter<AuthenticateModel>(),
  CustomerOrderListModel:
      getStoreJsonSerializebleConverter<CustomerOrderListModel>(),
  List<CustomerOrderListModel>: getListConverter<CustomerOrderListModel>(),
  ApiResponse<CustomerOrderListModel>:
      getApiResponseConverter<CustomerOrderListModel>(),
  ApiResponse<List<CustomerOrderListModel>>:
      getListApiResponseConverter<CustomerOrderListModel>(),
  OrderDetailsModel: getStoreJsonSerializebleConverter<OrderDetailsModel>(),
  List<OrderDetailsModel>: getListConverter<OrderDetailsModel>(),
  ApiResponse<OrderDetailsModel>: getApiResponseConverter<OrderDetailsModel>(),
  ApiResponse<List<OrderDetailsModel>>:
      getListApiResponseConverter<OrderDetailsModel>(),
  AddOrderNoteModel: getStoreJsonSerializebleConverter<AddOrderNoteModel>(),
  List<AddOrderNoteModel>: getListConverter<AddOrderNoteModel>(),
  ApiResponse<AddOrderNoteModel>: getApiResponseConverter<AddOrderNoteModel>(),
  ApiResponse<List<AddOrderNoteModel>>:
      getListApiResponseConverter<AddOrderNoteModel>(),
  ShipmentDetailsModel:
      getStoreJsonSerializebleConverter<ShipmentDetailsModel>(),
  List<ShipmentDetailsModel>: getListConverter<ShipmentDetailsModel>(),
  ApiResponse<ShipmentDetailsModel>:
      getApiResponseConverter<ShipmentDetailsModel>(),
  ApiResponse<List<ShipmentDetailsModel>>:
      getListApiResponseConverter<ShipmentDetailsModel>(),
  CustomerLoyaltyPointsModel:
      getStoreJsonSerializebleConverter<CustomerLoyaltyPointsModel>(),
  List<CustomerLoyaltyPointsModel>:
      getListConverter<CustomerLoyaltyPointsModel>(),
  ApiResponse<CustomerLoyaltyPointsModel>:
      getApiResponseConverter<CustomerLoyaltyPointsModel>(),
  ApiResponse<List<CustomerLoyaltyPointsModel>>:
      getListApiResponseConverter<CustomerLoyaltyPointsModel>(),
  OrderPagingModel: getStoreJsonSerializebleConverter<OrderPagingModel>(),
  List<OrderPagingModel>: getListConverter<OrderPagingModel>(),
  ApiResponse<OrderPagingModel>: getApiResponseConverter<OrderPagingModel>(),
  ApiResponse<List<OrderPagingModel>>:
      getListApiResponseConverter<OrderPagingModel>(),
  MiniShoppingCartModel:
      getStoreJsonSerializebleConverter<MiniShoppingCartModel>(),
  List<MiniShoppingCartModel>: getListConverter<MiniShoppingCartModel>(),
  ApiResponse<MiniShoppingCartModel>:
      getApiResponseConverter<MiniShoppingCartModel>(),
  ApiResponse<List<MiniShoppingCartModel>>:
      getListApiResponseConverter<MiniShoppingCartModel>(),
  AnonymousType_A25E79E1:
      getStoreJsonSerializebleConverter<AnonymousType_A25E79E1>(),
  List<AnonymousType_A25E79E1>: getListConverter<AnonymousType_A25E79E1>(),
  ApiResponse<AnonymousType_A25E79E1>:
      getApiResponseConverter<AnonymousType_A25E79E1>(),
  ApiResponse<List<AnonymousType_A25E79E1>>:
      getListApiResponseConverter<AnonymousType_A25E79E1>(),
  AnonymousType_5F706788:
      getStoreJsonSerializebleConverter<AnonymousType_5F706788>(),
  List<AnonymousType_5F706788>: getListConverter<AnonymousType_5F706788>(),
  ApiResponse<AnonymousType_5F706788>:
      getApiResponseConverter<AnonymousType_5F706788>(),
  ApiResponse<List<AnonymousType_5F706788>>:
      getListApiResponseConverter<AnonymousType_5F706788>(),
  ShoppingCartModel: getStoreJsonSerializebleConverter<ShoppingCartModel>(),
  List<ShoppingCartModel>: getListConverter<ShoppingCartModel>(),
  ApiResponse<ShoppingCartModel>: getApiResponseConverter<ShoppingCartModel>(),
  ApiResponse<List<ShoppingCartModel>>:
      getListApiResponseConverter<ShoppingCartModel>(),
  OrderTotalsModel: getStoreJsonSerializebleConverter<OrderTotalsModel>(),
  List<OrderTotalsModel>: getListConverter<OrderTotalsModel>(),
  ApiResponse<OrderTotalsModel>: getApiResponseConverter<OrderTotalsModel>(),
  ApiResponse<List<OrderTotalsModel>>:
      getListApiResponseConverter<OrderTotalsModel>(),
  AnonymousType_6F488518:
      getStoreJsonSerializebleConverter<AnonymousType_6F488518>(),
  List<AnonymousType_6F488518>: getListConverter<AnonymousType_6F488518>(),
  ApiResponse<AnonymousType_6F488518>:
      getApiResponseConverter<AnonymousType_6F488518>(),
  ApiResponse<List<AnonymousType_6F488518>>:
      getListApiResponseConverter<AnonymousType_6F488518>(),
  AnonymousType_845BADBC:
      getStoreJsonSerializebleConverter<AnonymousType_845BADBC>(),
  List<AnonymousType_845BADBC>: getListConverter<AnonymousType_845BADBC>(),
  ApiResponse<AnonymousType_845BADBC>:
      getApiResponseConverter<AnonymousType_845BADBC>(),
  ApiResponse<List<AnonymousType_845BADBC>>:
      getListApiResponseConverter<AnonymousType_845BADBC>(),
  AnonymousType_F96D6EB9:
      getStoreJsonSerializebleConverter<AnonymousType_F96D6EB9>(),
  List<AnonymousType_F96D6EB9>: getListConverter<AnonymousType_F96D6EB9>(),
  ApiResponse<AnonymousType_F96D6EB9>:
      getApiResponseConverter<AnonymousType_F96D6EB9>(),
  ApiResponse<List<AnonymousType_F96D6EB9>>:
      getListApiResponseConverter<AnonymousType_F96D6EB9>(),
  AnonymousType_EF661507:
      getStoreJsonSerializebleConverter<AnonymousType_EF661507>(),
  List<AnonymousType_EF661507>: getListConverter<AnonymousType_EF661507>(),
  ApiResponse<AnonymousType_EF661507>:
      getApiResponseConverter<AnonymousType_EF661507>(),
  ApiResponse<List<AnonymousType_EF661507>>:
      getListApiResponseConverter<AnonymousType_EF661507>(),
  CheckoutAttributeSelectedModel:
      getStoreJsonSerializebleConverter<CheckoutAttributeSelectedModel>(),
  List<CheckoutAttributeSelectedModel>:
      getListConverter<CheckoutAttributeSelectedModel>(),
  ApiResponse<CheckoutAttributeSelectedModel>:
      getApiResponseConverter<CheckoutAttributeSelectedModel>(),
  ApiResponse<List<CheckoutAttributeSelectedModel>>:
      getListApiResponseConverter<CheckoutAttributeSelectedModel>(),
  UpdateQuantityModel: getStoreJsonSerializebleConverter<UpdateQuantityModel>(),
  List<UpdateQuantityModel>: getListConverter<UpdateQuantityModel>(),
  ApiResponse<UpdateQuantityModel>:
      getApiResponseConverter<UpdateQuantityModel>(),
  ApiResponse<List<UpdateQuantityModel>>:
      getListApiResponseConverter<UpdateQuantityModel>(),
  DeleteCartItemModel: getStoreJsonSerializebleConverter<DeleteCartItemModel>(),
  List<DeleteCartItemModel>: getListConverter<DeleteCartItemModel>(),
  ApiResponse<DeleteCartItemModel>:
      getApiResponseConverter<DeleteCartItemModel>(),
  ApiResponse<List<DeleteCartItemModel>>:
      getListApiResponseConverter<DeleteCartItemModel>(),
  ChangeTypeCartItemModel:
      getStoreJsonSerializebleConverter<ChangeTypeCartItemModel>(),
  List<ChangeTypeCartItemModel>: getListConverter<ChangeTypeCartItemModel>(),
  ApiResponse<ChangeTypeCartItemModel>:
      getApiResponseConverter<ChangeTypeCartItemModel>(),
  ApiResponse<List<ChangeTypeCartItemModel>>:
      getListApiResponseConverter<ChangeTypeCartItemModel>(),
  DiscountCouponModel: getStoreJsonSerializebleConverter<DiscountCouponModel>(),
  List<DiscountCouponModel>: getListConverter<DiscountCouponModel>(),
  ApiResponse<DiscountCouponModel>:
      getApiResponseConverter<DiscountCouponModel>(),
  ApiResponse<List<DiscountCouponModel>>:
      getListApiResponseConverter<DiscountCouponModel>(),
  GiftVoucherCouponModel:
      getStoreJsonSerializebleConverter<GiftVoucherCouponModel>(),
  List<GiftVoucherCouponModel>: getListConverter<GiftVoucherCouponModel>(),
  ApiResponse<GiftVoucherCouponModel>:
      getApiResponseConverter<GiftVoucherCouponModel>(),
  ApiResponse<List<GiftVoucherCouponModel>>:
      getListApiResponseConverter<GiftVoucherCouponModel>(),
  EstimateShippingModel:
      getStoreJsonSerializebleConverter<EstimateShippingModel>(),
  List<EstimateShippingModel>: getListConverter<EstimateShippingModel>(),
  ApiResponse<EstimateShippingModel>:
      getApiResponseConverter<EstimateShippingModel>(),
  ApiResponse<List<EstimateShippingModel>>:
      getListApiResponseConverter<EstimateShippingModel>(),
  CustomerMerchandiseReturnsModel:
      getStoreJsonSerializebleConverter<CustomerMerchandiseReturnsModel>(),
  List<CustomerMerchandiseReturnsModel>:
      getListConverter<CustomerMerchandiseReturnsModel>(),
  ApiResponse<CustomerMerchandiseReturnsModel>:
      getApiResponseConverter<CustomerMerchandiseReturnsModel>(),
  ApiResponse<List<CustomerMerchandiseReturnsModel>>:
      getListApiResponseConverter<CustomerMerchandiseReturnsModel>(),
  MerchandiseReturnModel:
      getStoreJsonSerializebleConverter<MerchandiseReturnModel>(),
  List<MerchandiseReturnModel>: getListConverter<MerchandiseReturnModel>(),
  ApiResponse<MerchandiseReturnModel>:
      getApiResponseConverter<MerchandiseReturnModel>(),
  ApiResponse<List<MerchandiseReturnModel>>:
      getListApiResponseConverter<MerchandiseReturnModel>(),
  MerchandiseReturnDetailsModel:
      getStoreJsonSerializebleConverter<MerchandiseReturnDetailsModel>(),
  List<MerchandiseReturnDetailsModel>:
      getListConverter<MerchandiseReturnDetailsModel>(),
  ApiResponse<MerchandiseReturnDetailsModel>:
      getApiResponseConverter<MerchandiseReturnDetailsModel>(),
  ApiResponse<List<MerchandiseReturnDetailsModel>>:
      getListApiResponseConverter<MerchandiseReturnDetailsModel>(),
  ApplyVendorModel: getStoreJsonSerializebleConverter<ApplyVendorModel>(),
  List<ApplyVendorModel>: getListConverter<ApplyVendorModel>(),
  ApiResponse<ApplyVendorModel>: getApiResponseConverter<ApplyVendorModel>(),
  ApiResponse<List<ApplyVendorModel>>:
      getListApiResponseConverter<ApplyVendorModel>(),
  ContactVendorModel: getStoreJsonSerializebleConverter<ContactVendorModel>(),
  List<ContactVendorModel>: getListConverter<ContactVendorModel>(),
  ApiResponse<ContactVendorModel>:
      getApiResponseConverter<ContactVendorModel>(),
  ApiResponse<List<ContactVendorModel>>:
      getListApiResponseConverter<ContactVendorModel>(),
  ContactUsModel: getStoreJsonSerializebleConverter<ContactUsModel>(),
  List<ContactUsModel>: getListConverter<ContactUsModel>(),
  ApiResponse<ContactUsModel>: getApiResponseConverter<ContactUsModel>(),
  ApiResponse<List<ContactUsModel>>:
      getListApiResponseConverter<ContactUsModel>(),
  AnonymousType_84F04ECC:
      getStoreJsonSerializebleConverter<AnonymousType_84F04ECC>(),
  List<AnonymousType_84F04ECC>: getListConverter<AnonymousType_84F04ECC>(),
  ApiResponse<AnonymousType_84F04ECC>:
      getApiResponseConverter<AnonymousType_84F04ECC>(),
  ApiResponse<List<AnonymousType_84F04ECC>>:
      getListApiResponseConverter<AnonymousType_84F04ECC>(),
  ContactAttributeChangeModel:
      getStoreJsonSerializebleConverter<ContactAttributeChangeModel>(),
  List<ContactAttributeChangeModel>:
      getListConverter<ContactAttributeChangeModel>(),
  ApiResponse<ContactAttributeChangeModel>:
      getApiResponseConverter<ContactAttributeChangeModel>(),
  ApiResponse<List<ContactAttributeChangeModel>>:
      getListApiResponseConverter<ContactAttributeChangeModel>(),
  AnonymousType_F3E1E574:
      getStoreJsonSerializebleConverter<AnonymousType_F3E1E574>(),
  List<AnonymousType_F3E1E574>: getListConverter<AnonymousType_F3E1E574>(),
  ApiResponse<AnonymousType_F3E1E574>:
      getApiResponseConverter<AnonymousType_F3E1E574>(),
  ApiResponse<List<AnonymousType_F3E1E574>>:
      getListApiResponseConverter<AnonymousType_F3E1E574>(),
  CustomerOutOfStockSubscriptionsModel:
      getStoreJsonSerializebleConverter<CustomerOutOfStockSubscriptionsModel>(),
  List<CustomerOutOfStockSubscriptionsModel>:
      getListConverter<CustomerOutOfStockSubscriptionsModel>(),
  ApiResponse<CustomerOutOfStockSubscriptionsModel>:
      getApiResponseConverter<CustomerOutOfStockSubscriptionsModel>(),
  ApiResponse<List<CustomerOutOfStockSubscriptionsModel>>:
      getListApiResponseConverter<CustomerOutOfStockSubscriptionsModel>(),
  ProductModel: getStoreJsonSerializebleConverter<ProductModel>(),
  List<ProductModel>: getListConverter<ProductModel>(),
  ApiResponse<ProductModel>: getApiResponseConverter<ProductModel>(),
  ApiResponse<List<ProductModel>>: getListApiResponseConverter<ProductModel>(),
  KnowledgebaseHomePageModel:
      getStoreJsonSerializebleConverter<KnowledgebaseHomePageModel>(),
  List<KnowledgebaseHomePageModel>:
      getListConverter<KnowledgebaseHomePageModel>(),
  ApiResponse<KnowledgebaseHomePageModel>:
      getApiResponseConverter<KnowledgebaseHomePageModel>(),
  ApiResponse<List<KnowledgebaseHomePageModel>>:
      getListApiResponseConverter<KnowledgebaseHomePageModel>(),
  KnowledgebaseArticleModel:
      getStoreJsonSerializebleConverter<KnowledgebaseArticleModel>(),
  List<KnowledgebaseArticleModel>:
      getListConverter<KnowledgebaseArticleModel>(),
  ApiResponse<KnowledgebaseArticleModel>:
      getApiResponseConverter<KnowledgebaseArticleModel>(),
  ApiResponse<List<KnowledgebaseArticleModel>>:
      getListApiResponseConverter<KnowledgebaseArticleModel>(),
  AnonymousType_97C14FD8:
      getStoreJsonSerializebleConverter<AnonymousType_97C14FD8>(),
  List<AnonymousType_97C14FD8>: getListConverter<AnonymousType_97C14FD8>(),
  ApiResponse<AnonymousType_97C14FD8>:
      getApiResponseConverter<AnonymousType_97C14FD8>(),
  ApiResponse<List<AnonymousType_97C14FD8>>:
      getListApiResponseConverter<AnonymousType_97C14FD8>(),
  AnonymousType_01FA76B1:
      getStoreJsonSerializebleConverter<AnonymousType_01FA76B1>(),
  List<AnonymousType_01FA76B1>: getListConverter<AnonymousType_01FA76B1>(),
  ApiResponse<AnonymousType_01FA76B1>:
      getApiResponseConverter<AnonymousType_01FA76B1>(),
  ApiResponse<List<AnonymousType_01FA76B1>>:
      getListApiResponseConverter<AnonymousType_01FA76B1>(),
  ProductCatalogCart: getStoreJsonSerializebleConverter<ProductCatalogCart>(),
  List<ProductCatalogCart>: getListConverter<ProductCatalogCart>(),
  ApiResponse<ProductCatalogCart>:
      getApiResponseConverter<ProductCatalogCart>(),
  ApiResponse<List<ProductCatalogCart>>:
      getListApiResponseConverter<ProductCatalogCart>(),
  ProductDetailsCart: getStoreJsonSerializebleConverter<ProductDetailsCart>(),
  List<ProductDetailsCart>: getListConverter<ProductDetailsCart>(),
  ApiResponse<ProductDetailsCart>:
      getApiResponseConverter<ProductDetailsCart>(),
  ApiResponse<List<ProductDetailsCart>>:
      getListApiResponseConverter<ProductDetailsCart>(),
  AddBidModel: getStoreJsonSerializebleConverter<AddBidModel>(),
  List<AddBidModel>: getListConverter<AddBidModel>(),
  ApiResponse<AddBidModel>: getApiResponseConverter<AddBidModel>(),
  ApiResponse<List<AddBidModel>>: getListApiResponseConverter<AddBidModel>(),
  CourseModel: getStoreJsonSerializebleConverter<CourseModel>(),
  List<CourseModel>: getListConverter<CourseModel>(),
  ApiResponse<CourseModel>: getApiResponseConverter<CourseModel>(),
  ApiResponse<List<CourseModel>>: getListApiResponseConverter<CourseModel>(),
  LessonModel: getStoreJsonSerializebleConverter<LessonModel>(),
  List<LessonModel>: getListConverter<LessonModel>(),
  ApiResponse<LessonModel>: getApiResponseConverter<LessonModel>(),
  ApiResponse<List<LessonModel>>: getListApiResponseConverter<LessonModel>(),
  AnonymousType_3037AB66:
      getStoreJsonSerializebleConverter<AnonymousType_3037AB66>(),
  List<AnonymousType_3037AB66>: getListConverter<AnonymousType_3037AB66>(),
  ApiResponse<AnonymousType_3037AB66>:
      getApiResponseConverter<AnonymousType_3037AB66>(),
  ApiResponse<List<AnonymousType_3037AB66>>:
      getListApiResponseConverter<AnonymousType_3037AB66>(),
  NewsItemListModel: getStoreJsonSerializebleConverter<NewsItemListModel>(),
  List<NewsItemListModel>: getListConverter<NewsItemListModel>(),
  ApiResponse<NewsItemListModel>: getApiResponseConverter<NewsItemListModel>(),
  ApiResponse<List<NewsItemListModel>>:
      getListApiResponseConverter<NewsItemListModel>(),
  NewsItemModel: getStoreJsonSerializebleConverter<NewsItemModel>(),
  List<NewsItemModel>: getListConverter<NewsItemModel>(),
  ApiResponse<NewsItemModel>: getApiResponseConverter<NewsItemModel>(),
  ApiResponse<List<NewsItemModel>>:
      getListApiResponseConverter<NewsItemModel>(),
  AnonymousType_03AD2C00:
      getStoreJsonSerializebleConverter<AnonymousType_03AD2C00>(),
  List<AnonymousType_03AD2C00>: getListConverter<AnonymousType_03AD2C00>(),
  ApiResponse<AnonymousType_03AD2C00>:
      getApiResponseConverter<AnonymousType_03AD2C00>(),
  ApiResponse<List<AnonymousType_03AD2C00>>:
      getListApiResponseConverter<AnonymousType_03AD2C00>(),
  NewsPagingFilteringModel:
      getStoreJsonSerializebleConverter<NewsPagingFilteringModel>(),
  List<NewsPagingFilteringModel>: getListConverter<NewsPagingFilteringModel>(),
  ApiResponse<NewsPagingFilteringModel>:
      getApiResponseConverter<NewsPagingFilteringModel>(),
  ApiResponse<List<NewsPagingFilteringModel>>:
      getListApiResponseConverter<NewsPagingFilteringModel>(),
  AddNewsCommentModel: getStoreJsonSerializebleConverter<AddNewsCommentModel>(),
  List<AddNewsCommentModel>: getListConverter<AddNewsCommentModel>(),
  ApiResponse<AddNewsCommentModel>:
      getApiResponseConverter<AddNewsCommentModel>(),
  ApiResponse<List<AddNewsCommentModel>>:
      getListApiResponseConverter<AddNewsCommentModel>(),
  MiniWishlistModel: getStoreJsonSerializebleConverter<MiniWishlistModel>(),
  List<MiniWishlistModel>: getListConverter<MiniWishlistModel>(),
  ApiResponse<MiniWishlistModel>: getApiResponseConverter<MiniWishlistModel>(),
  ApiResponse<List<MiniWishlistModel>>:
      getListApiResponseConverter<MiniWishlistModel>(),
  WishlistModel: getStoreJsonSerializebleConverter<WishlistModel>(),
  List<WishlistModel>: getListConverter<WishlistModel>(),
  ApiResponse<WishlistModel>: getApiResponseConverter<WishlistModel>(),
  ApiResponse<List<WishlistModel>>:
      getListApiResponseConverter<WishlistModel>(),
  AnonymousType_2FEC469E:
      getStoreJsonSerializebleConverter<AnonymousType_2FEC469E>(),
  List<AnonymousType_2FEC469E>: getListConverter<AnonymousType_2FEC469E>(),
  ApiResponse<AnonymousType_2FEC469E>:
      getApiResponseConverter<AnonymousType_2FEC469E>(),
  ApiResponse<List<AnonymousType_2FEC469E>>:
      getListApiResponseConverter<AnonymousType_2FEC469E>(),
  WishlistEmailAFriendModel:
      getStoreJsonSerializebleConverter<WishlistEmailAFriendModel>(),
  List<WishlistEmailAFriendModel>:
      getListConverter<WishlistEmailAFriendModel>(),
  ApiResponse<WishlistEmailAFriendModel>:
      getApiResponseConverter<WishlistEmailAFriendModel>(),
  ApiResponse<List<WishlistEmailAFriendModel>>:
      getListApiResponseConverter<WishlistEmailAFriendModel>(),
  AddCartFromWishlistModel:
      getStoreJsonSerializebleConverter<AddCartFromWishlistModel>(),
  List<AddCartFromWishlistModel>: getListConverter<AddCartFromWishlistModel>(),
  ApiResponse<AddCartFromWishlistModel>:
      getApiResponseConverter<AddCartFromWishlistModel>(),
  ApiResponse<List<AddCartFromWishlistModel>>:
      getListApiResponseConverter<AddCartFromWishlistModel>(),
  ProductOverviewModel:
      getStoreJsonSerializebleConverter<ProductOverviewModel>(),
  List<ProductOverviewModel>: getListConverter<ProductOverviewModel>(),
  ApiResponse<ProductOverviewModel>:
      getApiResponseConverter<ProductOverviewModel>(),
  ApiResponse<List<ProductOverviewModel>>:
      getListApiResponseConverter<ProductOverviewModel>(),
  ProductEmailAFriendModel:
      getStoreJsonSerializebleConverter<ProductEmailAFriendModel>(),
  List<ProductEmailAFriendModel>: getListConverter<ProductEmailAFriendModel>(),
  ApiResponse<ProductEmailAFriendModel>:
      getApiResponseConverter<ProductEmailAFriendModel>(),
  ApiResponse<List<ProductEmailAFriendModel>>:
      getListApiResponseConverter<ProductEmailAFriendModel>(),
  ProductDetailsModel: getStoreJsonSerializebleConverter<ProductDetailsModel>(),
  List<ProductDetailsModel>: getListConverter<ProductDetailsModel>(),
  ApiResponse<ProductDetailsModel>:
      getApiResponseConverter<ProductDetailsModel>(),
  ApiResponse<List<ProductDetailsModel>>:
      getListApiResponseConverter<ProductDetailsModel>(),
  AnonymousType_0327C72F:
      getStoreJsonSerializebleConverter<AnonymousType_0327C72F>(),
  List<AnonymousType_0327C72F>: getListConverter<AnonymousType_0327C72F>(),
  ApiResponse<AnonymousType_0327C72F>:
      getApiResponseConverter<AnonymousType_0327C72F>(),
  ApiResponse<List<AnonymousType_0327C72F>>:
      getListApiResponseConverter<AnonymousType_0327C72F>(),
  AnonymousType_262F1F09:
      getStoreJsonSerializebleConverter<AnonymousType_262F1F09>(),
  List<AnonymousType_262F1F09>: getListConverter<AnonymousType_262F1F09>(),
  ApiResponse<AnonymousType_262F1F09>:
      getApiResponseConverter<AnonymousType_262F1F09>(),
  ApiResponse<List<AnonymousType_262F1F09>>:
      getListApiResponseConverter<AnonymousType_262F1F09>(),
  ProductReviewsModel: getStoreJsonSerializebleConverter<ProductReviewsModel>(),
  List<ProductReviewsModel>: getListConverter<ProductReviewsModel>(),
  ApiResponse<ProductReviewsModel>:
      getApiResponseConverter<ProductReviewsModel>(),
  ApiResponse<List<ProductReviewsModel>>:
      getListApiResponseConverter<ProductReviewsModel>(),
  CompareProductsModel:
      getStoreJsonSerializebleConverter<CompareProductsModel>(),
  List<CompareProductsModel>: getListConverter<CompareProductsModel>(),
  ApiResponse<CompareProductsModel>:
      getApiResponseConverter<CompareProductsModel>(),
  ApiResponse<List<CompareProductsModel>>:
      getListApiResponseConverter<CompareProductsModel>(),
  ProductAskQuestionSimpleModel:
      getStoreJsonSerializebleConverter<ProductAskQuestionSimpleModel>(),
  List<ProductAskQuestionSimpleModel>:
      getListConverter<ProductAskQuestionSimpleModel>(),
  ApiResponse<ProductAskQuestionSimpleModel>:
      getApiResponseConverter<ProductAskQuestionSimpleModel>(),
  ApiResponse<List<ProductAskQuestionSimpleModel>>:
      getListApiResponseConverter<ProductAskQuestionSimpleModel>(),
  InstallModel: getStoreJsonSerializebleConverter<InstallModel>(),
  List<InstallModel>: getListConverter<InstallModel>(),
  ApiResponse<InstallModel>: getApiResponseConverter<InstallModel>(),
  ApiResponse<List<InstallModel>>: getListApiResponseConverter<InstallModel>(),
  SitemapModel: getStoreJsonSerializebleConverter<SitemapModel>(),
  List<SitemapModel>: getListConverter<SitemapModel>(),
  ApiResponse<SitemapModel>: getApiResponseConverter<SitemapModel>(),
  ApiResponse<List<SitemapModel>>: getListApiResponseConverter<SitemapModel>(),
  AnonymousType_B6395690:
      getStoreJsonSerializebleConverter<AnonymousType_B6395690>(),
  List<AnonymousType_B6395690>: getListConverter<AnonymousType_B6395690>(),
  ApiResponse<AnonymousType_B6395690>:
      getApiResponseConverter<AnonymousType_B6395690>(),
  ApiResponse<List<AnonymousType_B6395690>>:
      getListApiResponseConverter<AnonymousType_B6395690>(),
  AnonymousType_343F9E63:
      getStoreJsonSerializebleConverter<AnonymousType_343F9E63>(),
  List<AnonymousType_343F9E63>: getListConverter<AnonymousType_343F9E63>(),
  ApiResponse<AnonymousType_343F9E63>:
      getApiResponseConverter<AnonymousType_343F9E63>(),
  ApiResponse<List<AnonymousType_343F9E63>>:
      getListApiResponseConverter<AnonymousType_343F9E63>(),
  LocationModel: getStoreJsonSerializebleConverter<LocationModel>(),
  List<LocationModel>: getListConverter<LocationModel>(),
  ApiResponse<LocationModel>: getApiResponseConverter<LocationModel>(),
  ApiResponse<List<LocationModel>>:
      getListApiResponseConverter<LocationModel>(),
  PublicInfoModel: getStoreJsonSerializebleConverter<PublicInfoModel>(),
  List<PublicInfoModel>: getListConverter<PublicInfoModel>(),
  ApiResponse<PublicInfoModel>: getApiResponseConverter<PublicInfoModel>(),
  ApiResponse<List<PublicInfoModel>>:
      getListApiResponseConverter<PublicInfoModel>(),
  Slider: getStoreJsonSerializebleConverter<Slider>(),
  List<Slider>: getListConverter<Slider>(),
  ApiResponse<Slider>: getApiResponseConverter<Slider>(),
  ApiResponse<List<Slider>>: getListApiResponseConverter<Slider>(),
  CustomerNavigationModel:
      getStoreJsonSerializebleConverter<CustomerNavigationModel>(),
  List<CustomerNavigationModel>: getListConverter<CustomerNavigationModel>(),
  ApiResponse<CustomerNavigationModel>:
      getApiResponseConverter<CustomerNavigationModel>(),
  ApiResponse<List<CustomerNavigationModel>>:
      getListApiResponseConverter<CustomerNavigationModel>(),
  CheckoutStepResponse:
      getStoreJsonSerializebleConverter<CheckoutStepResponse>(),
  List<CheckoutStepResponse>: getListConverter<CheckoutStepResponse>(),
  ApiResponse<CheckoutStepResponse>:
      getApiResponseConverter<CheckoutStepResponse>(),
  ApiResponse<List<CheckoutStepResponse>>:
      getListApiResponseConverter<CheckoutStepResponse>(),
  CheckoutConfirmModel:
      getStoreJsonSerializebleConverter<CheckoutConfirmModel>(),
  List<CheckoutConfirmModel>: getListConverter<CheckoutConfirmModel>(),
  ApiResponse<CheckoutConfirmModel>:
      getApiResponseConverter<CheckoutConfirmModel>(),
  ApiResponse<List<CheckoutConfirmModel>>:
      getListApiResponseConverter<CheckoutConfirmModel>(),
  StateProvinceModel: getStoreJsonSerializebleConverter<StateProvinceModel>(),
  List<StateProvinceModel>: getListConverter<StateProvinceModel>(),
  ApiResponse<StateProvinceModel>:
      getApiResponseConverter<StateProvinceModel>(),
  ApiResponse<List<StateProvinceModel>>:
      getListApiResponseConverter<StateProvinceModel>(),
  FooterModel: getStoreJsonSerializebleConverter<FooterModel>(),
  List<FooterModel>: getListConverter<FooterModel>(),
  ApiResponse<FooterModel>: getApiResponseConverter<FooterModel>(),
  ApiResponse<List<FooterModel>>: getListApiResponseConverter<FooterModel>(),
  LegalTextMessageTemplateComponentModel:
      getStoreJsonSerializebleConverter<
        LegalTextMessageTemplateComponentModel
      >(),
  List<LegalTextMessageTemplateComponentModel>:
      getListConverter<LegalTextMessageTemplateComponentModel>(),
  ApiResponse<LegalTextMessageTemplateComponentModel>:
      getApiResponseConverter<LegalTextMessageTemplateComponentModel>(),
  ApiResponse<List<LegalTextMessageTemplateComponentModel>>:
      getListApiResponseConverter<LegalTextMessageTemplateComponentModel>(),
  customer_order_list_model.OrderDetailsModel:
      getStoreJsonSerializebleConverter<
        customer_order_list_model.OrderDetailsModel
      >(),
  List<customer_order_list_model.OrderDetailsModel>:
      getListConverter<customer_order_list_model.OrderDetailsModel>(),
  ApiResponse<customer_order_list_model.OrderDetailsModel>:
      getApiResponseConverter<customer_order_list_model.OrderDetailsModel>(),
  ApiResponse<List<customer_order_list_model.OrderDetailsModel>>:
      getListApiResponseConverter<
        customer_order_list_model.OrderDetailsModel
      >(),
  ICaptchaValidModel: getStoreJsonSerializebleConverter<ICaptchaValidModel>(),
  List<ICaptchaValidModel>: getListConverter<ICaptchaValidModel>(),
  ApiResponse<ICaptchaValidModel>:
      getApiResponseConverter<ICaptchaValidModel>(),
  ApiResponse<List<ICaptchaValidModel>>:
      getListApiResponseConverter<ICaptchaValidModel>(),
  LoginModel: getStoreJsonSerializebleConverter<LoginModel>(),
  List<LoginModel>: getListConverter<LoginModel>(),
  ApiResponse<LoginModel>: getApiResponseConverter<LoginModel>(),
  ApiResponse<List<LoginModel>>: getListApiResponseConverter<LoginModel>(),

  QueuedEmail: getStoreJsonSerializebleConverter<QueuedEmail>(),
  List<QueuedEmail>: getListConverter<QueuedEmail>(),
  ApiResponse<QueuedEmail>: getApiResponseConverter<QueuedEmail>(),
  ApiResponse<List<QueuedEmail>>: getListApiResponseConverter<QueuedEmail>(),

  NotificationListResponse:
      getStoreJsonSerializebleConverter<NotificationListResponse>(),
  List<NotificationListResponse>: getListConverter<NotificationListResponse>(),
  ApiResponse<NotificationListResponse>:
      getApiResponseConverter<NotificationListResponse>(),
  ApiResponse<List<NotificationListResponse>>:
      getListApiResponseConverter<NotificationListResponse>(),

  NotificationDetailResponse:
      getStoreJsonSerializebleConverter<NotificationDetailResponse>(),
  List<NotificationDetailResponse>:
      getListConverter<NotificationDetailResponse>(),
  ApiResponse<NotificationDetailResponse>:
      getApiResponseConverter<NotificationDetailResponse>(),
  ApiResponse<List<NotificationDetailResponse>>:
      getListApiResponseConverter<NotificationDetailResponse>(),

  CartSummaryDto: getStoreJsonSerializebleConverter<CartSummaryDto>(),
  List<CartSummaryDto>: getListConverter<CartSummaryDto>(),
  ApiResponse<CartSummaryDto>: getApiResponseConverter<CartSummaryDto>(),
  ApiResponse<List<CartSummaryDto>>:
      getListApiResponseConverter<CartSummaryDto>(),

  FreeShippingInfoDto: getStoreJsonSerializebleConverter<FreeShippingInfoDto>(),
  List<FreeShippingInfoDto>: getListConverter<FreeShippingInfoDto>(),
  ApiResponse<FreeShippingInfoDto>:
      getApiResponseConverter<FreeShippingInfoDto>(),
  ApiResponse<List<FreeShippingInfoDto>>:
      getListApiResponseConverter<FreeShippingInfoDto>(),

  MinimumOrderInfoDto: getStoreJsonSerializebleConverter<MinimumOrderInfoDto>(),
  List<MinimumOrderInfoDto>: getListConverter<MinimumOrderInfoDto>(),
  ApiResponse<MinimumOrderInfoDto>:
      getApiResponseConverter<MinimumOrderInfoDto>(),
  ApiResponse<List<MinimumOrderInfoDto>>:
      getListApiResponseConverter<MinimumOrderInfoDto>(),

  ShoppingCartInfoResponse:
      getStoreJsonSerializebleConverter<ShoppingCartInfoResponse>(),
  List<ShoppingCartInfoResponse>: getListConverter<ShoppingCartInfoResponse>(),
  ApiResponse<ShoppingCartInfoResponse>:
      getApiResponseConverter<ShoppingCartInfoResponse>(),
  ApiResponse<List<ShoppingCartInfoResponse>>:
      getListApiResponseConverter<ShoppingCartInfoResponse>(),
};
