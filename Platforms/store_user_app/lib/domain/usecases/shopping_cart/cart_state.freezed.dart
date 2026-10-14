// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CartState {
  bool get isLoading => throw _privateConstructorUsedError;
  ShoppingCartModel? get cart => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Map<String, bool> get processingCarts => throw _privateConstructorUsedError;
  List<CustomAttribute> get selectedCustomAttributes =>
      throw _privateConstructorUsedError;
  OrderTotalsModel? get orderTotal => throw _privateConstructorUsedError;
  ShoppingCartInfoResponse? get shoppingCartInfo =>
      throw _privateConstructorUsedError;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartStateCopyWith<CartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartStateCopyWith<$Res> {
  factory $CartStateCopyWith(CartState value, $Res Function(CartState) then) =
      _$CartStateCopyWithImpl<$Res, CartState>;
  @useResult
  $Res call({
    bool isLoading,
    ShoppingCartModel? cart,
    String? error,
    Map<String, bool> processingCarts,
    List<CustomAttribute> selectedCustomAttributes,
    OrderTotalsModel? orderTotal,
    ShoppingCartInfoResponse? shoppingCartInfo,
  });

  $ShoppingCartModelCopyWith<$Res>? get cart;
  $OrderTotalsModelCopyWith<$Res>? get orderTotal;
  $ShoppingCartInfoResponseCopyWith<$Res>? get shoppingCartInfo;
}

