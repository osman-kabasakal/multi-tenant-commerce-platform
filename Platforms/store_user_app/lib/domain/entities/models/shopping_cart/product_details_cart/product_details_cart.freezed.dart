// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_details_cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductDetailsCart _$ProductDetailsCartFromJson(Map<String, dynamic> json) {
  return _ProductDetailsCart.fromJson(json);
}

/// @nodoc
mixin _$ProductDetailsCart {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
  ShoppingCartType? get shoppingCartTypeId =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ShoppingCartItemId', includeIfNull: false)
  String? get shoppingCartItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
  int? get enteredQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  String? get warehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
  String? get reservationDatepickerFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
  String? get reservationDatepickerTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'RecipientName', includeIfNull: false)
  String? get recipientName => throw _privateConstructorUsedError;
  @JsonKey(name: 'RecipientEmail', includeIfNull: false)
  String? get recipientEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'SenderName', includeIfNull: false)
  String? get senderName => throw _privateConstructorUsedError;
  @JsonKey(name: 'SenderEmail', includeIfNull: false)
  String? get senderEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'Message', includeIfNull: false)
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Reservation', includeIfNull: false)
  String? get reservation => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
  String? get customerEnteredPrice => throw _privateConstructorUsedError;

  /// Serializes this ProductDetailsCart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductDetailsCart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductDetailsCartCopyWith<ProductDetailsCart> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductDetailsCartCopyWith<$Res> {
  factory $ProductDetailsCartCopyWith(
    ProductDetailsCart value,
    $Res Function(ProductDetailsCart) then,
  ) = _$ProductDetailsCartCopyWithImpl<$Res, ProductDetailsCart>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
    ShoppingCartType? shoppingCartTypeId,
    @JsonKey(name: 'ShoppingCartItemId', includeIfNull: false)
    String? shoppingCartItemId,
    @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
    int? enteredQuantity,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
    @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
    String? reservationDatepickerFrom,
    @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
    String? reservationDatepickerTo,
    @JsonKey(name: 'RecipientName', includeIfNull: false) String? recipientName,
    @JsonKey(name: 'RecipientEmail', includeIfNull: false)
    String? recipientEmail,
    @JsonKey(name: 'SenderName', includeIfNull: false) String? senderName,
    @JsonKey(name: 'SenderEmail', includeIfNull: false) String? senderEmail,
    @JsonKey(name: 'Message', includeIfNull: false) String? message,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttributeModel>? attributes,
    @JsonKey(name: 'Reservation', includeIfNull: false) String? reservation,
    @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
    String? customerEnteredPrice,
  });
}

