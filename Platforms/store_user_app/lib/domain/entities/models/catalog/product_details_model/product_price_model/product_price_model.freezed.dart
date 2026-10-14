// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_price_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductPriceModel _$ProductPriceModelFromJson(Map<String, dynamic> json) {
  return _ProductPriceModel.fromJson(json);
}

/// @nodoc
mixin _$ProductPriceModel {
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  String? get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'OldPrice', includeIfNull: false)
  String? get oldPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'CatalogPrice', includeIfNull: false)
  String? get catalogPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'Price', includeIfNull: false)
  String? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
  String? get priceWithDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'PriceValue', includeIfNull: false)
  double? get priceValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'EnteredPrice', includeIfNull: false)
  bool? get enteredPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'CallForPrice', includeIfNull: false)
  bool? get callForPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'HidePrices', includeIfNull: false)
  bool? get hidePrices => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsReservation', includeIfNull: false)
  bool? get isReservation => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReservationPrice', includeIfNull: false)
  String? get reservationPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsAuction', includeIfNull: false)
  bool? get isAuction => throw _privateConstructorUsedError;
  @JsonKey(name: 'HighestBid', includeIfNull: false)
  String? get highestBid => throw _privateConstructorUsedError;
  @JsonKey(name: 'HighestBidValue', includeIfNull: false)
  double? get highestBidValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'StartPrice', includeIfNull: false)
  String? get startPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'StartPriceValue', includeIfNull: false)
  double? get startPriceValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
  bool? get disableBuyButton => throw _privateConstructorUsedError;
  @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
  String? get basePricePAngV => throw _privateConstructorUsedError;
  @JsonKey(name: 'AppliedDiscounts', includeIfNull: false)
  List<ApplyDiscount>? get appliedDiscounts =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'PreferredTierPrice', includeIfNull: false)
  TierPrice? get preferredTierPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductPriceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductPriceModelCopyWith<ProductPriceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductPriceModelCopyWith<$Res> {
  factory $ProductPriceModelCopyWith(
    ProductPriceModel value,
    $Res Function(ProductPriceModel) then,
  ) = _$ProductPriceModelCopyWithImpl<$Res, ProductPriceModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
    @JsonKey(name: 'OldPrice', includeIfNull: false) String? oldPrice,
    @JsonKey(name: 'CatalogPrice', includeIfNull: false) String? catalogPrice,
    @JsonKey(name: 'Price', includeIfNull: false) String? price,
    @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
    String? priceWithDiscount,
    @JsonKey(name: 'PriceValue', includeIfNull: false) double? priceValue,
    @JsonKey(name: 'EnteredPrice', includeIfNull: false) bool? enteredPrice,
    @JsonKey(name: 'CallForPrice', includeIfNull: false) bool? callForPrice,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'HidePrices', includeIfNull: false) bool? hidePrices,
    @JsonKey(name: 'IsReservation', includeIfNull: false) bool? isReservation,
    @JsonKey(name: 'ReservationPrice', includeIfNull: false)
    String? reservationPrice,
    @JsonKey(name: 'IsAuction', includeIfNull: false) bool? isAuction,
    @JsonKey(name: 'HighestBid', includeIfNull: false) String? highestBid,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    double? highestBidValue,
    @JsonKey(name: 'StartPrice', includeIfNull: false) String? startPrice,
    @JsonKey(name: 'StartPriceValue', includeIfNull: false)
    double? startPriceValue,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    bool? disableBuyButton,
    @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
    String? basePricePAngV,
    @JsonKey(name: 'AppliedDiscounts', includeIfNull: false)
    List<ApplyDiscount>? appliedDiscounts,
    @JsonKey(name: 'PreferredTierPrice', includeIfNull: false)
    TierPrice? preferredTierPrice,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $TierPriceCopyWith<$Res>? get preferredTierPrice;
}

