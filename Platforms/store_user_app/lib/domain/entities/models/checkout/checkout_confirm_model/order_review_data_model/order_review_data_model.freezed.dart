// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_review_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderReviewDataModel _$OrderReviewDataModelFromJson(Map<String, dynamic> json) {
  return _OrderReviewDataModel.fromJson(json);
}

/// @nodoc
mixin _$OrderReviewDataModel {
  @JsonKey(name: 'BillingAddress', includeIfNull: false)
  AddressModel? get billingAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsShippable', includeIfNull: false)
  bool? get isShippable => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  AddressModel? get shippingAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'SelectedPickUpInStore', includeIfNull: false)
  bool? get selectedPickUpInStore => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  AddressModel? get pickupAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingMethod', includeIfNull: false)
  String? get shippingMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
  String? get shippingAdditionDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'PaymentMethod', includeIfNull: false)
  String? get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this OrderReviewDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderReviewDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderReviewDataModelCopyWith<OrderReviewDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderReviewDataModelCopyWith<$Res> {
  factory $OrderReviewDataModelCopyWith(
    OrderReviewDataModel value,
    $Res Function(OrderReviewDataModel) then,
  ) = _$OrderReviewDataModelCopyWithImpl<$Res, OrderReviewDataModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'BillingAddress', includeIfNull: false)
    AddressModel? billingAddress,
    @JsonKey(name: 'IsShippable', includeIfNull: false) bool? isShippable,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    AddressModel? shippingAddress,
    @JsonKey(name: 'SelectedPickUpInStore', includeIfNull: false)
    bool? selectedPickUpInStore,
    @JsonKey(name: 'PickupAddress', includeIfNull: false)
    AddressModel? pickupAddress,
    @JsonKey(name: 'ShippingMethod', includeIfNull: false)
    String? shippingMethod,
    @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
    String? shippingAdditionDescription,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false) String? paymentMethod,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $AddressModelCopyWith<$Res>? get billingAddress;
  $AddressModelCopyWith<$Res>? get shippingAddress;
  $AddressModelCopyWith<$Res>? get pickupAddress;
}

/// @nodoc
class _$OrderReviewDataModelCopyWithImpl<
  $Res,
  $Val extends OrderReviewDataModel
>
    implements $OrderReviewDataModelCopyWith<$Res> {
  _$OrderReviewDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderReviewDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billingAddress = freezed,
    Object? isShippable = freezed,
    Object? shippingAddress = freezed,
    Object? selectedPickUpInStore = freezed,
    Object? pickupAddress = freezed,
    Object? shippingMethod = freezed,
    Object? shippingAdditionDescription = freezed,
    Object? paymentMethod = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            billingAddress:
                freezed == billingAddress
                    ? _value.billingAddress
                    : billingAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            isShippable:
                freezed == isShippable
                    ? _value.isShippable
                    : isShippable // ignore: cast_nullable_to_non_nullable
                        as bool?,
            shippingAddress:
                freezed == shippingAddress
                    ? _value.shippingAddress
                    : shippingAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            selectedPickUpInStore:
                freezed == selectedPickUpInStore
                    ? _value.selectedPickUpInStore
                    : selectedPickUpInStore // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pickupAddress:
                freezed == pickupAddress
                    ? _value.pickupAddress
                    : pickupAddress // ignore: cast_nullable_to_non_nullable
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
            paymentMethod:
                freezed == paymentMethod
                    ? _value.paymentMethod
                    : paymentMethod // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of OrderReviewDataModel
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

  /// Create a copy of OrderReviewDataModel
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

  /// Create a copy of OrderReviewDataModel
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
}

/// @nodoc
abstract class _$$OrderReviewDataModelImplCopyWith<$Res>
    implements $OrderReviewDataModelCopyWith<$Res> {
  factory _$$OrderReviewDataModelImplCopyWith(
    _$OrderReviewDataModelImpl value,
    $Res Function(_$OrderReviewDataModelImpl) then,
  ) = __$$OrderReviewDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'BillingAddress', includeIfNull: false)
    AddressModel? billingAddress,
    @JsonKey(name: 'IsShippable', includeIfNull: false) bool? isShippable,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    AddressModel? shippingAddress,
    @JsonKey(name: 'SelectedPickUpInStore', includeIfNull: false)
    bool? selectedPickUpInStore,
    @JsonKey(name: 'PickupAddress', includeIfNull: false)
    AddressModel? pickupAddress,
    @JsonKey(name: 'ShippingMethod', includeIfNull: false)
    String? shippingMethod,
    @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
    String? shippingAdditionDescription,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false) String? paymentMethod,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $AddressModelCopyWith<$Res>? get billingAddress;
  @override
  $AddressModelCopyWith<$Res>? get shippingAddress;
  @override
  $AddressModelCopyWith<$Res>? get pickupAddress;
}

