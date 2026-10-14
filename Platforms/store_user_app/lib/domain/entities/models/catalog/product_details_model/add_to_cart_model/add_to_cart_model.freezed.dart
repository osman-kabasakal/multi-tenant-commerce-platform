// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_to_cart_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddToCartModel _$AddToCartModelFromJson(Map<String, dynamic> json) {
  return _AddToCartModel.fromJson(json);
}

/// @nodoc
mixin _$AddToCartModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
  int? get enteredQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'MinimumQuantityNotification', includeIfNull: false)
  String? get minimumQuantityNotification => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
  List<SelectListItem>? get allowedQuantities =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'EnteredPrice', includeIfNull: false)
  bool? get enteredPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
  double? get customerEnteredPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerEnteredPriceRange', includeIfNull: false)
  String? get customerEnteredPriceRange => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
  bool? get disableBuyButton => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
  bool? get disableWishlistButton => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsReservation', includeIfNull: false)
  bool? get isReservation => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsAuction', includeIfNull: false)
  bool? get isAuction => throw _privateConstructorUsedError;
  @JsonKey(name: 'MeasureUnit', includeIfNull: false)
  String? get measureUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
  bool? get availableForPreOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
  DateTime? get preOrderDateTimeUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'UpdatedShoppingCartItemId', includeIfNull: false)
  String? get updatedShoppingCartItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'UpdateShoppingCartItemType', includeIfNull: false)
  ShoppingCartType? get updateShoppingCartItemType =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this AddToCartModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddToCartModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddToCartModelCopyWith<AddToCartModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddToCartModelCopyWith<$Res> {
  factory $AddToCartModelCopyWith(
    AddToCartModel value,
    $Res Function(AddToCartModel) then,
  ) = _$AddToCartModelCopyWithImpl<$Res, AddToCartModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
    int? enteredQuantity,
    @JsonKey(name: 'MinimumQuantityNotification', includeIfNull: false)
    String? minimumQuantityNotification,
    @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
    List<SelectListItem>? allowedQuantities,
    @JsonKey(name: 'EnteredPrice', includeIfNull: false) bool? enteredPrice,
    @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
    double? customerEnteredPrice,
    @JsonKey(name: 'CustomerEnteredPriceRange', includeIfNull: false)
    String? customerEnteredPriceRange,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    bool? disableBuyButton,
    @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
    bool? disableWishlistButton,
    @JsonKey(name: 'IsReservation', includeIfNull: false) bool? isReservation,
    @JsonKey(name: 'IsAuction', includeIfNull: false) bool? isAuction,
    @JsonKey(name: 'MeasureUnit', includeIfNull: false) String? measureUnit,
    @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
    bool? availableForPreOrder,
    @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
    DateTime? preOrderDateTimeUtc,
    @JsonKey(name: 'UpdatedShoppingCartItemId', includeIfNull: false)
    String? updatedShoppingCartItemId,
    @JsonKey(name: 'UpdateShoppingCartItemType', includeIfNull: false)
    ShoppingCartType? updateShoppingCartItemType,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$AddToCartModelCopyWithImpl<$Res, $Val extends AddToCartModel>
    implements $AddToCartModelCopyWith<$Res> {
  _$AddToCartModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddToCartModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? enteredQuantity = freezed,
    Object? minimumQuantityNotification = freezed,
    Object? allowedQuantities = freezed,
    Object? enteredPrice = freezed,
    Object? customerEnteredPrice = freezed,
    Object? customerEnteredPriceRange = freezed,
    Object? disableBuyButton = freezed,
    Object? disableWishlistButton = freezed,
    Object? isReservation = freezed,
    Object? isAuction = freezed,
    Object? measureUnit = freezed,
    Object? availableForPreOrder = freezed,
    Object? preOrderDateTimeUtc = freezed,
    Object? updatedShoppingCartItemId = freezed,
    Object? updateShoppingCartItemType = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            enteredQuantity:
                freezed == enteredQuantity
                    ? _value.enteredQuantity
                    : enteredQuantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            minimumQuantityNotification:
                freezed == minimumQuantityNotification
                    ? _value.minimumQuantityNotification
                    : minimumQuantityNotification // ignore: cast_nullable_to_non_nullable
                        as String?,
            allowedQuantities:
                freezed == allowedQuantities
                    ? _value.allowedQuantities
                    : allowedQuantities // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            enteredPrice:
                freezed == enteredPrice
                    ? _value.enteredPrice
                    : enteredPrice // ignore: cast_nullable_to_non_nullable
                        as bool?,
            customerEnteredPrice:
                freezed == customerEnteredPrice
                    ? _value.customerEnteredPrice
                    : customerEnteredPrice // ignore: cast_nullable_to_non_nullable
                        as double?,
            customerEnteredPriceRange:
                freezed == customerEnteredPriceRange
                    ? _value.customerEnteredPriceRange
                    : customerEnteredPriceRange // ignore: cast_nullable_to_non_nullable
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
            isReservation:
                freezed == isReservation
                    ? _value.isReservation
                    : isReservation // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isAuction:
                freezed == isAuction
                    ? _value.isAuction
                    : isAuction // ignore: cast_nullable_to_non_nullable
                        as bool?,
            measureUnit:
                freezed == measureUnit
                    ? _value.measureUnit
                    : measureUnit // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            updatedShoppingCartItemId:
                freezed == updatedShoppingCartItemId
                    ? _value.updatedShoppingCartItemId
                    : updatedShoppingCartItemId // ignore: cast_nullable_to_non_nullable
                        as String?,
            updateShoppingCartItemType:
                freezed == updateShoppingCartItemType
                    ? _value.updateShoppingCartItemType
                    : updateShoppingCartItemType // ignore: cast_nullable_to_non_nullable
                        as ShoppingCartType?,
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
abstract class _$$AddToCartModelImplCopyWith<$Res>
    implements $AddToCartModelCopyWith<$Res> {
  factory _$$AddToCartModelImplCopyWith(
    _$AddToCartModelImpl value,
    $Res Function(_$AddToCartModelImpl) then,
  ) = __$$AddToCartModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
    int? enteredQuantity,
    @JsonKey(name: 'MinimumQuantityNotification', includeIfNull: false)
    String? minimumQuantityNotification,
    @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
    List<SelectListItem>? allowedQuantities,
    @JsonKey(name: 'EnteredPrice', includeIfNull: false) bool? enteredPrice,
    @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
    double? customerEnteredPrice,
    @JsonKey(name: 'CustomerEnteredPriceRange', includeIfNull: false)
    String? customerEnteredPriceRange,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    bool? disableBuyButton,
    @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
    bool? disableWishlistButton,
    @JsonKey(name: 'IsReservation', includeIfNull: false) bool? isReservation,
    @JsonKey(name: 'IsAuction', includeIfNull: false) bool? isAuction,
    @JsonKey(name: 'MeasureUnit', includeIfNull: false) String? measureUnit,
    @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
    bool? availableForPreOrder,
    @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
    DateTime? preOrderDateTimeUtc,
    @JsonKey(name: 'UpdatedShoppingCartItemId', includeIfNull: false)
    String? updatedShoppingCartItemId,
    @JsonKey(name: 'UpdateShoppingCartItemType', includeIfNull: false)
    ShoppingCartType? updateShoppingCartItemType,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$AddToCartModelImplCopyWithImpl<$Res>
    extends _$AddToCartModelCopyWithImpl<$Res, _$AddToCartModelImpl>
    implements _$$AddToCartModelImplCopyWith<$Res> {
  __$$AddToCartModelImplCopyWithImpl(
    _$AddToCartModelImpl _value,
    $Res Function(_$AddToCartModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddToCartModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? enteredQuantity = freezed,
    Object? minimumQuantityNotification = freezed,
    Object? allowedQuantities = freezed,
    Object? enteredPrice = freezed,
    Object? customerEnteredPrice = freezed,
    Object? customerEnteredPriceRange = freezed,
    Object? disableBuyButton = freezed,
    Object? disableWishlistButton = freezed,
    Object? isReservation = freezed,
    Object? isAuction = freezed,
    Object? measureUnit = freezed,
    Object? availableForPreOrder = freezed,
    Object? preOrderDateTimeUtc = freezed,
    Object? updatedShoppingCartItemId = freezed,
    Object? updateShoppingCartItemType = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$AddToCartModelImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        enteredQuantity:
            freezed == enteredQuantity
                ? _value.enteredQuantity
                : enteredQuantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        minimumQuantityNotification:
            freezed == minimumQuantityNotification
                ? _value.minimumQuantityNotification
                : minimumQuantityNotification // ignore: cast_nullable_to_non_nullable
                    as String?,
        allowedQuantities:
            freezed == allowedQuantities
                ? _value._allowedQuantities
                : allowedQuantities // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        enteredPrice:
            freezed == enteredPrice
                ? _value.enteredPrice
                : enteredPrice // ignore: cast_nullable_to_non_nullable
                    as bool?,
        customerEnteredPrice:
            freezed == customerEnteredPrice
                ? _value.customerEnteredPrice
                : customerEnteredPrice // ignore: cast_nullable_to_non_nullable
                    as double?,
        customerEnteredPriceRange:
            freezed == customerEnteredPriceRange
                ? _value.customerEnteredPriceRange
                : customerEnteredPriceRange // ignore: cast_nullable_to_non_nullable
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
        isReservation:
            freezed == isReservation
                ? _value.isReservation
                : isReservation // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isAuction:
            freezed == isAuction
                ? _value.isAuction
                : isAuction // ignore: cast_nullable_to_non_nullable
                    as bool?,
        measureUnit:
            freezed == measureUnit
                ? _value.measureUnit
                : measureUnit // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        updatedShoppingCartItemId:
            freezed == updatedShoppingCartItemId
                ? _value.updatedShoppingCartItemId
                : updatedShoppingCartItemId // ignore: cast_nullable_to_non_nullable
                    as String?,
        updateShoppingCartItemType:
            freezed == updateShoppingCartItemType
                ? _value.updateShoppingCartItemType
                : updateShoppingCartItemType // ignore: cast_nullable_to_non_nullable
                    as ShoppingCartType?,
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
class _$AddToCartModelImpl implements _AddToCartModel {
  _$AddToCartModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
    this.enteredQuantity,
    @JsonKey(name: 'MinimumQuantityNotification', includeIfNull: false)
    this.minimumQuantityNotification,
    @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
    final List<SelectListItem>? allowedQuantities = const [],
    @JsonKey(name: 'EnteredPrice', includeIfNull: false)
    this.enteredPrice = false,
    @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
    this.customerEnteredPrice,
    @JsonKey(name: 'CustomerEnteredPriceRange', includeIfNull: false)
    this.customerEnteredPriceRange,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    this.disableBuyButton = false,
    @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
    this.disableWishlistButton = false,
    @JsonKey(name: 'IsReservation', includeIfNull: false)
    this.isReservation = false,
    @JsonKey(name: 'IsAuction', includeIfNull: false) this.isAuction = false,
    @JsonKey(name: 'MeasureUnit', includeIfNull: false) this.measureUnit,
    @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
    this.availableForPreOrder = false,
    @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
    this.preOrderDateTimeUtc = null,
    @JsonKey(name: 'UpdatedShoppingCartItemId', includeIfNull: false)
    this.updatedShoppingCartItemId,
    @JsonKey(name: 'UpdateShoppingCartItemType', includeIfNull: false)
    this.updateShoppingCartItemType = null,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _allowedQuantities = allowedQuantities,
       _userFields = userFields;

  factory _$AddToCartModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddToCartModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
  final int? enteredQuantity;
  @override
  @JsonKey(name: 'MinimumQuantityNotification', includeIfNull: false)
  final String? minimumQuantityNotification;
  final List<SelectListItem>? _allowedQuantities;
  @override
  @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
  List<SelectListItem>? get allowedQuantities {
    final value = _allowedQuantities;
    if (value == null) return null;
    if (_allowedQuantities is EqualUnmodifiableListView)
      return _allowedQuantities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'EnteredPrice', includeIfNull: false)
  final bool? enteredPrice;
  @override
  @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
  final double? customerEnteredPrice;
  @override
  @JsonKey(name: 'CustomerEnteredPriceRange', includeIfNull: false)
  final String? customerEnteredPriceRange;
  @override
  @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
  final bool? disableBuyButton;
  @override
  @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
  final bool? disableWishlistButton;
  @override
  @JsonKey(name: 'IsReservation', includeIfNull: false)
  final bool? isReservation;
  @override
  @JsonKey(name: 'IsAuction', includeIfNull: false)
  final bool? isAuction;
  @override
  @JsonKey(name: 'MeasureUnit', includeIfNull: false)
  final String? measureUnit;
  @override
  @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
  final bool? availableForPreOrder;
  @override
  @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
  final DateTime? preOrderDateTimeUtc;
  @override
  @JsonKey(name: 'UpdatedShoppingCartItemId', includeIfNull: false)
  final String? updatedShoppingCartItemId;
  @override
  @JsonKey(name: 'UpdateShoppingCartItemType', includeIfNull: false)
  final ShoppingCartType? updateShoppingCartItemType;
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
    return 'AddToCartModel(productId: $productId, enteredQuantity: $enteredQuantity, minimumQuantityNotification: $minimumQuantityNotification, allowedQuantities: $allowedQuantities, enteredPrice: $enteredPrice, customerEnteredPrice: $customerEnteredPrice, customerEnteredPriceRange: $customerEnteredPriceRange, disableBuyButton: $disableBuyButton, disableWishlistButton: $disableWishlistButton, isReservation: $isReservation, isAuction: $isAuction, measureUnit: $measureUnit, availableForPreOrder: $availableForPreOrder, preOrderDateTimeUtc: $preOrderDateTimeUtc, updatedShoppingCartItemId: $updatedShoppingCartItemId, updateShoppingCartItemType: $updateShoppingCartItemType, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddToCartModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.enteredQuantity, enteredQuantity) ||
                other.enteredQuantity == enteredQuantity) &&
            (identical(
                  other.minimumQuantityNotification,
                  minimumQuantityNotification,
                ) ||
                other.minimumQuantityNotification ==
                    minimumQuantityNotification) &&
            const DeepCollectionEquality().equals(
              other._allowedQuantities,
              _allowedQuantities,
            ) &&
            (identical(other.enteredPrice, enteredPrice) ||
                other.enteredPrice == enteredPrice) &&
            (identical(other.customerEnteredPrice, customerEnteredPrice) ||
                other.customerEnteredPrice == customerEnteredPrice) &&
            (identical(
                  other.customerEnteredPriceRange,
                  customerEnteredPriceRange,
                ) ||
                other.customerEnteredPriceRange == customerEnteredPriceRange) &&
            (identical(other.disableBuyButton, disableBuyButton) ||
                other.disableBuyButton == disableBuyButton) &&
            (identical(other.disableWishlistButton, disableWishlistButton) ||
                other.disableWishlistButton == disableWishlistButton) &&
            (identical(other.isReservation, isReservation) ||
                other.isReservation == isReservation) &&
            (identical(other.isAuction, isAuction) ||
                other.isAuction == isAuction) &&
            (identical(other.measureUnit, measureUnit) ||
                other.measureUnit == measureUnit) &&
            (identical(other.availableForPreOrder, availableForPreOrder) ||
                other.availableForPreOrder == availableForPreOrder) &&
            (identical(other.preOrderDateTimeUtc, preOrderDateTimeUtc) ||
                other.preOrderDateTimeUtc == preOrderDateTimeUtc) &&
            (identical(
                  other.updatedShoppingCartItemId,
                  updatedShoppingCartItemId,
                ) ||
                other.updatedShoppingCartItemId == updatedShoppingCartItemId) &&
            (identical(
                  other.updateShoppingCartItemType,
                  updateShoppingCartItemType,
                ) ||
                other.updateShoppingCartItemType ==
                    updateShoppingCartItemType) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    enteredQuantity,
    minimumQuantityNotification,
    const DeepCollectionEquality().hash(_allowedQuantities),
    enteredPrice,
    customerEnteredPrice,
    customerEnteredPriceRange,
    disableBuyButton,
    disableWishlistButton,
    isReservation,
    isAuction,
    measureUnit,
    availableForPreOrder,
    preOrderDateTimeUtc,
    updatedShoppingCartItemId,
    updateShoppingCartItemType,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of AddToCartModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddToCartModelImplCopyWith<_$AddToCartModelImpl> get copyWith =>
      __$$AddToCartModelImplCopyWithImpl<_$AddToCartModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddToCartModelImplToJson(this);
  }
}

abstract class _AddToCartModel implements AddToCartModel {
  factory _AddToCartModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
    final int? enteredQuantity,
    @JsonKey(name: 'MinimumQuantityNotification', includeIfNull: false)
    final String? minimumQuantityNotification,
    @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
    final List<SelectListItem>? allowedQuantities,
    @JsonKey(name: 'EnteredPrice', includeIfNull: false)
    final bool? enteredPrice,
    @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
    final double? customerEnteredPrice,
    @JsonKey(name: 'CustomerEnteredPriceRange', includeIfNull: false)
    final String? customerEnteredPriceRange,
    @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
    final bool? disableBuyButton,
    @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
    final bool? disableWishlistButton,
    @JsonKey(name: 'IsReservation', includeIfNull: false)
    final bool? isReservation,
    @JsonKey(name: 'IsAuction', includeIfNull: false) final bool? isAuction,
    @JsonKey(name: 'MeasureUnit', includeIfNull: false)
    final String? measureUnit,
    @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
    final bool? availableForPreOrder,
    @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
    final DateTime? preOrderDateTimeUtc,
    @JsonKey(name: 'UpdatedShoppingCartItemId', includeIfNull: false)
    final String? updatedShoppingCartItemId,
    @JsonKey(name: 'UpdateShoppingCartItemType', includeIfNull: false)
    final ShoppingCartType? updateShoppingCartItemType,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$AddToCartModelImpl;

  factory _AddToCartModel.fromJson(Map<String, dynamic> json) =
      _$AddToCartModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
  int? get enteredQuantity;
  @override
  @JsonKey(name: 'MinimumQuantityNotification', includeIfNull: false)
  String? get minimumQuantityNotification;
  @override
  @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
  List<SelectListItem>? get allowedQuantities;
  @override
  @JsonKey(name: 'EnteredPrice', includeIfNull: false)
  bool? get enteredPrice;
  @override
  @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
  double? get customerEnteredPrice;
  @override
  @JsonKey(name: 'CustomerEnteredPriceRange', includeIfNull: false)
  String? get customerEnteredPriceRange;
  @override
  @JsonKey(name: 'DisableBuyButton', includeIfNull: false)
  bool? get disableBuyButton;
  @override
  @JsonKey(name: 'DisableWishlistButton', includeIfNull: false)
  bool? get disableWishlistButton;
  @override
  @JsonKey(name: 'IsReservation', includeIfNull: false)
  bool? get isReservation;
  @override
  @JsonKey(name: 'IsAuction', includeIfNull: false)
  bool? get isAuction;
  @override
  @JsonKey(name: 'MeasureUnit', includeIfNull: false)
  String? get measureUnit;
  @override
  @JsonKey(name: 'AvailableForPreOrder', includeIfNull: false)
  bool? get availableForPreOrder;
  @override
  @JsonKey(name: 'PreOrderDateTimeUtc', includeIfNull: false)
  DateTime? get preOrderDateTimeUtc;
  @override
  @JsonKey(name: 'UpdatedShoppingCartItemId', includeIfNull: false)
  String? get updatedShoppingCartItemId;
  @override
  @JsonKey(name: 'UpdateShoppingCartItemType', includeIfNull: false)
  ShoppingCartType? get updateShoppingCartItemType;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of AddToCartModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddToCartModelImplCopyWith<_$AddToCartModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
