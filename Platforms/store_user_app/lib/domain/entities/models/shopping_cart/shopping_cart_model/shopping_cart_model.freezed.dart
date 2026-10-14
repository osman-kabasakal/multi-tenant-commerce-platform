// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_cart_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShoppingCartModel _$ShoppingCartModelFromJson(Map<String, dynamic> json) {
  return _ShoppingCartModel.fromJson(json);
}

/// @nodoc
mixin _$ShoppingCartModel {
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  bool? get showSku => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  bool? get showProductImages => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsEditable', includeIfNull: false)
  bool? get isEditable => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsAllowOnHold', includeIfNull: false)
  bool? get isAllowOnHold => throw _privateConstructorUsedError;
  @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
  bool? get termsOfServicePopup => throw _privateConstructorUsedError;
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShoppingCartItemModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
  String? get checkoutAttributeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'CheckoutAttributes', includeIfNull: false)
  List<CheckoutAttributeModel>? get checkoutAttributes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'MinOrderSubtotalWarning', includeIfNull: false)
  String? get minOrderSubtotalWarning => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowCheckoutAsGuestButton', includeIfNull: false)
  bool? get showCheckoutAsGuestButton => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsGuest', includeIfNull: false)
  bool? get isGuest => throw _privateConstructorUsedError;
  @JsonKey(name: 'TermsOfServiceOnShoppingCartPage', includeIfNull: false)
  bool? get termsOfServiceOnShoppingCartPage =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
  bool? get termsOfServiceOnOrderConfirmPage =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'DiscountBox', includeIfNull: false)
  DiscountBoxModel? get discountBox => throw _privateConstructorUsedError;
  @JsonKey(name: 'GiftVoucherBox', includeIfNull: false)
  GiftVoucherBoxModel? get giftVoucherBox => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ShoppingCartModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingCartModelCopyWith<ShoppingCartModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingCartModelCopyWith<$Res> {
  factory $ShoppingCartModelCopyWith(
    ShoppingCartModel value,
    $Res Function(ShoppingCartModel) then,
  ) = _$ShoppingCartModelCopyWithImpl<$Res, ShoppingCartModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ShowSku', includeIfNull: false) bool? showSku,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    bool? showProductImages,
    @JsonKey(name: 'IsEditable', includeIfNull: false) bool? isEditable,
    @JsonKey(name: 'IsAllowOnHold', includeIfNull: false) bool? isAllowOnHold,
    @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
    bool? termsOfServicePopup,
    @JsonKey(name: 'Items', includeIfNull: false)
    List<ShoppingCartItemModel>? items,
    @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
    String? checkoutAttributeInfo,
    @JsonKey(name: 'CheckoutAttributes', includeIfNull: false)
    List<CheckoutAttributeModel>? checkoutAttributes,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
    @JsonKey(name: 'MinOrderSubtotalWarning', includeIfNull: false)
    String? minOrderSubtotalWarning,
    @JsonKey(name: 'ShowCheckoutAsGuestButton', includeIfNull: false)
    bool? showCheckoutAsGuestButton,
    @JsonKey(name: 'IsGuest', includeIfNull: false) bool? isGuest,
    @JsonKey(name: 'TermsOfServiceOnShoppingCartPage', includeIfNull: false)
    bool? termsOfServiceOnShoppingCartPage,
    @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
    bool? termsOfServiceOnOrderConfirmPage,
    @JsonKey(name: 'DiscountBox', includeIfNull: false)
    DiscountBoxModel? discountBox,
    @JsonKey(name: 'GiftVoucherBox', includeIfNull: false)
    GiftVoucherBoxModel? giftVoucherBox,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $DiscountBoxModelCopyWith<$Res>? get discountBox;
  $GiftVoucherBoxModelCopyWith<$Res>? get giftVoucherBox;
}

