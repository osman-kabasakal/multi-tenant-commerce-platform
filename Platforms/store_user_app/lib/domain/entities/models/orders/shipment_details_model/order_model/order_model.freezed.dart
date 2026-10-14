// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  String? get orderCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingMethod', includeIfNull: false)
  String? get shippingMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickUpInStore', includeIfNull: false)
  bool? get pickUpInStore => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  AddressModel? get pickupAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  AddressModel? get shippingAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
    OrderModel value,
    $Res Function(OrderModel) then,
  ) = _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
    @JsonKey(name: 'ShippingMethod', includeIfNull: false)
    String? shippingMethod,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false) bool? pickUpInStore,
    @JsonKey(name: 'PickupAddress', includeIfNull: false)
    AddressModel? pickupAddress,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    AddressModel? shippingAddress,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $AddressModelCopyWith<$Res>? get pickupAddress;
  $AddressModelCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderNumber = freezed,
    Object? orderCode = freezed,
    Object? shippingMethod = freezed,
    Object? pickUpInStore = freezed,
    Object? pickupAddress = freezed,
    Object? shippingAddress = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            orderNumber:
                freezed == orderNumber
                    ? _value.orderNumber
                    : orderNumber // ignore: cast_nullable_to_non_nullable
                        as int?,
            orderCode:
                freezed == orderCode
                    ? _value.orderCode
                    : orderCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippingMethod:
                freezed == shippingMethod
                    ? _value.shippingMethod
                    : shippingMethod // ignore: cast_nullable_to_non_nullable
                        as String?,
            pickUpInStore:
                freezed == pickUpInStore
                    ? _value.pickUpInStore
                    : pickUpInStore // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pickupAddress:
                freezed == pickupAddress
                    ? _value.pickupAddress
                    : pickupAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            shippingAddress:
                freezed == shippingAddress
                    ? _value.shippingAddress
                    : shippingAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of OrderModel
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

  /// Create a copy of OrderModel
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
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
    _$OrderModelImpl value,
    $Res Function(_$OrderModelImpl) then,
  ) = __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
    @JsonKey(name: 'ShippingMethod', includeIfNull: false)
    String? shippingMethod,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false) bool? pickUpInStore,
    @JsonKey(name: 'PickupAddress', includeIfNull: false)
    AddressModel? pickupAddress,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    AddressModel? shippingAddress,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $AddressModelCopyWith<$Res>? get pickupAddress;
  @override
  $AddressModelCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
    _$OrderModelImpl _value,
    $Res Function(_$OrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderNumber = freezed,
    Object? orderCode = freezed,
    Object? shippingMethod = freezed,
    Object? pickUpInStore = freezed,
    Object? pickupAddress = freezed,
    Object? shippingAddress = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$OrderModelImpl(
        orderNumber:
            freezed == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                    as int?,
        orderCode:
            freezed == orderCode
                ? _value.orderCode
                : orderCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippingMethod:
            freezed == shippingMethod
                ? _value.shippingMethod
                : shippingMethod // ignore: cast_nullable_to_non_nullable
                    as String?,
        pickUpInStore:
            freezed == pickUpInStore
                ? _value.pickUpInStore
                : pickUpInStore // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pickupAddress:
            freezed == pickupAddress
                ? _value.pickupAddress
                : pickupAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        shippingAddress:
            freezed == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
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
class _$OrderModelImpl implements _OrderModel {
  _$OrderModelImpl({
    @JsonKey(name: 'OrderNumber', includeIfNull: false) this.orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) this.orderCode,
    @JsonKey(name: 'ShippingMethod', includeIfNull: false) this.shippingMethod,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false)
    this.pickUpInStore = false,
    @JsonKey(name: 'PickupAddress', includeIfNull: false) this.pickupAddress,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    this.shippingAddress,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  final int? orderNumber;
  @override
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  final String? orderCode;
  @override
  @JsonKey(name: 'ShippingMethod', includeIfNull: false)
  final String? shippingMethod;
  @override
  @JsonKey(name: 'PickUpInStore', includeIfNull: false)
  final bool? pickUpInStore;
  @override
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  final AddressModel? pickupAddress;
  @override
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  final AddressModel? shippingAddress;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
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
    return 'OrderModel(orderNumber: $orderNumber, orderCode: $orderCode, shippingMethod: $shippingMethod, pickUpInStore: $pickUpInStore, pickupAddress: $pickupAddress, shippingAddress: $shippingAddress, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.orderCode, orderCode) ||
                other.orderCode == orderCode) &&
            (identical(other.shippingMethod, shippingMethod) ||
                other.shippingMethod == shippingMethod) &&
            (identical(other.pickUpInStore, pickUpInStore) ||
                other.pickUpInStore == pickUpInStore) &&
            (identical(other.pickupAddress, pickupAddress) ||
                other.pickupAddress == pickupAddress) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderNumber,
    orderCode,
    shippingMethod,
    pickUpInStore,
    pickupAddress,
    shippingAddress,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(this);
  }
}

abstract class _OrderModel implements OrderModel {
  factory _OrderModel({
    @JsonKey(name: 'OrderNumber', includeIfNull: false) final int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) final String? orderCode,
    @JsonKey(name: 'ShippingMethod', includeIfNull: false)
    final String? shippingMethod,
    @JsonKey(name: 'PickUpInStore', includeIfNull: false)
    final bool? pickUpInStore,
    @JsonKey(name: 'PickupAddress', includeIfNull: false)
    final AddressModel? pickupAddress,
    @JsonKey(name: 'ShippingAddress', includeIfNull: false)
    final AddressModel? shippingAddress,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber;
  @override
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  String? get orderCode;
  @override
  @JsonKey(name: 'ShippingMethod', includeIfNull: false)
  String? get shippingMethod;
  @override
  @JsonKey(name: 'PickUpInStore', includeIfNull: false)
  bool? get pickUpInStore;
  @override
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  AddressModel? get pickupAddress;
  @override
  @JsonKey(name: 'ShippingAddress', includeIfNull: false)
  AddressModel? get shippingAddress;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
