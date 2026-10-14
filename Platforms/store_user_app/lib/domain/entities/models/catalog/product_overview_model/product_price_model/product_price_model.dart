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
      {@JsonKey(name: 'OldPrice', includeIfNull: false) String? oldPrice,
      @JsonKey(name: 'OldPriceValue', includeIfNull: false)
      double? oldPriceValue,
      @JsonKey(name: 'CatalogPrice', includeIfNull: false) String? catalogPrice,
      @JsonKey(name: 'Price', includeIfNull: false) String? price,
      @JsonKey(name: 'CallForPrice', includeIfNull: false)
      @Default(false)
      bool? callForPrice,
      @JsonKey(name: 'PriceValue', includeIfNull: false) double? priceValue,
      @JsonKey(name: 'PriceIncludesTax', includeIfNull: false)
      @Default(false)
      bool? priceIncludesTax,
      @JsonKey(name: 'StartPrice', includeIfNull: false) String? startPrice,
      @JsonKey(name: 'StartPriceValue', includeIfNull: false)
      double? startPriceValue,
      @JsonKey(name: 'HighestBid', includeIfNull: false) String? highestBid,
      @JsonKey(name: 'HighestBidValue', includeIfNull: false)
      double? highestBidValue,
      @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
      String? basePricePAngV,
      @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
      @Default(false)
      bool? disableBuyButton,
      @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
      @Default(false)
      bool? disableWishlistButton,
      @JsonKey(name: 'DisableAddToCompareListButton', includeIfNull: false)
      @Default(false)
      bool? disableAddToCompareListButton,
      @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
      @Default(false)
      bool? availableForPreOrder,
      @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
      @Default(null)
      DateTime? preOrderDateTimeUtc,
      @JsonKey(name: 'ForceRedirectionAfterAddingToCart', includeIfNull: false)
      @Default(false)
      bool? forceRedirectionAfterAddingToCart,
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