/// @nodoc
class _$ProductDetailsCartCopyWithImpl<$Res, $Val extends ProductDetailsCart>
    implements $ProductDetailsCartCopyWith<$Res> {
  _$ProductDetailsCartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductDetailsCart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? shoppingCartTypeId = freezed,
    Object? shoppingCartItemId = freezed,
    Object? enteredQuantity = freezed,
    Object? warehouseId = freezed,
    Object? reservationDatepickerFrom = freezed,
    Object? reservationDatepickerTo = freezed,
    Object? recipientName = freezed,
    Object? recipientEmail = freezed,
    Object? senderName = freezed,
    Object? senderEmail = freezed,
    Object? message = freezed,
    Object? attributes = freezed,
    Object? reservation = freezed,
    Object? customerEnteredPrice = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            shoppingCartTypeId:
                freezed == shoppingCartTypeId
                    ? _value.shoppingCartTypeId
                    : shoppingCartTypeId // ignore: cast_nullable_to_non_nullable
                        as ShoppingCartType?,
            shoppingCartItemId:
                freezed == shoppingCartItemId
                    ? _value.shoppingCartItemId
                    : shoppingCartItemId // ignore: cast_nullable_to_non_nullable
                        as String?,
            enteredQuantity:
                freezed == enteredQuantity
                    ? _value.enteredQuantity
                    : enteredQuantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            warehouseId:
                freezed == warehouseId
                    ? _value.warehouseId
                    : warehouseId // ignore: cast_nullable_to_non_nullable
                        as String?,
            reservationDatepickerFrom:
                freezed == reservationDatepickerFrom
                    ? _value.reservationDatepickerFrom
                    : reservationDatepickerFrom // ignore: cast_nullable_to_non_nullable
                        as String?,
            reservationDatepickerTo:
                freezed == reservationDatepickerTo
                    ? _value.reservationDatepickerTo
                    : reservationDatepickerTo // ignore: cast_nullable_to_non_nullable
                        as String?,
            recipientName:
                freezed == recipientName
                    ? _value.recipientName
                    : recipientName // ignore: cast_nullable_to_non_nullable
                        as String?,
            recipientEmail:
                freezed == recipientEmail
                    ? _value.recipientEmail
                    : recipientEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            senderName:
                freezed == senderName
                    ? _value.senderName
                    : senderName // ignore: cast_nullable_to_non_nullable
                        as String?,
            senderEmail:
                freezed == senderEmail
                    ? _value.senderEmail
                    : senderEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
            attributes:
                freezed == attributes
                    ? _value.attributes
                    : attributes // ignore: cast_nullable_to_non_nullable
                        as List<CustomAttributeModel>?,
            reservation:
                freezed == reservation
                    ? _value.reservation
                    : reservation // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerEnteredPrice:
                freezed == customerEnteredPrice
                    ? _value.customerEnteredPrice
                    : customerEnteredPrice // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductDetailsCartImplCopyWith<$Res>
    implements $ProductDetailsCartCopyWith<$Res> {
  factory _$$ProductDetailsCartImplCopyWith(
    _$ProductDetailsCartImpl value,
    $Res Function(_$ProductDetailsCartImpl) then,
  ) = __$$ProductDetailsCartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
    ShoppingCartType? shoppingCartTypeId,
    @JsonKey(name: 'ShoppingCartItemId', includeIfNull: false)
    String? shoppingCartItemId,
    @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
    int? enteredQuantity,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
    @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
    String? reservationDatepickerFrom,
    @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
    String? reservationDatepickerTo,
    @JsonKey(name: 'RecipientName', includeIfNull: false) String? recipientName,
    @JsonKey(name: 'RecipientEmail', includeIfNull: false)
    String? recipientEmail,
    @JsonKey(name: 'SenderName', includeIfNull: false) String? senderName,
    @JsonKey(name: 'SenderEmail', includeIfNull: false) String? senderEmail,
    @JsonKey(name: 'Message', includeIfNull: false) String? message,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttributeModel>? attributes,
    @JsonKey(name: 'Reservation', includeIfNull: false) String? reservation,
    @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
    String? customerEnteredPrice,
  });
}