/// @nodoc
class _$CartStateCopyWithImpl<$Res, $Val extends CartState>
    implements $CartStateCopyWith<$Res> {
  _$CartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? cart = freezed,
    Object? error = freezed,
    Object? processingCarts = null,
    Object? selectedCustomAttributes = null,
    Object? orderTotal = freezed,
    Object? shoppingCartInfo = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            cart:
                freezed == cart
                    ? _value.cart
                    : cart // ignore: cast_nullable_to_non_nullable
                        as ShoppingCartModel?,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            processingCarts:
                null == processingCarts
                    ? _value.processingCarts
                    : processingCarts // ignore: cast_nullable_to_non_nullable
                        as Map<String, bool>,
            selectedCustomAttributes:
                null == selectedCustomAttributes
                    ? _value.selectedCustomAttributes
                    : selectedCustomAttributes // ignore: cast_nullable_to_non_nullable
                        as List<CustomAttribute>,
            orderTotal:
                freezed == orderTotal
                    ? _value.orderTotal
                    : orderTotal // ignore: cast_nullable_to_non_nullable
                        as OrderTotalsModel?,
            shoppingCartInfo:
                freezed == shoppingCartInfo
                    ? _value.shoppingCartInfo
                    : shoppingCartInfo // ignore: cast_nullable_to_non_nullable
                        as ShoppingCartInfoResponse?,
          )
          as $Val,
    );
  }

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShoppingCartModelCopyWith<$Res>? get cart {
    if (_value.cart == null) {
      return null;
    }

    return $ShoppingCartModelCopyWith<$Res>(_value.cart!, (value) {
      return _then(_value.copyWith(cart: value) as $Val);
    });
  }

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderTotalsModelCopyWith<$Res>? get orderTotal {
    if (_value.orderTotal == null) {
      return null;
    }

    return $OrderTotalsModelCopyWith<$Res>(_value.orderTotal!, (value) {
      return _then(_value.copyWith(orderTotal: value) as $Val);
    });
  }

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShoppingCartInfoResponseCopyWith<$Res>? get shoppingCartInfo {
    if (_value.shoppingCartInfo == null) {
      return null;
    }

    return $ShoppingCartInfoResponseCopyWith<$Res>(_value.shoppingCartInfo!, (
      value,
    ) {
      return _then(_value.copyWith(shoppingCartInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartStateImplCopyWith<$Res>
    implements $CartStateCopyWith<$Res> {
  factory _$$CartStateImplCopyWith(
    _$CartStateImpl value,
    $Res Function(_$CartStateImpl) then,
  ) = __$$CartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    ShoppingCartModel? cart,
    String? error,
    Map<String, bool> processingCarts,
    List<CustomAttribute> selectedCustomAttributes,
    OrderTotalsModel? orderTotal,
    ShoppingCartInfoResponse? shoppingCartInfo,
  });

  @override
  $ShoppingCartModelCopyWith<$Res>? get cart;
  @override
  $OrderTotalsModelCopyWith<$Res>? get orderTotal;
  @override
  $ShoppingCartInfoResponseCopyWith<$Res>? get shoppingCartInfo;
}

/// @nodoc
class __$$CartStateImplCopyWithImpl<$Res>
    extends _$CartStateCopyWithImpl<$Res, _$CartStateImpl>
    implements _$$CartStateImplCopyWith<$Res> {
  __$$CartStateImplCopyWithImpl(
    _$CartStateImpl _value,
    $Res Function(_$CartStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? cart = freezed,
    Object? error = freezed,
    Object? processingCarts = null,
    Object? selectedCustomAttributes = null,
    Object? orderTotal = freezed,
    Object? shoppingCartInfo = freezed,
  }) {
    return _then(
      _$CartStateImpl(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        cart:
            freezed == cart
                ? _value.cart
                : cart // ignore: cast_nullable_to_non_nullable
                    as ShoppingCartModel?,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        processingCarts:
            null == processingCarts
                ? _value._processingCarts
                : processingCarts // ignore: cast_nullable_to_non_nullable
                    as Map<String, bool>,
        selectedCustomAttributes:
            null == selectedCustomAttributes
                ? _value._selectedCustomAttributes
                : selectedCustomAttributes // ignore: cast_nullable_to_non_nullable
                    as List<CustomAttribute>,
        orderTotal:
            freezed == orderTotal
                ? _value.orderTotal
                : orderTotal // ignore: cast_nullable_to_non_nullable
                    as OrderTotalsModel?,
        shoppingCartInfo:
            freezed == shoppingCartInfo
                ? _value.shoppingCartInfo
                : shoppingCartInfo // ignore: cast_nullable_to_non_nullable
                    as ShoppingCartInfoResponse?,
      ),
    );
  }
}

/// @nodoc

class _$CartStateImpl implements _CartState {
  const _$CartStateImpl({
    this.isLoading = false,
    this.cart = null,
    this.error = null,
    final Map<String, bool> processingCarts = const {},
    final List<CustomAttribute> selectedCustomAttributes = const [],
    this.orderTotal = null,
    this.shoppingCartInfo = null,
  }) : _processingCarts = processingCarts,
       _selectedCustomAttributes = selectedCustomAttributes;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final ShoppingCartModel? cart;
  @override
  @JsonKey()
  final String? error;
  final Map<String, bool> _processingCarts;
  @override
  @JsonKey()
  Map<String, bool> get processingCarts {
    if (_processingCarts is EqualUnmodifiableMapView) return _processingCarts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_processingCarts);
  }

  final List<CustomAttribute> _selectedCustomAttributes;
  @override
  @JsonKey()
  List<CustomAttribute> get selectedCustomAttributes {
    if (_selectedCustomAttributes is EqualUnmodifiableListView)
      return _selectedCustomAttributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedCustomAttributes);
  }

  @override
  @JsonKey()
  final OrderTotalsModel? orderTotal;
  @override
  @JsonKey()
  final ShoppingCartInfoResponse? shoppingCartInfo;

  @override
  String toString() {
    return 'CartState(isLoading: $isLoading, cart: $cart, error: $error, processingCarts: $processingCarts, selectedCustomAttributes: $selectedCustomAttributes, orderTotal: $orderTotal, shoppingCartInfo: $shoppingCartInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.cart, cart) || other.cart == cart) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(
              other._processingCarts,
              _processingCarts,
            ) &&
            const DeepCollectionEquality().equals(
              other._selectedCustomAttributes,
              _selectedCustomAttributes,
            ) &&
            (identical(other.orderTotal, orderTotal) ||
                other.orderTotal == orderTotal) &&
            (identical(other.shoppingCartInfo, shoppingCartInfo) ||
                other.shoppingCartInfo == shoppingCartInfo));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    cart,
    error,
    const DeepCollectionEquality().hash(_processingCarts),
    const DeepCollectionEquality().hash(_selectedCustomAttributes),
    orderTotal,
    shoppingCartInfo,
  );

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartStateImplCopyWith<_$CartStateImpl> get copyWith =>
      __$$CartStateImplCopyWithImpl<_$CartStateImpl>(this, _$identity);
}

abstract class _CartState implements CartState {
  const factory _CartState({
    final bool isLoading,
    final ShoppingCartModel? cart,
    final String? error,
    final Map<String, bool> processingCarts,
    final List<CustomAttribute> selectedCustomAttributes,
    final OrderTotalsModel? orderTotal,
    final ShoppingCartInfoResponse? shoppingCartInfo,
  }) = _$CartStateImpl;

  @override
  bool get isLoading;
  @override
  ShoppingCartModel? get cart;
  @override
  String? get error;
  @override
  Map<String, bool> get processingCarts;
  @override
  List<CustomAttribute> get selectedCustomAttributes;
  @override
  OrderTotalsModel? get orderTotal;
  @override
  ShoppingCartInfoResponse? get shoppingCartInfo;

  /// Create a copy of CartState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartStateImplCopyWith<_$CartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
