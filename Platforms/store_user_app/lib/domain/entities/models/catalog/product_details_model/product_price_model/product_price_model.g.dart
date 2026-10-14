// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductPriceModelImpl _$$ProductPriceModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductPriceModelImpl(
  currencyCode: json['CurrencyCode'] as String?,
  oldPrice: json['OldPrice'] as String?,
  catalogPrice: json['CatalogPrice'] as String?,
  price: json['Price'] as String?,
  priceWithDiscount: json['PriceWithDiscount'] as String?,
  priceValue: (json['PriceValue'] as num?)?.toDouble(),
  enteredPrice: json['EnteredPrice'] as bool? ?? false,
  callForPrice: json['CallForPrice'] as bool? ?? false,
  productId: json['ProductId'] as String?,
  hidePrices: json['HidePrices'] as bool? ?? false,
  isReservation: json['IsReservation'] as bool? ?? false,
  reservationPrice: json['ReservationPrice'] as String?,
  isAuction: json['IsAuction'] as bool? ?? false,
  highestBid: json['HighestBid'] as String?,
  highestBidValue: (json['HighestBidValue'] as num?)?.toDouble(),
  startPrice: json['StartPrice'] as String?,
  startPriceValue: (json['StartPriceValue'] as num?)?.toDouble(),
  disableBuyButton: json['DisableBuyButton'] as bool? ?? false,
  basePricePAngV: json['BasePricePAngV'] as String?,
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
  if (instance.currencyCode case final value?) 'CurrencyCode': value,
  if (instance.oldPrice case final value?) 'OldPrice': value,
  if (instance.catalogPrice case final value?) 'CatalogPrice': value,
  if (instance.price case final value?) 'Price': value,
  if (instance.priceWithDiscount case final value?) 'PriceWithDiscount': value,
  if (instance.priceValue case final value?) 'PriceValue': value,
  if (instance.enteredPrice case final value?) 'EnteredPrice': value,
  if (instance.callForPrice case final value?) 'CallForPrice': value,
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.hidePrices case final value?) 'HidePrices': value,
  if (instance.isReservation case final value?) 'IsReservation': value,
  if (instance.reservationPrice case final value?) 'ReservationPrice': value,
  if (instance.isAuction case final value?) 'IsAuction': value,
  if (instance.highestBid case final value?) 'HighestBid': value,
  if (instance.highestBidValue case final value?) 'HighestBidValue': value,
  if (instance.startPrice case final value?) 'StartPrice': value,
  if (instance.startPriceValue case final value?) 'StartPriceValue': value,
  if (instance.disableBuyButton case final value?) 'DisableBuyButton': value,
  if (instance.basePricePAngV case final value?) 'BasePricePAngV': value,
  if (instance.appliedDiscounts case final value?) 'AppliedDiscounts': value,
  if (instance.preferredTierPrice case final value?)
    'PreferredTierPrice': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
