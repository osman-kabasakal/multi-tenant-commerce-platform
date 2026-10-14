// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderDetailsModel _$OrderDetailsModelFromJson(Map<String, dynamic> json) {
  return _OrderDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$OrderDetailsModel {
  @JsonKey(name: 'PdfInvoiceDisabled', includeIfNull: false)
  bool? get pdfInvoiceDisabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserCanCancelUnpaidOrder', includeIfNull: false)
  bool? get userCanCancelUnpaidOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderStatus', includeIfNull: false)
  String? get orderStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsReOrderAllowed', includeIfNull: false)
  bool? get isReOrderAllowed => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
  bool? get isMerchandiseReturnAllowed => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsShippable', includeIfNull: false)
  bool? get isShippable => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickUpInStore', includeIfNull: false)
  bool? get pickUpInStore => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  AddressModel? get pickupAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingStatus', includeIfNull: false)
  String? get shippingStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  AddressModel? get shippingAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingMethod', includeIfNull: false)
  String? get shippingMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
  String? get shippingAdditionDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'Shipments', includeIfNull: false)
  List<ShipmentBriefModel>? get shipments => throw _privateConstructorUsedError;
  @JsonKey(name: 'BillingAddress', includeIfNull: false)
  AddressModel? get billingAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'VatNumber', includeIfNull: false)
  String? get vatNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  String? get orderCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'PaymentMethod', includeIfNull: false)
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'PaymentMethodStatus', includeIfNull: false)
  String? get paymentMethodStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'CanRePostProcessPayment', includeIfNull: false)
  bool? get canRePostProcessPayment => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomValues', includeIfNull: false)
  Map<String, Object>? get customValues => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderIncludingTax', includeIfNull: false)
  bool? get orderIncludingTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderSubtotal', includeIfNull: false)
  String? get orderSubtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderSubTotalDiscount', includeIfNull: false)
  String? get orderSubTotalDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderShipping', includeIfNull: false)
  String? get orderShipping => throw _privateConstructorUsedError;
  @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
  String? get paymentMethodAdditionalFee => throw _privateConstructorUsedError;
  @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
  String? get checkoutAttributeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'PricesIncludeTax', includeIfNull: false)
  bool? get pricesIncludeTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'Tax', includeIfNull: false)
  String? get tax => throw _privateConstructorUsedError;
  @JsonKey(name: 'TaxRates', includeIfNull: false)
  List<TaxRate>? get taxRates => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayTax', includeIfNull: false)
  bool? get displayTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
  bool? get displayTaxRates => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
  String? get orderTotalDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
  int? get redeemedLoyaltyPoints => throw _privateConstructorUsedError;
  @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
  String? get redeemedLoyaltyPointsAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderTotal', includeIfNull: false)
  String? get orderTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'GiftVouchers', includeIfNull: false)
  List<GiftVoucher>? get giftVouchers => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  bool? get showSku => throw _privateConstructorUsedError;
  @JsonKey(name: 'Items', includeIfNull: false)
  List<OrderItemModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderNotes', includeIfNull: false)
  List<OrderNote>? get orderNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowAddOrderNote', includeIfNull: false)
  bool? get showAddOrderNote => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this OrderDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDetailsModelCopyWith<OrderDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDetailsModelCopyWith<$Res> {
  factory $OrderDetailsModelCopyWith(
    OrderDetailsModel value,
    $Res Function(OrderDetailsModel) then,
  ) = _$OrderDetailsModelCopyWithImpl<$Res, OrderDetailsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'PdfInvoiceDisabled', includeIfNull: false)
    bool? pdfInvoiceDisabled,
    @JsonKey(name: 'UserCanCancelUnpaidOrder', includeIfNull: false)
    bool? userCanCancelUnpaidOrder,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'OrderStatus', includeIfNull: false) String? orderStatus,
    @JsonKey(name: 'IsReOrderAllowed', includeIfNull: false)
    bool? isReOrderAllowed,
    @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
    bool? isMerchandiseReturnAllowed,
    @JsonKey(name: 'IsShippable', includeIfNull: false) bool? isShippable,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false) bool? pickUpInStore,
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
    List<ShipmentBriefModel>? shipments,
    @JsonKey(name: 'BillingAddress', includeIfNull: false)
    AddressModel? billingAddress,
    @JsonKey(name: 'VatNumber', includeIfNull: false) String? vatNumber,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false) String? paymentMethod,
    @JsonKey(name: 'PaymentMethodStatus', includeIfNull: false)
    String? paymentMethodStatus,
    @JsonKey(name: 'CanRePostProcessPayment', includeIfNull: false)
    bool? canRePostProcessPayment,
    @JsonKey(name: 'CustomValues', includeIfNull: false)
    Map<String, Object>? customValues,
    @JsonKey(name: 'OrderIncludingTax', includeIfNull: false)
    bool? orderIncludingTax,
    @JsonKey(name: 'OrderSubtotal', includeIfNull: false) String? orderSubtotal,
    @JsonKey(name: 'OrderSubTotalDiscount', includeIfNull: false)
    String? orderSubTotalDiscount,
    @JsonKey(name: 'OrderShipping', includeIfNull: false) String? orderShipping,
    @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
    String? paymentMethodAdditionalFee,
    @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
    String? checkoutAttributeInfo,
    @JsonKey(name: 'PricesIncludeTax', includeIfNull: false)
    bool? pricesIncludeTax,
    @JsonKey(name: 'Tax', includeIfNull: false) String? tax,
    @JsonKey(name: 'TaxRates', includeIfNull: false) List<TaxRate>? taxRates,
    @JsonKey(name: 'DisplayTax', includeIfNull: false) bool? displayTax,
    @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
    bool? displayTaxRates,
    @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
    String? orderTotalDiscount,
    @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
    int? redeemedLoyaltyPoints,
    @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
    String? redeemedLoyaltyPointsAmount,
    @JsonKey(name: 'OrderTotal', includeIfNull: false) String? orderTotal,
    @JsonKey(name: 'GiftVouchers', includeIfNull: false)
    List<GiftVoucher>? giftVouchers,
    @JsonKey(name: 'ShowSku', includeIfNull: false) bool? showSku,
    @JsonKey(name: 'Items', includeIfNull: false) List<OrderItemModel>? items,
    @JsonKey(name: 'OrderNotes', includeIfNull: false)
    List<OrderNote>? orderNotes,
    @JsonKey(name: 'ShowAddOrderNote', includeIfNull: false)
    bool? showAddOrderNote,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $AddressModelCopyWith<$Res>? get pickupAddress;
  $AddressModelCopyWith<$Res>? get shippingAddress;
  $AddressModelCopyWith<$Res>? get billingAddress;
}

