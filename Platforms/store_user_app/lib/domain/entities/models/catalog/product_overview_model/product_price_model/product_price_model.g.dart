// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductPriceModelImpl _$$ProductPriceModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductPriceModelImpl(
  oldPrice: json['OldPrice'] as String?,
  oldPriceValue: (json['OldPriceValue'] as num?)?.toDouble(),
  catalogPrice: json['CatalogPrice'] as String?,
  price: json['Price'] as String?,
  callForPrice: json['CallForPrice'] as bool? ?? false,
  priceValue: (json['PriceValue'] as num?)?.toDouble(),
  priceIncludesTax: json['PriceIncludesTax'] as bool? ?? false,
  startPrice: json['StartPrice'] as String?,
  startPriceValue: (json['StartPriceValue'] as num?)?.toDouble(),
  highestBid: json['HighestBid'] as String?,
  highestBidValue: (json['HighestBidValue'] as num?)?.toDouble(),
  basePricePAngV: json['BasePricePAngV'] as String?,
  disableBuyButton: json['DisableBuyButton'] as bool? ?? false,
  disableWishlistButton: json['DisableWishlistButton'] as bool? ?? false,
  disableAddToCompareListButton:
      json['DisableAddToCompareListButton'] as bool? ?? false,
  availableForPreOrder: json['AvailableForPreOrder'] as bool? ?? false,
  preOrderDateTimeUtc:
      json['PreOrderDateTimeUtc'] == null
          ? null
          : DateTime.parse(json['PreOrderDateTimeUtc'] as String),
  forceRedirectionAfterAddingToCart:
      json['ForceRedirectionAfterAddingToCart'] as bool? ?? false,
  appliedDiscounts:
      (json['AppliedDiscounts'] as List<dynamic>?)
          ?.map((e) => ApplyDiscount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  preferredTierPrice:
      json['PreferredTierPrice'] == null
          ? null
          : TierPrice.fromJson(
            json['PreferredTierPrice'] as Map<String, dynamic>,
          ),
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ProductPriceModelImplToJson(
  _$ProductPriceModelImpl instance,
) => <String, dynamic>{
  if (instance.oldPrice case final value?) 'OldPrice': value,
  if (instance.oldPriceValue case final value?) 'OldPriceValue': value,
  if (instance.catalogPrice case final value?) 'CatalogPrice': value,
  if (instance.price case final value?) 'Price': value,
  if (instance.callForPrice case final value?) 'CallForPrice': value,
  if (instance.priceValue case final value?) 'PriceValue': value,
  if (instance.priceIncludesTax case final value?) 'PriceIncludesTax': value,
  if (instance.startPrice case final value?) 'StartPrice': value,
  if (instance.startPriceValue case final value?) 'StartPriceValue': value,
  if (instance.highestBid case final value?) 'HighestBid': value,
  if (instance.highestBidValue case final value?) 'HighestBidValue': value,
  if (instance.basePricePAngV case final value?) 'BasePricePAngV': value,
  if (instance.disableBuyButton case final value?) 'DisableBuyButton': value,
  if (instance.disableWishlistButton case final value?)
    'DisableWishlistButton': value,
  if (instance.disableAddToCompareListButton case final value?)
    'DisableAddToCompareListButton': value,
  if (instance.availableForPreOrder case final value?)
    'AvailableForPreOrder': value,
  if (instance.preOrderDateTimeUtc?.toIso8601String() case final value?)
    'PreOrderDateTimeUtc': value,
  if (instance.forceRedirectionAfterAddingToCart case final value?)
    'ForceRedirectionAfterAddingToCart': value,
  if (instance.appliedDiscounts case final value?) 'AppliedDiscounts': value,
  if (instance.preferredTierPrice case final value?)
    'PreferredTierPrice': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
