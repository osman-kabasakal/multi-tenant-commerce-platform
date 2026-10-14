// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_cart_info_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShoppingCartInfoResponse _$ShoppingCartInfoResponseFromJson(
  Map<String, dynamic> json,
) {
  return _ShoppingCartInfoResponse.fromJson(json);
}

/// @nodoc
mixin _$ShoppingCartInfoResponse {
  @JsonKey(name: 'Success', includeIfNull: false)
  bool? get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'Message', includeIfNull: false)
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'CartIsEmpty', includeIfNull: false)
  bool? get cartIsEmpty => throw _privateConstructorUsedError;
  @JsonKey(name: 'CanCheckout', includeIfNull: false)
  bool? get canCheckout => throw _privateConstructorUsedError;
  @JsonKey(name: 'MinimumOrder', includeIfNull: false)
  MinimumOrderInfoDto? get minimumOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'FreeShipping', includeIfNull: false)
  FreeShippingInfoDto? get freeShipping => throw _privateConstructorUsedError;
  @JsonKey(name: 'CartSummary', includeIfNull: false)
  CartSummaryDto? get cartSummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'ValidationMessages', includeIfNull: false)
  List<String>? get validationMessages => throw _privateConstructorUsedError;

  /// Serializes this ShoppingCartInfoResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingCartInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingCartInfoResponseCopyWith<ShoppingCartInfoResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingCartInfoResponseCopyWith<$Res> {
  factory $ShoppingCartInfoResponseCopyWith(
    ShoppingCartInfoResponse value,
    $Res Function(ShoppingCartInfoResponse) then,
  ) = _$ShoppingCartInfoResponseCopyWithImpl<$Res, ShoppingCartInfoResponse>;
  @useResult
  $Res call({
    @JsonKey(name: 'Success', includeIfNull: false) bool? success,
    @JsonKey(name: 'Message', includeIfNull: false) String? message,
    @JsonKey(name: 'CartIsEmpty', includeIfNull: false) bool? cartIsEmpty,
    @JsonKey(name: 'CanCheckout', includeIfNull: false) bool? canCheckout,
    @JsonKey(name: 'MinimumOrder', includeIfNull: false)
    MinimumOrderInfoDto? minimumOrder,
    @JsonKey(name: 'FreeShipping', includeIfNull: false)
    FreeShippingInfoDto? freeShipping,
    @JsonKey(name: 'CartSummary', includeIfNull: false)
    CartSummaryDto? cartSummary,
    @JsonKey(name: 'ValidationMessages', includeIfNull: false)
    List<String>? validationMessages,
  });

  $MinimumOrderInfoDtoCopyWith<$Res>? get minimumOrder;
  $FreeShippingInfoDtoCopyWith<$Res>? get freeShipping;
  $CartSummaryDtoCopyWith<$Res>? get cartSummary;
}

/// @nodoc
class _$ShoppingCartInfoResponseCopyWithImpl<
  $Res,
  $Val extends ShoppingCartInfoResponse
