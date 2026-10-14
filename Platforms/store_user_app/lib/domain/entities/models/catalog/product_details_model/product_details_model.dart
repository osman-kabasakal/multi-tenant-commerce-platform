import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../media/picture_model/picture_model.dart';

import '../../../catalog/product_type/product_type.dart';

import '../brand_brief_info_model/brand_brief_info_model.dart';

import '../vendor_brief_info_model/vendor_brief_info_model.dart';

import 'gift_voucher_model/gift_voucher_model.dart';

import 'product_warehouse_model/product_warehouse_model.dart';

import '../../../catalog/interval_unit/interval_unit.dart';

import '../../../microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';

import '../product_ask_question_simple_model/product_ask_question_simple_model.dart';

import 'product_price_model/product_price_model.dart';

import 'add_to_cart_model/add_to_cart_model.dart';

import 'product_breadcrumb_model/product_breadcrumb_model.dart';

import '../product_tag_model/product_tag_model.dart';

import 'product_attribute_model/product_attribute_model.dart';

import '../product_specification_model/product_specification_model.dart';

import '../collection_model/collection_model.dart';

import '../product_review_overview_model/product_review_overview_model.dart';

import 'tier_price_model/tier_price_model.dart';

import 'product_bundle_model/product_bundle_model.dart';

import '../../../common/user_field/user_field.dart';

part 'product_details_model.freezed.dart';
part 'product_details_model.g.dart';