/// @nodoc
class _$ProductPriceModelCopyWithImpl<$Res, $Val extends ProductPriceModel>
    implements $ProductPriceModelCopyWith<$Res> {
  _$ProductPriceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyCode = freezed,
    Object? oldPrice = freezed,
    Object? catalogPrice = freezed,
    Object? price = freezed,
    Object? priceWithDiscount = freezed,
    Object? priceValue = freezed,
    Object? enteredPrice = freezed,
    Object? callForPrice = freezed,
    Object? productId = freezed,
    Object? hidePrices = freezed,
    Object? isReservation = freezed,
    Object? reservationPrice = freezed,
    Object? isAuction = freezed,
    Object? highestBid = freezed,
    Object? highestBidValue = freezed,
    Object? startPrice = freezed,
    Object? startPriceValue = freezed,
    Object? disableBuyButton = freezed,
    Object? basePricePAngV = freezed,
    Object? appliedDiscounts = freezed,
    Object? preferredTierPrice = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            currencyCode:
                freezed == currencyCode
                    ? _value.currencyCode
                    : currencyCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            oldPrice:
                freezed == oldPrice
                    ? _value.oldPrice
                    : oldPrice // ignore: cast_nullable_to_non_nullable
                        as String?,
            catalogPrice:
                freezed == catalogPrice
                    ? _value.catalogPrice
                    : catalogPrice // ignore: cast_nullable_to_non_nullable
                        as String?,
            price:
                freezed == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as String?,
            priceWithDiscount:
                freezed == priceWithDiscount
                    ? _value.priceWithDiscount
                    : priceWithDiscount // ignore: cast_nullable_to_non_nullable
                        as String?,
            priceValue:
                freezed == priceValue
                    ? _value.priceValue
                    : priceValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            enteredPrice:
                freezed == enteredPrice
                    ? _value.enteredPrice
                    : enteredPrice // ignore: cast_nullable_to_non_nullable
                        as bool?,
            callForPrice:
                freezed == callForPrice
                    ? _value.callForPrice
                    : callForPrice // ignore: cast_nullable_to_non_nullable
                        as bool?,
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            hidePrices:
                freezed == hidePrices
                    ? _value.hidePrices
                    : hidePrices // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isReservation:
                freezed == isReservation
                    ? _value.isReservation
                    : isReservation // ignore: cast_nullable_to_non_nullable
                        as bool?,
            reservationPrice:
                freezed == reservationPrice
                    ? _value.reservationPrice
                    : reservationPrice // ignore: cast_nullable_to_non_nullable
                        as String?,
            isAuction:
                freezed == isAuction
                    ? _value.isAuction
                    : isAuction // ignore: cast_nullable_to_non_nullable
                        as bool?,
            highestBid:
                freezed == highestBid
                    ? _value.highestBid
                    : highestBid // ignore: cast_nullable_to_non_nullable
                        as String?,
            highestBidValue:
                freezed == highestBidValue
                    ? _value.highestBidValue
                    : highestBidValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            startPrice:
                freezed == startPrice
                    ? _value.startPrice
                    : startPrice // ignore: cast_nullable_to_non_nullable
                        as String?,
            startPriceValue:
                freezed == startPriceValue
                    ? _value.startPriceValue
                    : startPriceValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            disableBuyButton:
                freezed == disableBuyButton
                    ? _value.disableBuyButton
                    : disableBuyButton // ignore: cast_nullable_to_non_nullable
                        as bool?,
            basePricePAngV:
                freezed == basePricePAngV
                    ? _value.basePricePAngV
                    : basePricePAngV // ignore: cast_nullable_to_non_nullable
                        as String?,
            appliedDiscounts:
                freezed == appliedDiscounts
                    ? _value.appliedDiscounts
                    : appliedDiscounts // ignore: cast_nullable_to_non_nullable
                        as List<ApplyDiscount>?,
            preferredTierPrice:
                freezed == preferredTierPrice
                    ? _value.preferredTierPrice
                    : preferredTierPrice // ignore: cast_nullable_to_non_nullable
                        as TierPrice?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TierPriceCopyWith<$Res>? get preferredTierPrice {
    if (_value.preferredTierPrice == null) {
      return null;
    }

    return $TierPriceCopyWith<$Res>(_value.preferredTierPrice!, (value) {
      return _then(_value.copyWith(preferredTierPrice: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductPriceModelImplCopyWith<$Res>
    implements $ProductPriceModelCopyWith<$Res> {
  factory _$$ProductPriceModelImplCopyWith(
    _$ProductPriceModelImpl value,
    $Res Function(_$ProductPriceModelImpl) then,
  ) = __$$ProductPriceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
    @JsonKey(name: 'OldPrice', includeIfNull: false) String? oldPrice,
    @JsonKey(name: 'CatalogPrice', includeIfNull: false) String? catalogPrice,
    @JsonKey(name: 'Price', includeIfNull: false) String? price,
    @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
    String? priceWithDiscount,
    @JsonKey(name: 'PriceValue', includeIfNull: false) double? priceValue,
    @JsonKey(name: 'EnteredPrice', includeIfNull: false) bool? enteredPrice,
    @JsonKey(name: 'CallForPrice', includeIfNull: false) bool? callForPrice,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'HidePrices', includeIfNull: false) bool? hidePrices,
    @JsonKey(name: 'IsReservation', includeIfNull: false) bool? isReservation,
    @JsonKey(name: 'ReservationPrice', includeIfNull: false)
    String? reservationPrice,
    @JsonKey(name: 'IsAuction', includeIfNull: false) bool? isAuction,
    @JsonKey(name: 'HighestBid', includeIfNull: false) String? highestBid,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    double? highestBidValue,
    @JsonKey(name: 'StartPrice', includeIfNull: false) String? startPrice,
    @JsonKey(name: 'StartPriceValue', includeIfNull: false)
    double? startPriceValue,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    bool? disableBuyButton,
    @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
    String? basePricePAngV,
    @JsonKey(name: 'AppliedDiscounts', includeIfNull: false)
    List<ApplyDiscount>? appliedDiscounts,
    @JsonKey(name: 'PreferredTierPrice', includeIfNull: false)
    TierPrice? preferredTierPrice,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $TierPriceCopyWith<$Res>? get preferredTierPrice;
}

/// @nodoc
class __$$ProductPriceModelImplCopyWithImpl<$Res>
    extends _$ProductPriceModelCopyWithImpl<$Res, _$ProductPriceModelImpl>
    implements _$$ProductPriceModelImplCopyWith<$Res> {
  __$$ProductPriceModelImplCopyWithImpl(
    _$ProductPriceModelImpl _value,
    $Res Function(_$ProductPriceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyCode = freezed,
    Object? oldPrice = freezed,
    Object? catalogPrice = freezed,
    Object? price = freezed,
    Object? priceWithDiscount = freezed,
    Object? priceValue = freezed,
    Object? enteredPrice = freezed,
    Object? callForPrice = freezed,
    Object? productId = freezed,
    Object? hidePrices = freezed,
    Object? isReservation = freezed,
    Object? reservationPrice = freezed,
    Object? isAuction = freezed,
    Object? highestBid = freezed,
    Object? highestBidValue = freezed,
    Object? startPrice = freezed,
    Object? startPriceValue = freezed,
    Object? disableBuyButton = freezed,
    Object? basePricePAngV = freezed,
    Object? appliedDiscounts = freezed,
    Object? preferredTierPrice = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductPriceModelImpl(
        currencyCode:
            freezed == currencyCode
                ? _value.currencyCode
                : currencyCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        oldPrice:
            freezed == oldPrice
                ? _value.oldPrice
                : oldPrice // ignore: cast_nullable_to_non_nullable
                    as String?,
        catalogPrice:
            freezed == catalogPrice
                ? _value.catalogPrice
                : catalogPrice // ignore: cast_nullable_to_non_nullable
                    as String?,
        price:
            freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as String?,
        priceWithDiscount:
            freezed == priceWithDiscount
                ? _value.priceWithDiscount
                : priceWithDiscount // ignore: cast_nullable_to_non_nullable
                    as String?,
        priceValue:
            freezed == priceValue
                ? _value.priceValue
                : priceValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        enteredPrice:
            freezed == enteredPrice
                ? _value.enteredPrice
                : enteredPrice // ignore: cast_nullable_to_non_nullable
                    as bool?,
        callForPrice:
            freezed == callForPrice
                ? _value.callForPrice
                : callForPrice // ignore: cast_nullable_to_non_nullable
                    as bool?,
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        hidePrices:
            freezed == hidePrices
                ? _value.hidePrices
                : hidePrices // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isReservation:
            freezed == isReservation
                ? _value.isReservation
                : isReservation // ignore: cast_nullable_to_non_nullable
                    as bool?,
        reservationPrice:
            freezed == reservationPrice
                ? _value.reservationPrice
                : reservationPrice // ignore: cast_nullable_to_non_nullable
                    as String?,
        isAuction:
            freezed == isAuction
                ? _value.isAuction
                : isAuction // ignore: cast_nullable_to_non_nullable
                    as bool?,
        highestBid:
            freezed == highestBid
                ? _value.highestBid
                : highestBid // ignore: cast_nullable_to_non_nullable
                    as String?,
        highestBidValue:
            freezed == highestBidValue
                ? _value.highestBidValue
                : highestBidValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        startPrice:
            freezed == startPrice
                ? _value.startPrice
                : startPrice // ignore: cast_nullable_to_non_nullable
                    as String?,
        startPriceValue:
            freezed == startPriceValue
                ? _value.startPriceValue
                : startPriceValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        disableBuyButton:
            freezed == disableBuyButton
                ? _value.disableBuyButton
                : disableBuyButton // ignore: cast_nullable_to_non_nullable
                    as bool?,
        basePricePAngV:
            freezed == basePricePAngV
                ? _value.basePricePAngV
                : basePricePAngV // ignore: cast_nullable_to_non_nullable
                    as String?,
        appliedDiscounts:
            freezed == appliedDiscounts
                ? _value._appliedDiscounts
                : appliedDiscounts // ignore: cast_nullable_to_non_nullable
                    as List<ApplyDiscount>?,
        preferredTierPrice:
            freezed == preferredTierPrice
                ? _value.preferredTierPrice
                : preferredTierPrice // ignore: cast_nullable_to_non_nullable
                    as TierPrice?,
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
class _$ProductPriceModelImpl implements _ProductPriceModel {
  _$ProductPriceModelImpl({
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) this.currencyCode,
    @JsonKey(name: 'OldPrice', includeIfNull: false) this.oldPrice,
    @JsonKey(name: 'CatalogPrice', includeIfNull: false) this.catalogPrice,
    @JsonKey(name: 'Price', includeIfNull: false) this.price,
    @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
    this.priceWithDiscount,
    @JsonKey(name: 'PriceValue', includeIfNull: false) this.priceValue,
    @JsonKey(name: 'EnteredPrice', includeIfNull: false)
    this.enteredPrice = false,
    @JsonKey(name: 'CallForPrice', includeIfNull: false)
    this.callForPrice = false,
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'HidePrices', includeIfNull: false) this.hidePrices = false,
    @JsonKey(name: 'IsReservation', includeIfNull: false)
    this.isReservation = false,
    @JsonKey(name: 'ReservationPrice', includeIfNull: false)
    this.reservationPrice,
    @JsonKey(name: 'IsAuction', includeIfNull: false) this.isAuction = false,
    @JsonKey(name: 'HighestBid', includeIfNull: false) this.highestBid,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    this.highestBidValue,
    @JsonKey(name: 'StartPrice', includeIfNull: false) this.startPrice,
    @JsonKey(name: 'StartPriceValue', includeIfNull: false)
    this.startPriceValue,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    this.disableBuyButton = false,
    @JsonKey(name: 'BasePricePAngV', includeIfNull: false) this.basePricePAngV,
    @JsonKey(name: 'AppliedDiscounts', includeIfNull: false)
    final List<ApplyDiscount>? appliedDiscounts = const [],
    @JsonKey(name: 'PreferredTierPrice', includeIfNull: false)
    this.preferredTierPrice,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _appliedDiscounts = appliedDiscounts,
       _userFields = userFields;

  factory _$ProductPriceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductPriceModelImplFromJson(json);

  @override
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  final String? currencyCode;
  @override
  @JsonKey(name: 'OldPrice', includeIfNull: false)
  final String? oldPrice;
  @override
  @JsonKey(name: 'CatalogPrice', includeIfNull: false)
  final String? catalogPrice;
  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  final String? price;
  @override
  @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
  final String? priceWithDiscount;
  @override
  @JsonKey(name: 'PriceValue', includeIfNull: false)
  final double? priceValue;
  @override
  @JsonKey(name: 'EnteredPrice', includeIfNull: false)
  final bool? enteredPrice;
  @override
  @JsonKey(name: 'CallForPrice', includeIfNull: false)
  final bool? callForPrice;
  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'HidePrices', includeIfNull: false)
  final bool? hidePrices;
  @override
  @JsonKey(name: 'IsReservation', includeIfNull: false)
  final bool? isReservation;
  @override
  @JsonKey(name: 'ReservationPrice', includeIfNull: false)
  final String? reservationPrice;
  @override
  @JsonKey(name: 'IsAuction', includeIfNull: false)
  final bool? isAuction;
  @override
  @JsonKey(name: 'HighestBid', includeIfNull: false)
  final String? highestBid;
  @override
  @JsonKey(name: 'HighestBidValue', includeIfNull: false)
  final double? highestBidValue;
  @override
  @JsonKey(name: 'StartPrice', includeIfNull: false)
  final String? startPrice;
  @override
  @JsonKey(name: 'StartPriceValue', includeIfNull: false)
  final double? startPriceValue;
  @override
  @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
  final bool? disableBuyButton;
  @override
  @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
  final String? basePricePAngV;
  final List<ApplyDiscount>? _appliedDiscounts;
  @override
  @JsonKey(name: 'AppliedDiscounts', includeIfNull: false)
  List<ApplyDiscount>? get appliedDiscounts {
    final value = _appliedDiscounts;
    if (value == null) return null;
    if (_appliedDiscounts is EqualUnmodifiableListView)
      return _appliedDiscounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'PreferredTierPrice', includeIfNull: false)
  final TierPrice? preferredTierPrice;
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
    return 'ProductPriceModel(currencyCode: $currencyCode, oldPrice: $oldPrice, catalogPrice: $catalogPrice, price: $price, priceWithDiscount: $priceWithDiscount, priceValue: $priceValue, enteredPrice: $enteredPrice, callForPrice: $callForPrice, productId: $productId, hidePrices: $hidePrices, isReservation: $isReservation, reservationPrice: $reservationPrice, isAuction: $isAuction, highestBid: $highestBid, highestBidValue: $highestBidValue, startPrice: $startPrice, startPriceValue: $startPriceValue, disableBuyButton: $disableBuyButton, basePricePAngV: $basePricePAngV, appliedDiscounts: $appliedDiscounts, preferredTierPrice: $preferredTierPrice, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductPriceModelImpl &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.oldPrice, oldPrice) ||
                other.oldPrice == oldPrice) &&
            (identical(other.catalogPrice, catalogPrice) ||
                other.catalogPrice == catalogPrice) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.priceWithDiscount, priceWithDiscount) ||
                other.priceWithDiscount == priceWithDiscount) &&
            (identical(other.priceValue, priceValue) ||
                other.priceValue == priceValue) &&
            (identical(other.enteredPrice, enteredPrice) ||
                other.enteredPrice == enteredPrice) &&
            (identical(other.callForPrice, callForPrice) ||
                other.callForPrice == callForPrice) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.hidePrices, hidePrices) ||
                other.hidePrices == hidePrices) &&
            (identical(other.isReservation, isReservation) ||
                other.isReservation == isReservation) &&
            (identical(other.reservationPrice, reservationPrice) ||
                other.reservationPrice == reservationPrice) &&
            (identical(other.isAuction, isAuction) ||
                other.isAuction == isAuction) &&
            (identical(other.highestBid, highestBid) ||
                other.highestBid == highestBid) &&
            (identical(other.highestBidValue, highestBidValue) ||
                other.highestBidValue == highestBidValue) &&
            (identical(other.startPrice, startPrice) ||
                other.startPrice == startPrice) &&
            (identical(other.startPriceValue, startPriceValue) ||
                other.startPriceValue == startPriceValue) &&
            (identical(other.disableBuyButton, disableBuyButton) ||
                other.disableBuyButton == disableBuyButton) &&
            (identical(other.basePricePAngV, basePricePAngV) ||
                other.basePricePAngV == basePricePAngV) &&
            const DeepCollectionEquality().equals(
              other._appliedDiscounts,
              _appliedDiscounts,
            ) &&
            (identical(other.preferredTierPrice, preferredTierPrice) ||
                other.preferredTierPrice == preferredTierPrice) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    currencyCode,
    oldPrice,
    catalogPrice,
    price,
    priceWithDiscount,
    priceValue,
    enteredPrice,
    callForPrice,
    productId,
    hidePrices,
    isReservation,
    reservationPrice,
    isAuction,
    highestBid,
    highestBidValue,
    startPrice,
    startPriceValue,
    disableBuyButton,
    basePricePAngV,
    const DeepCollectionEquality().hash(_appliedDiscounts),
    preferredTierPrice,
    const DeepCollectionEquality().hash(_userFields),
  ]);

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductPriceModelImplCopyWith<_$ProductPriceModelImpl> get copyWith =>
      __$$ProductPriceModelImplCopyWithImpl<_$ProductPriceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductPriceModelImplToJson(this);
  }
}

