// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_totals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderTotalsModelImpl _$$OrderTotalsModelImplFromJson(
  Map<String, dynamic> json,
) => _$OrderTotalsModelImpl(
  isEditable: json['IsEditable'] as bool? ?? false,
  subTotal: json['SubTotal'] as String?,
  subTotalIncludingTax: json['SubTotalIncludingTax'] as bool? ?? false,
  subTotalValue: (json['SubTotalValue'] as num?)?.toDouble(),
  subTotalDiscount: json['SubTotalDiscount'] as String?,
  subTotalDiscountValue: (json['SubTotalDiscountValue'] as num?)?.toDouble(),
  shipping: json['Shipping'] as String?,
  requiresShipping: json['RequiresShipping'] as bool? ?? false,
  selectedShippingMethod: json['SelectedShippingMethod'] as String?,
  paymentMethodAdditionalFee: json['PaymentMethodAdditionalFee'] as String?,
  paymentMethodAdditionalFeeValue:
      (json['PaymentMethodAdditionalFeeValue'] as num?)?.toDouble(),
  tax: json['Tax'] as String?,
  taxRates:
      (json['TaxRates'] as List<dynamic>?)
          ?.map((e) => TaxRate.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  displayTax: json['DisplayTax'] as bool? ?? false,
  displayTaxRates: json['DisplayTaxRates'] as bool? ?? false,
  giftVouchers:
      (json['GiftVouchers'] as List<dynamic>?)
          ?.map((e) => GiftVoucher.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  orderTotalDiscount: json['OrderTotalDiscount'] as String?,
  orderTotalDiscountValue:
      (json['OrderTotalDiscountValue'] as num?)?.toDouble(),
  redeemedLoyaltyPoints: (json['RedeemedLoyaltyPoints'] as num?)?.toInt(),
  redeemedLoyaltyPointsAmount: json['RedeemedLoyaltyPointsAmount'] as String?,
  willEarnLoyaltyPoints: (json['WillEarnLoyaltyPoints'] as num?)?.toInt(),
  orderTotal: json['OrderTotal'] as String?,
  orderTotalValue: (json['OrderTotalValue'] as num?)?.toDouble(),
  discounts:
      (json['Discounts'] as List<dynamic>?)?.map((e) => e as String).toSet() ??
      const <String>{},
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OrderTotalsModelImplToJson(
  _$OrderTotalsModelImpl instance,
) => <String, dynamic>{
  if (instance.isEditable case final value?) 'IsEditable': value,
  if (instance.subTotal case final value?) 'SubTotal': value,
  if (instance.subTotalIncludingTax case final value?)
    'SubTotalIncludingTax': value,
  if (instance.subTotalValue case final value?) 'SubTotalValue': value,
  if (instance.subTotalDiscount case final value?) 'SubTotalDiscount': value,
  if (instance.subTotalDiscountValue case final value?)
    'SubTotalDiscountValue': value,
  if (instance.shipping case final value?) 'Shipping': value,
  if (instance.requiresShipping case final value?) 'RequiresShipping': value,
  if (instance.selectedShippingMethod case final value?)
    'SelectedShippingMethod': value,
  if (instance.paymentMethodAdditionalFee case final value?)
    'PaymentMethodAdditionalFee': value,
  if (instance.paymentMethodAdditionalFeeValue case final value?)
    'PaymentMethodAdditionalFeeValue': value,
  if (instance.tax case final value?) 'Tax': value,
  if (instance.taxRates case final value?) 'TaxRates': value,
  if (instance.displayTax case final value?) 'DisplayTax': value,
  if (instance.displayTaxRates case final value?) 'DisplayTaxRates': value,
  if (instance.giftVouchers case final value?) 'GiftVouchers': value,
  if (instance.orderTotalDiscount case final value?)
    'OrderTotalDiscount': value,
  if (instance.orderTotalDiscountValue case final value?)
    'OrderTotalDiscountValue': value,
  if (instance.redeemedLoyaltyPoints case final value?)
    'RedeemedLoyaltyPoints': value,
  if (instance.redeemedLoyaltyPointsAmount case final value?)
    'RedeemedLoyaltyPointsAmount': value,
  if (instance.willEarnLoyaltyPoints case final value?)
    'WillEarnLoyaltyPoints': value,
  if (instance.orderTotal case final value?) 'OrderTotal': value,
  if (instance.orderTotalValue case final value?) 'OrderTotalValue': value,
  if (instance.discounts?.toList() case final value?) 'Discounts': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
