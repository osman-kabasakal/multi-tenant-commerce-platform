import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../utilities/catalog/apply_discount/apply_discount.dart';

import '../../../../catalog/tier_price/tier_price.dart';

import '../../../../common/user_field/user_field.dart';

part 'product_price_model.freezed.dart';
part 'product_price_model.g.dart';

@freezed
class ProductPriceModel extends StoreJsonSerializable<ProductPriceModel>
    with _$ProductPriceModel {
  factory ProductPriceModel(
      {@JsonKey(name: 'CurrencyCode', includeIfNull: false)
      String? currencyCode,
      @JsonKey(name: 'OldPrice', includeIfNull: false) String? oldPrice,
      @JsonKey(name: 'CatalogPrice', includeIfNull: false) String? catalogPrice,
      @JsonKey(name: 'Price', includeIfNull: false) String? price,
      @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
      String? priceWithDiscount,
      @JsonKey(name: 'PriceValue', includeIfNull: false) double? priceValue,
      @JsonKey(name: 'EnteredPrice', includeIfNull: false)
      @Default(false)
      bool? enteredPrice,
      @JsonKey(name: 'CallForPrice', includeIfNull: false)
      @Default(false)
      bool? callForPrice,
      @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'HidePrices', includeIfNull: false)
      @Default(false)
      bool? hidePrices,
      @JsonKey(name: 'IsReservation', includeIfNull: false)
      @Default(false)
      bool? isReservation,
      @JsonKey(name: 'ReservationPrice', includeIfNull: false)
      String? reservationPrice,
      @JsonKey(name: 'IsAuction', includeIfNull: false)
      @Default(false)
      bool? isAuction,
      @JsonKey(name: 'HighestBid', includeIfNull: false) String? highestBid,
      @JsonKey(name: 'HighestBidValue', includeIfNull: false)
      double? highestBidValue,
      @JsonKey(name: 'StartPrice', includeIfNull: false) String? startPrice,
      @JsonKey(name: 'StartPriceValue', includeIfNull: false)
      double? startPriceValue,
      @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
      @Default(false)
      bool? disableBuyButton,
      @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
      String? basePricePAngV,
      @JsonKey(name: 'AppliedDiscounts', includeIfNull: false)
      @Default([])
      List<ApplyDiscount>? appliedDiscounts,
      @JsonKey(name: 'PreferredTierPrice', includeIfNull: false)
      TierPrice? preferredTierPrice,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductPriceModel;

  factory ProductPriceModel.fromJson(Map<String, dynamic> json) =>
      _$ProductPriceModelFromJson(json);
}
