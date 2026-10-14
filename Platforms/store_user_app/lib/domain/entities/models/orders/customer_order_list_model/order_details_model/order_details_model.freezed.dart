// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderDetailsModel _$OrderDetailsModelFromJson(Map<String, dynamic> json) {
  return _OrderDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$OrderDetailsModel {
  @JsonKey(name: 'OrderTotal', includeIfNull: false)
  String? get orderTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
  bool? get isMerchandiseReturnAllowed => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderStatusId', includeIfNull: false)
  int? get orderStatusId => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderStatus', includeIfNull: false)
  String? get orderStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'PaymentStatus', includeIfNull: false)
  String? get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingStatus', includeIfNull: false)
  String? get shippingStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  String? get orderCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerEmail', includeIfNull: false)
  String? get customerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this OrderDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDetailsModelCopyWith<OrderDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDetailsModelCopyWith<$Res> {
  factory $OrderDetailsModelCopyWith(
    OrderDetailsModel value,
    $Res Function(OrderDetailsModel) then,
  ) = _$OrderDetailsModelCopyWithImpl<$Res, OrderDetailsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'OrderTotal', includeIfNull: false) String? orderTotal,
    @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
    bool? isMerchandiseReturnAllowed,
    @JsonKey(name: 'OrderStatusId', includeIfNull: false) int? orderStatusId,
    @JsonKey(name: 'OrderStatus', includeIfNull: false) String? orderStatus,
    @JsonKey(name: 'PaymentStatus', includeIfNull: false) String? paymentStatus,
    @JsonKey(name: 'ShippingStatus', includeIfNull: false)
    String? shippingStatus,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
    @JsonKey(name: 'CustomerEmail', includeIfNull: false) String? customerEmail,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$OrderDetailsModelCopyWithImpl<$Res, $Val extends OrderDetailsModel>
    implements $OrderDetailsModelCopyWith<$Res> {
  _$OrderDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderTotal = freezed,
    Object? isMerchandiseReturnAllowed = freezed,
    Object? orderStatusId = freezed,
    Object? orderStatus = freezed,
    Object? paymentStatus = freezed,
    Object? shippingStatus = freezed,
    Object? createdOn = freezed,
    Object? orderNumber = freezed,
    Object? orderCode = freezed,
    Object? customerEmail = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            orderTotal:
                freezed == orderTotal
                    ? _value.orderTotal
                    : orderTotal // ignore: cast_nullable_to_non_nullable
                        as String?,
            isMerchandiseReturnAllowed:
                freezed == isMerchandiseReturnAllowed
                    ? _value.isMerchandiseReturnAllowed
                    : isMerchandiseReturnAllowed // ignore: cast_nullable_to_non_nullable
                        as bool?,
            orderStatusId:
                freezed == orderStatusId
                    ? _value.orderStatusId
                    : orderStatusId // ignore: cast_nullable_to_non_nullable
                        as int?,
            orderStatus:
                freezed == orderStatus
                    ? _value.orderStatus
                    : orderStatus // ignore: cast_nullable_to_non_nullable
                        as String?,
            paymentStatus:
                freezed == paymentStatus
                    ? _value.paymentStatus
                    : paymentStatus // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippingStatus:
                freezed == shippingStatus
                    ? _value.shippingStatus
                    : shippingStatus // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdOn:
                freezed == createdOn
                    ? _value.createdOn
                    : createdOn // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
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
            customerEmail:
                freezed == customerEmail
                    ? _value.customerEmail
                    : customerEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
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
}