/// @nodoc
class __$$OrderReviewDataModelImplCopyWithImpl<$Res>
    extends _$OrderReviewDataModelCopyWithImpl<$Res, _$OrderReviewDataModelImpl>
    implements _$$OrderReviewDataModelImplCopyWith<$Res> {
  __$$OrderReviewDataModelImplCopyWithImpl(
    _$OrderReviewDataModelImpl _value,
    $Res Function(_$OrderReviewDataModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderReviewDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? billingAddress = freezed,
    Object? isShippable = freezed,
    Object? shippingAddress = freezed,
    Object? selectedPickUpInStore = freezed,
    Object? pickupAddress = freezed,
    Object? shippingMethod = freezed,
    Object? shippingAdditionDescription = freezed,
    Object? paymentMethod = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$OrderReviewDataModelImpl(
        billingAddress:
            freezed == billingAddress
                ? _value.billingAddress
                : billingAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        isShippable:
            freezed == isShippable
                ? _value.isShippable
                : isShippable // ignore: cast_nullable_to_non_nullable
                    as bool?,
        shippingAddress:
            freezed == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        selectedPickUpInStore:
            freezed == selectedPickUpInStore
                ? _value.selectedPickUpInStore
                : selectedPickUpInStore // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pickupAddress:
            freezed == pickupAddress
                ? _value.pickupAddress
                : pickupAddress // ignore: cast_nullable_to_non_nullable
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
        paymentMethod:
            freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
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
class _$OrderReviewDataModelImpl implements _OrderReviewDataModel {
  _$OrderReviewDataModelImpl({
    @JsonKey(name: 'BillingAddress', includeIfNull: false) this.billingAddress,
    @JsonKey(name: 'IsShippable', includeIfNull: false)
    this.isShippable = false,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    this.shippingAddress,
    @JsonKey(name: 'SelectedPickUpInStore', includeIfNull: false)
    this.selectedPickUpInStore = false,
    @JsonKey(name: 'PickupAddress', includeIfNull: false) this.pickupAddress,
    @JsonKey(name: 'ShippingMethod', includeIfNull: false) this.shippingMethod,
    @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
    this.shippingAdditionDescription,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false) this.paymentMethod,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$OrderReviewDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderReviewDataModelImplFromJson(json);

  @override
  @JsonKey(name: 'BillingAddress', includeIfNull: false)
  final AddressModel? billingAddress;
  @override
  @JsonKey(name: 'IsShippable', includeIfNull: false)
  final bool? isShippable;
  @override
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  final AddressModel? shippingAddress;
  @override
  @JsonKey(name: 'SelectedPickUpInStore', includeIfNull: false)
  final bool? selectedPickUpInStore;
  @override
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  final AddressModel? pickupAddress;
  @override
  @JsonKey(name: 'ShippingMethod', includeIfNull: false)
  final String? shippingMethod;
  @override
  @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
  final String? shippingAdditionDescription;
  @override
  @JsonKey(name: 'PaymentMethod', includeIfNull: false)
  final String? paymentMethod;
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
    return 'OrderReviewDataModel(billingAddress: $billingAddress, isShippable: $isShippable, shippingAddress: $shippingAddress, selectedPickUpInStore: $selectedPickUpInStore, pickupAddress: $pickupAddress, shippingMethod: $shippingMethod, shippingAdditionDescription: $shippingAdditionDescription, paymentMethod: $paymentMethod, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderReviewDataModelImpl &&
            (identical(other.billingAddress, billingAddress) ||
                other.billingAddress == billingAddress) &&
            (identical(other.isShippable, isShippable) ||
                other.isShippable == isShippable) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.selectedPickUpInStore, selectedPickUpInStore) ||
                other.selectedPickUpInStore == selectedPickUpInStore) &&
            (identical(other.pickupAddress, pickupAddress) ||
                other.pickupAddress == pickupAddress) &&
            (identical(other.shippingMethod, shippingMethod) ||
                other.shippingMethod == shippingMethod) &&
            (identical(
                  other.shippingAdditionDescription,
                  shippingAdditionDescription,
                ) ||
                other.shippingAdditionDescription ==
                    shippingAdditionDescription) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    billingAddress,
    isShippable,
    shippingAddress,
    selectedPickUpInStore,
    pickupAddress,
    shippingMethod,
    shippingAdditionDescription,
    paymentMethod,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of OrderReviewDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderReviewDataModelImplCopyWith<_$OrderReviewDataModelImpl>
  get copyWith =>
      __$$OrderReviewDataModelImplCopyWithImpl<_$OrderReviewDataModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderReviewDataModelImplToJson(this);
  }
}

abstract class _OrderReviewDataModel implements OrderReviewDataModel {
  factory _OrderReviewDataModel({
    @JsonKey(name: 'BillingAddress', includeIfNull: false)
    final AddressModel? billingAddress,
    @JsonKey(name: 'IsShippable', includeIfNull: false) final bool? isShippable,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    final AddressModel? shippingAddress,
    @JsonKey(name: 'SelectedPickUpInStore', includeIfNull: false)
    final bool? selectedPickUpInStore,
    @JsonKey(name: 'PickupAddress', includeIfNull: false)
    final AddressModel? pickupAddress,
    @JsonKey(name: 'ShippingMethod', includeIfNull: false)
    final String? shippingMethod,
    @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
    final String? shippingAdditionDescription,
    @JsonKey(name: 'PaymentMethod', includeIfNull: false)
    final String? paymentMethod,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$OrderReviewDataModelImpl;

  factory _OrderReviewDataModel.fromJson(Map<String, dynamic> json) =
      _$OrderReviewDataModelImpl.fromJson;

  @override
  @JsonKey(name: 'BillingAddress', includeIfNull: false)
  AddressModel? get billingAddress;
  @override
  @JsonKey(name: 'IsShippable', includeIfNull: false)
  bool? get isShippable;
  @override
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  AddressModel? get shippingAddress;
  @override
  @JsonKey(name: 'SelectedPickUpInStore', includeIfNull: false)
  bool? get selectedPickUpInStore;
  @override
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  AddressModel? get pickupAddress;
  @override
  @JsonKey(name: 'ShippingMethod', includeIfNull: false)
  String? get shippingMethod;
  @override
  @JsonKey(name: 'ShippingAdditionDescription', includeIfNull: false)
  String? get shippingAdditionDescription;
  @override
  @JsonKey(name: 'PaymentMethod', includeIfNull: false)
  String? get paymentMethod;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of OrderReviewDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderReviewDataModelImplCopyWith<_$OrderReviewDataModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
