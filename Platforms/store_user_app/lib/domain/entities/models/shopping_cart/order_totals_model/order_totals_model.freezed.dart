// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_totals_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderTotalsModel _$OrderTotalsModelFromJson(Map<String, dynamic> json) {
  return _OrderTotalsModel.fromJson(json);
}

/// @nodoc
mixin _$OrderTotalsModel {
  @JsonKey(name: 'IsEditable', includeIfNull: false)
  bool? get isEditable => throw _privateConstructorUsedError;
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  String? get subTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
  bool? get subTotalIncludingTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'SubTotalValue', includeIfNull: false)
  double? get subTotalValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'SubTotalDiscount', includeIfNull: false)
  String? get subTotalDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'SubTotalDiscountValue', includeIfNull: false)
  double? get subTotalDiscountValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'Shipping', includeIfNull: false)
  String? get shipping => throw _privateConstructorUsedError;
  @JsonKey(name: 'RequiresShipping', includeIfNull: false)
  bool? get requiresShipping => throw _privateConstructorUsedError;
  @JsonKey(name: 'SelectedShippingMethod', includeIfNull: false)
  String? get selectedShippingMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
  String? get paymentMethodAdditionalFee => throw _privateConstructorUsedError;
  @JsonKey(name: 'PaymentMethodAdditionalFeeValue', includeIfNull: false)
  double? get paymentMethodAdditionalFeeValue =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Tax', includeIfNull: false)
  String? get tax => throw _privateConstructorUsedError;
  @JsonKey(name: 'TaxRates', includeIfNull: false)
  List<TaxRate>? get taxRates => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayTax', includeIfNull: false)
  bool? get displayTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
  bool? get displayTaxRates => throw _privateConstructorUsedError;
  @JsonKey(name: 'GiftVouchers', includeIfNull: false)
  List<GiftVoucher>? get giftVouchers => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
  String? get orderTotalDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderTotalDiscountValue', includeIfNull: false)
  double? get orderTotalDiscountValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
  int? get redeemedLoyaltyPoints => throw _privateConstructorUsedError;
  @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
  String? get redeemedLoyaltyPointsAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'WillEarnLoyaltyPoints', includeIfNull: false)
  int? get willEarnLoyaltyPoints => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderTotal', includeIfNull: false)
  String? get orderTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderTotalValue', includeIfNull: false)
  double? get orderTotalValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'Discounts', includeIfNull: false)
  Set<String>? get discounts => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this OrderTotalsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderTotalsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderTotalsModelCopyWith<OrderTotalsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderTotalsModelCopyWith<$Res> {
  factory $OrderTotalsModelCopyWith(
    OrderTotalsModel value,
    $Res Function(OrderTotalsModel) then,
  ) = _$OrderTotalsModelCopyWithImpl<$Res, OrderTotalsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'IsEditable', includeIfNull: false) bool? isEditable,
    @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
    @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
    bool? subTotalIncludingTax,
    @JsonKey(name: 'SubTotalValue', includeIfNull: false) double? subTotalValue,
    @JsonKey(name: 'SubTotalDiscount', includeIfNull: false)
    String? subTotalDiscount,
    @JsonKey(name: 'SubTotalDiscountValue', includeIfNull: false)
    double? subTotalDiscountValue,
    @JsonKey(name: 'Shipping', includeIfNull: false) String? shipping,
    @JsonKey(name: 'RequiresShipping', includeIfNull: false)
    bool? requiresShipping,
    @JsonKey(name: 'SelectedShippingMethod', includeIfNull: false)
    String? selectedShippingMethod,
    @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
    String? paymentMethodAdditionalFee,
    @JsonKey(name: 'PaymentMethodAdditionalFeeValue', includeIfNull: false)
    double? paymentMethodAdditionalFeeValue,
    @JsonKey(name: 'Tax', includeIfNull: false) String? tax,
    @JsonKey(name: 'TaxRates', includeIfNull: false) List<TaxRate>? taxRates,
    @JsonKey(name: 'DisplayTax', includeIfNull: false) bool? displayTax,
    @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
    bool? displayTaxRates,
    @JsonKey(name: 'GiftVouchers', includeIfNull: false)
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
    @JsonKey(name: 'Discounts', includeIfNull: false) Set<String>? discounts,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$OrderTotalsModelCopyWithImpl<$Res, $Val extends OrderTotalsModel>
    implements $OrderTotalsModelCopyWith<$Res> {
  _$OrderTotalsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderTotalsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEditable = freezed,
    Object? subTotal = freezed,
    Object? subTotalIncludingTax = freezed,
    Object? subTotalValue = freezed,
    Object? subTotalDiscount = freezed,
    Object? subTotalDiscountValue = freezed,
    Object? shipping = freezed,
    Object? requiresShipping = freezed,
    Object? selectedShippingMethod = freezed,
    Object? paymentMethodAdditionalFee = freezed,
    Object? paymentMethodAdditionalFeeValue = freezed,
    Object? tax = freezed,
    Object? taxRates = freezed,
    Object? displayTax = freezed,
    Object? displayTaxRates = freezed,
    Object? giftVouchers = freezed,
    Object? orderTotalDiscount = freezed,
    Object? orderTotalDiscountValue = freezed,
    Object? redeemedLoyaltyPoints = freezed,
    Object? redeemedLoyaltyPointsAmount = freezed,
    Object? willEarnLoyaltyPoints = freezed,
    Object? orderTotal = freezed,
    Object? orderTotalValue = freezed,
    Object? discounts = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            isEditable:
                freezed == isEditable
                    ? _value.isEditable
                    : isEditable // ignore: cast_nullable_to_non_nullable
                        as bool?,
            subTotal:
                freezed == subTotal
                    ? _value.subTotal
                    : subTotal // ignore: cast_nullable_to_non_nullable
                        as String?,
            subTotalIncludingTax:
                freezed == subTotalIncludingTax
                    ? _value.subTotalIncludingTax
                    : subTotalIncludingTax // ignore: cast_nullable_to_non_nullable
                        as bool?,
            subTotalValue:
                freezed == subTotalValue
                    ? _value.subTotalValue
                    : subTotalValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            subTotalDiscount:
                freezed == subTotalDiscount
                    ? _value.subTotalDiscount
                    : subTotalDiscount // ignore: cast_nullable_to_non_nullable
                        as String?,
            subTotalDiscountValue:
                freezed == subTotalDiscountValue
                    ? _value.subTotalDiscountValue
                    : subTotalDiscountValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            shipping:
                freezed == shipping
                    ? _value.shipping
                    : shipping // ignore: cast_nullable_to_non_nullable
                        as String?,
            requiresShipping:
                freezed == requiresShipping
                    ? _value.requiresShipping
                    : requiresShipping // ignore: cast_nullable_to_non_nullable
                        as bool?,
            selectedShippingMethod:
                freezed == selectedShippingMethod
                    ? _value.selectedShippingMethod
                    : selectedShippingMethod // ignore: cast_nullable_to_non_nullable
                        as String?,
            paymentMethodAdditionalFee:
                freezed == paymentMethodAdditionalFee
                    ? _value.paymentMethodAdditionalFee
                    : paymentMethodAdditionalFee // ignore: cast_nullable_to_non_nullable
                        as String?,
            paymentMethodAdditionalFeeValue:
                freezed == paymentMethodAdditionalFeeValue
                    ? _value.paymentMethodAdditionalFeeValue
                    : paymentMethodAdditionalFeeValue // ignore: cast_nullable_to_non_nullable
                        as double?,
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
            giftVouchers:
                freezed == giftVouchers
                    ? _value.giftVouchers
                    : giftVouchers // ignore: cast_nullable_to_non_nullable
                        as List<GiftVoucher>?,
            orderTotalDiscount:
                freezed == orderTotalDiscount
                    ? _value.orderTotalDiscount
                    : orderTotalDiscount // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderTotalDiscountValue:
                freezed == orderTotalDiscountValue
                    ? _value.orderTotalDiscountValue
                    : orderTotalDiscountValue // ignore: cast_nullable_to_non_nullable
                        as double?,
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
            willEarnLoyaltyPoints:
                freezed == willEarnLoyaltyPoints
                    ? _value.willEarnLoyaltyPoints
                    : willEarnLoyaltyPoints // ignore: cast_nullable_to_non_nullable
                        as int?,
            orderTotal:
                freezed == orderTotal
                    ? _value.orderTotal
                    : orderTotal // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderTotalValue:
                freezed == orderTotalValue
                    ? _value.orderTotalValue
                    : orderTotalValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            discounts:
                freezed == discounts
                    ? _value.discounts
                    : discounts // ignore: cast_nullable_to_non_nullable
                        as Set<String>?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderTotalsModelImplCopyWith<$Res>
    implements $OrderTotalsModelCopyWith<$Res> {
  factory _$$OrderTotalsModelImplCopyWith(
    _$OrderTotalsModelImpl value,
    $Res Function(_$OrderTotalsModelImpl) then,
  ) = __$$OrderTotalsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'IsEditable', includeIfNull: false) bool? isEditable,
    @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
    @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
    bool? subTotalIncludingTax,
    @JsonKey(name: 'SubTotalValue', includeIfNull: false) double? subTotalValue,
    @JsonKey(name: 'SubTotalDiscount', includeIfNull: false)
    String? subTotalDiscount,
    @JsonKey(name: 'SubTotalDiscountValue', includeIfNull: false)
    double? subTotalDiscountValue,
    @JsonKey(name: 'Shipping', includeIfNull: false) String? shipping,
    @JsonKey(name: 'RequiresShipping', includeIfNull: false)
    bool? requiresShipping,
    @JsonKey(name: 'SelectedShippingMethod', includeIfNull: false)
    String? selectedShippingMethod,
    @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
    String? paymentMethodAdditionalFee,
    @JsonKey(name: 'PaymentMethodAdditionalFeeValue', includeIfNull: false)
    double? paymentMethodAdditionalFeeValue,
    @JsonKey(name: 'Tax', includeIfNull: false) String? tax,
    @JsonKey(name: 'TaxRates', includeIfNull: false) List<TaxRate>? taxRates,
    @JsonKey(name: 'DisplayTax', includeIfNull: false) bool? displayTax,
    @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
    bool? displayTaxRates,
    @JsonKey(name: 'GiftVouchers', includeIfNull: false)
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
    @JsonKey(name: 'Discounts', includeIfNull: false) Set<String>? discounts,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$OrderTotalsModelImplCopyWithImpl<$Res>
    extends _$OrderTotalsModelCopyWithImpl<$Res, _$OrderTotalsModelImpl>
    implements _$$OrderTotalsModelImplCopyWith<$Res> {
  __$$OrderTotalsModelImplCopyWithImpl(
    _$OrderTotalsModelImpl _value,
    $Res Function(_$OrderTotalsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderTotalsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isEditable = freezed,
    Object? subTotal = freezed,
    Object? subTotalIncludingTax = freezed,
    Object? subTotalValue = freezed,
    Object? subTotalDiscount = freezed,
    Object? subTotalDiscountValue = freezed,
    Object? shipping = freezed,
    Object? requiresShipping = freezed,
    Object? selectedShippingMethod = freezed,
    Object? paymentMethodAdditionalFee = freezed,
    Object? paymentMethodAdditionalFeeValue = freezed,
    Object? tax = freezed,
    Object? taxRates = freezed,
    Object? displayTax = freezed,
    Object? displayTaxRates = freezed,
    Object? giftVouchers = freezed,
    Object? orderTotalDiscount = freezed,
    Object? orderTotalDiscountValue = freezed,
    Object? redeemedLoyaltyPoints = freezed,
    Object? redeemedLoyaltyPointsAmount = freezed,
    Object? willEarnLoyaltyPoints = freezed,
    Object? orderTotal = freezed,
    Object? orderTotalValue = freezed,
    Object? discounts = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$OrderTotalsModelImpl(
        isEditable:
            freezed == isEditable
                ? _value.isEditable
                : isEditable // ignore: cast_nullable_to_non_nullable
                    as bool?,
        subTotal:
            freezed == subTotal
                ? _value.subTotal
                : subTotal // ignore: cast_nullable_to_non_nullable
                    as String?,
        subTotalIncludingTax:
            freezed == subTotalIncludingTax
                ? _value.subTotalIncludingTax
                : subTotalIncludingTax // ignore: cast_nullable_to_non_nullable
                    as bool?,
        subTotalValue:
            freezed == subTotalValue
                ? _value.subTotalValue
                : subTotalValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        subTotalDiscount:
            freezed == subTotalDiscount
                ? _value.subTotalDiscount
                : subTotalDiscount // ignore: cast_nullable_to_non_nullable
                    as String?,
        subTotalDiscountValue:
            freezed == subTotalDiscountValue
                ? _value.subTotalDiscountValue
                : subTotalDiscountValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        shipping:
            freezed == shipping
                ? _value.shipping
                : shipping // ignore: cast_nullable_to_non_nullable
                    as String?,
        requiresShipping:
            freezed == requiresShipping
                ? _value.requiresShipping
                : requiresShipping // ignore: cast_nullable_to_non_nullable
                    as bool?,
        selectedShippingMethod:
            freezed == selectedShippingMethod
                ? _value.selectedShippingMethod
                : selectedShippingMethod // ignore: cast_nullable_to_non_nullable
                    as String?,
        paymentMethodAdditionalFee:
            freezed == paymentMethodAdditionalFee
                ? _value.paymentMethodAdditionalFee
                : paymentMethodAdditionalFee // ignore: cast_nullable_to_non_nullable
                    as String?,
        paymentMethodAdditionalFeeValue:
            freezed == paymentMethodAdditionalFeeValue
                ? _value.paymentMethodAdditionalFeeValue
                : paymentMethodAdditionalFeeValue // ignore: cast_nullable_to_non_nullable
                    as double?,
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
        giftVouchers:
            freezed == giftVouchers
                ? _value._giftVouchers
                : giftVouchers // ignore: cast_nullable_to_non_nullable
                    as List<GiftVoucher>?,
        orderTotalDiscount:
            freezed == orderTotalDiscount
                ? _value.orderTotalDiscount
                : orderTotalDiscount // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderTotalDiscountValue:
            freezed == orderTotalDiscountValue
                ? _value.orderTotalDiscountValue
                : orderTotalDiscountValue // ignore: cast_nullable_to_non_nullable
                    as double?,
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
        willEarnLoyaltyPoints:
            freezed == willEarnLoyaltyPoints
                ? _value.willEarnLoyaltyPoints
                : willEarnLoyaltyPoints // ignore: cast_nullable_to_non_nullable
                    as int?,
        orderTotal:
            freezed == orderTotal
                ? _value.orderTotal
                : orderTotal // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderTotalValue:
            freezed == orderTotalValue
                ? _value.orderTotalValue
                : orderTotalValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        discounts:
            freezed == discounts
                ? _value._discounts
                : discounts // ignore: cast_nullable_to_non_nullable
                    as Set<String>?,
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
class _$OrderTotalsModelImpl implements _OrderTotalsModel {
  _$OrderTotalsModelImpl({
    @JsonKey(name: 'IsEditable', includeIfNull: false) this.isEditable = false,
    @JsonKey(name: 'SubTotal', includeIfNull: false) this.subTotal,
    @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
    this.subTotalIncludingTax = false,
    @JsonKey(name: 'SubTotalValue', includeIfNull: false) this.subTotalValue,
    @JsonKey(name: 'SubTotalDiscount', includeIfNull: false)
    this.subTotalDiscount,
    @JsonKey(name: 'SubTotalDiscountValue', includeIfNull: false)
    this.subTotalDiscountValue,
    @JsonKey(name: 'Shipping', includeIfNull: false) this.shipping,
    @JsonKey(name: 'RequiresShipping', includeIfNull: false)
    this.requiresShipping = false,
    @JsonKey(name: 'SelectedShippingMethod', includeIfNull: false)
    this.selectedShippingMethod,
    @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
    this.paymentMethodAdditionalFee,
    @JsonKey(name: 'PaymentMethodAdditionalFeeValue', includeIfNull: false)
    this.paymentMethodAdditionalFeeValue,
    @JsonKey(name: 'Tax', includeIfNull: false) this.tax,
    @JsonKey(name: 'TaxRates', includeIfNull: false)
    final List<TaxRate>? taxRates = const [],
    @JsonKey(name: 'DisplayTax', includeIfNull: false) this.displayTax = false,
    @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
    this.displayTaxRates = false,
    @JsonKey(name: 'GiftVouchers', includeIfNull: false)
    final List<GiftVoucher>? giftVouchers = const [],
    @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
    this.orderTotalDiscount,
    @JsonKey(name: 'OrderTotalDiscountValue', includeIfNull: false)
    this.orderTotalDiscountValue,
    @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
    this.redeemedLoyaltyPoints,
    @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
    this.redeemedLoyaltyPointsAmount,
    @JsonKey(name: 'WillEarnLoyaltyPoints', includeIfNull: false)
    this.willEarnLoyaltyPoints,
    @JsonKey(name: 'OrderTotal', includeIfNull: false) this.orderTotal,
    @JsonKey(name: 'OrderTotalValue', includeIfNull: false)
    this.orderTotalValue,
    @JsonKey(name: 'Discounts', includeIfNull: false)
    final Set<String>? discounts = const <String>{},
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _taxRates = taxRates,
       _giftVouchers = giftVouchers,
       _discounts = discounts,
       _userFields = userFields;

  factory _$OrderTotalsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderTotalsModelImplFromJson(json);

  @override
  @JsonKey(name: 'IsEditable', includeIfNull: false)
  final bool? isEditable;
  @override
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  final String? subTotal;
  @override
  @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
  final bool? subTotalIncludingTax;
  @override
  @JsonKey(name: 'SubTotalValue', includeIfNull: false)
  final double? subTotalValue;
  @override
  @JsonKey(name: 'SubTotalDiscount', includeIfNull: false)
  final String? subTotalDiscount;
  @override
  @JsonKey(name: 'SubTotalDiscountValue', includeIfNull: false)
  final double? subTotalDiscountValue;
  @override
  @JsonKey(name: 'Shipping', includeIfNull: false)
  final String? shipping;
  @override
  @JsonKey(name: 'RequiresShipping', includeIfNull: false)
  final bool? requiresShipping;
  @override
  @JsonKey(name: 'SelectedShippingMethod', includeIfNull: false)
  final String? selectedShippingMethod;
  @override
  @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
  final String? paymentMethodAdditionalFee;
  @override
  @JsonKey(name: 'PaymentMethodAdditionalFeeValue', includeIfNull: false)
  final double? paymentMethodAdditionalFeeValue;
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
  @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
  final String? orderTotalDiscount;
  @override
  @JsonKey(name: 'OrderTotalDiscountValue', includeIfNull: false)
  final double? orderTotalDiscountValue;
  @override
  @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
  final int? redeemedLoyaltyPoints;
  @override
  @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
  final String? redeemedLoyaltyPointsAmount;
  @override
  @JsonKey(name: 'WillEarnLoyaltyPoints', includeIfNull: false)
  final int? willEarnLoyaltyPoints;
  @override
  @JsonKey(name: 'OrderTotal', includeIfNull: false)
  final String? orderTotal;
  @override
  @JsonKey(name: 'OrderTotalValue', includeIfNull: false)
  final double? orderTotalValue;
  final Set<String>? _discounts;
  @override
  @JsonKey(name: 'Discounts', includeIfNull: false)
  Set<String>? get discounts {
    final value = _discounts;
    if (value == null) return null;
    if (_discounts is EqualUnmodifiableSetView) return _discounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

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
    return 'OrderTotalsModel(isEditable: $isEditable, subTotal: $subTotal, subTotalIncludingTax: $subTotalIncludingTax, subTotalValue: $subTotalValue, subTotalDiscount: $subTotalDiscount, subTotalDiscountValue: $subTotalDiscountValue, shipping: $shipping, requiresShipping: $requiresShipping, selectedShippingMethod: $selectedShippingMethod, paymentMethodAdditionalFee: $paymentMethodAdditionalFee, paymentMethodAdditionalFeeValue: $paymentMethodAdditionalFeeValue, tax: $tax, taxRates: $taxRates, displayTax: $displayTax, displayTaxRates: $displayTaxRates, giftVouchers: $giftVouchers, orderTotalDiscount: $orderTotalDiscount, orderTotalDiscountValue: $orderTotalDiscountValue, redeemedLoyaltyPoints: $redeemedLoyaltyPoints, redeemedLoyaltyPointsAmount: $redeemedLoyaltyPointsAmount, willEarnLoyaltyPoints: $willEarnLoyaltyPoints, orderTotal: $orderTotal, orderTotalValue: $orderTotalValue, discounts: $discounts, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderTotalsModelImpl &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable) &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.subTotalIncludingTax, subTotalIncludingTax) ||
                other.subTotalIncludingTax == subTotalIncludingTax) &&
            (identical(other.subTotalValue, subTotalValue) ||
                other.subTotalValue == subTotalValue) &&
            (identical(other.subTotalDiscount, subTotalDiscount) ||
                other.subTotalDiscount == subTotalDiscount) &&
            (identical(other.subTotalDiscountValue, subTotalDiscountValue) ||
                other.subTotalDiscountValue == subTotalDiscountValue) &&
            (identical(other.shipping, shipping) ||
                other.shipping == shipping) &&
            (identical(other.requiresShipping, requiresShipping) ||
                other.requiresShipping == requiresShipping) &&
            (identical(other.selectedShippingMethod, selectedShippingMethod) ||
                other.selectedShippingMethod == selectedShippingMethod) &&
            (identical(
                  other.paymentMethodAdditionalFee,
                  paymentMethodAdditionalFee,
                ) ||
                other.paymentMethodAdditionalFee ==
                    paymentMethodAdditionalFee) &&
            (identical(
                  other.paymentMethodAdditionalFeeValue,
                  paymentMethodAdditionalFeeValue,
                ) ||
                other.paymentMethodAdditionalFeeValue ==
                    paymentMethodAdditionalFeeValue) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            const DeepCollectionEquality().equals(other._taxRates, _taxRates) &&
            (identical(other.displayTax, displayTax) ||
                other.displayTax == displayTax) &&
            (identical(other.displayTaxRates, displayTaxRates) ||
                other.displayTaxRates == displayTaxRates) &&
            const DeepCollectionEquality().equals(
              other._giftVouchers,
              _giftVouchers,
            ) &&
            (identical(other.orderTotalDiscount, orderTotalDiscount) ||
                other.orderTotalDiscount == orderTotalDiscount) &&
            (identical(
                  other.orderTotalDiscountValue,
                  orderTotalDiscountValue,
                ) ||
                other.orderTotalDiscountValue == orderTotalDiscountValue) &&
            (identical(other.redeemedLoyaltyPoints, redeemedLoyaltyPoints) ||
                other.redeemedLoyaltyPoints == redeemedLoyaltyPoints) &&
            (identical(
                  other.redeemedLoyaltyPointsAmount,
                  redeemedLoyaltyPointsAmount,
                ) ||
                other.redeemedLoyaltyPointsAmount ==
                    redeemedLoyaltyPointsAmount) &&
            (identical(other.willEarnLoyaltyPoints, willEarnLoyaltyPoints) ||
                other.willEarnLoyaltyPoints == willEarnLoyaltyPoints) &&
            (identical(other.orderTotal, orderTotal) ||
                other.orderTotal == orderTotal) &&
            (identical(other.orderTotalValue, orderTotalValue) ||
                other.orderTotalValue == orderTotalValue) &&
            const DeepCollectionEquality().equals(
              other._discounts,
              _discounts,
            ) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    isEditable,
    subTotal,
    subTotalIncludingTax,
    subTotalValue,
    subTotalDiscount,
    subTotalDiscountValue,
    shipping,
    requiresShipping,
    selectedShippingMethod,
    paymentMethodAdditionalFee,
    paymentMethodAdditionalFeeValue,
    tax,
    const DeepCollectionEquality().hash(_taxRates),
    displayTax,
    displayTaxRates,
    const DeepCollectionEquality().hash(_giftVouchers),
    orderTotalDiscount,
    orderTotalDiscountValue,
    redeemedLoyaltyPoints,
    redeemedLoyaltyPointsAmount,
    willEarnLoyaltyPoints,
    orderTotal,
    orderTotalValue,
    const DeepCollectionEquality().hash(_discounts),
    const DeepCollectionEquality().hash(_userFields),
  ]);

  /// Create a copy of OrderTotalsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderTotalsModelImplCopyWith<_$OrderTotalsModelImpl> get copyWith =>
      __$$OrderTotalsModelImplCopyWithImpl<_$OrderTotalsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderTotalsModelImplToJson(this);
  }
}

abstract class _OrderTotalsModel implements OrderTotalsModel {
  factory _OrderTotalsModel({
    @JsonKey(name: 'IsEditable', includeIfNull: false) final bool? isEditable,
    @JsonKey(name: 'SubTotal', includeIfNull: false) final String? subTotal,
    @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
    final bool? subTotalIncludingTax,
    @JsonKey(name: 'SubTotalValue', includeIfNull: false)
    final double? subTotalValue,
    @JsonKey(name: 'SubTotalDiscount', includeIfNull: false)
    final String? subTotalDiscount,
    @JsonKey(name: 'SubTotalDiscountValue', includeIfNull: false)
    final double? subTotalDiscountValue,
    @JsonKey(name: 'Shipping', includeIfNull: false) final String? shipping,
    @JsonKey(name: 'RequiresShipping', includeIfNull: false)
    final bool? requiresShipping,
    @JsonKey(name: 'SelectedShippingMethod', includeIfNull: false)
    final String? selectedShippingMethod,
    @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
    final String? paymentMethodAdditionalFee,
    @JsonKey(name: 'PaymentMethodAdditionalFeeValue', includeIfNull: false)
    final double? paymentMethodAdditionalFeeValue,
    @JsonKey(name: 'Tax', includeIfNull: false) final String? tax,
    @JsonKey(name: 'TaxRates', includeIfNull: false)
    final List<TaxRate>? taxRates,
    @JsonKey(name: 'DisplayTax', includeIfNull: false) final bool? displayTax,
    @JsonKey(name: 'DisplayTaxRates', includeIfNull: false)
    final bool? displayTaxRates,
    @JsonKey(name: 'GiftVouchers', includeIfNull: false)
    final List<GiftVoucher>? giftVouchers,
    @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
    final String? orderTotalDiscount,
    @JsonKey(name: 'OrderTotalDiscountValue', includeIfNull: false)
    final double? orderTotalDiscountValue,
    @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
    final int? redeemedLoyaltyPoints,
    @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
    final String? redeemedLoyaltyPointsAmount,
    @JsonKey(name: 'WillEarnLoyaltyPoints', includeIfNull: false)
    final int? willEarnLoyaltyPoints,
    @JsonKey(name: 'OrderTotal', includeIfNull: false) final String? orderTotal,
    @JsonKey(name: 'OrderTotalValue', includeIfNull: false)
    final double? orderTotalValue,
    @JsonKey(name: 'Discounts', includeIfNull: false)
    final Set<String>? discounts,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$OrderTotalsModelImpl;

  factory _OrderTotalsModel.fromJson(Map<String, dynamic> json) =
      _$OrderTotalsModelImpl.fromJson;

  @override
  @JsonKey(name: 'IsEditable', includeIfNull: false)
  bool? get isEditable;
  @override
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  String? get subTotal;
  @override
  @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
  bool? get subTotalIncludingTax;
  @override
  @JsonKey(name: 'SubTotalValue', includeIfNull: false)
  double? get subTotalValue;
  @override
  @JsonKey(name: 'SubTotalDiscount', includeIfNull: false)
  String? get subTotalDiscount;
  @override
  @JsonKey(name: 'SubTotalDiscountValue', includeIfNull: false)
  double? get subTotalDiscountValue;
  @override
  @JsonKey(name: 'Shipping', includeIfNull: false)
  String? get shipping;
  @override
  @JsonKey(name: 'RequiresShipping', includeIfNull: false)
  bool? get requiresShipping;
  @override
  @JsonKey(name: 'SelectedShippingMethod', includeIfNull: false)
  String? get selectedShippingMethod;
  @override
  @JsonKey(name: 'PaymentMethodAdditionalFee', includeIfNull: false)
  String? get paymentMethodAdditionalFee;
  @override
  @JsonKey(name: 'PaymentMethodAdditionalFeeValue', includeIfNull: false)
  double? get paymentMethodAdditionalFeeValue;
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
  @JsonKey(name: 'GiftVouchers', includeIfNull: false)
  List<GiftVoucher>? get giftVouchers;
  @override
  @JsonKey(name: 'OrderTotalDiscount', includeIfNull: false)
  String? get orderTotalDiscount;
  @override
  @JsonKey(name: 'OrderTotalDiscountValue', includeIfNull: false)
  double? get orderTotalDiscountValue;
  @override
  @JsonKey(name: 'RedeemedLoyaltyPoints', includeIfNull: false)
  int? get redeemedLoyaltyPoints;
  @override
  @JsonKey(name: 'RedeemedLoyaltyPointsAmount', includeIfNull: false)
  String? get redeemedLoyaltyPointsAmount;
  @override
  @JsonKey(name: 'WillEarnLoyaltyPoints', includeIfNull: false)
  int? get willEarnLoyaltyPoints;
  @override
  @JsonKey(name: 'OrderTotal', includeIfNull: false)
  String? get orderTotal;
  @override
  @JsonKey(name: 'OrderTotalValue', includeIfNull: false)
  double? get orderTotalValue;
  @override
  @JsonKey(name: 'Discounts', includeIfNull: false)
  Set<String>? get discounts;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of OrderTotalsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderTotalsModelImplCopyWith<_$OrderTotalsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
