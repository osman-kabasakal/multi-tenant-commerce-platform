// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details_cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductDetailsCartImpl _$$ProductDetailsCartImplFromJson(
  Map<String, dynamic> json,
) => _$ProductDetailsCartImpl(
  productId: json['ProductId'] as String?,
  shoppingCartTypeId:
      $enumDecodeNullable(
        _$ShoppingCartTypeEnumMap,
        json['ShoppingCartTypeId'],
      ) ??
      ShoppingCartType.onHoldCart,
  shoppingCartItemId: json['ShoppingCartItemId'] as String?,
  enteredQuantity: (json['EnteredQuantity'] as num?)?.toInt(),
  warehouseId: json['WarehouseId'] as String?,
  reservationDatepickerFrom: json['ReservationDatepickerFrom'] as String?,
  reservationDatepickerTo: json['ReservationDatepickerTo'] as String?,
  recipientName: json['RecipientName'] as String?,
  recipientEmail: json['RecipientEmail'] as String?,
  senderName: json['SenderName'] as String?,
  senderEmail: json['SenderEmail'] as String?,
  message: json['Message'] as String?,
  attributes:
      (json['Attributes'] as List<dynamic>?)
          ?.map((e) => CustomAttributeModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  reservation: json['Reservation'] as String?,
  customerEnteredPrice: json['CustomerEnteredPrice'] as String?,
);

Map<String, dynamic> _$$ProductDetailsCartImplToJson(
  _$ProductDetailsCartImpl instance,
) => <String, dynamic>{
  if (instance.productId case final value?) 'ProductId': value,
  if (_$ShoppingCartTypeEnumMap[instance.shoppingCartTypeId] case final value?)
    'ShoppingCartTypeId': value,
  if (instance.shoppingCartItemId case final value?)
    'ShoppingCartItemId': value,
  if (instance.enteredQuantity case final value?) 'EnteredQuantity': value,
  if (instance.warehouseId case final value?) 'WarehouseId': value,
  if (instance.reservationDatepickerFrom case final value?)
    'ReservationDatepickerFrom': value,
  if (instance.reservationDatepickerTo case final value?)
    'ReservationDatepickerTo': value,
  if (instance.recipientName case final value?) 'RecipientName': value,
  if (instance.recipientEmail case final value?) 'RecipientEmail': value,
  if (instance.senderName case final value?) 'SenderName': value,
  if (instance.senderEmail case final value?) 'SenderEmail': value,
  if (instance.message case final value?) 'Message': value,
  if (instance.attributes case final value?) 'Attributes': value,
  if (instance.reservation case final value?) 'Reservation': value,
  if (instance.customerEnteredPrice case final value?)
    'CustomerEnteredPrice': value,
};

const _$ShoppingCartTypeEnumMap = {
  ShoppingCartType.onHoldCart: 0,
  ShoppingCartType.shoppingCart: 1,
  ShoppingCartType.wishlist: 2,
  ShoppingCartType.auctions: 3,
};
