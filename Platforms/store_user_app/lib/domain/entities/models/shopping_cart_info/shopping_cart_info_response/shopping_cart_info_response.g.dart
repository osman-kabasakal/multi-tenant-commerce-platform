// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingCartInfoResponseImpl _$$ShoppingCartInfoResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ShoppingCartInfoResponseImpl(
  success: json['Success'] as bool? ?? false,
  message: json['Message'] as String?,
  cartIsEmpty: json['CartIsEmpty'] as bool? ?? false,
  canCheckout: json['CanCheckout'] as bool? ?? false,
  minimumOrder:
      json['MinimumOrder'] == null
          ? null
          : MinimumOrderInfoDto.fromJson(
            json['MinimumOrder'] as Map<String, dynamic>,
          ),
  freeShipping:
      json['FreeShipping'] == null
          ? null
          : FreeShippingInfoDto.fromJson(
            json['FreeShipping'] as Map<String, dynamic>,
          ),
  cartSummary:
      json['CartSummary'] == null
          ? null
          : CartSummaryDto.fromJson(
            json['CartSummary'] as Map<String, dynamic>,
          ),
  validationMessages:
      (json['ValidationMessages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ShoppingCartInfoResponseImplToJson(
  _$ShoppingCartInfoResponseImpl instance,
) => <String, dynamic>{
  if (instance.success case final value?) 'Success': value,
  if (instance.message case final value?) 'Message': value,
  if (instance.cartIsEmpty case final value?) 'CartIsEmpty': value,
  if (instance.canCheckout case final value?) 'CanCheckout': value,
  if (instance.minimumOrder case final value?) 'MinimumOrder': value,
  if (instance.freeShipping case final value?) 'FreeShipping': value,
  if (instance.cartSummary case final value?) 'CartSummary': value,
  if (instance.validationMessages case final value?)
    'ValidationMessages': value,
};