/// @nodoc
class __$$ProductDetailsCartImplCopyWithImpl<$Res>
    extends _$ProductDetailsCartCopyWithImpl<$Res, _$ProductDetailsCartImpl>
    implements _$$ProductDetailsCartImplCopyWith<$Res> {
  __$$ProductDetailsCartImplCopyWithImpl(
    _$ProductDetailsCartImpl _value,
    $Res Function(_$ProductDetailsCartImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductDetailsCart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? shoppingCartTypeId = freezed,
    Object? shoppingCartItemId = freezed,
    Object? enteredQuantity = freezed,
    Object? warehouseId = freezed,
    Object? reservationDatepickerFrom = freezed,
    Object? reservationDatepickerTo = freezed,
    Object? recipientName = freezed,
    Object? recipientEmail = freezed,
    Object? senderName = freezed,
    Object? senderEmail = freezed,
    Object? message = freezed,
    Object? attributes = freezed,
    Object? reservation = freezed,
    Object? customerEnteredPrice = freezed,
  }) {
    return _then(
      _$ProductDetailsCartImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        shoppingCartTypeId:
            freezed == shoppingCartTypeId
                ? _value.shoppingCartTypeId
                : shoppingCartTypeId // ignore: cast_nullable_to_non_nullable
                    as ShoppingCartType?,
        shoppingCartItemId:
            freezed == shoppingCartItemId
                ? _value.shoppingCartItemId
                : shoppingCartItemId // ignore: cast_nullable_to_non_nullable
                    as String?,
        enteredQuantity:
            freezed == enteredQuantity
                ? _value.enteredQuantity
                : enteredQuantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        warehouseId:
            freezed == warehouseId
                ? _value.warehouseId
                : warehouseId // ignore: cast_nullable_to_non_nullable
                    as String?,
        reservationDatepickerFrom:
            freezed == reservationDatepickerFrom
                ? _value.reservationDatepickerFrom
                : reservationDatepickerFrom // ignore: cast_nullable_to_non_nullable
                    as String?,
        reservationDatepickerTo:
            freezed == reservationDatepickerTo
                ? _value.reservationDatepickerTo
                : reservationDatepickerTo // ignore: cast_nullable_to_non_nullable
                    as String?,
        recipientName:
            freezed == recipientName
                ? _value.recipientName
                : recipientName // ignore: cast_nullable_to_non_nullable
                    as String?,
        recipientEmail:
            freezed == recipientEmail
                ? _value.recipientEmail
                : recipientEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        senderName:
            freezed == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                    as String?,
        senderEmail:
            freezed == senderEmail
                ? _value.senderEmail
                : senderEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
        attributes:
            freezed == attributes
                ? _value._attributes
                : attributes // ignore: cast_nullable_to_non_nullable
                    as List<CustomAttributeModel>?,
        reservation:
            freezed == reservation
                ? _value.reservation
                : reservation // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerEnteredPrice:
            freezed == customerEnteredPrice
                ? _value.customerEnteredPrice
                : customerEnteredPrice // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductDetailsCartImpl implements _ProductDetailsCart {
  _$ProductDetailsCartImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
    this.shoppingCartTypeId = ShoppingCartType.onHoldCart,
    @JsonKey(name: 'ShoppingCartItemId', includeIfNull: false)
    this.shoppingCartItemId,
    @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
    this.enteredQuantity,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) this.warehouseId,
    @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
    this.reservationDatepickerFrom,
    @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
    this.reservationDatepickerTo,
    @JsonKey(name: 'RecipientName', includeIfNull: false) this.recipientName,
    @JsonKey(name: 'RecipientEmail', includeIfNull: false) this.recipientEmail,
    @JsonKey(name: 'SenderName', includeIfNull: false) this.senderName,
    @JsonKey(name: 'SenderEmail', includeIfNull: false) this.senderEmail,
    @JsonKey(name: 'Message', includeIfNull: false) this.message,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttributeModel>? attributes = const [],
    @JsonKey(name: 'Reservation', includeIfNull: false) this.reservation,
    @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
    this.customerEnteredPrice,
  }) : _attributes = attributes;

  factory _$ProductDetailsCartImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductDetailsCartImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
  final ShoppingCartType? shoppingCartTypeId;
  @override
  @JsonKey(name: 'ShoppingCartItemId', includeIfNull: false)
  final String? shoppingCartItemId;
  @override
  @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
  final int? enteredQuantity;
  @override
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  final String? warehouseId;
  @override
  @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
  final String? reservationDatepickerFrom;
  @override
  @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
  final String? reservationDatepickerTo;
  @override
  @JsonKey(name: 'RecipientName', includeIfNull: false)
  final String? recipientName;
  @override
  @JsonKey(name: 'RecipientEmail', includeIfNull: false)
  final String? recipientEmail;
  @override
  @JsonKey(name: 'SenderName', includeIfNull: false)
  final String? senderName;
  @override
  @JsonKey(name: 'SenderEmail', includeIfNull: false)
  final String? senderEmail;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  final String? message;
  final List<CustomAttributeModel>? _attributes;
  @override
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes {
    final value = _attributes;
    if (value == null) return null;
    if (_attributes is EqualUnmodifiableListView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'Reservation', includeIfNull: false)
  final String? reservation;
  @override
  @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
  final String? customerEnteredPrice;

  @override
  String toString() {
    return 'ProductDetailsCart(productId: $productId, shoppingCartTypeId: $shoppingCartTypeId, shoppingCartItemId: $shoppingCartItemId, enteredQuantity: $enteredQuantity, warehouseId: $warehouseId, reservationDatepickerFrom: $reservationDatepickerFrom, reservationDatepickerTo: $reservationDatepickerTo, recipientName: $recipientName, recipientEmail: $recipientEmail, senderName: $senderName, senderEmail: $senderEmail, message: $message, attributes: $attributes, reservation: $reservation, customerEnteredPrice: $customerEnteredPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailsCartImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.shoppingCartTypeId, shoppingCartTypeId) ||
                other.shoppingCartTypeId == shoppingCartTypeId) &&
            (identical(other.shoppingCartItemId, shoppingCartItemId) ||
                other.shoppingCartItemId == shoppingCartItemId) &&
            (identical(other.enteredQuantity, enteredQuantity) ||
                other.enteredQuantity == enteredQuantity) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(
                  other.reservationDatepickerFrom,
                  reservationDatepickerFrom,
                ) ||
                other.reservationDatepickerFrom == reservationDatepickerFrom) &&
            (identical(
                  other.reservationDatepickerTo,
                  reservationDatepickerTo,
                ) ||
                other.reservationDatepickerTo == reservationDatepickerTo) &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.recipientEmail, recipientEmail) ||
                other.recipientEmail == recipientEmail) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderEmail, senderEmail) ||
                other.senderEmail == senderEmail) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(
              other._attributes,
              _attributes,
            ) &&
            (identical(other.reservation, reservation) ||
                other.reservation == reservation) &&
            (identical(other.customerEnteredPrice, customerEnteredPrice) ||
                other.customerEnteredPrice == customerEnteredPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    shoppingCartTypeId,
    shoppingCartItemId,
    enteredQuantity,
    warehouseId,
    reservationDatepickerFrom,
    reservationDatepickerTo,
    recipientName,
    recipientEmail,
    senderName,
    senderEmail,
    message,
    const DeepCollectionEquality().hash(_attributes),
    reservation,
    customerEnteredPrice,
  );

  /// Create a copy of ProductDetailsCart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductDetailsCartImplCopyWith<_$ProductDetailsCartImpl> get copyWith =>
      __$$ProductDetailsCartImplCopyWithImpl<_$ProductDetailsCartImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductDetailsCartImplToJson(this);
  }
}