>
    implements $ShoppingCartInfoResponseCopyWith<$Res> {
  _$ShoppingCartInfoResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingCartInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? message = freezed,
    Object? cartIsEmpty = freezed,
    Object? canCheckout = freezed,
    Object? minimumOrder = freezed,
    Object? freeShipping = freezed,
    Object? cartSummary = freezed,
    Object? validationMessages = freezed,
  }) {
    return _then(
      _value.copyWith(
            success:
                freezed == success
                    ? _value.success
                    : success // ignore: cast_nullable_to_non_nullable
                        as bool?,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
            cartIsEmpty:
                freezed == cartIsEmpty
                    ? _value.cartIsEmpty
                    : cartIsEmpty // ignore: cast_nullable_to_non_nullable
                        as bool?,
            canCheckout:
                freezed == canCheckout
                    ? _value.canCheckout
                    : canCheckout // ignore: cast_nullable_to_non_nullable
                        as bool?,
            minimumOrder:
                freezed == minimumOrder
                    ? _value.minimumOrder
                    : minimumOrder // ignore: cast_nullable_to_non_nullable
                        as MinimumOrderInfoDto?,
            freeShipping:
                freezed == freeShipping
                    ? _value.freeShipping
                    : freeShipping // ignore: cast_nullable_to_non_nullable
                        as FreeShippingInfoDto?,
            cartSummary:
                freezed == cartSummary
                    ? _value.cartSummary
                    : cartSummary // ignore: cast_nullable_to_non_nullable
                        as CartSummaryDto?,
            validationMessages:
                freezed == validationMessages
                    ? _value.validationMessages
                    : validationMessages // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ShoppingCartInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MinimumOrderInfoDtoCopyWith<$Res>? get minimumOrder {
    if (_value.minimumOrder == null) {
      return null;
    }

    return $MinimumOrderInfoDtoCopyWith<$Res>(_value.minimumOrder!, (value) {
      return _then(_value.copyWith(minimumOrder: value) as $Val);
    });
  }

  /// Create a copy of ShoppingCartInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FreeShippingInfoDtoCopyWith<$Res>? get freeShipping {
    if (_value.freeShipping == null) {
      return null;
    }

    return $FreeShippingInfoDtoCopyWith<$Res>(_value.freeShipping!, (value) {
      return _then(_value.copyWith(freeShipping: value) as $Val);
    });
  }

  /// Create a copy of ShoppingCartInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartSummaryDtoCopyWith<$Res>? get cartSummary {
    if (_value.cartSummary == null) {
      return null;
    }

    return $CartSummaryDtoCopyWith<$Res>(_value.cartSummary!, (value) {
      return _then(_value.copyWith(cartSummary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShoppingCartInfoResponseImplCopyWith<$Res>
    implements $ShoppingCartInfoResponseCopyWith<$Res> {
  factory _$$ShoppingCartInfoResponseImplCopyWith(
    _$ShoppingCartInfoResponseImpl value,
    $Res Function(_$ShoppingCartInfoResponseImpl) then,
  ) = __$$ShoppingCartInfoResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Success', includeIfNull: false) bool? success,
    @JsonKey(name: 'Message', includeIfNull: false) String? message,
    @JsonKey(name: 'CartIsEmpty', includeIfNull: false) bool? cartIsEmpty,
    @JsonKey(name: 'CanCheckout', includeIfNull: false) bool? canCheckout,
    @JsonKey(name: 'MinimumOrder', includeIfNull: false)
    MinimumOrderInfoDto? minimumOrder,
    @JsonKey(name: 'FreeShipping', includeIfNull: false)
    FreeShippingInfoDto? freeShipping,
    @JsonKey(name: 'CartSummary', includeIfNull: false)
    CartSummaryDto? cartSummary,
    @JsonKey(name: 'ValidationMessages', includeIfNull: false)
    List<String>? validationMessages,
  });

  @override
  $MinimumOrderInfoDtoCopyWith<$Res>? get minimumOrder;
  @override
  $FreeShippingInfoDtoCopyWith<$Res>? get freeShipping;
  @override
  $CartSummaryDtoCopyWith<$Res>? get cartSummary;
}

/// @nodoc
class __$$ShoppingCartInfoResponseImplCopyWithImpl<$Res>
    extends
        _$ShoppingCartInfoResponseCopyWithImpl<
          $Res,
          _$ShoppingCartInfoResponseImpl
        >
    implements _$$ShoppingCartInfoResponseImplCopyWith<$Res> {
  __$$ShoppingCartInfoResponseImplCopyWithImpl(
    _$ShoppingCartInfoResponseImpl _value,
    $Res Function(_$ShoppingCartInfoResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoppingCartInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? message = freezed,
    Object? cartIsEmpty = freezed,
    Object? canCheckout = freezed,
    Object? minimumOrder = freezed,
    Object? freeShipping = freezed,
    Object? cartSummary = freezed,
    Object? validationMessages = freezed,
  }) {
    return _then(
      _$ShoppingCartInfoResponseImpl(
        success:
            freezed == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                    as bool?,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
        cartIsEmpty:
            freezed == cartIsEmpty
                ? _value.cartIsEmpty
                : cartIsEmpty // ignore: cast_nullable_to_non_nullable
                    as bool?,
        canCheckout:
            freezed == canCheckout
                ? _value.canCheckout
                : canCheckout // ignore: cast_nullable_to_non_nullable
                    as bool?,
        minimumOrder:
            freezed == minimumOrder
                ? _value.minimumOrder
                : minimumOrder // ignore: cast_nullable_to_non_nullable
                    as MinimumOrderInfoDto?,
        freeShipping:
            freezed == freeShipping
                ? _value.freeShipping
                : freeShipping // ignore: cast_nullable_to_non_nullable
                    as FreeShippingInfoDto?,
        cartSummary:
            freezed == cartSummary
                ? _value.cartSummary
                : cartSummary // ignore: cast_nullable_to_non_nullable
                    as CartSummaryDto?,
        validationMessages:
            freezed == validationMessages
                ? _value._validationMessages
                : validationMessages // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShoppingCartInfoResponseImpl implements _ShoppingCartInfoResponse {
  _$ShoppingCartInfoResponseImpl({
    @JsonKey(name: 'Success', includeIfNull: false) this.success = false,
    @JsonKey(name: 'Message', includeIfNull: false) this.message,
    @JsonKey(name: 'CartIsEmpty', includeIfNull: false)
    this.cartIsEmpty = false,
    @JsonKey(name: 'CanCheckout', includeIfNull: false)
    this.canCheckout = false,
    @JsonKey(name: 'MinimumOrder', includeIfNull: false) this.minimumOrder,
    @JsonKey(name: 'FreeShipping', includeIfNull: false) this.freeShipping,
    @JsonKey(name: 'CartSummary', includeIfNull: false) this.cartSummary,
    @JsonKey(name: 'ValidationMessages', includeIfNull: false)
    final List<String>? validationMessages = const [],
  }) : _validationMessages = validationMessages;

  factory _$ShoppingCartInfoResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingCartInfoResponseImplFromJson(json);

  @override
  @JsonKey(name: 'Success', includeIfNull: false)
  final bool? success;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  final String? message;
  @override
  @JsonKey(name: 'CartIsEmpty', includeIfNull: false)
  final bool? cartIsEmpty;
  @override
  @JsonKey(name: 'CanCheckout', includeIfNull: false)
  final bool? canCheckout;
  @override
  @JsonKey(name: 'MinimumOrder', includeIfNull: false)
  final MinimumOrderInfoDto? minimumOrder;
  @override
  @JsonKey(name: 'FreeShipping', includeIfNull: false)
  final FreeShippingInfoDto? freeShipping;
  @override
  @JsonKey(name: 'CartSummary', includeIfNull: false)
  final CartSummaryDto? cartSummary;
  final List<String>? _validationMessages;
  @override
  @JsonKey(name: 'ValidationMessages', includeIfNull: false)
  List<String>? get validationMessages {
    final value = _validationMessages;
    if (value == null) return null;
    if (_validationMessages is EqualUnmodifiableListView)
      return _validationMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ShoppingCartInfoResponse(success: $success, message: $message, cartIsEmpty: $cartIsEmpty, canCheckout: $canCheckout, minimumOrder: $minimumOrder, freeShipping: $freeShipping, cartSummary: $cartSummary, validationMessages: $validationMessages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingCartInfoResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.cartIsEmpty, cartIsEmpty) ||
                other.cartIsEmpty == cartIsEmpty) &&
            (identical(other.canCheckout, canCheckout) ||
                other.canCheckout == canCheckout) &&
            (identical(other.minimumOrder, minimumOrder) ||
                other.minimumOrder == minimumOrder) &&
            (identical(other.freeShipping, freeShipping) ||
                other.freeShipping == freeShipping) &&
            (identical(other.cartSummary, cartSummary) ||
                other.cartSummary == cartSummary) &&
            const DeepCollectionEquality().equals(
              other._validationMessages,
              _validationMessages,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    message,
    cartIsEmpty,
    canCheckout,
    minimumOrder,
    freeShipping,
    cartSummary,
    const DeepCollectionEquality().hash(_validationMessages),
  );

  /// Create a copy of ShoppingCartInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingCartInfoResponseImplCopyWith<_$ShoppingCartInfoResponseImpl>
  get copyWith => __$$ShoppingCartInfoResponseImplCopyWithImpl<
    _$ShoppingCartInfoResponseImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingCartInfoResponseImplToJson(this);
  }
}

abstract class _ShoppingCartInfoResponse implements ShoppingCartInfoResponse {
  factory _ShoppingCartInfoResponse({
    @JsonKey(name: 'Success', includeIfNull: false) final bool? success,
    @JsonKey(name: 'Message', includeIfNull: false) final String? message,
    @JsonKey(name: 'CartIsEmpty', includeIfNull: false) final bool? cartIsEmpty,
    @JsonKey(name: 'CanCheckout', includeIfNull: false) final bool? canCheckout,
    @JsonKey(name: 'MinimumOrder', includeIfNull: false)
    final MinimumOrderInfoDto? minimumOrder,
    @JsonKey(name: 'FreeShipping', includeIfNull: false)
    final FreeShippingInfoDto? freeShipping,
    @JsonKey(name: 'CartSummary', includeIfNull: false)
    final CartSummaryDto? cartSummary,
    @JsonKey(name: 'ValidationMessages', includeIfNull: false)
    final List<String>? validationMessages,
  }) = _$ShoppingCartInfoResponseImpl;

  factory _ShoppingCartInfoResponse.fromJson(Map<String, dynamic> json) =
      _$ShoppingCartInfoResponseImpl.fromJson;

  @override
  @JsonKey(name: 'Success', includeIfNull: false)
  bool? get success;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  String? get message;
  @override
  @JsonKey(name: 'CartIsEmpty', includeIfNull: false)
  bool? get cartIsEmpty;
  @override
  @JsonKey(name: 'CanCheckout', includeIfNull: false)
  bool? get canCheckout;
  @override
  @JsonKey(name: 'MinimumOrder', includeIfNull: false)
  MinimumOrderInfoDto? get minimumOrder;
  @override
  @JsonKey(name: 'FreeShipping', includeIfNull: false)
  FreeShippingInfoDto? get freeShipping;
  @override
  @JsonKey(name: 'CartSummary', includeIfNull: false)
  CartSummaryDto? get cartSummary;
  @override
  @JsonKey(name: 'ValidationMessages', includeIfNull: false)
  List<String>? get validationMessages;

  /// Create a copy of ShoppingCartInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingCartInfoResponseImplCopyWith<_$ShoppingCartInfoResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
