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
  @JsonKey(name: 'OldPrice', includeIfNull: false)
  String? get oldPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'OldPriceValue', includeIfNull: false)
  double? get oldPriceValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'CatalogPrice', includeIfNull: false)
  String? get catalogPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'Price', includeIfNull: false)
  String? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'CallForPrice', includeIfNull: false)
  bool? get callForPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'PriceValue', includeIfNull: false)
  double? get priceValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'PriceIncludesTax', includeIfNull: false)
  bool? get priceIncludesTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'StartPrice', includeIfNull: false)
  String? get startPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'StartPriceValue', includeIfNull: false)
  double? get startPriceValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'HighestBid', includeIfNull: false)
  String? get highestBid => throw _privateConstructorUsedError;
  @JsonKey(name: 'HighestBidValue', includeIfNull: false)
  double? get highestBidValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
  String? get basePricePAngV => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
  bool? get disableBuyButton => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
  bool? get disableWishlistButton => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisableAddToCompareListButton', includeIfNull: false)
  bool? get disableAddToCompareListButton => throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
  bool? get availableForPreOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
  DateTime? get preOrderDateTimeUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'ForceRedirectionAfterAddingToCart', includeIfNull: false)
  bool? get forceRedirectionAfterAddingToCart =>
      throw _privateConstructorUsedError;
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
    @JsonKey(name: 'OldPrice', includeIfNull: false) String? oldPrice,
    @JsonKey(name: 'OldPriceValue', includeIfNull: false) double? oldPriceValue,
    @JsonKey(name: 'CatalogPrice', includeIfNull: false) String? catalogPrice,
    @JsonKey(name: 'Price', includeIfNull: false) String? price,
    @JsonKey(name: 'CallForPrice', includeIfNull: false) bool? callForPrice,
    @JsonKey(name: 'PriceValue', includeIfNull: false) double? priceValue,
    @JsonKey(name: 'PriceIncludesTax', includeIfNull: false)
    bool? priceIncludesTax,
    @JsonKey(name: 'StartPrice', includeIfNull: false) String? startPrice,
    @JsonKey(name: 'StartPriceValue', includeIfNull: false)
    double? startPriceValue,
    @JsonKey(name: 'HighestBid', includeIfNull: false) String? highestBid,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    double? highestBidValue,
    @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
    String? basePricePAngV,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    bool? disableBuyButton,
    @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
    bool? disableWishlistButton,
    @JsonKey(name: 'DisableAddToCompareListButton', includeIfNull: false)
    bool? disableAddToCompareListButton,
    @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
    bool? availableForPreOrder,
    @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
    DateTime? preOrderDateTimeUtc,
    @JsonKey(name: 'ForceRedirectionAfterAddingToCart', includeIfNull: false)
    bool? forceRedirectionAfterAddingToCart,
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
    Object? oldPrice = freezed,
    Object? oldPriceValue = freezed,
    Object? catalogPrice = freezed,
    Object? price = freezed,
    Object? callForPrice = freezed,
    Object? priceValue = freezed,
    Object? priceIncludesTax = freezed,
    Object? startPrice = freezed,
    Object? startPriceValue = freezed,
    Object? highestBid = freezed,
    Object? highestBidValue = freezed,
    Object? basePricePAngV = freezed,
    Object? disableBuyButton = freezed,
    Object? disableWishlistButton = freezed,
    Object? disableAddToCompareListButton = freezed,
    Object? availableForPreOrder = freezed,
    Object? preOrderDateTimeUtc = freezed,
    Object? forceRedirectionAfterAddingToCart = freezed,
    Object? appliedDiscounts = freezed,
    Object? preferredTierPrice = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            oldPrice:
                freezed == oldPrice
                    ? _value.oldPrice
                    : oldPrice // ignore: cast_nullable_to_non_nullable
                        as String?,
            oldPriceValue:
                freezed == oldPriceValue
                    ? _value.oldPriceValue
                    : oldPriceValue // ignore: cast_nullable_to_non_nullable
                        as double?,
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
            callForPrice:
                freezed == callForPrice
                    ? _value.callForPrice
                    : callForPrice // ignore: cast_nullable_to_non_nullable
                        as bool?,
            priceValue:
                freezed == priceValue
                    ? _value.priceValue
                    : priceValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            priceIncludesTax:
                freezed == priceIncludesTax
                    ? _value.priceIncludesTax
                    : priceIncludesTax // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
            basePricePAngV:
                freezed == basePricePAngV
                    ? _value.basePricePAngV
                    : basePricePAngV // ignore: cast_nullable_to_non_nullable
                        as String?,
            disableBuyButton:
                freezed == disableBuyButton
                    ? _value.disableBuyButton
                    : disableBuyButton // ignore: cast_nullable_to_non_nullable
                        as bool?,
            disableWishlistButton:
                freezed == disableWishlistButton
                    ? _value.disableWishlistButton
                    : disableWishlistButton // ignore: cast_nullable_to_non_nullable
                        as bool?,
            disableAddToCompareListButton:
                freezed == disableAddToCompareListButton
                    ? _value.disableAddToCompareListButton
                    : disableAddToCompareListButton // ignore: cast_nullable_to_non_nullable
                        as bool?,
            availableForPreOrder:
                freezed == availableForPreOrder
                    ? _value.availableForPreOrder
                    : availableForPreOrder // ignore: cast_nullable_to_non_nullable
                        as bool?,
            preOrderDateTimeUtc:
                freezed == preOrderDateTimeUtc
                    ? _value.preOrderDateTimeUtc
                    : preOrderDateTimeUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            forceRedirectionAfterAddingToCart:
                freezed == forceRedirectionAfterAddingToCart
                    ? _value.forceRedirectionAfterAddingToCart
                    : forceRedirectionAfterAddingToCart // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
    @JsonKey(name: 'OldPrice', includeIfNull: false) String? oldPrice,
    @JsonKey(name: 'OldPriceValue', includeIfNull: false) double? oldPriceValue,
    @JsonKey(name: 'CatalogPrice', includeIfNull: false) String? catalogPrice,
    @JsonKey(name: 'Price', includeIfNull: false) String? price,
    @JsonKey(name: 'CallForPrice', includeIfNull: false) bool? callForPrice,
    @JsonKey(name: 'PriceValue', includeIfNull: false) double? priceValue,
    @JsonKey(name: 'PriceIncludesTax', includeIfNull: false)
    bool? priceIncludesTax,
    @JsonKey(name: 'StartPrice', includeIfNull: false) String? startPrice,
    @JsonKey(name: 'StartPriceValue', includeIfNull: false)
    double? startPriceValue,
    @JsonKey(name: 'HighestBid', includeIfNull: false) String? highestBid,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    double? highestBidValue,
    @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
    String? basePricePAngV,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    bool? disableBuyButton,
    @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
    bool? disableWishlistButton,
    @JsonKey(name: 'DisableAddToCompareListButton', includeIfNull: false)
    bool? disableAddToCompareListButton,
    @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
    bool? availableForPreOrder,
    @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
    DateTime? preOrderDateTimeUtc,
    @JsonKey(name: 'ForceRedirectionAfterAddingToCart', includeIfNull: false)
    bool? forceRedirectionAfterAddingToCart,
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
    Object? oldPrice = freezed,
    Object? oldPriceValue = freezed,
    Object? catalogPrice = freezed,
    Object? price = freezed,
    Object? callForPrice = freezed,
    Object? priceValue = freezed,
    Object? priceIncludesTax = freezed,
    Object? startPrice = freezed,
    Object? startPriceValue = freezed,
    Object? highestBid = freezed,
    Object? highestBidValue = freezed,
    Object? basePricePAngV = freezed,
    Object? disableBuyButton = freezed,
    Object? disableWishlistButton = freezed,
    Object? disableAddToCompareListButton = freezed,
    Object? availableForPreOrder = freezed,
    Object? preOrderDateTimeUtc = freezed,
    Object? forceRedirectionAfterAddingToCart = freezed,
    Object? appliedDiscounts = freezed,
    Object? preferredTierPrice = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductPriceModelImpl(
        oldPrice:
            freezed == oldPrice
                ? _value.oldPrice
                : oldPrice // ignore: cast_nullable_to_non_nullable
                    as String?,
        oldPriceValue:
            freezed == oldPriceValue
                ? _value.oldPriceValue
                : oldPriceValue // ignore: cast_nullable_to_non_nullable
                    as double?,
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
        callForPrice:
            freezed == callForPrice
                ? _value.callForPrice
                : callForPrice // ignore: cast_nullable_to_non_nullable
                    as bool?,
        priceValue:
            freezed == priceValue
                ? _value.priceValue
                : priceValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        priceIncludesTax:
            freezed == priceIncludesTax
                ? _value.priceIncludesTax
                : priceIncludesTax // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
        basePricePAngV:
            freezed == basePricePAngV
                ? _value.basePricePAngV
                : basePricePAngV // ignore: cast_nullable_to_non_nullable
                    as String?,
        disableBuyButton:
            freezed == disableBuyButton
                ? _value.disableBuyButton
                : disableBuyButton // ignore: cast_nullable_to_non_nullable
                    as bool?,
        disableWishlistButton:
            freezed == disableWishlistButton
                ? _value.disableWishlistButton
                : disableWishlistButton // ignore: cast_nullable_to_non_nullable
                    as bool?,
        disableAddToCompareListButton:
            freezed == disableAddToCompareListButton
                ? _value.disableAddToCompareListButton
                : disableAddToCompareListButton // ignore: cast_nullable_to_non_nullable
                    as bool?,
        availableForPreOrder:
            freezed == availableForPreOrder
                ? _value.availableForPreOrder
                : availableForPreOrder // ignore: cast_nullable_to_non_nullable
                    as bool?,
        preOrderDateTimeUtc:
            freezed == preOrderDateTimeUtc
                ? _value.preOrderDateTimeUtc
                : preOrderDateTimeUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        forceRedirectionAfterAddingToCart:
            freezed == forceRedirectionAfterAddingToCart
                ? _value.forceRedirectionAfterAddingToCart
                : forceRedirectionAfterAddingToCart // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
    @JsonKey(name: 'OldPrice', includeIfNull: false) this.oldPrice,
    @JsonKey(name: 'OldPriceValue', includeIfNull: false) this.oldPriceValue,
    @JsonKey(name: 'CatalogPrice', includeIfNull: false) this.catalogPrice,
    @JsonKey(name: 'Price', includeIfNull: false) this.price,
    @JsonKey(name: 'CallForPrice', includeIfNull: false)
    this.callForPrice = false,
    @JsonKey(name: 'PriceValue', includeIfNull: false) this.priceValue,
    @JsonKey(name: 'PriceIncludesTax', includeIfNull: false)
    this.priceIncludesTax = false,
    @JsonKey(name: 'StartPrice', includeIfNull: false) this.startPrice,
    @JsonKey(name: 'StartPriceValue', includeIfNull: false)
    this.startPriceValue,
    @JsonKey(name: 'HighestBid', includeIfNull: false) this.highestBid,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    this.highestBidValue,
    @JsonKey(name: 'BasePricePAngV', includeIfNull: false) this.basePricePAngV,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    this.disableBuyButton = false,
    @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
    this.disableWishlistButton = false,
    @JsonKey(name: 'DisableAddToCompareListButton', includeIfNull: false)
    this.disableAddToCompareListButton = false,
    @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
    this.availableForPreOrder = false,
    @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
    this.preOrderDateTimeUtc = null,
    @JsonKey(name: 'ForceRedirectionAfterAddingToCart', includeIfNull: false)
    this.forceRedirectionAfterAddingToCart = false,
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
  @JsonKey(name: 'OldPrice', includeIfNull: false)
  final String? oldPrice;
  @override
  @JsonKey(name: 'OldPriceValue', includeIfNull: false)
  final double? oldPriceValue;
  @override
  @JsonKey(name: 'CatalogPrice', includeIfNull: false)
  final String? catalogPrice;
  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  final String? price;
  @override
  @JsonKey(name: 'CallForPrice', includeIfNull: false)
  final bool? callForPrice;
  @override
  @JsonKey(name: 'PriceValue', includeIfNull: false)
  final double? priceValue;
  @override
  @JsonKey(name: 'PriceIncludesTax', includeIfNull: false)
  final bool? priceIncludesTax;
  @override
  @JsonKey(name: 'StartPrice', includeIfNull: false)
  final String? startPrice;
  @override
  @JsonKey(name: 'StartPriceValue', includeIfNull: false)
  final double? startPriceValue;
  @override
  @JsonKey(name: 'HighestBid', includeIfNull: false)
  final String? highestBid;
  @override
  @JsonKey(name: 'HighestBidValue', includeIfNull: false)
  final double? highestBidValue;
  @override
  @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
  final String? basePricePAngV;
  @override
  @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
  final bool? disableBuyButton;
  @override
  @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
  final bool? disableWishlistButton;
  @override
  @JsonKey(name: 'DisableAddToCompareListButton', includeIfNull: false)
  final bool? disableAddToCompareListButton;
  @override
  @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
  final bool? availableForPreOrder;
  @override
  @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
  final DateTime? preOrderDateTimeUtc;
  @override
  @JsonKey(name: 'ForceRedirectionAfterAddingToCart', includeIfNull: false)
  final bool? forceRedirectionAfterAddingToCart;
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
    return 'ProductPriceModel(oldPrice: $oldPrice, oldPriceValue: $oldPriceValue, catalogPrice: $catalogPrice, price: $price, callForPrice: $callForPrice, priceValue: $priceValue, priceIncludesTax: $priceIncludesTax, startPrice: $startPrice, startPriceValue: $startPriceValue, highestBid: $highestBid, highestBidValue: $highestBidValue, basePricePAngV: $basePricePAngV, disableBuyButton: $disableBuyButton, disableWishlistButton: $disableWishlistButton, disableAddToCompareListButton: $disableAddToCompareListButton, availableForPreOrder: $availableForPreOrder, preOrderDateTimeUtc: $preOrderDateTimeUtc, forceRedirectionAfterAddingToCart: $forceRedirectionAfterAddingToCart, appliedDiscounts: $appliedDiscounts, preferredTierPrice: $preferredTierPrice, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductPriceModelImpl &&
            (identical(other.oldPrice, oldPrice) ||
                other.oldPrice == oldPrice) &&
            (identical(other.oldPriceValue, oldPriceValue) ||
                other.oldPriceValue == oldPriceValue) &&
            (identical(other.catalogPrice, catalogPrice) ||
                other.catalogPrice == catalogPrice) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.callForPrice, callForPrice) ||
                other.callForPrice == callForPrice) &&
            (identical(other.priceValue, priceValue) ||
                other.priceValue == priceValue) &&
            (identical(other.priceIncludesTax, priceIncludesTax) ||
                other.priceIncludesTax == priceIncludesTax) &&
            (identical(other.startPrice, startPrice) ||
                other.startPrice == startPrice) &&
            (identical(other.startPriceValue, startPriceValue) ||
                other.startPriceValue == startPriceValue) &&
            (identical(other.highestBid, highestBid) ||
                other.highestBid == highestBid) &&
            (identical(other.highestBidValue, highestBidValue) ||
                other.highestBidValue == highestBidValue) &&
            (identical(other.basePricePAngV, basePricePAngV) ||
                other.basePricePAngV == basePricePAngV) &&
            (identical(other.disableBuyButton, disableBuyButton) ||
                other.disableBuyButton == disableBuyButton) &&
            (identical(other.disableWishlistButton, disableWishlistButton) ||
                other.disableWishlistButton == disableWishlistButton) &&
            (identical(
                  other.disableAddToCompareListButton,
                  disableAddToCompareListButton,
                ) ||
                other.disableAddToCompareListButton ==
                    disableAddToCompareListButton) &&
            (identical(other.availableForPreOrder, availableForPreOrder) ||
                other.availableForPreOrder == availableForPreOrder) &&
            (identical(other.preOrderDateTimeUtc, preOrderDateTimeUtc) ||
                other.preOrderDateTimeUtc == preOrderDateTimeUtc) &&
            (identical(
                  other.forceRedirectionAfterAddingToCart,
                  forceRedirectionAfterAddingToCart,
                ) ||
                other.forceRedirectionAfterAddingToCart ==
                    forceRedirectionAfterAddingToCart) &&
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
    oldPrice,
    oldPriceValue,
    catalogPrice,
    price,
    callForPrice,
    priceValue,
    priceIncludesTax,
    startPrice,
    startPriceValue,
    highestBid,
    highestBidValue,
    basePricePAngV,
    disableBuyButton,
    disableWishlistButton,
    disableAddToCompareListButton,
    availableForPreOrder,
    preOrderDateTimeUtc,
    forceRedirectionAfterAddingToCart,
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
    @JsonKey(name: 'OldPrice', includeIfNull: false) final String? oldPrice,
    @JsonKey(name: 'OldPriceValue', includeIfNull: false)
    final double? oldPriceValue,
    @JsonKey(name: 'CatalogPrice', includeIfNull: false)
    final String? catalogPrice,
    @JsonKey(name: 'Price', includeIfNull: false) final String? price,
    @JsonKey(name: 'CallForPrice', includeIfNull: false)
    final bool? callForPrice,
    @JsonKey(name: 'PriceValue', includeIfNull: false) final double? priceValue,
    @JsonKey(name: 'PriceIncludesTax', includeIfNull: false)
    final bool? priceIncludesTax,
    @JsonKey(name: 'StartPrice', includeIfNull: false) final String? startPrice,
    @JsonKey(name: 'StartPriceValue', includeIfNull: false)
    final double? startPriceValue,
    @JsonKey(name: 'HighestBid', includeIfNull: false) final String? highestBid,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    final double? highestBidValue,
    @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
    final String? basePricePAngV,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    final bool? disableBuyButton,
    @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
    final bool? disableWishlistButton,
    @JsonKey(name: 'DisableAddToCompareListButton', includeIfNull: false)
    final bool? disableAddToCompareListButton,
    @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
    final bool? availableForPreOrder,
    @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
    final DateTime? preOrderDateTimeUtc,
    @JsonKey(name: 'ForceRedirectionAfterAddingToCart', includeIfNull: false)
    final bool? forceRedirectionAfterAddingToCart,
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
  @JsonKey(name: 'OldPrice', includeIfNull: false)
  String? get oldPrice;
  @override
  @JsonKey(name: 'OldPriceValue', includeIfNull: false)
  double? get oldPriceValue;
  @override
  @JsonKey(name: 'CatalogPrice', includeIfNull: false)
  String? get catalogPrice;
  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  String? get price;
  @override
  @JsonKey(name: 'CallForPrice', includeIfNull: false)
  bool? get callForPrice;
  @override
  @JsonKey(name: 'PriceValue', includeIfNull: false)
  double? get priceValue;
  @override
  @JsonKey(name: 'PriceIncludesTax', includeIfNull: false)
  bool? get priceIncludesTax;
  @override
  @JsonKey(name: 'StartPrice', includeIfNull: false)
  String? get startPrice;
  @override
  @JsonKey(name: 'StartPriceValue', includeIfNull: false)
  double? get startPriceValue;
  @override
  @JsonKey(name: 'HighestBid', includeIfNull: false)
  String? get highestBid;
  @override
  @JsonKey(name: 'HighestBidValue', includeIfNull: false)
  double? get highestBidValue;
  @override
  @JsonKey(name: 'BasePricePAngV', includeIfNull: false)
  String? get basePricePAngV;
  @override
  @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
  bool? get disableBuyButton;
  @override
  @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
  bool? get disableWishlistButton;
  @override
  @JsonKey(name: 'DisableAddToCompareListButton', includeIfNull: false)
  bool? get disableAddToCompareListButton;
  @override
  @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
  bool? get availableForPreOrder;
  @override
  @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
  DateTime? get preOrderDateTimeUtc;
  @override
  @JsonKey(name: 'ForceRedirectionAfterAddingToCart', includeIfNull: false)
  bool? get forceRedirectionAfterAddingToCart;
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