abstract class _ProductDetailsCart implements ProductDetailsCart {
  factory _ProductDetailsCart({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
    final ShoppingCartType? shoppingCartTypeId,
    @JsonKey(name: 'ShoppingCartItemId', includeIfNull: false)
    final String? shoppingCartItemId,
    @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
    final int? enteredQuantity,
    @JsonKey(name: 'WarehouseId', includeIfNull: false)
    final String? warehouseId,
    @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
    final String? reservationDatepickerFrom,
    @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
    final String? reservationDatepickerTo,
    @JsonKey(name: 'RecipientName', includeIfNull: false)
    final String? recipientName,
    @JsonKey(name: 'RecipientEmail', includeIfNull: false)
    final String? recipientEmail,
    @JsonKey(name: 'SenderName', includeIfNull: false) final String? senderName,
    @JsonKey(name: 'SenderEmail', includeIfNull: false)
    final String? senderEmail,
    @JsonKey(name: 'Message', includeIfNull: false) final String? message,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttributeModel>? attributes,
    @JsonKey(name: 'Reservation', includeIfNull: false)
    final String? reservation,
    @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
    final String? customerEnteredPrice,
  }) = _$ProductDetailsCartImpl;

  factory _ProductDetailsCart.fromJson(Map<String, dynamic> json) =
      _$ProductDetailsCartImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
  ShoppingCartType? get shoppingCartTypeId;
  @override
  @JsonKey(name: 'ShoppingCartItemId', includeIfNull: false)
  String? get shoppingCartItemId;
  @override
  @JsonKey(name: 'EnteredQuantity', includeIfNull: false)
  int? get enteredQuantity;
  @override
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  String? get warehouseId;
  @override
  @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
  String? get reservationDatepickerFrom;
  @override
  @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
  String? get reservationDatepickerTo;
  @override
  @JsonKey(name: 'RecipientName', includeIfNull: false)
  String? get recipientName;
  @override
  @JsonKey(name: 'RecipientEmail', includeIfNull: false)
  String? get recipientEmail;
  @override
  @JsonKey(name: 'SenderName', includeIfNull: false)
  String? get senderName;
  @override
  @JsonKey(name: 'SenderEmail', includeIfNull: false)
  String? get senderEmail;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  String? get message;
  @override
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes;
  @override
  @JsonKey(name: 'Reservation', includeIfNull: false)
  String? get reservation;
  @override
  @JsonKey(name: 'CustomerEnteredPrice', includeIfNull: false)
  String? get customerEnteredPrice;

  /// Create a copy of ProductDetailsCart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductDetailsCartImplCopyWith<_$ProductDetailsCartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
