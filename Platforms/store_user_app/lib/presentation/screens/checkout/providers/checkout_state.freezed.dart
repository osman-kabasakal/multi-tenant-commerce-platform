// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CheckoutState {
  CheckoutStep get currentStep => throw _privateConstructorUsedError;
  ShoppingCartModel get cart => throw _privateConstructorUsedError;
  CheckOutRouteData get routeData => throw _privateConstructorUsedError;
  CheckoutModel? get checkoutModel => throw _privateConstructorUsedError;
  CheckoutStepResponse? get currentStepResponse =>
      throw _privateConstructorUsedError;
  CheckoutBillingAddressModel? get selectedAddress =>
      throw _privateConstructorUsedError;
  CheckoutShippingAddressModel? get selectedDeliveryTime =>
      throw _privateConstructorUsedError;
  CheckoutShippingMethodModel? get selectedShippingMethod =>
      throw _privateConstructorUsedError;
  CheckoutPaymentMethodModel? get paymentMethod =>
      throw _privateConstructorUsedError;
  Map<String, String>? get paymentMethodInfo =>
      throw _privateConstructorUsedError;
  CheckoutCompletedModel? get checkoutCompleted =>
      throw _privateConstructorUsedError;
  CheckoutConfirmModel? get checkoutConfirm =>
      throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutStateCopyWith<CheckoutState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutStateCopyWith<$Res> {
  factory $CheckoutStateCopyWith(
    CheckoutState value,
    $Res Function(CheckoutState) then,
  ) = _$CheckoutStateCopyWithImpl<$Res, CheckoutState>;
  @useResult
  $Res call({
    CheckoutStep currentStep,
    ShoppingCartModel cart,
    CheckOutRouteData routeData,
    CheckoutModel? checkoutModel,
    CheckoutStepResponse? currentStepResponse,
    CheckoutBillingAddressModel? selectedAddress,
    CheckoutShippingAddressModel? selectedDeliveryTime,
    CheckoutShippingMethodModel? selectedShippingMethod,
    CheckoutPaymentMethodModel? paymentMethod,
    Map<String, String>? paymentMethodInfo,
    CheckoutCompletedModel? checkoutCompleted,
    CheckoutConfirmModel? checkoutConfirm,
    String? error,
    bool isLoading,
  });

  $ShoppingCartModelCopyWith<$Res> get cart;
  $CheckOutRouteDataCopyWith<$Res> get routeData;
  $CheckoutModelCopyWith<$Res>? get checkoutModel;
  $CheckoutStepResponseCopyWith<$Res>? get currentStepResponse;
  $CheckoutBillingAddressModelCopyWith<$Res>? get selectedAddress;
  $CheckoutShippingAddressModelCopyWith<$Res>? get selectedDeliveryTime;
  $CheckoutShippingMethodModelCopyWith<$Res>? get selectedShippingMethod;
  $CheckoutPaymentMethodModelCopyWith<$Res>? get paymentMethod;
  $CheckoutCompletedModelCopyWith<$Res>? get checkoutCompleted;
  $CheckoutConfirmModelCopyWith<$Res>? get checkoutConfirm;
}

