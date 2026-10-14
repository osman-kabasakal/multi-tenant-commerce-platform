// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductDetailsModelImpl _$$ProductDetailsModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductDetailsModelImpl(
  defaultPictureZoomEnabled:
      json['DefaultPictureZoomEnabled'] as bool? ?? false,
  defaultPictureModel:
      json['DefaultPictureModel'] == null
          ? null
          : PictureModel.fromJson(
            json['DefaultPictureModel'] as Map<String, dynamic>,
          ),
  pictureModels:
      (json['PictureModels'] as List<dynamic>?)
          ?.map((e) => PictureModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  productType:
      $enumDecodeNullable(_$ProductTypeEnumMap, json['ProductType']) ??
      ProductType.simpleProduct,
  name: json['Name'] as String?,
  shortDescription: json['ShortDescription'] as String?,
  fullDescription: json['FullDescription'] as String?,
  metaKeywords: json['MetaKeywords'] as String?,
  metaDescription: json['MetaDescription'] as String?,
  metaTitle: json['MetaTitle'] as String?,
  seName: json['SeName'] as String?,
  showSku: json['ShowSku'] as bool? ?? false,
  sku: json['Sku'] as String?,
  flag: json['Flag'] as String?,
  showMpn: json['ShowMpn'] as bool? ?? false,
  mpn: json['Mpn'] as String?,
  showGtin: json['ShowGtin'] as bool? ?? false,
  gtin: json['Gtin'] as String?,
  brandModel:
      json['BrandModel'] == null
          ? null
          : BrandBriefInfoModel.fromJson(
            json['BrandModel'] as Map<String, dynamic>,
          ),
  showVendor: json['ShowVendor'] as bool? ?? false,
  vendorModel:
      json['VendorModel'] == null
          ? null
          : VendorBriefInfoModel.fromJson(
            json['VendorModel'] as Map<String, dynamic>,
          ),
  hasSampleDownload: json['HasSampleDownload'] as bool? ?? false,
  giftVoucher:
      json['GiftVoucher'] == null
          ? null
          : GiftVoucherModel.fromJson(
            json['GiftVoucher'] as Map<String, dynamic>,
          ),
  isShipEnabled: json['IsShipEnabled'] as bool? ?? false,
  notReturnable: json['NotReturnable'] as bool? ?? false,
  isFreeShipping: json['IsFreeShipping'] as bool? ?? false,
  allowToSelectWarehouse: json['AllowToSelectWarehouse'] as bool? ?? false,
  productWarehouses:
      (json['ProductWarehouses'] as List<dynamic>?)
          ?.map(
            (e) => ProductWarehouseModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  additionalShippingCharge:
      (json['AdditionalShippingCharge'] as num?)?.toDouble(),
  additionalShippingChargeStr: json['AdditionalShippingChargeStr'] as String?,
  freeShippingNotificationEnabled:
      json['FreeShippingNotificationEnabled'] as bool? ?? false,
  deliveryDate: json['DeliveryDate'] as String?,
  deliveryColorSquaresRgb: json['DeliveryColorSquaresRgb'] as String?,
  interval: (json['Interval'] as num?)?.toInt(),
  intervalUnit:
      $enumDecodeNullable(_$IntervalUnitEnumMap, json['IntervalUnit']) ??
      IntervalUnit.minute,
  incBothDate: json['IncBothDate'] as bool? ?? false,
  parameters:
      (json['Parameters'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  startDate:
      json['StartDate'] == null
          ? null
          : DateTime.parse(json['StartDate'] as String),
  rentalStartDateUtc:
      json['RentalStartDateUtc'] == null
          ? null
          : DateTime.parse(json['RentalStartDateUtc'] as String),
  rentalEndDateUtc:
      json['RentalEndDateUtc'] == null
          ? null
          : DateTime.parse(json['RentalEndDateUtc'] as String),
  rentalReservationId: json['RentalReservationId'] as String?,
  stockAvailability: json['StockAvailability'] as String?,
  displayOutOfStockSubscription:
      json['DisplayOutOfStockSubscription'] as bool? ?? false,
  emailAFriendEnabled: json['EmailAFriendEnabled'] as bool? ?? false,
  askQuestionOnProduct: json['AskQuestionOnProduct'] as bool? ?? false,
  productAskQuestion:
      json['ProductAskQuestion'] == null
          ? null
          : ProductAskQuestionSimpleModel.fromJson(
            json['ProductAskQuestion'] as Map<String, dynamic>,
          ),
  compareProductsEnabled: json['CompareProductsEnabled'] as bool? ?? false,
  pageShareCode: json['PageShareCode'] as String?,
  productPrice:
      json['ProductPrice'] == null
          ? null
          : ProductPriceModel.fromJson(
            json['ProductPrice'] as Map<String, dynamic>,
          ),
  addToCart:
      json['AddToCart'] == null
          ? null
          : AddToCartModel.fromJson(json['AddToCart'] as Map<String, dynamic>),
  breadcrumb:
      json['Breadcrumb'] == null
          ? null
          : ProductBreadcrumbModel.fromJson(
            json['Breadcrumb'] as Map<String, dynamic>,
          ),
  productTags:
      (json['ProductTags'] as List<dynamic>?)
          ?.map((e) => ProductTagModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  productAttributes:
      (json['ProductAttributes'] as List<dynamic>?)
          ?.map(
            (e) => ProductAttributeModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  productSpecifications:
      (json['ProductSpecifications'] as List<dynamic>?)
          ?.map(
            (e) =>
                ProductSpecificationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  productCollections:
      (json['ProductCollections'] as List<dynamic>?)
          ?.map((e) => CollectionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  productReviewOverview:
      json['ProductReviewOverview'] == null
          ? null
          : ProductReviewOverviewModel.fromJson(
            json['ProductReviewOverview'] as Map<String, dynamic>,
          ),
  tierPrices:
      (json['TierPrices'] as List<dynamic>?)
          ?.map((e) => TierPriceModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  associatedProducts:
      (json['AssociatedProducts'] as List<dynamic>?)
          ?.map((e) => ProductDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  productBundleModels:
      (json['ProductBundleModels'] as List<dynamic>?)
          ?.map((e) => ProductBundleModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  displayDiscontinuedMessage:
      json['DisplayDiscontinuedMessage'] as bool? ?? false,
  currentStoreName: json['CurrentStoreName'] as String?,
  startPrice: (json['StartPrice'] as num?)?.toDouble(),
  highestBidValue: (json['HighestBidValue'] as num?)?.toDouble(),
  endTime:
      json['EndTime'] == null
          ? null
          : DateTime.parse(json['EndTime'] as String),
  endTimeLocalTime:
      json['EndTimeLocalTime'] == null
          ? null
          : DateTime.parse(json['EndTimeLocalTime'] as String),
  auctionEnded: json['AuctionEnded'] as bool? ?? false,
  renderCaptcha: json['RenderCaptcha'] as bool? ?? false,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductDetailsModelImplToJson(
  _$ProductDetailsModelImpl instance,
) => <String, dynamic>{
  if (instance.defaultPictureZoomEnabled case final value?)
    'DefaultPictureZoomEnabled': value,
  if (instance.defaultPictureModel case final value?)
    'DefaultPictureModel': value,
  if (instance.pictureModels case final value?) 'PictureModels': value,
  if (_$ProductTypeEnumMap[instance.productType] case final value?)
    'ProductType': value,
  if (instance.name case final value?) 'Name': value,
  if (instance.shortDescription case final value?) 'ShortDescription': value,
  if (instance.fullDescription case final value?) 'FullDescription': value,
  if (instance.metaKeywords case final value?) 'MetaKeywords': value,
  if (instance.metaDescription case final value?) 'MetaDescription': value,
  if (instance.metaTitle case final value?) 'MetaTitle': value,
  if (instance.seName case final value?) 'SeName': value,
  if (instance.showSku case final value?) 'ShowSku': value,
  if (instance.sku case final value?) 'Sku': value,
  if (instance.flag case final value?) 'Flag': value,
  if (instance.showMpn case final value?) 'ShowMpn': value,
  if (instance.mpn case final value?) 'Mpn': value,
  if (instance.showGtin case final value?) 'ShowGtin': value,
  if (instance.gtin case final value?) 'Gtin': value,
  if (instance.brandModel case final value?) 'BrandModel': value,
  if (instance.showVendor case final value?) 'ShowVendor': value,
  if (instance.vendorModel case final value?) 'VendorModel': value,
  if (instance.hasSampleDownload case final value?) 'HasSampleDownload': value,
  if (instance.giftVoucher case final value?) 'GiftVoucher': value,
  if (instance.isShipEnabled case final value?) 'IsShipEnabled': value,
  if (instance.notReturnable case final value?) 'NotReturnable': value,
  if (instance.isFreeShipping case final value?) 'IsFreeShipping': value,
  if (instance.allowToSelectWarehouse case final value?)
    'AllowToSelectWarehouse': value,
  if (instance.productWarehouses case final value?) 'ProductWarehouses': value,
  if (instance.additionalShippingCharge case final value?)
    'AdditionalShippingCharge': value,
  if (instance.additionalShippingChargeStr case final value?)
    'AdditionalShippingChargeStr': value,
  if (instance.freeShippingNotificationEnabled case final value?)
    'FreeShippingNotificationEnabled': value,
  if (instance.deliveryDate case final value?) 'DeliveryDate': value,
  if (instance.deliveryColorSquaresRgb case final value?)
    'DeliveryColorSquaresRgb': value,
  if (instance.interval case final value?) 'Interval': value,
  if (_$IntervalUnitEnumMap[instance.intervalUnit] case final value?)
    'IntervalUnit': value,
  if (instance.incBothDate case final value?) 'IncBothDate': value,
  if (instance.parameters case final value?) 'Parameters': value,
  if (instance.startDate?.toIso8601String() case final value?)
    'StartDate': value,
  if (instance.rentalStartDateUtc?.toIso8601String() case final value?)
    'RentalStartDateUtc': value,
  if (instance.rentalEndDateUtc?.toIso8601String() case final value?)
    'RentalEndDateUtc': value,
  if (instance.rentalReservationId case final value?)
    'RentalReservationId': value,
  if (instance.stockAvailability case final value?) 'StockAvailability': value,
  if (instance.displayOutOfStockSubscription case final value?)
    'DisplayOutOfStockSubscription': value,
  if (instance.emailAFriendEnabled case final value?)
    'EmailAFriendEnabled': value,
  if (instance.askQuestionOnProduct case final value?)
    'AskQuestionOnProduct': value,
  if (instance.productAskQuestion case final value?)
    'ProductAskQuestion': value,
  if (instance.compareProductsEnabled case final value?)
    'CompareProductsEnabled': value,
  if (instance.pageShareCode case final value?) 'PageShareCode': value,
  if (instance.productPrice case final value?) 'ProductPrice': value,
  if (instance.addToCart case final value?) 'AddToCart': value,
  if (instance.breadcrumb case final value?) 'Breadcrumb': value,
  if (instance.productTags case final value?) 'ProductTags': value,
  if (instance.productAttributes case final value?) 'ProductAttributes': value,
  if (instance.productSpecifications case final value?)
    'ProductSpecifications': value,
  if (instance.productCollections case final value?)
    'ProductCollections': value,
  if (instance.productReviewOverview case final value?)
    'ProductReviewOverview': value,
  if (instance.tierPrices case final value?) 'TierPrices': value,
  if (instance.associatedProducts case final value?)
    'AssociatedProducts': value,
  if (instance.productBundleModels case final value?)
    'ProductBundleModels': value,
  if (instance.displayDiscontinuedMessage case final value?)
    'DisplayDiscontinuedMessage': value,
  if (instance.currentStoreName case final value?) 'CurrentStoreName': value,
  if (instance.startPrice case final value?) 'StartPrice': value,
  if (instance.highestBidValue case final value?) 'HighestBidValue': value,
  if (instance.endTime?.toIso8601String() case final value?) 'EndTime': value,
  if (instance.endTimeLocalTime?.toIso8601String() case final value?)
    'EndTimeLocalTime': value,
  if (instance.auctionEnded case final value?) 'AuctionEnded': value,
  if (instance.renderCaptcha case final value?) 'RenderCaptcha': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};

const _$ProductTypeEnumMap = {
  ProductType.simpleProduct: 0,
  ProductType.groupedProduct: 10,
  ProductType.reservation: 20,
  ProductType.bundledProduct: 30,
  ProductType.auction: 40,
};

const _$IntervalUnitEnumMap = {
  IntervalUnit.minute: 0,
  IntervalUnit.hour: 5,
  IntervalUnit.day: 10,
};