abstract class _ProductPriceModel implements ProductPriceModel {
  factory _ProductPriceModel({
    @JsonKey(name: 'CurrencyCode', includeIfNull: false)
    final String? currencyCode,
    @JsonKey(name: 'OldPrice', includeIfNull: false) final String? oldPrice,
    @JsonKey(name: 'CatalogPrice', includeIfNull: false)
    final String? catalogPrice,
    @JsonKey(name: 'Price', includeIfNull: false) final String? price,
    @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
    final String? priceWithDiscount,
    @JsonKey(name: 'PriceValue', includeIfNull: false) final double? priceValue,
    @JsonKey(name: 'EnteredPrice', includeIfNull: false)
    final bool? enteredPrice,
    @JsonKey(name: 'CallForPrice', includeIfNull: false)
    final bool? callForPrice,
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'HidePrices', includeIfNull: false) final bool? hidePrices,
    @JsonKey(name: 'IsReservation', includeIfNull: false)
    final bool? isReservation,
    @JsonKey(name: 'ReservationPrice', includeIfNull: false)
    final String? reservationPrice,
    @JsonKey(name: 'IsAuction', includeIfNull: false) final bool? isAuction,
    @JsonKey(name: 'HighestBid', includeIfNull: false) final String? highestBid,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    final double? highestBidValue,
    @JsonKey(name: 'StartPrice', includeIfNull: false) final String? startPrice,
    @JsonKey(name: 'StartPriceValue', includeIfNull: false)
    final double? startPriceValue,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    final bool? disableBuyButton,
    @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
    final String? basePricePAngV,
    @JsonKey(name: 'AppliedDiscounts', includeIfNull: false)
    final List<ApplyDiscount>? appliedDiscounts,
    @JsonKey(name: 'PreferredTierPrice', includeIfNull: false)
    final TierPrice? preferredTierPrice,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductPriceModelImpl;

  factory _ProductPriceModel.fromJson(Map<String, dynamic> json) =
      _$ProductPriceModelImpl.fromJson;

  @override
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  String? get currencyCode;
  @override
  @JsonKey(name: 'OldPrice', includeIfNull: false)
  String? get oldPrice;
  @override
  @JsonKey(name: 'CatalogPrice', includeIfNull: false)
  String? get catalogPrice;
  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  String? get price;
  @override
  @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
  String? get priceWithDiscount;
  @override
  @JsonKey(name: 'PriceValue', includeIfNull: false)
  double? get priceValue;
  @override
  @JsonKey(name: 'EnteredPrice', includeIfNull: false)
  bool? get enteredPrice;
  @override
  @JsonKey(name: 'CallForPrice', includeIfNull: false)
  bool? get callForPrice;
  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'HidePrices', includeIfNull: false)
  bool? get hidePrices;
  @override
  @JsonKey(name: 'IsReservation', includeIfNull: false)
  bool? get isReservation;
  @override
  @JsonKey(name: 'ReservationPrice', includeIfNull: false)
  String? get reservationPrice;
  @override
  @JsonKey(name: 'IsAuction', includeIfNull: false)
  bool? get isAuction;
  @override
  @JsonKey(name: 'HighestBid', includeIfNull: false)
  String? get highestBid;
  @override
  @JsonKey(name: 'HighestBidValue', includeIfNull: false)
  double? get highestBidValue;
  @override
  @JsonKey(name: 'StartPrice', includeIfNull: false)
  String? get startPrice;
  @override
  @JsonKey(name: 'StartPriceValue', includeIfNull: false)
  double? get startPriceValue;
  @override
  @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
  bool? get disableBuyButton;
  @override
  @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
  String? get basePricePAngV;
  @override
  @JsonKey(name: 'AppliedDiscounts', includeIfNull: false)
  List<ApplyDiscount>? get appliedDiscounts;
  @override
  @JsonKey(name: 'PreferredTierPrice', includeIfNull: false)
  TierPrice? get preferredTierPrice;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductPriceModelImplCopyWith<_$ProductPriceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