/// @nodoc
class _$CheckoutStateCopyWithImpl<$Res, $Val extends CheckoutState>
    implements $CheckoutStateCopyWith<$Res> {
  _$CheckoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? cart = null,
    Object? routeData = null,
    Object? checkoutModel = freezed,
    Object? currentStepResponse = freezed,
    Object? selectedAddress = freezed,
    Object? selectedDeliveryTime = freezed,
    Object? selectedShippingMethod = freezed,
    Object? paymentMethod = freezed,
    Object? paymentMethodInfo = freezed,
    Object? checkoutCompleted = freezed,
    Object? checkoutConfirm = freezed,
    Object? error = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _value.copyWith(
            currentStep:
                null == currentStep
                    ? _value.currentStep
                    : currentStep // ignore: cast_nullable_to_non_nullable
                        as CheckoutStep,
            cart:
                null == cart
                    ? _value.cart
                    : cart // ignore: cast_nullable_to_non_nullable
                        as ShoppingCartModel,
            routeData:
                null == routeData
                    ? _value.routeData
                    : routeData // ignore: cast_nullable_to_non_nullable
                        as CheckOutRouteData,
            checkoutModel:
                freezed == checkoutModel
                    ? _value.checkoutModel
                    : checkoutModel // ignore: cast_nullable_to_non_nullable
                        as CheckoutModel?,
            currentStepResponse:
                freezed == currentStepResponse
                    ? _value.currentStepResponse
                    : currentStepResponse // ignore: cast_nullable_to_non_nullable
                        as CheckoutStepResponse?,
            selectedAddress:
                freezed == selectedAddress
                    ? _value.selectedAddress
                    : selectedAddress // ignore: cast_nullable_to_non_nullable
                        as CheckoutBillingAddressModel?,
            selectedDeliveryTime:
                freezed == selectedDeliveryTime
                    ? _value.selectedDeliveryTime
                    : selectedDeliveryTime // ignore: cast_nullable_to_non_nullable
                        as CheckoutShippingAddressModel?,
            selectedShippingMethod:
                freezed == selectedShippingMethod
                    ? _value.selectedShippingMethod
                    : selectedShippingMethod // ignore: cast_nullable_to_non_nullable
                        as CheckoutShippingMethodModel?,
            paymentMethod:
                freezed == paymentMethod
                    ? _value.paymentMethod
                    : paymentMethod // ignore: cast_nullable_to_non_nullable
                        as CheckoutPaymentMethodModel?,
            paymentMethodInfo:
                freezed == paymentMethodInfo
                    ? _value.paymentMethodInfo
                    : paymentMethodInfo // ignore: cast_nullable_to_non_nullable
                        as Map<String, String>?,
            checkoutCompleted:
                freezed == checkoutCompleted
                    ? _value.checkoutCompleted
                    : checkoutCompleted // ignore: cast_nullable_to_non_nullable
                        as CheckoutCompletedModel?,
            checkoutConfirm:
                freezed == checkoutConfirm
                    ? _value.checkoutConfirm
                    : checkoutConfirm // ignore: cast_nullable_to_non_nullable
                        as CheckoutConfirmModel?,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShoppingCartModelCopyWith<$Res> get cart {
    return $ShoppingCartModelCopyWith<$Res>(_value.cart, (value) {
      return _then(_value.copyWith(cart: value) as $Val);
    });
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckOutRouteDataCopyWith<$Res> get routeData {
    return $CheckOutRouteDataCopyWith<$Res>(_value.routeData, (value) {
      return _then(_value.copyWith(routeData: value) as $Val);
    });
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutModelCopyWith<$Res>? get checkoutModel {
    if (_value.checkoutModel == null) {
      return null;
    }

    return $CheckoutModelCopyWith<$Res>(_value.checkoutModel!, (value) {
      return _then(_value.copyWith(checkoutModel: value) as $Val);
    });
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutStepResponseCopyWith<$Res>? get currentStepResponse {
    if (_value.currentStepResponse == null) {
      return null;
    }

    return $CheckoutStepResponseCopyWith<$Res>(_value.currentStepResponse!, (
      value,
    ) {
      return _then(_value.copyWith(currentStepResponse: value) as $Val);
    });
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutBillingAddressModelCopyWith<$Res>? get selectedAddress {
    if (_value.selectedAddress == null) {
      return null;
    }

    return $CheckoutBillingAddressModelCopyWith<$Res>(_value.selectedAddress!, (
      value,
    ) {
      return _then(_value.copyWith(selectedAddress: value) as $Val);
    });
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutShippingAddressModelCopyWith<$Res>? get selectedDeliveryTime {
    if (_value.selectedDeliveryTime == null) {
      return null;
    }

    return $CheckoutShippingAddressModelCopyWith<$Res>(
      _value.selectedDeliveryTime!,
      (value) {
        return _then(_value.copyWith(selectedDeliveryTime: value) as $Val);
      },
    );
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutShippingMethodModelCopyWith<$Res>? get selectedShippingMethod {
    if (_value.selectedShippingMethod == null) {
      return null;
    }

    return $CheckoutShippingMethodModelCopyWith<$Res>(
      _value.selectedShippingMethod!,
      (value) {
        return _then(_value.copyWith(selectedShippingMethod: value) as $Val);
      },
    );
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutPaymentMethodModelCopyWith<$Res>? get paymentMethod {
    if (_value.paymentMethod == null) {
      return null;
    }

    return $CheckoutPaymentMethodModelCopyWith<$Res>(_value.paymentMethod!, (
      value,
    ) {
      return _then(_value.copyWith(paymentMethod: value) as $Val);
    });
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutCompletedModelCopyWith<$Res>? get checkoutCompleted {
    if (_value.checkoutCompleted == null) {
      return null;
    }

    return $CheckoutCompletedModelCopyWith<$Res>(_value.checkoutCompleted!, (
      value,
    ) {
      return _then(_value.copyWith(checkoutCompleted: value) as $Val);
    });
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CheckoutConfirmModelCopyWith<$Res>? get checkoutConfirm {
    if (_value.checkoutConfirm == null) {
      return null;
    }

    return $CheckoutConfirmModelCopyWith<$Res>(_value.checkoutConfirm!, (
      value,
    ) {
      return _then(_value.copyWith(checkoutConfirm: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckoutStateImplCopyWith<$Res>
    implements $CheckoutStateCopyWith<$Res> {
  factory _$$CheckoutStateImplCopyWith(
    _$CheckoutStateImpl value,
    $Res Function(_$CheckoutStateImpl) then,
  ) = __$$CheckoutStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CheckoutStep currentStep,
    ShoppingCartModel cart,
    CheckOutRouteData routeData,
    CheckoutModel? checkoutModel,
    CheckoutStepResponse? currentStepResponse,
    CheckoutBillingAddressModel? selectedAddress,
    CheckoutShippingAddressModel? selectedDeliveryTime,
    CheckoutShippingMethodModel? selectedShippingMethod,
    CheckoutPaymentMethodModel? paymentMethod,
    Map<String, String>? paymentMethodInfo,
    CheckoutCompletedModel? checkoutCompleted,
    CheckoutConfirmModel? checkoutConfirm,
    String? error,
    bool isLoading,
  });

  @override
  $ShoppingCartModelCopyWith<$Res> get cart;
  @override
  $CheckOutRouteDataCopyWith<$Res> get routeData;
  @override
  $CheckoutModelCopyWith<$Res>? get checkoutModel;
  @override
  $CheckoutStepResponseCopyWith<$Res>? get currentStepResponse;
  @override
  $CheckoutBillingAddressModelCopyWith<$Res>? get selectedAddress;
  @override
  $CheckoutShippingAddressModelCopyWith<$Res>? get selectedDeliveryTime;
  @override
  $CheckoutShippingMethodModelCopyWith<$Res>? get selectedShippingMethod;
  @override
  $CheckoutPaymentMethodModelCopyWith<$Res>? get paymentMethod;
  @override
  $CheckoutCompletedModelCopyWith<$Res>? get checkoutCompleted;
  @override
  $CheckoutConfirmModelCopyWith<$Res>? get checkoutConfirm;
}

/// @nodoc
class __$$CheckoutStateImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$CheckoutStateImpl>
    implements _$$CheckoutStateImplCopyWith<$Res> {
  __$$CheckoutStateImplCopyWithImpl(
    _$CheckoutStateImpl _value,
    $Res Function(_$CheckoutStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? cart = null,
    Object? routeData = null,
    Object? checkoutModel = freezed,
    Object? currentStepResponse = freezed,
    Object? selectedAddress = freezed,
    Object? selectedDeliveryTime = freezed,
    Object? selectedShippingMethod = freezed,
    Object? paymentMethod = freezed,
    Object? paymentMethodInfo = freezed,
    Object? checkoutCompleted = freezed,
    Object? checkoutConfirm = freezed,
    Object? error = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _$CheckoutStateImpl(
        currentStep:
            null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                    as CheckoutStep,
        cart:
            null == cart
                ? _value.cart
                : cart // ignore: cast_nullable_to_non_nullable
                    as ShoppingCartModel,
        routeData:
            null == routeData
                ? _value.routeData
                : routeData // ignore: cast_nullable_to_non_nullable
                    as CheckOutRouteData,
        checkoutModel:
            freezed == checkoutModel
                ? _value.checkoutModel
                : checkoutModel // ignore: cast_nullable_to_non_nullable
                    as CheckoutModel?,
        currentStepResponse:
            freezed == currentStepResponse
                ? _value.currentStepResponse
                : currentStepResponse // ignore: cast_nullable_to_non_nullable
                    as CheckoutStepResponse?,
        selectedAddress:
            freezed == selectedAddress
                ? _value.selectedAddress
                : selectedAddress // ignore: cast_nullable_to_non_nullable
                    as CheckoutBillingAddressModel?,
        selectedDeliveryTime:
            freezed == selectedDeliveryTime
                ? _value.selectedDeliveryTime
                : selectedDeliveryTime // ignore: cast_nullable_to_non_nullable
                    as CheckoutShippingAddressModel?,
        selectedShippingMethod:
            freezed == selectedShippingMethod
                ? _value.selectedShippingMethod
                : selectedShippingMethod // ignore: cast_nullable_to_non_nullable
                    as CheckoutShippingMethodModel?,
        paymentMethod:
            freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                    as CheckoutPaymentMethodModel?,
        paymentMethodInfo:
            freezed == paymentMethodInfo
                ? _value._paymentMethodInfo
                : paymentMethodInfo // ignore: cast_nullable_to_non_nullable
                    as Map<String, String>?,
        checkoutCompleted:
            freezed == checkoutCompleted
                ? _value.checkoutCompleted
                : checkoutCompleted // ignore: cast_nullable_to_non_nullable
                    as CheckoutCompletedModel?,
        checkoutConfirm:
            freezed == checkoutConfirm
                ? _value.checkoutConfirm
                : checkoutConfirm // ignore: cast_nullable_to_non_nullable
                    as CheckoutConfirmModel?,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$CheckoutStateImpl implements _CheckoutState {
  const _$CheckoutStateImpl({
    required this.currentStep,
    required this.cart,
    required this.routeData,
    this.checkoutModel,
    this.currentStepResponse,
    this.selectedAddress,
    this.selectedDeliveryTime,
    this.selectedShippingMethod,
    this.paymentMethod,
    final Map<String, String>? paymentMethodInfo,
    this.checkoutCompleted,
    this.checkoutConfirm,
    this.error,
    this.isLoading = false,
  }) : _paymentMethodInfo = paymentMethodInfo;

  @override
  final CheckoutStep currentStep;
  @override
  final ShoppingCartModel cart;
  @override
  final CheckOutRouteData routeData;
  @override
  final CheckoutModel? checkoutModel;
  @override
  final CheckoutStepResponse? currentStepResponse;
  @override
  final CheckoutBillingAddressModel? selectedAddress;
  @override
  final CheckoutShippingAddressModel? selectedDeliveryTime;
  @override
  final CheckoutShippingMethodModel? selectedShippingMethod;
  @override
  final CheckoutPaymentMethodModel? paymentMethod;
  final Map<String, String>? _paymentMethodInfo;
  @override
  Map<String, String>? get paymentMethodInfo {
    final value = _paymentMethodInfo;
    if (value == null) return null;
    if (_paymentMethodInfo is EqualUnmodifiableMapView)
      return _paymentMethodInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final CheckoutCompletedModel? checkoutCompleted;
  @override
  final CheckoutConfirmModel? checkoutConfirm;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'CheckoutState(currentStep: $currentStep, cart: $cart, routeData: $routeData, checkoutModel: $checkoutModel, currentStepResponse: $currentStepResponse, selectedAddress: $selectedAddress, selectedDeliveryTime: $selectedDeliveryTime, selectedShippingMethod: $selectedShippingMethod, paymentMethod: $paymentMethod, paymentMethodInfo: $paymentMethodInfo, checkoutCompleted: $checkoutCompleted, checkoutConfirm: $checkoutConfirm, error: $error, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.cart, cart) || other.cart == cart) &&
            (identical(other.routeData, routeData) ||
                other.routeData == routeData) &&
            (identical(other.checkoutModel, checkoutModel) ||
                other.checkoutModel == checkoutModel) &&
            (identical(other.currentStepResponse, currentStepResponse) ||
                other.currentStepResponse == currentStepResponse) &&
            (identical(other.selectedAddress, selectedAddress) ||
                other.selectedAddress == selectedAddress) &&
            (identical(other.selectedDeliveryTime, selectedDeliveryTime) ||
                other.selectedDeliveryTime == selectedDeliveryTime) &&
            (identical(other.selectedShippingMethod, selectedShippingMethod) ||
                other.selectedShippingMethod == selectedShippingMethod) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality().equals(
              other._paymentMethodInfo,
              _paymentMethodInfo,
            ) &&
            (identical(other.checkoutCompleted, checkoutCompleted) ||
                other.checkoutCompleted == checkoutCompleted) &&
            (identical(other.checkoutConfirm, checkoutConfirm) ||
                other.checkoutConfirm == checkoutConfirm) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStep,
    cart,
    routeData,
    checkoutModel,
    currentStepResponse,
    selectedAddress,
    selectedDeliveryTime,
    selectedShippingMethod,
    paymentMethod,
    const DeepCollectionEquality().hash(_paymentMethodInfo),
    checkoutCompleted,
    checkoutConfirm,
    error,
    isLoading,
  );

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutStateImplCopyWith<_$CheckoutStateImpl> get copyWith =>
      __$$CheckoutStateImplCopyWithImpl<_$CheckoutStateImpl>(this, _$identity);
}

abstract class _CheckoutState implements CheckoutState {
  const factory _CheckoutState({
    required final CheckoutStep currentStep,
    required final ShoppingCartModel cart,
    required final CheckOutRouteData routeData,
    final CheckoutModel? checkoutModel,
    final CheckoutStepResponse? currentStepResponse,
    final CheckoutBillingAddressModel? selectedAddress,
    final CheckoutShippingAddressModel? selectedDeliveryTime,
    final CheckoutShippingMethodModel? selectedShippingMethod,
    final CheckoutPaymentMethodModel? paymentMethod,
    final Map<String, String>? paymentMethodInfo,
    final CheckoutCompletedModel? checkoutCompleted,
    final CheckoutConfirmModel? checkoutConfirm,
    final String? error,
    final bool isLoading,
  }) = _$CheckoutStateImpl;

  @override
  CheckoutStep get currentStep;
  @override
  ShoppingCartModel get cart;
  @override
  CheckOutRouteData get routeData;
  @override
  CheckoutModel? get checkoutModel;
  @override
  CheckoutStepResponse? get currentStepResponse;
  @override
  CheckoutBillingAddressModel? get selectedAddress;
  @override
  CheckoutShippingAddressModel? get selectedDeliveryTime;
  @override
  CheckoutShippingMethodModel? get selectedShippingMethod;
  @override
  CheckoutPaymentMethodModel? get paymentMethod;
  @override
  Map<String, String>? get paymentMethodInfo;
  @override
  CheckoutCompletedModel? get checkoutCompleted;
  @override
  CheckoutConfirmModel? get checkoutConfirm;
  @override
  String? get error;
  @override
  bool get isLoading;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutStateImplCopyWith<_$CheckoutStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