/// @nodoc
class _$OrderDetailsModelCopyWithImpl<$Res, $Val extends OrderDetailsModel>
    implements $OrderDetailsModelCopyWith<$Res> {
  _$OrderDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pdfInvoiceDisabled = freezed,
    Object? userCanCancelUnpaidOrder = freezed,
    Object? createdOn = freezed,
    Object? orderStatus = freezed,
    Object? isReOrderAllowed = freezed,
    Object? isMerchandiseReturnAllowed = freezed,
    Object? isShippable = freezed,
    Object? pickUpInStore = freezed,
    Object? pickupAddress = freezed,
    Object? shippingStatus = freezed,
    Object? shippingAddress = freezed,
    Object? shippingMethod = freezed,
    Object? shippingAdditionDescription = freezed,
    Object? shipments = freezed,
    Object? billingAddress = freezed,
    Object? vatNumber = freezed,
    Object? orderNumber = freezed,
    Object? orderCode = freezed,
    Object? paymentMethod = freezed,
    Object? paymentMethodStatus = freezed,
    Object? canRePostProcessPayment = freezed,
    Object? customValues = freezed,
    Object? orderIncludingTax = freezed,
    Object? orderSubtotal = freezed,
    Object? orderSubTotalDiscount = freezed,
    Object? orderShipping = freezed,
    Object? paymentMethodAdditionalFee = freezed,
    Object? checkoutAttributeInfo = freezed,
    Object? pricesIncludeTax = freezed,
    Object? tax = freezed,
    Object? taxRates = freezed,
    Object? displayTax = freezed,
    Object? displayTaxRates = freezed,
    Object? orderTotalDiscount = freezed,
    Object? redeemedLoyaltyPoints = freezed,
    Object? redeemedLoyaltyPointsAmount = freezed,
    Object? orderTotal = freezed,
    Object? giftVouchers = freezed,
    Object? showSku = freezed,
    Object? items = freezed,
    Object? orderNotes = freezed,
    Object? showAddOrderNote = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            pdfInvoiceDisabled:
                freezed == pdfInvoiceDisabled
                    ? _value.pdfInvoiceDisabled
                    : pdfInvoiceDisabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            userCanCancelUnpaidOrder:
                freezed == userCanCancelUnpaidOrder
                    ? _value.userCanCancelUnpaidOrder
                    : userCanCancelUnpaidOrder // ignore: cast_nullable_to_non_nullable
                        as bool?,
            createdOn:
                freezed == createdOn
                    ? _value.createdOn
                    : createdOn // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            orderStatus:
                freezed == orderStatus
                    ? _value.orderStatus
                    : orderStatus // ignore: cast_nullable_to_non_nullable
                        as String?,
            isReOrderAllowed:
                freezed == isReOrderAllowed
                    ? _value.isReOrderAllowed
                    : isReOrderAllowed // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isMerchandiseReturnAllowed:
                freezed == isMerchandiseReturnAllowed
                    ? _value.isMerchandiseReturnAllowed
                    : isMerchandiseReturnAllowed // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isShippable:
                freezed == isShippable
                    ? _value.isShippable
                    : isShippable // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pickUpInStore:
                freezed == pickUpInStore
                    ? _value.pickUpInStore
                    : pickUpInStore // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pickupAddress:
                freezed == pickupAddress
                    ? _value.pickupAddress
                    : pickupAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            shippingStatus:
                freezed == shippingStatus
                    ? _value.shippingStatus
                    : shippingStatus // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippingAddress:
                freezed == shippingAddress
                    ? _value.shippingAddress
                    : shippingAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            shippingMethod:
                freezed == shippingMethod
                    ? _value.shippingMethod
                    : shippingMethod // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippingAdditionDescription:
                freezed == shippingAdditionDescription
                    ? _value.shippingAdditionDescription
                    : shippingAdditionDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            shipments:
                freezed == shipments
                    ? _value.shipments
                    : shipments // ignore: cast_nullable_to_non_nullable
                        as List<ShipmentBriefModel>?,
            billingAddress:
                freezed == billingAddress
                    ? _value.billingAddress
                    : billingAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            vatNumber:
                freezed == vatNumber
                    ? _value.vatNumber
                    : vatNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderNumber:
                freezed == orderNumber
                    ? _value.orderNumber
                    : orderNumber // ignore: cast_nullable_to_non_nullable
                        as int?,
            orderCode:
                freezed == orderCode
                    ? _value.orderCode
                    : orderCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            paymentMethod:
                freezed == paymentMethod
                    ? _value.paymentMethod
                    : paymentMethod // ignore: cast_nullable_to_non_nullable
                        as String?,
            paymentMethodStatus:
                freezed == paymentMethodStatus
                    ? _value.paymentMethodStatus
                    : paymentMethodStatus // ignore: cast_nullable_to_non_nullable
                        as String?,
            canRePostProcessPayment:
                freezed == canRePostProcessPayment
                    ? _value.canRePostProcessPayment
                    : canRePostProcessPayment // ignore: cast_nullable_to_non_nullable
                        as bool?,
            customValues:
                freezed == customValues
                    ? _value.customValues
                    : customValues // ignore: cast_nullable_to_non_nullable
                        as Map<String, Object>?,
            orderIncludingTax:
                freezed == orderIncludingTax
                    ? _value.orderIncludingTax
                    : orderIncludingTax // ignore: cast_nullable_to_non_nullable
                        as bool?,
            orderSubtotal:
                freezed == orderSubtotal
                    ? _value.orderSubtotal
                    : orderSubtotal // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderSubTotalDiscount:
                freezed == orderSubTotalDiscount
                    ? _value.orderSubTotalDiscount
                    : orderSubTotalDiscount // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderShipping:
                freezed == orderShipping
                    ? _value.orderShipping
                    : orderShipping // ignore: cast_nullable_to_non_nullable
                        as String?,
            paymentMethodAdditionalFee:
                freezed == paymentMethodAdditionalFee
                    ? _value.paymentMethodAdditionalFee
                    : paymentMethodAdditionalFee // ignore: cast_nullable_to_non_nullable
                        as String?,
            checkoutAttributeInfo:
                freezed == checkoutAttributeInfo
                    ? _value.checkoutAttributeInfo
                    : checkoutAttributeInfo // ignore: cast_nullable_to_non_nullable
                        as String?,
            pricesIncludeTax:
                freezed == pricesIncludeTax
                    ? _value.pricesIncludeTax
                    : pricesIncludeTax // ignore: cast_nullable_to_non_nullable
                        as bool?,
            tax:
                freezed == tax
                    ? _value.tax
                    : tax // ignore: cast_nullable_to_non_nullable
                        as String?,
            taxRates:
                freezed == taxRates
                    ? _value.taxRates
                    : taxRates // ignore: cast_nullable_to_non_nullable
                        as List<TaxRate>?,
            displayTax:
                freezed == displayTax
                    ? _value.displayTax
                    : displayTax // ignore: cast_nullable_to_non_nullable
                        as bool?,
            displayTaxRates:
                freezed == displayTaxRates
                    ? _value.displayTaxRates
                    : displayTaxRates // ignore: cast_nullable_to_non_nullable
                        as bool?,
            orderTotalDiscount:
                freezed == orderTotalDiscount
                    ? _value.orderTotalDiscount
                    : orderTotalDiscount // ignore: cast_nullable_to_non_nullable
                        as String?,
            redeemedLoyaltyPoints:
                freezed == redeemedLoyaltyPoints
                    ? _value.redeemedLoyaltyPoints
                    : redeemedLoyaltyPoints // ignore: cast_nullable_to_non_nullable
                        as int?,
            redeemedLoyaltyPointsAmount:
                freezed == redeemedLoyaltyPointsAmount
                    ? _value.redeemedLoyaltyPointsAmount
                    : redeemedLoyaltyPointsAmount // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderTotal:
                freezed == orderTotal
                    ? _value.orderTotal
                    : orderTotal // ignore: cast_nullable_to_non_nullable
                        as String?,
            giftVouchers:
                freezed == giftVouchers
                    ? _value.giftVouchers
                    : giftVouchers // ignore: cast_nullable_to_non_nullable
                        as List<GiftVoucher>?,
            showSku:
                freezed == showSku
                    ? _value.showSku
                    : showSku // ignore: cast_nullable_to_non_nullable
                        as bool?,
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<OrderItemModel>?,
            orderNotes:
                freezed == orderNotes
                    ? _value.orderNotes
                    : orderNotes // ignore: cast_nullable_to_non_nullable
                        as List<OrderNote>?,
            showAddOrderNote:
                freezed == showAddOrderNote
                    ? _value.showAddOrderNote
                    : showAddOrderNote // ignore: cast_nullable_to_non_nullable
                        as bool?,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get pickupAddress {
    if (_value.pickupAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.pickupAddress!, (value) {
      return _then(_value.copyWith(pickupAddress: value) as $Val);
    });
  }

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get shippingAddress {
    if (_value.shippingAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.shippingAddress!, (value) {
      return _then(_value.copyWith(shippingAddress: value) as $Val);
    });
  }

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get billingAddress {
    if (_value.billingAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.billingAddress!, (value) {
      return _then(_value.copyWith(billingAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderDetailsModelImplCopyWith<$Res>
    implements $OrderDetailsModelCopyWith<$Res> {
  factory _$$OrderDetailsModelImplCopyWith(
    _$OrderDetailsModelImpl value,
    $Res Function(_$OrderDetailsModelImpl) then,
  ) = __$$OrderDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PdfInvoiceDisabled', includeIfNull: false)
    bool? pdfInvoiceDisabled,
    @JsonKey(name: 'UserCanCancelUnpaidOrder', includeIfNull: false)
    bool? userCanCancelUnpaidOrder,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'OrderStatus', includeIfNull: false) String? orderStatus,
    @JsonKey(name: 'IsReOrderAllowed', includeIfNull: false)
    bool? isReOrderAllowed,
    @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
    bool? isMerchandiseReturnAllowed,
    @JsonKey(name: 'IsShippable', includeIfNull: false) bool? isShippable,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false) bool? pickUpInStore,
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
    List<ShipmentBriefModel>? shipments,
    @JsonKey(name: 'BillingAddress', includeIfNull: false)
    AddressModel? billingAddress,
    @JsonKey(name: 'VatNumber', includeIfNull: false) String? vatNumber,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false) String? paymentMethod,
    @JsonKey(name: 'PaymentMethodStatus', includeIfNull: false)
    String? paymentMethodStatus,
    @JsonKey(name: 'CanRePostProcessPayment', includeIfNull: false)
    bool? canRePostProcessPayment,
    @JsonKey(name: 'CustomValues', includeIfNull: false)
    Map<String, Object>? customValues,
    @JsonKey(name: 'OrderIncludingTax', includeIfNull: false)
    bool? orderIncludingTax,
    @JsonKey(name: 'OrderSubtotal', includeIfNull: false) String? orderSubtotal,
    @JsonKey(name: 'OrderSubTotalDiscount', includeIfNull: false)
    String? orderSubTotalDiscount,
    @JsonKey(name: 'OrderShipping', includeIfNull: false) String? orderShipping,
    @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
    String? paymentMethodAdditionalFee,
    @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
    String? checkoutAttributeInfo,
    @JsonKey(name: 'PricesIncludeTax', includeIfNull: false)
    bool? pricesIncludeTax,
    @JsonKey(name: 'Tax', includeIfNull: false) String? tax,
    @JsonKey(name: 'TaxRates', includeIfNull: false) List<TaxRate>? taxRates,
    @JsonKey(name: 'DisplayTax', includeIfNull: false) bool? displayTax,
    @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
    bool? displayTaxRates,
    @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
    String? orderTotalDiscount,
    @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
    int? redeemedLoyaltyPoints,
    @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
    String? redeemedLoyaltyPointsAmount,
    @JsonKey(name: 'OrderTotal', includeIfNull: false) String? orderTotal,
    @JsonKey(name: 'GiftVouchers', includeIfNull: false)
    List<GiftVoucher>? giftVouchers,
    @JsonKey(name: 'ShowSku', includeIfNull: false) bool? showSku,
    @JsonKey(name: 'Items', includeIfNull: false) List<OrderItemModel>? items,
    @JsonKey(name: 'OrderNotes', includeIfNull: false)
    List<OrderNote>? orderNotes,
    @JsonKey(name: 'ShowAddOrderNote', includeIfNull: false)
    bool? showAddOrderNote,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $AddressModelCopyWith<$Res>? get pickupAddress;
  @override
  $AddressModelCopyWith<$Res>? get shippingAddress;
  @override
  $AddressModelCopyWith<$Res>? get billingAddress;
}

/// @nodoc
class __$$OrderDetailsModelImplCopyWithImpl<$Res>
    extends _$OrderDetailsModelCopyWithImpl<$Res, _$OrderDetailsModelImpl>
    implements _$$OrderDetailsModelImplCopyWith<$Res> {
  __$$OrderDetailsModelImplCopyWithImpl(
    _$OrderDetailsModelImpl _value,
    $Res Function(_$OrderDetailsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pdfInvoiceDisabled = freezed,
    Object? userCanCancelUnpaidOrder = freezed,
    Object? createdOn = freezed,
    Object? orderStatus = freezed,
    Object? isReOrderAllowed = freezed,
    Object? isMerchandiseReturnAllowed = freezed,
    Object? isShippable = freezed,
    Object? pickUpInStore = freezed,
    Object? pickupAddress = freezed,
    Object? shippingStatus = freezed,
    Object? shippingAddress = freezed,
    Object? shippingMethod = freezed,
    Object? shippingAdditionDescription = freezed,
    Object? shipments = freezed,
    Object? billingAddress = freezed,
    Object? vatNumber = freezed,
    Object? orderNumber = freezed,
    Object? orderCode = freezed,
    Object? paymentMethod = freezed,
    Object? paymentMethodStatus = freezed,
    Object? canRePostProcessPayment = freezed,
    Object? customValues = freezed,
    Object? orderIncludingTax = freezed,
    Object? orderSubtotal = freezed,
    Object? orderSubTotalDiscount = freezed,
    Object? orderShipping = freezed,
    Object? paymentMethodAdditionalFee = freezed,
    Object? checkoutAttributeInfo = freezed,
    Object? pricesIncludeTax = freezed,
    Object? tax = freezed,
    Object? taxRates = freezed,
    Object? displayTax = freezed,
    Object? displayTaxRates = freezed,
    Object? orderTotalDiscount = freezed,
    Object? redeemedLoyaltyPoints = freezed,
    Object? redeemedLoyaltyPointsAmount = freezed,
    Object? orderTotal = freezed,
    Object? giftVouchers = freezed,
    Object? showSku = freezed,
    Object? items = freezed,
    Object? orderNotes = freezed,
    Object? showAddOrderNote = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$OrderDetailsModelImpl(
        pdfInvoiceDisabled:
            freezed == pdfInvoiceDisabled
                ? _value.pdfInvoiceDisabled
                : pdfInvoiceDisabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        userCanCancelUnpaidOrder:
            freezed == userCanCancelUnpaidOrder
                ? _value.userCanCancelUnpaidOrder
                : userCanCancelUnpaidOrder // ignore: cast_nullable_to_non_nullable
                    as bool?,
        createdOn:
            freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        orderStatus:
            freezed == orderStatus
                ? _value.orderStatus
                : orderStatus // ignore: cast_nullable_to_non_nullable
                    as String?,
        isReOrderAllowed:
            freezed == isReOrderAllowed
                ? _value.isReOrderAllowed
                : isReOrderAllowed // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isMerchandiseReturnAllowed:
            freezed == isMerchandiseReturnAllowed
                ? _value.isMerchandiseReturnAllowed
                : isMerchandiseReturnAllowed // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isShippable:
            freezed == isShippable
                ? _value.isShippable
                : isShippable // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pickUpInStore:
            freezed == pickUpInStore
                ? _value.pickUpInStore
                : pickUpInStore // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pickupAddress:
            freezed == pickupAddress
                ? _value.pickupAddress
                : pickupAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        shippingStatus:
            freezed == shippingStatus
                ? _value.shippingStatus
                : shippingStatus // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippingAddress:
            freezed == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        shippingMethod:
            freezed == shippingMethod
                ? _value.shippingMethod
                : shippingMethod // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippingAdditionDescription:
            freezed == shippingAdditionDescription
                ? _value.shippingAdditionDescription
                : shippingAdditionDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        shipments:
            freezed == shipments
                ? _value._shipments
                : shipments // ignore: cast_nullable_to_non_nullable
                    as List<ShipmentBriefModel>?,
        billingAddress:
            freezed == billingAddress
                ? _value.billingAddress
                : billingAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        vatNumber:
            freezed == vatNumber
                ? _value.vatNumber
                : vatNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderNumber:
            freezed == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                    as int?,
        orderCode:
            freezed == orderCode
                ? _value.orderCode
                : orderCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        paymentMethod:
            freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                    as String?,
        paymentMethodStatus:
            freezed == paymentMethodStatus
                ? _value.paymentMethodStatus
                : paymentMethodStatus // ignore: cast_nullable_to_non_nullable
                    as String?,
        canRePostProcessPayment:
            freezed == canRePostProcessPayment
                ? _value.canRePostProcessPayment
                : canRePostProcessPayment // ignore: cast_nullable_to_non_nullable
                    as bool?,
        customValues:
            freezed == customValues
                ? _value._customValues
                : customValues // ignore: cast_nullable_to_non_nullable
                    as Map<String, Object>?,
        orderIncludingTax:
            freezed == orderIncludingTax
                ? _value.orderIncludingTax
                : orderIncludingTax // ignore: cast_nullable_to_non_nullable
                    as bool?,
        orderSubtotal:
            freezed == orderSubtotal
                ? _value.orderSubtotal
                : orderSubtotal // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderSubTotalDiscount:
            freezed == orderSubTotalDiscount
                ? _value.orderSubTotalDiscount
                : orderSubTotalDiscount // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderShipping:
            freezed == orderShipping
                ? _value.orderShipping
                : orderShipping // ignore: cast_nullable_to_non_nullable
                    as String?,
        paymentMethodAdditionalFee:
            freezed == paymentMethodAdditionalFee
                ? _value.paymentMethodAdditionalFee
                : paymentMethodAdditionalFee // ignore: cast_nullable_to_non_nullable
                    as String?,
        checkoutAttributeInfo:
            freezed == checkoutAttributeInfo
                ? _value.checkoutAttributeInfo
                : checkoutAttributeInfo // ignore: cast_nullable_to_non_nullable
                    as String?,
        pricesIncludeTax:
            freezed == pricesIncludeTax
                ? _value.pricesIncludeTax
                : pricesIncludeTax // ignore: cast_nullable_to_non_nullable
                    as bool?,
        tax:
            freezed == tax
                ? _value.tax
                : tax // ignore: cast_nullable_to_non_nullable
                    as String?,
        taxRates:
            freezed == taxRates
                ? _value._taxRates
                : taxRates // ignore: cast_nullable_to_non_nullable
                    as List<TaxRate>?,
        displayTax:
            freezed == displayTax
                ? _value.displayTax
                : displayTax // ignore: cast_nullable_to_non_nullable
                    as bool?,
        displayTaxRates:
            freezed == displayTaxRates
                ? _value.displayTaxRates
                : displayTaxRates // ignore: cast_nullable_to_non_nullable
                    as bool?,
        orderTotalDiscount:
            freezed == orderTotalDiscount
                ? _value.orderTotalDiscount
                : orderTotalDiscount // ignore: cast_nullable_to_non_nullable
                    as String?,
        redeemedLoyaltyPoints:
            freezed == redeemedLoyaltyPoints
                ? _value.redeemedLoyaltyPoints
                : redeemedLoyaltyPoints // ignore: cast_nullable_to_non_nullable
                    as int?,
        redeemedLoyaltyPointsAmount:
            freezed == redeemedLoyaltyPointsAmount
                ? _value.redeemedLoyaltyPointsAmount
                : redeemedLoyaltyPointsAmount // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderTotal:
            freezed == orderTotal
                ? _value.orderTotal
                : orderTotal // ignore: cast_nullable_to_non_nullable
                    as String?,
        giftVouchers:
            freezed == giftVouchers
                ? _value._giftVouchers
                : giftVouchers // ignore: cast_nullable_to_non_nullable
                    as List<GiftVoucher>?,
        showSku:
            freezed == showSku
                ? _value.showSku
                : showSku // ignore: cast_nullable_to_non_nullable
                    as bool?,
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<OrderItemModel>?,
        orderNotes:
            freezed == orderNotes
                ? _value._orderNotes
                : orderNotes // ignore: cast_nullable_to_non_nullable
                    as List<OrderNote>?,
        showAddOrderNote:
            freezed == showAddOrderNote
                ? _value.showAddOrderNote
                : showAddOrderNote // ignore: cast_nullable_to_non_nullable
                    as bool?,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        userFields:
            freezed == userFields
                ? _value._userFields
                : userFields // ignore: cast_nullable_to_non_nullable
                    as List<UserField>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderDetailsModelImpl implements _OrderDetailsModel {
  _$OrderDetailsModelImpl({
    @JsonKey(name: 'PdfInvoiceDisabled', includeIfNull: false)
    this.pdfInvoiceDisabled = false,
    @JsonKey(name: 'UserCanCancelUnpaidOrder', includeIfNull: false)
    this.userCanCancelUnpaidOrder = false,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'OrderStatus', includeIfNull: false) this.orderStatus,
    @JsonKey(name: 'IsReOrderAllowed', includeIfNull: false)
    this.isReOrderAllowed = false,
    @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
    this.isMerchandiseReturnAllowed = false,
    @JsonKey(name: 'IsShippable', includeIfNull: false)
    this.isShippable = false,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false)
    this.pickUpInStore = false,
    @JsonKey(name: 'PickupAddress', includeIfNull: false) this.pickupAddress,
    @JsonKey(name: 'ShippingStatus', includeIfNull: false) this.shippingStatus,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    this.shippingAddress,
    @JsonKey(name: 'ShippingMethod', includeIfNull: false) this.shippingMethod,
    @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
    this.shippingAdditionDescription,
    @JsonKey(name: 'Shipments', includeIfNull: false)
    final List<ShipmentBriefModel>? shipments = const [],
    @JsonKey(name: 'BillingAddress', includeIfNull: false) this.billingAddress,
    @JsonKey(name: 'VatNumber', includeIfNull: false) this.vatNumber,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) this.orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) this.orderCode,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false) this.paymentMethod,
    @JsonKey(name: 'PaymentMethodStatus', includeIfNull: false)
    this.paymentMethodStatus,
    @JsonKey(name: 'CanRePostProcessPayment', includeIfNull: false)
    this.canRePostProcessPayment = false,
    @JsonKey(name: 'CustomValues', includeIfNull: false)
    final Map<String, Object>? customValues = const {},
    @JsonKey(name: 'OrderIncludingTax', includeIfNull: false)
    this.orderIncludingTax = false,
    @JsonKey(name: 'OrderSubtotal', includeIfNull: false) this.orderSubtotal,
    @JsonKey(name: 'OrderSubTotalDiscount', includeIfNull: false)
    this.orderSubTotalDiscount,
    @JsonKey(name: 'OrderShipping', includeIfNull: false) this.orderShipping,
    @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
    this.paymentMethodAdditionalFee,
    @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
    this.checkoutAttributeInfo,
    @JsonKey(name: 'PricesIncludeTax', includeIfNull: false)
    this.pricesIncludeTax = false,
    @JsonKey(name: 'Tax', includeIfNull: false) this.tax,
    @JsonKey(name: 'TaxRates', includeIfNull: false)
    final List<TaxRate>? taxRates = const [],
    @JsonKey(name: 'DisplayTax', includeIfNull: false) this.displayTax = false,
    @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
    this.displayTaxRates = false,
    @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
    this.orderTotalDiscount,
    @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
    this.redeemedLoyaltyPoints,
    @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
    this.redeemedLoyaltyPointsAmount,
    @JsonKey(name: 'OrderTotal', includeIfNull: false) this.orderTotal,
    @JsonKey(name: 'GiftVouchers', includeIfNull: false)
    final List<GiftVoucher>? giftVouchers = const [],
    @JsonKey(name: 'ShowSku', includeIfNull: false) this.showSku = false,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<OrderItemModel>? items = const [],
    @JsonKey(name: 'OrderNotes', includeIfNull: false)
    final List<OrderNote>? orderNotes = const [],
    @JsonKey(name: 'ShowAddOrderNote', includeIfNull: false)
    this.showAddOrderNote = false,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _shipments = shipments,
       _customValues = customValues,
       _taxRates = taxRates,
       _giftVouchers = giftVouchers,
       _items = items,
       _orderNotes = orderNotes,
       _userFields = userFields;

  factory _$OrderDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDetailsModelImplFromJson(json);

  @override
  @JsonKey(name: 'PdfInvoiceDisabled', includeIfNull: false)
  final bool? pdfInvoiceDisabled;
  @override
  @JsonKey(name: 'UserCanCancelUnpaidOrder', includeIfNull: false)
  final bool? userCanCancelUnpaidOrder;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
  @override
  @JsonKey(name: 'OrderStatus', includeIfNull: false)
  final String? orderStatus;
  @override
  @JsonKey(name: 'IsReOrderAllowed', includeIfNull: false)
  final bool? isReOrderAllowed;
  @override
  @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
  final bool? isMerchandiseReturnAllowed;
  @override
  @JsonKey(name: 'IsShippable', includeIfNull: false)
  final bool? isShippable;
  @override
  @JsonKey(name: 'PickUpInStore', includeIfNull: false)
  final bool? pickUpInStore;
  @override
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  final AddressModel? pickupAddress;
  @override
  @JsonKey(name: 'ShippingStatus', includeIfNull: false)
  final String? shippingStatus;
  @override
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  final AddressModel? shippingAddress;
  @override
  @JsonKey(name: 'ShippingMethod', includeIfNull: false)
  final String? shippingMethod;
  @override
  @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
  final String? shippingAdditionDescription;
  final List<ShipmentBriefModel>? _shipments;
  @override
  @JsonKey(name: 'Shipments', includeIfNull: false)
  List<ShipmentBriefModel>? get shipments {
    final value = _shipments;
    if (value == null) return null;
    if (_shipments is EqualUnmodifiableListView) return _shipments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'BillingAddress', includeIfNull: false)
  final AddressModel? billingAddress;
  @override
  @JsonKey(name: 'VatNumber', includeIfNull: false)
  final String? vatNumber;
  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  final int? orderNumber;
  @override
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  final String? orderCode;
  @override
  @JsonKey(name: 'PaymentMethod', includeIfNull: false)
  final String? paymentMethod;
  @override
  @JsonKey(name: 'PaymentMethodStatus', includeIfNull: false)
  final String? paymentMethodStatus;
  @override
  @JsonKey(name: 'CanRePostProcessPayment', includeIfNull: false)
  final bool? canRePostProcessPayment;
  final Map<String, Object>? _customValues;
  @override
  @JsonKey(name: 'CustomValues', includeIfNull: false)
  Map<String, Object>? get customValues {
    final value = _customValues;
    if (value == null) return null;
    if (_customValues is EqualUnmodifiableMapView) return _customValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'OrderIncludingTax', includeIfNull: false)
  final bool? orderIncludingTax;
  @override
  @JsonKey(name: 'OrderSubtotal', includeIfNull: false)
  final String? orderSubtotal;
  @override
  @JsonKey(name: 'OrderSubTotalDiscount', includeIfNull: false)
  final String? orderSubTotalDiscount;
  @override
  @JsonKey(name: 'OrderShipping', includeIfNull: false)
  final String? orderShipping;
  @override
  @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
  final String? paymentMethodAdditionalFee;
  @override
  @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
  final String? checkoutAttributeInfo;
  @override
  @JsonKey(name: 'PricesIncludeTax', includeIfNull: false)
  final bool? pricesIncludeTax;
  @override
  @JsonKey(name: 'Tax', includeIfNull: false)
  final String? tax;
  final List<TaxRate>? _taxRates;
  @override
  @JsonKey(name: 'TaxRates', includeIfNull: false)
  List<TaxRate>? get taxRates {
    final value = _taxRates;
    if (value == null) return null;
    if (_taxRates is EqualUnmodifiableListView) return _taxRates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'DisplayTax', includeIfNull: false)
  final bool? displayTax;
  @override
  @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
  final bool? displayTaxRates;
  @override
  @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
  final String? orderTotalDiscount;
  @override
  @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
  final int? redeemedLoyaltyPoints;
  @override
  @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
  final String? redeemedLoyaltyPointsAmount;
  @override
  @JsonKey(name: 'OrderTotal', includeIfNull: false)
  final String? orderTotal;
  final List<GiftVoucher>? _giftVouchers;
  @override
  @JsonKey(name: 'GiftVouchers', includeIfNull: false)
  List<GiftVoucher>? get giftVouchers {
    final value = _giftVouchers;
    if (value == null) return null;
    if (_giftVouchers is EqualUnmodifiableListView) return _giftVouchers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  final bool? showSku;
  final List<OrderItemModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<OrderItemModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<OrderNote>? _orderNotes;
  @override
  @JsonKey(name: 'OrderNotes', includeIfNull: false)
  List<OrderNote>? get orderNotes {
    final value = _orderNotes;
    if (value == null) return null;
    if (_orderNotes is EqualUnmodifiableListView) return _orderNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'ShowAddOrderNote', includeIfNull: false)
  final bool? showAddOrderNote;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
  final List<UserField>? _userFields;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields {
    final value = _userFields;
    if (value == null) return null;
    if (_userFields is EqualUnmodifiableListView) return _userFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'OrderDetailsModel(pdfInvoiceDisabled: $pdfInvoiceDisabled, userCanCancelUnpaidOrder: $userCanCancelUnpaidOrder, createdOn: $createdOn, orderStatus: $orderStatus, isReOrderAllowed: $isReOrderAllowed, isMerchandiseReturnAllowed: $isMerchandiseReturnAllowed, isShippable: $isShippable, pickUpInStore: $pickUpInStore, pickupAddress: $pickupAddress, shippingStatus: $shippingStatus, shippingAddress: $shippingAddress, shippingMethod: $shippingMethod, shippingAdditionDescription: $shippingAdditionDescription, shipments: $shipments, billingAddress: $billingAddress, vatNumber: $vatNumber, orderNumber: $orderNumber, orderCode: $orderCode, paymentMethod: $paymentMethod, paymentMethodStatus: $paymentMethodStatus, canRePostProcessPayment: $canRePostProcessPayment, customValues: $customValues, orderIncludingTax: $orderIncludingTax, orderSubtotal: $orderSubtotal, orderSubTotalDiscount: $orderSubTotalDiscount, orderShipping: $orderShipping, paymentMethodAdditionalFee: $paymentMethodAdditionalFee, checkoutAttributeInfo: $checkoutAttributeInfo, pricesIncludeTax: $pricesIncludeTax, tax: $tax, taxRates: $taxRates, displayTax: $displayTax, displayTaxRates: $displayTaxRates, orderTotalDiscount: $orderTotalDiscount, redeemedLoyaltyPoints: $redeemedLoyaltyPoints, redeemedLoyaltyPointsAmount: $redeemedLoyaltyPointsAmount, orderTotal: $orderTotal, giftVouchers: $giftVouchers, showSku: $showSku, items: $items, orderNotes: $orderNotes, showAddOrderNote: $showAddOrderNote, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDetailsModelImpl &&
            (identical(other.pdfInvoiceDisabled, pdfInvoiceDisabled) ||
                other.pdfInvoiceDisabled == pdfInvoiceDisabled) &&
            (identical(
                  other.userCanCancelUnpaidOrder,
                  userCanCancelUnpaidOrder,
                ) ||
                other.userCanCancelUnpaidOrder == userCanCancelUnpaidOrder) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.orderStatus, orderStatus) ||
                other.orderStatus == orderStatus) &&
            (identical(other.isReOrderAllowed, isReOrderAllowed) ||
                other.isReOrderAllowed == isReOrderAllowed) &&
            (identical(
                  other.isMerchandiseReturnAllowed,
                  isMerchandiseReturnAllowed,
                ) ||
                other.isMerchandiseReturnAllowed ==
                    isMerchandiseReturnAllowed) &&
            (identical(other.isShippable, isShippable) ||
                other.isShippable == isShippable) &&
            (identical(other.pickUpInStore, pickUpInStore) ||
                other.pickUpInStore == pickUpInStore) &&
            (identical(other.pickupAddress, pickupAddress) ||
                other.pickupAddress == pickupAddress) &&
            (identical(other.shippingStatus, shippingStatus) ||
                other.shippingStatus == shippingStatus) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.shippingMethod, shippingMethod) ||
                other.shippingMethod == shippingMethod) &&
            (identical(
                  other.shippingAdditionDescription,
                  shippingAdditionDescription,
                ) ||
                other.shippingAdditionDescription ==
                    shippingAdditionDescription) &&
            const DeepCollectionEquality().equals(
              other._shipments,
              _shipments,
            ) &&
            (identical(other.billingAddress, billingAddress) ||
                other.billingAddress == billingAddress) &&
            (identical(other.vatNumber, vatNumber) ||
                other.vatNumber == vatNumber) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.orderCode, orderCode) ||
                other.orderCode == orderCode) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentMethodStatus, paymentMethodStatus) ||
                other.paymentMethodStatus == paymentMethodStatus) &&
            (identical(
                  other.canRePostProcessPayment,
                  canRePostProcessPayment,
                ) ||
                other.canRePostProcessPayment == canRePostProcessPayment) &&
            const DeepCollectionEquality().equals(
              other._customValues,
              _customValues,
            ) &&
            (identical(other.orderIncludingTax, orderIncludingTax) ||
                other.orderIncludingTax == orderIncludingTax) &&
            (identical(other.orderSubtotal, orderSubtotal) ||
                other.orderSubtotal == orderSubtotal) &&
            (identical(other.orderSubTotalDiscount, orderSubTotalDiscount) ||
                other.orderSubTotalDiscount == orderSubTotalDiscount) &&
            (identical(other.orderShipping, orderShipping) ||
                other.orderShipping == orderShipping) &&
            (identical(
                  other.paymentMethodAdditionalFee,
                  paymentMethodAdditionalFee,
                ) ||
                other.paymentMethodAdditionalFee ==
                    paymentMethodAdditionalFee) &&
            (identical(other.checkoutAttributeInfo, checkoutAttributeInfo) ||
                other.checkoutAttributeInfo == checkoutAttributeInfo) &&
            (identical(other.pricesIncludeTax, pricesIncludeTax) ||
                other.pricesIncludeTax == pricesIncludeTax) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            const DeepCollectionEquality().equals(other._taxRates, _taxRates) &&
            (identical(other.displayTax, displayTax) ||
                other.displayTax == displayTax) &&
            (identical(other.displayTaxRates, displayTaxRates) ||
                other.displayTaxRates == displayTaxRates) &&
            (identical(other.orderTotalDiscount, orderTotalDiscount) ||
                other.orderTotalDiscount == orderTotalDiscount) &&
            (identical(other.redeemedLoyaltyPoints, redeemedLoyaltyPoints) ||
                other.redeemedLoyaltyPoints == redeemedLoyaltyPoints) &&
            (identical(
                  other.redeemedLoyaltyPointsAmount,
                  redeemedLoyaltyPointsAmount,
                ) ||
                other.redeemedLoyaltyPointsAmount ==
                    redeemedLoyaltyPointsAmount) &&
            (identical(other.orderTotal, orderTotal) ||
                other.orderTotal == orderTotal) &&
            const DeepCollectionEquality().equals(
              other._giftVouchers,
              _giftVouchers,
            ) &&
            (identical(other.showSku, showSku) || other.showSku == showSku) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._orderNotes,
              _orderNotes,
            ) &&
            (identical(other.showAddOrderNote, showAddOrderNote) ||
                other.showAddOrderNote == showAddOrderNote) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    pdfInvoiceDisabled,
    userCanCancelUnpaidOrder,
    createdOn,
    orderStatus,
    isReOrderAllowed,
    isMerchandiseReturnAllowed,
    isShippable,
    pickUpInStore,
    pickupAddress,
    shippingStatus,
    shippingAddress,
    shippingMethod,
    shippingAdditionDescription,
    const DeepCollectionEquality().hash(_shipments),
    billingAddress,
    vatNumber,
    orderNumber,
    orderCode,
    paymentMethod,
    paymentMethodStatus,
    canRePostProcessPayment,
    const DeepCollectionEquality().hash(_customValues),
    orderIncludingTax,
    orderSubtotal,
    orderSubTotalDiscount,
    orderShipping,
    paymentMethodAdditionalFee,
    checkoutAttributeInfo,
    pricesIncludeTax,
    tax,
    const DeepCollectionEquality().hash(_taxRates),
    displayTax,
    displayTaxRates,
    orderTotalDiscount,
    redeemedLoyaltyPoints,
    redeemedLoyaltyPointsAmount,
    orderTotal,
    const DeepCollectionEquality().hash(_giftVouchers),
    showSku,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_orderNotes),
    showAddOrderNote,
    id,
    const DeepCollectionEquality().hash(_userFields),
  ]);

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDetailsModelImplCopyWith<_$OrderDetailsModelImpl> get copyWith =>
      __$$OrderDetailsModelImplCopyWithImpl<_$OrderDetailsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderDetailsModelImplToJson(this);
  }
}