/// @nodoc
class _$ShoppingCartModelCopyWithImpl<$Res, $Val extends ShoppingCartModel>
    implements $ShoppingCartModelCopyWith<$Res> {
  _$ShoppingCartModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showSku = freezed,
    Object? showProductImages = freezed,
    Object? isEditable = freezed,
    Object? isAllowOnHold = freezed,
    Object? termsOfServicePopup = freezed,
    Object? items = freezed,
    Object? checkoutAttributeInfo = freezed,
    Object? checkoutAttributes = freezed,
    Object? warnings = freezed,
    Object? minOrderSubtotalWarning = freezed,
    Object? showCheckoutAsGuestButton = freezed,
    Object? isGuest = freezed,
    Object? termsOfServiceOnShoppingCartPage = freezed,
    Object? termsOfServiceOnOrderConfirmPage = freezed,
    Object? discountBox = freezed,
    Object? giftVoucherBox = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            showSku:
                freezed == showSku
                    ? _value.showSku
                    : showSku // ignore: cast_nullable_to_non_nullable
                        as bool?,
            showProductImages:
                freezed == showProductImages
                    ? _value.showProductImages
                    : showProductImages // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isEditable:
                freezed == isEditable
                    ? _value.isEditable
                    : isEditable // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isAllowOnHold:
                freezed == isAllowOnHold
                    ? _value.isAllowOnHold
                    : isAllowOnHold // ignore: cast_nullable_to_non_nullable
                        as bool?,
            termsOfServicePopup:
                freezed == termsOfServicePopup
                    ? _value.termsOfServicePopup
                    : termsOfServicePopup // ignore: cast_nullable_to_non_nullable
                        as bool?,
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<ShoppingCartItemModel>?,
            checkoutAttributeInfo:
                freezed == checkoutAttributeInfo
                    ? _value.checkoutAttributeInfo
                    : checkoutAttributeInfo // ignore: cast_nullable_to_non_nullable
                        as String?,
            checkoutAttributes:
                freezed == checkoutAttributes
                    ? _value.checkoutAttributes
                    : checkoutAttributes // ignore: cast_nullable_to_non_nullable
                        as List<CheckoutAttributeModel>?,
            warnings:
                freezed == warnings
                    ? _value.warnings
                    : warnings // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            minOrderSubtotalWarning:
                freezed == minOrderSubtotalWarning
                    ? _value.minOrderSubtotalWarning
                    : minOrderSubtotalWarning // ignore: cast_nullable_to_non_nullable
                        as String?,
            showCheckoutAsGuestButton:
                freezed == showCheckoutAsGuestButton
                    ? _value.showCheckoutAsGuestButton
                    : showCheckoutAsGuestButton // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isGuest:
                freezed == isGuest
                    ? _value.isGuest
                    : isGuest // ignore: cast_nullable_to_non_nullable
                        as bool?,
            termsOfServiceOnShoppingCartPage:
                freezed == termsOfServiceOnShoppingCartPage
                    ? _value.termsOfServiceOnShoppingCartPage
                    : termsOfServiceOnShoppingCartPage // ignore: cast_nullable_to_non_nullable
                        as bool?,
            termsOfServiceOnOrderConfirmPage:
                freezed == termsOfServiceOnOrderConfirmPage
                    ? _value.termsOfServiceOnOrderConfirmPage
                    : termsOfServiceOnOrderConfirmPage // ignore: cast_nullable_to_non_nullable
                        as bool?,
            discountBox:
                freezed == discountBox
                    ? _value.discountBox
                    : discountBox // ignore: cast_nullable_to_non_nullable
                        as DiscountBoxModel?,
            giftVoucherBox:
                freezed == giftVoucherBox
                    ? _value.giftVoucherBox
                    : giftVoucherBox // ignore: cast_nullable_to_non_nullable
                        as GiftVoucherBoxModel?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DiscountBoxModelCopyWith<$Res>? get discountBox {
    if (_value.discountBox == null) {
      return null;
    }

    return $DiscountBoxModelCopyWith<$Res>(_value.discountBox!, (value) {
      return _then(_value.copyWith(discountBox: value) as $Val);
    });
  }

  /// Create a copy of ShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GiftVoucherBoxModelCopyWith<$Res>? get giftVoucherBox {
    if (_value.giftVoucherBox == null) {
      return null;
    }

    return $GiftVoucherBoxModelCopyWith<$Res>(_value.giftVoucherBox!, (value) {
      return _then(_value.copyWith(giftVoucherBox: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShoppingCartModelImplCopyWith<$Res>
    implements $ShoppingCartModelCopyWith<$Res> {
  factory _$$ShoppingCartModelImplCopyWith(
    _$ShoppingCartModelImpl value,
    $Res Function(_$ShoppingCartModelImpl) then,
  ) = __$$ShoppingCartModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ShowSku', includeIfNull: false) bool? showSku,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    bool? showProductImages,
    @JsonKey(name: 'IsEditable', includeIfNull: false) bool? isEditable,
    @JsonKey(name: 'IsAllowOnHold', includeIfNull: false) bool? isAllowOnHold,
    @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
    bool? termsOfServicePopup,
    @JsonKey(name: 'Items', includeIfNull: false)
    List<ShoppingCartItemModel>? items,
    @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
    String? checkoutAttributeInfo,
    @JsonKey(name: 'CheckoutAttributes', includeIfNull: false)
    List<CheckoutAttributeModel>? checkoutAttributes,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
    @JsonKey(name: 'MinOrderSubtotalWarning', includeIfNull: false)
    String? minOrderSubtotalWarning,
    @JsonKey(name: 'ShowCheckoutAsGuestButton', includeIfNull: false)
    bool? showCheckoutAsGuestButton,
    @JsonKey(name: 'IsGuest', includeIfNull: false) bool? isGuest,
    @JsonKey(name: 'TermsOfServiceOnShoppingCartPage', includeIfNull: false)
    bool? termsOfServiceOnShoppingCartPage,
    @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
    bool? termsOfServiceOnOrderConfirmPage,
    @JsonKey(name: 'DiscountBox', includeIfNull: false)
    DiscountBoxModel? discountBox,
    @JsonKey(name: 'GiftVoucherBox', includeIfNull: false)
    GiftVoucherBoxModel? giftVoucherBox,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $DiscountBoxModelCopyWith<$Res>? get discountBox;
  @override
  $GiftVoucherBoxModelCopyWith<$Res>? get giftVoucherBox;
}

/// @nodoc
class __$$ShoppingCartModelImplCopyWithImpl<$Res>
    extends _$ShoppingCartModelCopyWithImpl<$Res, _$ShoppingCartModelImpl>
    implements _$$ShoppingCartModelImplCopyWith<$Res> {
  __$$ShoppingCartModelImplCopyWithImpl(
    _$ShoppingCartModelImpl _value,
    $Res Function(_$ShoppingCartModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showSku = freezed,
    Object? showProductImages = freezed,
    Object? isEditable = freezed,
    Object? isAllowOnHold = freezed,
    Object? termsOfServicePopup = freezed,
    Object? items = freezed,
    Object? checkoutAttributeInfo = freezed,
    Object? checkoutAttributes = freezed,
    Object? warnings = freezed,
    Object? minOrderSubtotalWarning = freezed,
    Object? showCheckoutAsGuestButton = freezed,
    Object? isGuest = freezed,
    Object? termsOfServiceOnShoppingCartPage = freezed,
    Object? termsOfServiceOnOrderConfirmPage = freezed,
    Object? discountBox = freezed,
    Object? giftVoucherBox = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ShoppingCartModelImpl(
        showSku:
            freezed == showSku
                ? _value.showSku
                : showSku // ignore: cast_nullable_to_non_nullable
                    as bool?,
        showProductImages:
            freezed == showProductImages
                ? _value.showProductImages
                : showProductImages // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isEditable:
            freezed == isEditable
                ? _value.isEditable
                : isEditable // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isAllowOnHold:
            freezed == isAllowOnHold
                ? _value.isAllowOnHold
                : isAllowOnHold // ignore: cast_nullable_to_non_nullable
                    as bool?,
        termsOfServicePopup:
            freezed == termsOfServicePopup
                ? _value.termsOfServicePopup
                : termsOfServicePopup // ignore: cast_nullable_to_non_nullable
                    as bool?,
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<ShoppingCartItemModel>?,
        checkoutAttributeInfo:
            freezed == checkoutAttributeInfo
                ? _value.checkoutAttributeInfo
                : checkoutAttributeInfo // ignore: cast_nullable_to_non_nullable
                    as String?,
        checkoutAttributes:
            freezed == checkoutAttributes
                ? _value._checkoutAttributes
                : checkoutAttributes // ignore: cast_nullable_to_non_nullable
                    as List<CheckoutAttributeModel>?,
        warnings:
            freezed == warnings
                ? _value._warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        minOrderSubtotalWarning:
            freezed == minOrderSubtotalWarning
                ? _value.minOrderSubtotalWarning
                : minOrderSubtotalWarning // ignore: cast_nullable_to_non_nullable
                    as String?,
        showCheckoutAsGuestButton:
            freezed == showCheckoutAsGuestButton
                ? _value.showCheckoutAsGuestButton
                : showCheckoutAsGuestButton // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isGuest:
            freezed == isGuest
                ? _value.isGuest
                : isGuest // ignore: cast_nullable_to_non_nullable
                    as bool?,
        termsOfServiceOnShoppingCartPage:
            freezed == termsOfServiceOnShoppingCartPage
                ? _value.termsOfServiceOnShoppingCartPage
                : termsOfServiceOnShoppingCartPage // ignore: cast_nullable_to_non_nullable
                    as bool?,
        termsOfServiceOnOrderConfirmPage:
            freezed == termsOfServiceOnOrderConfirmPage
                ? _value.termsOfServiceOnOrderConfirmPage
                : termsOfServiceOnOrderConfirmPage // ignore: cast_nullable_to_non_nullable
                    as bool?,
        discountBox:
            freezed == discountBox
                ? _value.discountBox
                : discountBox // ignore: cast_nullable_to_non_nullable
                    as DiscountBoxModel?,
        giftVoucherBox:
            freezed == giftVoucherBox
                ? _value.giftVoucherBox
                : giftVoucherBox // ignore: cast_nullable_to_non_nullable
                    as GiftVoucherBoxModel?,
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
class _$ShoppingCartModelImpl implements _ShoppingCartModel {
  _$ShoppingCartModelImpl({
    @JsonKey(name: 'ShowSku', includeIfNull: false) this.showSku = false,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    this.showProductImages = false,
    @JsonKey(name: 'IsEditable', includeIfNull: false) this.isEditable = false,
    @JsonKey(name: 'IsAllowOnHold', includeIfNull: false)
    this.isAllowOnHold = false,
    @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
    this.termsOfServicePopup = false,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<ShoppingCartItemModel>? items = const [],
    @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
    this.checkoutAttributeInfo,
    @JsonKey(name: 'CheckoutAttributes', includeIfNull: false)
    final List<CheckoutAttributeModel>? checkoutAttributes = const [],
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings = const [],
    @JsonKey(name: 'MinOrderSubtotalWarning', includeIfNull: false)
    this.minOrderSubtotalWarning,
    @JsonKey(name: 'ShowCheckoutAsGuestButton', includeIfNull: false)
    this.showCheckoutAsGuestButton = false,
    @JsonKey(name: 'IsGuest', includeIfNull: false) this.isGuest = false,
    @JsonKey(name: 'TermsOfServiceOnShoppingCartPage', includeIfNull: false)
    this.termsOfServiceOnShoppingCartPage = false,
    @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
    this.termsOfServiceOnOrderConfirmPage = false,
    @JsonKey(name: 'DiscountBox', includeIfNull: false) this.discountBox,
    @JsonKey(name: 'GiftVoucherBox', includeIfNull: false) this.giftVoucherBox,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _items = items,
       _checkoutAttributes = checkoutAttributes,
       _warnings = warnings,
       _userFields = userFields;

  factory _$ShoppingCartModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingCartModelImplFromJson(json);

  @override
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  final bool? showSku;
  @override
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  final bool? showProductImages;
  @override
  @JsonKey(name: 'IsEditable', includeIfNull: false)
  final bool? isEditable;
  @override
  @JsonKey(name: 'IsAllowOnHold', includeIfNull: false)
  final bool? isAllowOnHold;
  @override
  @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
  final bool? termsOfServicePopup;
  final List<ShoppingCartItemModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShoppingCartItemModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
  final String? checkoutAttributeInfo;
  final List<CheckoutAttributeModel>? _checkoutAttributes;
  @override
  @JsonKey(name: 'CheckoutAttributes', includeIfNull: false)
  List<CheckoutAttributeModel>? get checkoutAttributes {
    final value = _checkoutAttributes;
    if (value == null) return null;
    if (_checkoutAttributes is EqualUnmodifiableListView)
      return _checkoutAttributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _warnings;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings {
    final value = _warnings;
    if (value == null) return null;
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'MinOrderSubtotalWarning', includeIfNull: false)
  final String? minOrderSubtotalWarning;
  @override
  @JsonKey(name: 'ShowCheckoutAsGuestButton', includeIfNull: false)
  final bool? showCheckoutAsGuestButton;
  @override
  @JsonKey(name: 'IsGuest', includeIfNull: false)
  final bool? isGuest;
  @override
  @JsonKey(name: 'TermsOfServiceOnShoppingCartPage', includeIfNull: false)
  final bool? termsOfServiceOnShoppingCartPage;
  @override
  @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
  final bool? termsOfServiceOnOrderConfirmPage;
  @override
  @JsonKey(name: 'DiscountBox', includeIfNull: false)
  final DiscountBoxModel? discountBox;
  @override
  @JsonKey(name: 'GiftVoucherBox', includeIfNull: false)
  final GiftVoucherBoxModel? giftVoucherBox;
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
    return 'ShoppingCartModel(showSku: $showSku, showProductImages: $showProductImages, isEditable: $isEditable, isAllowOnHold: $isAllowOnHold, termsOfServicePopup: $termsOfServicePopup, items: $items, checkoutAttributeInfo: $checkoutAttributeInfo, checkoutAttributes: $checkoutAttributes, warnings: $warnings, minOrderSubtotalWarning: $minOrderSubtotalWarning, showCheckoutAsGuestButton: $showCheckoutAsGuestButton, isGuest: $isGuest, termsOfServiceOnShoppingCartPage: $termsOfServiceOnShoppingCartPage, termsOfServiceOnOrderConfirmPage: $termsOfServiceOnOrderConfirmPage, discountBox: $discountBox, giftVoucherBox: $giftVoucherBox, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingCartModelImpl &&
            (identical(other.showSku, showSku) || other.showSku == showSku) &&
            (identical(other.showProductImages, showProductImages) ||
                other.showProductImages == showProductImages) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable) &&
            (identical(other.isAllowOnHold, isAllowOnHold) ||
                other.isAllowOnHold == isAllowOnHold) &&
            (identical(other.termsOfServicePopup, termsOfServicePopup) ||
                other.termsOfServicePopup == termsOfServicePopup) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.checkoutAttributeInfo, checkoutAttributeInfo) ||
                other.checkoutAttributeInfo == checkoutAttributeInfo) &&
            const DeepCollectionEquality().equals(
              other._checkoutAttributes,
              _checkoutAttributes,
            ) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            (identical(
                  other.minOrderSubtotalWarning,
                  minOrderSubtotalWarning,
                ) ||
                other.minOrderSubtotalWarning == minOrderSubtotalWarning) &&
            (identical(
                  other.showCheckoutAsGuestButton,
                  showCheckoutAsGuestButton,
                ) ||
                other.showCheckoutAsGuestButton == showCheckoutAsGuestButton) &&
            (identical(other.isGuest, isGuest) || other.isGuest == isGuest) &&
            (identical(
                  other.termsOfServiceOnShoppingCartPage,
                  termsOfServiceOnShoppingCartPage,
                ) ||
                other.termsOfServiceOnShoppingCartPage ==
                    termsOfServiceOnShoppingCartPage) &&
            (identical(
                  other.termsOfServiceOnOrderConfirmPage,
                  termsOfServiceOnOrderConfirmPage,
                ) ||
                other.termsOfServiceOnOrderConfirmPage ==
                    termsOfServiceOnOrderConfirmPage) &&
            (identical(other.discountBox, discountBox) ||
                other.discountBox == discountBox) &&
            (identical(other.giftVoucherBox, giftVoucherBox) ||
                other.giftVoucherBox == giftVoucherBox) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    showSku,
    showProductImages,
    isEditable,
    isAllowOnHold,
    termsOfServicePopup,
    const DeepCollectionEquality().hash(_items),
    checkoutAttributeInfo,
    const DeepCollectionEquality().hash(_checkoutAttributes),
    const DeepCollectionEquality().hash(_warnings),
    minOrderSubtotalWarning,
    showCheckoutAsGuestButton,
    isGuest,
    termsOfServiceOnShoppingCartPage,
    termsOfServiceOnOrderConfirmPage,
    discountBox,
    giftVoucherBox,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingCartModelImplCopyWith<_$ShoppingCartModelImpl> get copyWith =>
      __$$ShoppingCartModelImplCopyWithImpl<_$ShoppingCartModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingCartModelImplToJson(this);
  }
}

abstract class _ShoppingCartModel implements ShoppingCartModel {
  factory _ShoppingCartModel({
    @JsonKey(name: 'ShowSku', includeIfNull: false) final bool? showSku,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    final bool? showProductImages,
    @JsonKey(name: 'IsEditable', includeIfNull: false) final bool? isEditable,
    @JsonKey(name: 'IsAllowOnHold', includeIfNull: false)
    final bool? isAllowOnHold,
    @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
    final bool? termsOfServicePopup,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<ShoppingCartItemModel>? items,
    @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
    final String? checkoutAttributeInfo,
    @JsonKey(name: 'CheckoutAttributes', includeIfNull: false)
    final List<CheckoutAttributeModel>? checkoutAttributes,
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings,
    @JsonKey(name: 'MinOrderSubtotalWarning', includeIfNull: false)
    final String? minOrderSubtotalWarning,
    @JsonKey(name: 'ShowCheckoutAsGuestButton', includeIfNull: false)
    final bool? showCheckoutAsGuestButton,
    @JsonKey(name: 'IsGuest', includeIfNull: false) final bool? isGuest,
    @JsonKey(name: 'TermsOfServiceOnShoppingCartPage', includeIfNull: false)
    final bool? termsOfServiceOnShoppingCartPage,
    @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
    final bool? termsOfServiceOnOrderConfirmPage,
    @JsonKey(name: 'DiscountBox', includeIfNull: false)
    final DiscountBoxModel? discountBox,
    @JsonKey(name: 'GiftVoucherBox', includeIfNull: false)
    final GiftVoucherBoxModel? giftVoucherBox,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ShoppingCartModelImpl;

  factory _ShoppingCartModel.fromJson(Map<String, dynamic> json) =
      _$ShoppingCartModelImpl.fromJson;

  @override
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  bool? get showSku;
  @override
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  bool? get showProductImages;
  @override
  @JsonKey(name: 'IsEditable', includeIfNull: false)
  bool? get isEditable;
  @override
  @JsonKey(name: 'IsAllowOnHold', includeIfNull: false)
  bool? get isAllowOnHold;
  @override
  @JsonKey(name: 'TermsOfServicePopup', includeIfNull: false)
  bool? get termsOfServicePopup;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShoppingCartItemModel>? get items;
  @override
  @JsonKey(name: 'CheckoutAttributeInfo', includeIfNull: false)
  String? get checkoutAttributeInfo;
  @override
  @JsonKey(name: 'CheckoutAttributes', includeIfNull: false)
  List<CheckoutAttributeModel>? get checkoutAttributes;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings;
  @override
  @JsonKey(name: 'MinOrderSubtotalWarning', includeIfNull: false)
  String? get minOrderSubtotalWarning;
  @override
  @JsonKey(name: 'ShowCheckoutAsGuestButton', includeIfNull: false)
  bool? get showCheckoutAsGuestButton;
  @override
  @JsonKey(name: 'IsGuest', includeIfNull: false)
  bool? get isGuest;
  @override
  @JsonKey(name: 'TermsOfServiceOnShoppingCartPage', includeIfNull: false)
  bool? get termsOfServiceOnShoppingCartPage;
  @override
  @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
  bool? get termsOfServiceOnOrderConfirmPage;
  @override
  @JsonKey(name: 'DiscountBox', includeIfNull: false)
  DiscountBoxModel? get discountBox;
  @override
  @JsonKey(name: 'GiftVoucherBox', includeIfNull: false)
  GiftVoucherBoxModel? get giftVoucherBox;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingCartModelImplCopyWith<_$ShoppingCartModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
