// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddToCartModelImpl _$$AddToCartModelImplFromJson(Map<String, dynamic> json) =>
    _$AddToCartModelImpl(
      productId: json['ProductId'] as String?,
      enteredQuantity: (json['EnteredQuantity'] as num?)?.toInt(),
      minimumQuantityNotification:
          json['MinimumQuantityNotification'] as String?,
      allowedQuantities:
          (json['AllowedQuantities'] as List<dynamic>?)
              ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      enteredPrice: json['EnteredPrice'] as bool? ?? false,
      customerEnteredPrice: (json['CustomerEnteredPrice'] as num?)?.toDouble(),
      customerEnteredPriceRange: json['CustomerEnteredPriceRange'] as String?,
      disableBuyButton: json['DisableBuyButton'] as bool? ?? false,
      disableWishlistButton: json['DisableWishlistButton'] as bool? ?? false,
      isReservation: json['IsReservation'] as bool? ?? false,
      isAuction: json['IsAuction'] as bool? ?? false,
      measureUnit: json['MeasureUnit'] as String?,
      availableForPreOrder: json['AvailableForPreOrder'] as bool? ?? false,
      preOrderDateTimeUtc:
          json['PreOrderDateTimeUtc'] == null
              ? null
              : DateTime.parse(json['PreOrderDateTimeUtc'] as String),
      updatedShoppingCartItemId: json['UpdatedShoppingCartItemId'] as String?,
      updateShoppingCartItemType:
          $enumDecodeNullable(
            _$ShoppingCartTypeEnumMap,
            json['UpdateShoppingCartItemType'],
          ) ??
          null,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AddToCartModelImplToJson(
  _$AddToCartModelImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.enteredQuantity case final value?) 'EnteredQuantity': value,
  if (instance.minimumQuantityNotification case final value?)
    'MinimumQuantityNotification': value,
  if (instance.allowedQuantities case final value?) 'AllowedQuantities': value,
  if (instance.enteredPrice case final value?) 'EnteredPrice': value,
  if (instance.customerEnteredPrice case final value?)
    'CustomerEnteredPrice': value,
  if (instance.customerEnteredPriceRange case final value?)
    'CustomerEnteredPriceRange': value,
  if (instance.disableBuyButton case final value?) 'DisableBuyButton': value,
  if (instance.disableWishlistButton case final value?)
    'DisableWishlistButton': value,
  if (instance.isReservation case final value?) 'IsReservation': value,
  if (instance.isAuction case final value?) 'IsAuction': value,
  if (instance.measureUnit case final value?) 'MeasureUnit': value,
  if (instance.availableForPreOrder case final value?)
    'AvailableForPreOrder': value,
  if (instance.preOrderDateTimeUtc?.toIso8601String() case final value?)
    'PreOrderDateTimeUtc': value,
  if (instance.updatedShoppingCartItemId case final value?)
    'UpdatedShoppingCartItemId': value,
  if (_$ShoppingCartTypeEnumMap[instance.updateShoppingCartItemType]
      case final value?)
    'UpdateShoppingCartItemType': value,
  if (instance.userFields case final value?) 'UserFields': value,
};

const _$ShoppingCartTypeEnumMap = {
  ShoppingCartType.onHoldCart: 0,
  ShoppingCartType.shoppingCart: 1,
  ShoppingCartType.wishlist: 2,
  ShoppingCartType.auctions: 3,
};