@freezed
class ProductDetailsModel extends StoreJsonSerializable<ProductDetailsModel>
    with _$ProductDetailsModel {
  factory ProductDetailsModel(
      {@JsonKey(name: 'DefaultPictureZoomEnabled', includeIfNull: false)
      @Default(false)
      bool? defaultPictureZoomEnabled,
      @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
      PictureModel? defaultPictureModel,
      @JsonKey(name: 'PictureModels', includeIfNull: false)
      @Default([])
      List<PictureModel>? pictureModels,
      @JsonKey(name: 'ProductType', includeIfNull: false)
      @Default(ProductType.simpleProduct)
      ProductType? productType,
      @JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'ShortDescription', includeIfNull: false)
      String? shortDescription,
      @JsonKey(name: 'FullDescription', includeIfNull: false)
      String? fullDescription,
      @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
      @JsonKey(name: 'MetaDescription', includeIfNull: false)
      String? metaDescription,
      @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'ShowSku', includeIfNull: false)
      @Default(false)
      bool? showSku,
      @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
      @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
      @JsonKey(name: 'ShowMpn', includeIfNull: false)
      @Default(false)
      bool? showMpn,
      @JsonKey(name: 'Mpn', includeIfNull: false) String? mpn,
      @JsonKey(name: 'ShowGtin', includeIfNull: false)
      @Default(false)
      bool? showGtin,
      @JsonKey(name: 'Gtin', includeIfNull: false) String? gtin,
      @JsonKey(name: 'BrandModel', includeIfNull: false)
      BrandBriefInfoModel? brandModel,
      @JsonKey(name: 'ShowVendor', includeIfNull: false)
      @Default(false)
      bool? showVendor,
      @JsonKey(name: 'VendorModel', includeIfNull: false)
      VendorBriefInfoModel? vendorModel,
      @JsonKey(name: 'HasSampleDownload', includeIfNull: false)
      @Default(false)
      bool? hasSampleDownload,
      @JsonKey(name: 'GiftVoucher', includeIfNull: false)
      GiftVoucherModel? giftVoucher,
      @JsonKey(name: 'IsShipEnabled', includeIfNull: false)
      @Default(false)
      bool? isShipEnabled,
      @JsonKey(name: 'NotReturnable', includeIfNull: false)
      @Default(false)
      bool? notReturnable,
      @JsonKey(name: 'IsFreeShipping', includeIfNull: false)
      @Default(false)
      bool? isFreeShipping,
      @JsonKey(name: 'AllowToSelectWarehouse', includeIfNull: false)
      @Default(false)
      bool? allowToSelectWarehouse,
      @JsonKey(name: 'ProductWarehouses', includeIfNull: false)
      @Default([])
      List<ProductWarehouseModel>? productWarehouses,
      @JsonKey(name: 'AdditionalShippingCharge', includeIfNull: false)
      double? additionalShippingCharge,
      @JsonKey(name: 'AdditionalShippingChargeStr', includeIfNull: false)
      String? additionalShippingChargeStr,
      @JsonKey(name: 'FreeShippingNotificationEnabled', includeIfNull: false)
      @Default(false)
      bool? freeShippingNotificationEnabled,
      @JsonKey(name: 'DeliveryDate', includeIfNull: false) String? deliveryDate,
      @JsonKey(name: 'DeliveryColorSquaresRgb', includeIfNull: false)
      String? deliveryColorSquaresRgb,
      @JsonKey(name: 'Interval', includeIfNull: false) int? interval,
      @JsonKey(name: 'IntervalUnit', includeIfNull: false)
      @Default(IntervalUnit.minute)
      IntervalUnit? intervalUnit,
      @JsonKey(name: 'IncBothDate', includeIfNull: false)
      @Default(false)
      bool? incBothDate,
      @JsonKey(name: 'Parameters', includeIfNull: false)
      @Default([])
      List<SelectListItem>? parameters,
      @JsonKey(name: 'StartDate', includeIfNull: false) DateTime? startDate,
      @JsonKey(name: 'RentalStartDateUtc', includeIfNull: false)
      @Default(null)
      DateTime? rentalStartDateUtc,
      @JsonKey(name: 'RentalEndDateUtc', includeIfNull: false)
      @Default(null)
      DateTime? rentalEndDateUtc,
      @JsonKey(name: 'RentalReservationId', includeIfNull: false)
      String? rentalReservationId,
      @JsonKey(name: 'StockAvailability', includeIfNull: false)
      String? stockAvailability,
      @JsonKey(name: 'DisplayOutOfStockSubscription', includeIfNull: false)
      @Default(false)
      bool? displayOutOfStockSubscription,
      @JsonKey(name: 'EmailAFriendEnabled', includeIfNull: false)
      @Default(false)
      bool? emailAFriendEnabled,
      @JsonKey(name: 'AskQuestionOnProduct', includeIfNull: false)
      @Default(false)
      bool? askQuestionOnProduct,
      @JsonKey(name: 'ProductAskQuestion', includeIfNull: false)
      ProductAskQuestionSimpleModel? productAskQuestion,
      @JsonKey(name: 'CompareProductsEnabled', includeIfNull: false)
      @Default(false)
      bool? compareProductsEnabled,
      @JsonKey(name: 'PageShareCode', includeIfNull: false)
      String? pageShareCode,
      @JsonKey(name: 'ProductPrice', includeIfNull: false)
      ProductPriceModel? productPrice,
      @JsonKey(name: 'AddToCart', includeIfNull: false)
      AddToCartModel? addToCart,
      @JsonKey(name: 'Breadcrumb', includeIfNull: false)
      ProductBreadcrumbModel? breadcrumb,
      @JsonKey(name: 'ProductTags', includeIfNull: false)
      @Default([])
      List<ProductTagModel>? productTags,
      @JsonKey(name: 'ProductAttributes', includeIfNull: false)
      @Default([])
      List<ProductAttributeModel>? productAttributes,
      @JsonKey(name: 'ProductSpecifications', includeIfNull: false)
      @Default([])
      List<ProductSpecificationModel>? productSpecifications,
      @JsonKey(name: 'ProductCollections', includeIfNull: false)
      @Default([])
      List<CollectionModel>? productCollections,
      @JsonKey(name: 'ProductReviewOverview', includeIfNull: false)
      ProductReviewOverviewModel? productReviewOverview,
      @JsonKey(name: 'TierPrices', includeIfNull: false)
      @Default([])
      List<TierPriceModel>? tierPrices,
      @JsonKey(name: 'AssociatedProducts', includeIfNull: false)
      @Default([])
      List<ProductDetailsModel>? associatedProducts,
      @JsonKey(name: 'ProductBundleModels', includeIfNull: false)
      @Default([])
      List<ProductBundleModel>? productBundleModels,
      @JsonKey(name: 'DisplayDiscontinuedMessage', includeIfNull: false)
      @Default(false)
      bool? displayDiscontinuedMessage,
      @JsonKey(name: 'CurrentStoreName', includeIfNull: false)
      String? currentStoreName,
      @JsonKey(name: 'StartPrice', includeIfNull: false) double? startPrice,
      @JsonKey(name: 'HighestBidValue', includeIfNull: false)
      double? highestBidValue,
      @JsonKey(name: 'EndTime', includeIfNull: false)
      @Default(null)
      DateTime? endTime,
      @JsonKey(name: 'EndTimeLocalTime', includeIfNull: false)
      @Default(null)
      DateTime? endTimeLocalTime,
      @JsonKey(name: 'AuctionEnded', includeIfNull: false)
      @Default(false)
      bool? auctionEnded,
      @JsonKey(name: 'RenderCaptcha', includeIfNull: false)
      @Default(false)
      bool? renderCaptcha,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductDetailsModel;

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsModelFromJson(json);
}
