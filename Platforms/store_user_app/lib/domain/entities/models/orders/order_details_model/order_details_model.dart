import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../common/address_model/address_model.dart';

import 'shipment_brief_model/shipment_brief_model.dart';

import 'tax_rate/tax_rate.dart';

import 'gift_voucher/gift_voucher.dart';

import 'order_item_model/order_item_model.dart';

import 'order_note/order_note.dart';

import '../../../common/user_field/user_field.dart';

part 'order_details_model.freezed.dart';
part 'order_details_model.g.dart';

@freezed
class OrderDetailsModel extends StoreJsonSerializable<OrderDetailsModel>
    with _$OrderDetailsModel {
  factory OrderDetailsModel(
      {@JsonKey(name: 'PdfInvoiceDisabled', includeIfNull: false)
      @Default(false)
      bool? pdfInvoiceDisabled,
      @JsonKey(name: 'UserCanCancelUnpaidOrder', includeIfNull: false)
      @Default(false)
      bool? userCanCancelUnpaidOrder,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'OrderStatus', includeIfNull: false) String? orderStatus,
      @JsonKey(name: 'IsReOrderAllowed', includeIfNull: false)
      @Default(false)
      bool? isReOrderAllowed,
      @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
      @Default(false)
      bool? isMerchandiseReturnAllowed,
      @JsonKey(name: 'IsShippable', includeIfNull: false)
      @Default(false)
      bool? isShippable,
      @JsonKey(name: 'PickUpInStore', includeIfNull: false)
      @Default(false)
      bool? pickUpInStore,
      @JsonKey(name: 'PickupAddress', includeIfNull: false)
      AddressModel? pickupAddress,
      @JsonKey(name: 'ShippingStatus', includeIfNull: false)
      String? shippingStatus,
      @JsonKey(name: 'ShippingAddress', includeIfNull: false)
      AddressModel? shippingAddress,
      @JsonKey(name: 'ShippingMethod', includeIfNull: false)
      String? shippingMethod,
      @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
      String? shippingAdditionDescription,
      @JsonKey(name: 'Shipments', includeIfNull: false)
      @Default([])
      List<ShipmentBriefModel>? shipments,
      @JsonKey(name: 'BillingAddress', includeIfNull: false)
      AddressModel? billingAddress,
      @JsonKey(name: 'VatNumber', includeIfNull: false) String? vatNumber,
      @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
      @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
      @JsonKey(name: 'PaymentMethod', includeIfNull: false)
      String? paymentMethod,
      @JsonKey(name: 'PaymentMethodStatus', includeIfNull: false)
      String? paymentMethodStatus,
      @JsonKey(name: 'CanRePostProcessPayment', includeIfNull: false)
      @Default(false)
      bool? canRePostProcessPayment,
      @JsonKey(name: 'CustomValues', includeIfNull: false)
      @Default({})
      Map<String, Object>? customValues,
      @JsonKey(name: 'OrderIncludingTax', includeIfNull: false)
      @Default(false)
      bool? orderIncludingTax,
      @JsonKey(name: 'OrderSubtotal', includeIfNull: false)
      String? orderSubtotal,
      @JsonKey(name: 'OrderSubTotalDiscount', includeIfNull: false)
      String? orderSubTotalDiscount,
      @JsonKey(name: 'OrderShipping', includeIfNull: false)
      String? orderShipping,
      @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
      String? paymentMethodAdditionalFee,
      @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
      String? checkoutAttributeInfo,
      @JsonKey(name: 'PricesIncludeTax', includeIfNull: false)
      @Default(false)
      bool? pricesIncludeTax,
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
      @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
      String? orderTotalDiscount,
      @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
      int? redeemedLoyaltyPoints,
      @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
      String? redeemedLoyaltyPointsAmount,
      @JsonKey(name: 'OrderTotal', includeIfNull: false) String? orderTotal,
      @JsonKey(name: 'GiftVouchers', includeIfNull: false)
      @Default([])
      List<GiftVoucher>? giftVouchers,
      @JsonKey(name: 'ShowSku', includeIfNull: false)
      @Default(false)
      bool? showSku,
      @JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<OrderItemModel>? items,
      @JsonKey(name: 'OrderNotes', includeIfNull: false)
      @Default([])
      List<OrderNote>? orderNotes,
      @JsonKey(name: 'ShowAddOrderNote', includeIfNull: false)
      @Default(false)
      bool? showAddOrderNote,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _OrderDetailsModel;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsModelFromJson(json);
}
