// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDetailsModelImpl _$$OrderDetailsModelImplFromJson(
  Map<String, dynamic> json,
) => _$OrderDetailsModelImpl(
  pdfInvoiceDisabled: json['PdfInvoiceDisabled'] as bool? ?? false,
  userCanCancelUnpaidOrder: json['UserCanCancelUnpaidOrder'] as bool? ?? false,
  createdOn:
      json['CreatedOn'] == null
          ? null
          : DateTime.parse(json['CreatedOn'] as String),
  orderStatus: json['OrderStatus'] as String?,
  isReOrderAllowed: json['IsReOrderAllowed'] as bool? ?? false,
  isMerchandiseReturnAllowed:
      json['IsMerchandiseReturnAllowed'] as bool? ?? false,
  isShippable: json['IsShippable'] as bool? ?? false,
  pickUpInStore: json['PickUpInStore'] as bool? ?? false,
  pickupAddress:
      json['PickupAddress'] == null
          ? null
          : AddressModel.fromJson(
            json['PickupAddress'] as Map<String, dynamic>,
          ),
  shippingStatus: json['ShippingStatus'] as String?,
  shippingAddress:
      json['ShippingAddress'] == null
          ? null
          : AddressModel.fromJson(
            json['ShippingAddress'] as Map<String, dynamic>,
          ),
  shippingMethod: json['ShippingMethod'] as String?,
  shippingAdditionDescription: json['ShippingAdditionDescription'] as String?,
  shipments:
      (json['Shipments'] as List<dynamic>?)
          ?.map((e) => ShipmentBriefModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  billingAddress:
      json['BillingAddress'] == null
          ? null
          : AddressModel.fromJson(
            json['BillingAddress'] as Map<String, dynamic>,
          ),
  vatNumber: json['VatNumber'] as String?,
  orderNumber: (json['OrderNumber'] as num?)?.toInt(),
  orderCode: json['OrderCode'] as String?,
  paymentMethod: json['PaymentMethod'] as String?,
  paymentMethodStatus: json['PaymentMethodStatus'] as String?,
  canRePostProcessPayment: json['CanRePostProcessPayment'] as bool? ?? false,
  customValues:
      (json['CustomValues'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Object),
      ) ??
      const {},
  orderIncludingTax: json['OrderIncludingTax'] as bool? ?? false,
  orderSubtotal: json['OrderSubtotal'] as String?,
  orderSubTotalDiscount: json['OrderSubTotalDiscount'] as String?,
  orderShipping: json['OrderShipping'] as String?,
  paymentMethodAdditionalFee: json['PaymentMethodAdditionalFee'] as String?,
  checkoutAttributeInfo: json['CheckoutAttributeInfo'] as String?,
  pricesIncludeTax: json['PricesIncludeTax'] as bool? ?? false,
  tax: json['Tax'] as String?,
  taxRates:
      (json['TaxRates'] as List<dynamic>?)
          ?.map((e) => TaxRate.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  displayTax: json['DisplayTax'] as bool? ?? false,
  displayTaxRates: json['DisplayTaxRates'] as bool? ?? false,
  orderTotalDiscount: json['OrderTotalDiscount'] as String?,
  redeemedLoyaltyPoints: (json['RedeemedLoyaltyPoints'] as num?)?.toInt(),
  redeemedLoyaltyPointsAmount: json['RedeemedLoyaltyPointsAmount'] as String?,
  orderTotal: json['OrderTotal'] as String?,
  giftVouchers:
      (json['GiftVouchers'] as List<dynamic>?)
          ?.map((e) => GiftVoucher.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  showSku: json['ShowSku'] as bool? ?? false,
  items:
      (json['Items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  orderNotes:
      (json['OrderNotes'] as List<dynamic>?)
          ?.map((e) => OrderNote.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  showAddOrderNote: json['ShowAddOrderNote'] as bool? ?? false,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OrderDetailsModelImplToJson(
  _$OrderDetailsModelImpl instance,
) => <String, dynamic>{
  if (instance.pdfInvoiceDisabled case final value?)
    'PdfInvoiceDisabled': value,
  if (instance.userCanCancelUnpaidOrder case final value?)
    'UserCanCancelUnpaidOrder': value,
  if (instance.createdOn?.toIso8601String() case final value?)
    'CreatedOn': value,
  if (instance.orderStatus case final value?) 'OrderStatus': value,
  if (instance.isReOrderAllowed case final value?) 'IsReOrderAllowed': value,
  if (instance.isMerchandiseReturnAllowed case final value?)
    'IsMerchandiseReturnAllowed': value,
  if (instance.isShippable case final value?) 'IsShippable': value,
  if (instance.pickUpInStore case final value?) 'PickUpInStore': value,
  if (instance.pickupAddress case final value?) 'PickupAddress': value,
  if (instance.shippingStatus case final value?) 'ShippingStatus': value,
  if (instance.shippingAddress case final value?) 'ShippingAddress': value,
  if (instance.shippingMethod case final value?) 'ShippingMethod': value,
  if (instance.shippingAdditionDescription case final value?)
    'ShippingAdditionDescription': value,
  if (instance.shipments case final value?) 'Shipments': value,
  if (instance.billingAddress case final value?) 'BillingAddress': value,
  if (instance.vatNumber case final value?) 'VatNumber': value,
  if (instance.orderNumber case final value?) 'OrderNumber': value,
  if (instance.orderCode case final value?) 'OrderCode': value,
  if (instance.paymentMethod case final value?) 'PaymentMethod': value,
  if (instance.paymentMethodStatus case final value?)
    'PaymentMethodStatus': value,
  if (instance.canRePostProcessPayment case final value?)
    'CanRePostProcessPayment': value,
  if (instance.customValues case final value?) 'CustomValues': value,
  if (instance.orderIncludingTax case final value?) 'OrderIncludingTax': value,
  if (instance.orderSubtotal case final value?) 'OrderSubtotal': value,
  if (instance.orderSubTotalDiscount case final value?)
    'OrderSubTotalDiscount': value,
  if (instance.orderShipping case final value?) 'OrderShipping': value,
  if (instance.paymentMethodAdditionalFee case final value?)
    'PaymentMethodAdditionalFee': value,
  if (instance.checkoutAttributeInfo case final value?)
    'CheckoutAttributeInfo': value,
  if (instance.pricesIncludeTax case final value?) 'PricesIncludeTax': value,
  if (instance.tax case final value?) 'Tax': value,
  if (instance.taxRates case final value?) 'TaxRates': value,
  if (instance.displayTax case final value?) 'DisplayTax': value,
  if (instance.displayTaxRates case final value?) 'DisplayTaxRates': value,
  if (instance.orderTotalDiscount case final value?)
    'OrderTotalDiscount': value,
  if (instance.redeemedLoyaltyPoints case final value?)
    'RedeemedLoyaltyPoints': value,
  if (instance.redeemedLoyaltyPointsAmount case final value?)
    'RedeemedLoyaltyPointsAmount': value,
  if (instance.orderTotal case final value?) 'OrderTotal': value,
  if (instance.giftVouchers case final value?) 'GiftVouchers': value,
  if (instance.showSku case final value?) 'ShowSku': value,
  if (instance.items case final value?) 'Items': value,
  if (instance.orderNotes case final value?) 'OrderNotes': value,
  if (instance.showAddOrderNote case final value?) 'ShowAddOrderNote': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