/// @nodoc
abstract class _$$OrderDetailsModelImplCopyWith<$Res>
    implements $OrderDetailsModelCopyWith<$Res> {
  factory _$$OrderDetailsModelImplCopyWith(
    _$OrderDetailsModelImpl value,
    $Res Function(_$OrderDetailsModelImpl) then,
  ) = __$$OrderDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'OrderTotal', includeIfNull: false) String? orderTotal,
    @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
    bool? isMerchandiseReturnAllowed,
    @JsonKey(name: 'OrderStatusId', includeIfNull: false) int? orderStatusId,
    @JsonKey(name: 'OrderStatus', includeIfNull: false) String? orderStatus,
    @JsonKey(name: 'PaymentStatus', includeIfNull: false) String? paymentStatus,
    @JsonKey(name: 'ShippingStatus', includeIfNull: false)
    String? shippingStatus,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
    @JsonKey(name: 'CustomerEmail', includeIfNull: false) String? customerEmail,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$OrderDetailsModelImplCopyWithImpl<$Res>
    extends _$OrderDetailsModelCopyWithImpl<$Res, _$OrderDetailsModelImpl>
    implements _$$OrderDetailsModelImplCopyWith<$Res> {
  __$$OrderDetailsModelImplCopyWithImpl(
    _$OrderDetailsModelImpl _value,
    $Res Function(_$OrderDetailsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderTotal = freezed,
    Object? isMerchandiseReturnAllowed = freezed,
    Object? orderStatusId = freezed,
    Object? orderStatus = freezed,
    Object? paymentStatus = freezed,
    Object? shippingStatus = freezed,
    Object? createdOn = freezed,
    Object? orderNumber = freezed,
    Object? orderCode = freezed,
    Object? customerEmail = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$OrderDetailsModelImpl(
        orderTotal:
            freezed == orderTotal
                ? _value.orderTotal
                : orderTotal // ignore: cast_nullable_to_non_nullable
                    as String?,
        isMerchandiseReturnAllowed:
            freezed == isMerchandiseReturnAllowed
                ? _value.isMerchandiseReturnAllowed
                : isMerchandiseReturnAllowed // ignore: cast_nullable_to_non_nullable
                    as bool?,
        orderStatusId:
            freezed == orderStatusId
                ? _value.orderStatusId
                : orderStatusId // ignore: cast_nullable_to_non_nullable
                    as int?,
        orderStatus:
            freezed == orderStatus
                ? _value.orderStatus
                : orderStatus // ignore: cast_nullable_to_non_nullable
                    as String?,
        paymentStatus:
            freezed == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippingStatus:
            freezed == shippingStatus
                ? _value.shippingStatus
                : shippingStatus // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdOn:
            freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
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
        customerEmail:
            freezed == customerEmail
                ? _value.customerEmail
                : customerEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$OrderDetailsModelImpl implements _OrderDetailsModel {
  _$OrderDetailsModelImpl({
    @JsonKey(name: 'OrderTotal', includeIfNull: false) this.orderTotal,
    @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
    this.isMerchandiseReturnAllowed = false,
    @JsonKey(name: 'OrderStatusId', includeIfNull: false) this.orderStatusId,
    @JsonKey(name: 'OrderStatus', includeIfNull: false) this.orderStatus,
    @JsonKey(name: 'PaymentStatus', includeIfNull: false) this.paymentStatus,
    @JsonKey(name: 'ShippingStatus', includeIfNull: false) this.shippingStatus,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) this.orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) this.orderCode,
    @JsonKey(name: 'CustomerEmail', includeIfNull: false) this.customerEmail,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$OrderDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDetailsModelImplFromJson(json);

  @override
  @JsonKey(name: 'OrderTotal', includeIfNull: false)
  final String? orderTotal;
  @override
  @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
  final bool? isMerchandiseReturnAllowed;
  @override
  @JsonKey(name: 'OrderStatusId', includeIfNull: false)
  final int? orderStatusId;
  @override
  @JsonKey(name: 'OrderStatus', includeIfNull: false)
  final String? orderStatus;
  @override
  @JsonKey(name: 'PaymentStatus', includeIfNull: false)
  final String? paymentStatus;
  @override
  @JsonKey(name: 'ShippingStatus', includeIfNull: false)
  final String? shippingStatus;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  final int? orderNumber;
  @override
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  final String? orderCode;
  @override
  @JsonKey(name: 'CustomerEmail', includeIfNull: false)
  final String? customerEmail;
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
    return 'OrderDetailsModel(orderTotal: $orderTotal, isMerchandiseReturnAllowed: $isMerchandiseReturnAllowed, orderStatusId: $orderStatusId, orderStatus: $orderStatus, paymentStatus: $paymentStatus, shippingStatus: $shippingStatus, createdOn: $createdOn, orderNumber: $orderNumber, orderCode: $orderCode, customerEmail: $customerEmail, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDetailsModelImpl &&
            (identical(other.orderTotal, orderTotal) ||
                other.orderTotal == orderTotal) &&
            (identical(
                  other.isMerchandiseReturnAllowed,
                  isMerchandiseReturnAllowed,
                ) ||
                other.isMerchandiseReturnAllowed ==
                    isMerchandiseReturnAllowed) &&
            (identical(other.orderStatusId, orderStatusId) ||
                other.orderStatusId == orderStatusId) &&
            (identical(other.orderStatus, orderStatus) ||
                other.orderStatus == orderStatus) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.shippingStatus, shippingStatus) ||
                other.shippingStatus == shippingStatus) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.orderCode, orderCode) ||
                other.orderCode == orderCode) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
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
    orderTotal,
    isMerchandiseReturnAllowed,
    orderStatusId,
    orderStatus,
    paymentStatus,
    shippingStatus,
    createdOn,
    orderNumber,
    orderCode,
    customerEmail,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDetailsModelImplCopyWith<_$OrderDetailsModelImpl> get copyWith =>
      __$$OrderDetailsModelImplCopyWithImpl<_$OrderDetailsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderDetailsModelImplToJson(this);
  }
}

abstract class _OrderDetailsModel implements OrderDetailsModel {
  factory _OrderDetailsModel({
    @JsonKey(name: 'OrderTotal', includeIfNull: false) final String? orderTotal,
    @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
    final bool? isMerchandiseReturnAllowed,
    @JsonKey(name: 'OrderStatusId', includeIfNull: false)
    final int? orderStatusId,
    @JsonKey(name: 'OrderStatus', includeIfNull: false)
    final String? orderStatus,
    @JsonKey(name: 'PaymentStatus', includeIfNull: false)
    final String? paymentStatus,
    @JsonKey(name: 'ShippingStatus', includeIfNull: false)
    final String? shippingStatus,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) final int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) final String? orderCode,
    @JsonKey(name: 'CustomerEmail', includeIfNull: false)
    final String? customerEmail,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$OrderDetailsModelImpl;

  factory _OrderDetailsModel.fromJson(Map<String, dynamic> json) =
      _$OrderDetailsModelImpl.fromJson;

  @override
  @JsonKey(name: 'OrderTotal', includeIfNull: false)
  String? get orderTotal;
  @override
  @JsonKey(name: 'IsMerchandiseReturnAllowed', includeIfNull: false)
  bool? get isMerchandiseReturnAllowed;
  @override
  @JsonKey(name: 'OrderStatusId', includeIfNull: false)
  int? get orderStatusId;
  @override
  @JsonKey(name: 'OrderStatus', includeIfNull: false)
  String? get orderStatus;
  @override
  @JsonKey(name: 'PaymentStatus', includeIfNull: false)
  String? get paymentStatus;
  @override
  @JsonKey(name: 'ShippingStatus', includeIfNull: false)
  String? get shippingStatus;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;
  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber;
  @override
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  String? get orderCode;
  @override
  @JsonKey(name: 'CustomerEmail', includeIfNull: false)
  String? get customerEmail;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of OrderDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDetailsModelImplCopyWith<_$OrderDetailsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
