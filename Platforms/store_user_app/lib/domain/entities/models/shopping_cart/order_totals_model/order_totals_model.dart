import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'tax_rate/tax_rate.dart';

import 'gift_voucher/gift_voucher.dart';

import '../../../common/user_field/user_field.dart';

part 'order_totals_model.freezed.dart';
part 'order_totals_model.g.dart';

@freezed
class OrderTotalsModel extends StoreJsonSerializable<OrderTotalsModel>
    with _$OrderTotalsModel {
  factory OrderTotalsModel(
      {@JsonKey(name: 'IsEditable', includeIfNull: false)
      @Default(false)
      bool? isEditable,
      @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
      @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
      @Default(false)
      bool? subTotalIncludingTax,
      @JsonKey(name: 'SubTotalValue', includeIfNull: false)
      double? subTotalValue,
      @JsonKey(name: 'SubTotalDiscount', includeIfNull: false)
      String? subTotalDiscount,
      @JsonKey(name: 'SubTotalDiscountValue', includeIfNull: false)
      double? subTotalDiscountValue,
      @JsonKey(name: 'Shipping', includeIfNull: false) String? shipping,
      @JsonKey(name: 'RequiresShipping', includeIfNull: false)
      @Default(false)
      bool? requiresShipping,
      @JsonKey(name: 'SelectedShippingMethod', includeIfNull: false)
      String? selectedShippingMethod,
      @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
      String? paymentMethodAdditionalFee,
      @JsonKey(name: 'PaymentMethodAdditionalFeeValue', includeIfNull: false)
      double? paymentMethodAdditionalFeeValue,
      @JsonKey(name: 'Tax', includeIfNull: false) String? tax,
      @JsonKey(name: 'TaxRates', includeIfNull: false)
      @Default([])
      List<TaxRate>? taxRates,
      @JsonKey(name: 'DisplayTax', includeIfNull: false)
      @Default(false)
      bool? displayTax,
      @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
      @Default(false)
      bool? displayTaxRates,
      @JsonKey(name: 'GiftVouchers', includeIfNull: false)
      @Default([])
      List<GiftVoucher>? giftVouchers,
      @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
      String? orderTotalDiscount,
      @JsonKey(name: 'OrderTotalDiscountValue', includeIfNull: false)
      double? orderTotalDiscountValue,
      @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
      int? redeemedLoyaltyPoints,
      @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
      String? redeemedLoyaltyPointsAmount,
      @JsonKey(name: 'WillEarnLoyaltyPoints', includeIfNull: false)
      int? willEarnLoyaltyPoints,
      @JsonKey(name: 'OrderTotal', includeIfNull: false) String? orderTotal,
      @JsonKey(name: 'OrderTotalValue', includeIfNull: false)
      double? orderTotalValue,
      @JsonKey(name: 'Discounts', includeIfNull: false)
      @Default(<String>{})
      Set<String>? discounts,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _OrderTotalsModel;

  factory OrderTotalsModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTotalsModelFromJson(json);
}