abstract class _OrderDetailsModel implements OrderDetailsModel {
  factory _OrderDetailsModel({
    @JsonKey(name: 'PdfInvoiceDisabled', includeIfNull: false)
    final bool? pdfInvoiceDisabled,
    @JsonKey(name: 'UserCanCancelUnpaidOrder', includeIfNull: false)
    final bool? userCanCancelUnpaidOrder,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'OrderStatus', includeIfNull: false)
    final String? orderStatus,
    @JsonKey(name: 'IsReOrderAllowed', includeIfNull: false)
    final bool? isReOrderAllowed,
    @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
    final bool? isMerchandiseReturnAllowed,
    @JsonKey(name: 'IsShippable', includeIfNull: false) final bool? isShippable,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false)
    final bool? pickUpInStore,
    @JsonKey(name: 'PickupAddress', includeIfNull: false)
    final AddressModel? pickupAddress,
    @JsonKey(name: 'ShippingStatus', includeIfNull: false)
    final String? shippingStatus,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    final AddressModel? shippingAddress,
    @JsonKey(name: 'ShippingMethod', includeIfNull: false)
    final String? shippingMethod,
    @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
    final String? shippingAdditionDescription,
    @JsonKey(name: 'Shipments', includeIfNull: false)
    final List<ShipmentBriefModel>? shipments,
    @JsonKey(name: 'BillingAddress', includeIfNull: false)
    final AddressModel? billingAddress,
    @JsonKey(name: 'VatNumber', includeIfNull: false) final String? vatNumber,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) final int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) final String? orderCode,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false)
    final String? paymentMethod,
    @JsonKey(name: 'PaymentMethodStatus', includeIfNull: false)
    final String? paymentMethodStatus,
    @JsonKey(name: 'CanRePostProcessPayment', includeIfNull: false)
    final bool? canRePostProcessPayment,
    @JsonKey(name: 'CustomValues', includeIfNull: false)
    final Map<String, Object>? customValues,
    @JsonKey(name: 'OrderIncludingTax', includeIfNull: false)
    final bool? orderIncludingTax,
    @JsonKey(name: 'OrderSubtotal', includeIfNull: false)
    final String? orderSubtotal,
    @JsonKey(name: 'OrderSubTotalDiscount', includeIfNull: false)
    final String? orderSubTotalDiscount,
    @JsonKey(name: 'OrderShipping', includeIfNull: false)
    final String? orderShipping,
    @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
    final String? paymentMethodAdditionalFee,
    @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
    final String? checkoutAttributeInfo,
    @JsonKey(name: 'PricesIncludeTax', includeIfNull: false)
    final bool? pricesIncludeTax,
    @JsonKey(name: 'Tax', includeIfNull: false) final String? tax,
    @JsonKey(name: 'TaxRates', includeIfNull: false)
    final List<TaxRate>? taxRates,
    @JsonKey(name: 'DisplayTax', includeIfNull: false) final bool? displayTax,
    @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
    final bool? displayTaxRates,
    @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
    final String? orderTotalDiscount,
    @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
    final int? redeemedLoyaltyPoints,
    @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
    final String? redeemedLoyaltyPointsAmount,
    @JsonKey(name: 'OrderTotal', includeIfNull: false) final String? orderTotal,
    @JsonKey(name: 'GiftVouchers', includeIfNull: false)
    final List<GiftVoucher>? giftVouchers,
    @JsonKey(name: 'ShowSku', includeIfNull: false) final bool? showSku,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<OrderItemModel>? items,
    @JsonKey(name: 'OrderNotes', includeIfNull: false)
    final List<OrderNote>? orderNotes,
    @JsonKey(name: 'ShowAddOrderNote', includeIfNull: false)
    final bool? showAddOrderNote,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$OrderDetailsModelImpl;

  factory _OrderDetailsModel.fromJson(Map<String, dynamic> json) =
      _$OrderDetailsModelImpl.fromJson;

  @override
  @JsonKey(name: 'PdfInvoiceDisabled', includeIfNull: false)
  bool? get pdfInvoiceDisabled;
  @override
  @JsonKey(name: 'UserCanCancelUnpaidOrder', includeIfNull: false)
  bool? get userCanCancelUnpaidOrder;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;
  @override
  @JsonKey(name: 'OrderStatus', includeIfNull: false)
  String? get orderStatus;
  @override
  @JsonKey(name: 'IsReOrderAllowed', includeIfNull: false)
  bool? get isReOrderAllowed;
  @override
  @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
  bool? get isMerchandiseReturnAllowed;
  @override
  @JsonKey(name: 'IsShippable', includeIfNull: false)
  bool? get isShippable;
  @override
  @JsonKey(name: 'PickUpInStore', includeIfNull: false)
  bool? get pickUpInStore;
  @override
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  AddressModel? get pickupAddress;
  @override
  @JsonKey(name: 'ShippingStatus', includeIfNull: false)
  String? get shippingStatus;
  @override
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  AddressModel? get shippingAddress;
  @override
  @JsonKey(name: 'ShippingMethod', includeIfNull: false)
  String? get shippingMethod;
  @override
  @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
  String? get shippingAdditionDescription;
  @override
  @JsonKey(name: 'Shipments', includeIfNull: false)
  List<ShipmentBriefModel>? get shipments;
  @override
  @JsonKey(name: 'BillingAddress', includeIfNull: false)
  AddressModel? get billingAddress;
  @override
  @JsonKey(name: 'VatNumber', includeIfNull: false)
  String? get vatNumber;
  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber;
  @override
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  String? get orderCode;
  @override
  @JsonKey(name: 'PaymentMethod', includeIfNull: false)
  String? get paymentMethod;
  @override
  @JsonKey(name: 'PaymentMethodStatus', includeIfNull: false)
  String? get paymentMethodStatus;
  @override
  @JsonKey(name: 'CanRePostProcessPayment', includeIfNull: false)
  bool? get canRePostProcessPayment;
  @override
  @JsonKey(name: 'CustomValues', includeIfNull: false)
  Map<String, Object>? get customValues;
  @override
  @JsonKey(name: 'OrderIncludingTax', includeIfNull: false)
  bool? get orderIncludingTax;
  @override
  @JsonKey(name: 'OrderSubtotal', includeIfNull: false)
  String? get orderSubtotal;
  @override
  @JsonKey(name: 'OrderSubTotalDiscount', includeIfNull: false)
  String? get orderSubTotalDiscount;
  @override
  @JsonKey(name: 'OrderShipping', includeIfNull: false)
  String? get orderShipping;
  @override
  @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
  String? get paymentMethodAdditionalFee;
  @override
  @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
  String? get checkoutAttributeInfo;
  @override
  @JsonKey(name: 'PricesIncludeTax', includeIfNull: false)
  bool? get pricesIncludeTax;
  @override
  @JsonKey(name: 'Tax', includeIfNull: false)
  String? get tax;
  @override
  @JsonKey(name: 'TaxRates', includeIfNull: false)
  List<TaxRate>? get taxRates;
  @override
  @JsonKey(name: 'DisplayTax', includeIfNull: false)
  bool? get displayTax;
  @override
  @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
  bool? get displayTaxRates;
  @override
  @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
  String? get orderTotalDiscount;
  @override
  @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
  int? get redeemedLoyaltyPoints;
  @override
  @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
  String? get redeemedLoyaltyPointsAmount;
  @override
  @JsonKey(name: 'OrderTotal', includeIfNull: false)
  String? get orderTotal;
  @override
  @JsonKey(name: 'GiftVouchers', includeIfNull: false)
  List<GiftVoucher>? get giftVouchers;
  @override
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  bool? get showSku;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<OrderItemModel>? get items;
  @override
  @JsonKey(name: 'OrderNotes', includeIfNull: false)
  List<OrderNote>? get orderNotes;
  @override
  @JsonKey(name: 'ShowAddOrderNote', includeIfNull: false)
  bool? get showAddOrderNote;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDetailsModelImplCopyWith<_$OrderDetailsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
