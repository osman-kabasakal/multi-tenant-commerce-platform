// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchandise_return_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MerchandiseReturnModel _$MerchandiseReturnModelFromJson(
  Map<String, dynamic> json,
) {
  return _MerchandiseReturnModel.fromJson(json);
}

/// @nodoc
mixin _$MerchandiseReturnModel {
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  String? get orderCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'Items', includeIfNull: false)
  List<OrderItemModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableReturnReasons', includeIfNull: false)
  List<MerchandiseReturnReasonModel>? get availableReturnReasons =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableReturnActions', includeIfNull: false)
  List<MerchandiseReturnActionModel>? get availableReturnActions =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Comments', includeIfNull: false)
  String? get comments => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupDate', includeIfNull: false)
  DateTime? get pickupDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'Error', includeIfNull: false)
  String? get error => throw _privateConstructorUsedError;
  @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
  List<AddressModel>? get existingAddresses =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
  bool? get newAddressPreselected => throw _privateConstructorUsedError;
  @JsonKey(name: 'MerchandiseReturnNewAddress', includeIfNull: false)
  AddressModel? get merchandiseReturnNewAddress =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupAddressId', includeIfNull: false)
  String? get pickupAddressId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
  bool? get showPickupAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
  bool? get showPickupDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupDateRequired', includeIfNull: false)
  bool? get pickupDateRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this MerchandiseReturnModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchandiseReturnModelCopyWith<MerchandiseReturnModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchandiseReturnModelCopyWith<$Res> {
  factory $MerchandiseReturnModelCopyWith(
    MerchandiseReturnModel value,
    $Res Function(MerchandiseReturnModel) then,
  ) = _$MerchandiseReturnModelCopyWithImpl<$Res, MerchandiseReturnModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
    @JsonKey(name: 'Items', includeIfNull: false) List<OrderItemModel>? items,
    @JsonKey(name: 'AvailableReturnReasons', includeIfNull: false)
    List<MerchandiseReturnReasonModel>? availableReturnReasons,
    @JsonKey(name: 'AvailableReturnActions', includeIfNull: false)
    List<MerchandiseReturnActionModel>? availableReturnActions,
    @JsonKey(name: 'Comments', includeIfNull: false) String? comments,
    @JsonKey(name: 'PickupDate', includeIfNull: false) DateTime? pickupDate,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'Error', includeIfNull: false) String? error,
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    List<AddressModel>? existingAddresses,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    bool? newAddressPreselected,
    @JsonKey(name: 'MerchandiseReturnNewAddress', includeIfNull: false)
    AddressModel? merchandiseReturnNewAddress,
    @JsonKey(name: 'PickupAddressId', includeIfNull: false)
    String? pickupAddressId,
    @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
    bool? showPickupAddress,
    @JsonKey(name: 'ShowPickupDate', includeIfNull: false) bool? showPickupDate,
    @JsonKey(name: 'PickupDateRequired', includeIfNull: false)
    bool? pickupDateRequired,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $AddressModelCopyWith<$Res>? get merchandiseReturnNewAddress;
}

/// @nodoc
class _$MerchandiseReturnModelCopyWithImpl<
  $Res,
  $Val extends MerchandiseReturnModel
>
    implements $MerchandiseReturnModelCopyWith<$Res> {
  _$MerchandiseReturnModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
    Object? orderNumber = freezed,
    Object? orderCode = freezed,
    Object? items = freezed,
    Object? availableReturnReasons = freezed,
    Object? availableReturnActions = freezed,
    Object? comments = freezed,
    Object? pickupDate = freezed,
    Object? result = freezed,
    Object? error = freezed,
    Object? existingAddresses = freezed,
    Object? newAddressPreselected = freezed,
    Object? merchandiseReturnNewAddress = freezed,
    Object? pickupAddressId = freezed,
    Object? showPickupAddress = freezed,
    Object? showPickupDate = freezed,
    Object? pickupDateRequired = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            orderId:
                freezed == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<OrderItemModel>?,
            availableReturnReasons:
                freezed == availableReturnReasons
                    ? _value.availableReturnReasons
                    : availableReturnReasons // ignore: cast_nullable_to_non_nullable
                        as List<MerchandiseReturnReasonModel>?,
            availableReturnActions:
                freezed == availableReturnActions
                    ? _value.availableReturnActions
                    : availableReturnActions // ignore: cast_nullable_to_non_nullable
                        as List<MerchandiseReturnActionModel>?,
            comments:
                freezed == comments
                    ? _value.comments
                    : comments // ignore: cast_nullable_to_non_nullable
                        as String?,
            pickupDate:
                freezed == pickupDate
                    ? _value.pickupDate
                    : pickupDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            result:
                freezed == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
                        as String?,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            existingAddresses:
                freezed == existingAddresses
                    ? _value.existingAddresses
                    : existingAddresses // ignore: cast_nullable_to_non_nullable
                        as List<AddressModel>?,
            newAddressPreselected:
                freezed == newAddressPreselected
                    ? _value.newAddressPreselected
                    : newAddressPreselected // ignore: cast_nullable_to_non_nullable
                        as bool?,
            merchandiseReturnNewAddress:
                freezed == merchandiseReturnNewAddress
                    ? _value.merchandiseReturnNewAddress
                    : merchandiseReturnNewAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            pickupAddressId:
                freezed == pickupAddressId
                    ? _value.pickupAddressId
                    : pickupAddressId // ignore: cast_nullable_to_non_nullable
                        as String?,
            showPickupAddress:
                freezed == showPickupAddress
                    ? _value.showPickupAddress
                    : showPickupAddress // ignore: cast_nullable_to_non_nullable
                        as bool?,
            showPickupDate:
                freezed == showPickupDate
                    ? _value.showPickupDate
                    : showPickupDate // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pickupDateRequired:
                freezed == pickupDateRequired
                    ? _value.pickupDateRequired
                    : pickupDateRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get merchandiseReturnNewAddress {
    if (_value.merchandiseReturnNewAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.merchandiseReturnNewAddress!, (
      value,
    ) {
      return _then(_value.copyWith(merchandiseReturnNewAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MerchandiseReturnModelImplCopyWith<$Res>
    implements $MerchandiseReturnModelCopyWith<$Res> {
  factory _$$MerchandiseReturnModelImplCopyWith(
    _$MerchandiseReturnModelImpl value,
    $Res Function(_$MerchandiseReturnModelImpl) then,
  ) = __$$MerchandiseReturnModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
    @JsonKey(name: 'Items', includeIfNull: false) List<OrderItemModel>? items,
    @JsonKey(name: 'AvailableReturnReasons', includeIfNull: false)
    List<MerchandiseReturnReasonModel>? availableReturnReasons,
    @JsonKey(name: 'AvailableReturnActions', includeIfNull: false)
    List<MerchandiseReturnActionModel>? availableReturnActions,
    @JsonKey(name: 'Comments', includeIfNull: false) String? comments,
    @JsonKey(name: 'PickupDate', includeIfNull: false) DateTime? pickupDate,
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'Error', includeIfNull: false) String? error,
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    List<AddressModel>? existingAddresses,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    bool? newAddressPreselected,
    @JsonKey(name: 'MerchandiseReturnNewAddress', includeIfNull: false)
    AddressModel? merchandiseReturnNewAddress,
    @JsonKey(name: 'PickupAddressId', includeIfNull: false)
    String? pickupAddressId,
    @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
    bool? showPickupAddress,
    @JsonKey(name: 'ShowPickupDate', includeIfNull: false) bool? showPickupDate,
    @JsonKey(name: 'PickupDateRequired', includeIfNull: false)
    bool? pickupDateRequired,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $AddressModelCopyWith<$Res>? get merchandiseReturnNewAddress;
}

/// @nodoc
class __$$MerchandiseReturnModelImplCopyWithImpl<$Res>
    extends
        _$MerchandiseReturnModelCopyWithImpl<$Res, _$MerchandiseReturnModelImpl>
    implements _$$MerchandiseReturnModelImplCopyWith<$Res> {
  __$$MerchandiseReturnModelImplCopyWithImpl(
    _$MerchandiseReturnModelImpl _value,
    $Res Function(_$MerchandiseReturnModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
    Object? orderNumber = freezed,
    Object? orderCode = freezed,
    Object? items = freezed,
    Object? availableReturnReasons = freezed,
    Object? availableReturnActions = freezed,
    Object? comments = freezed,
    Object? pickupDate = freezed,
    Object? result = freezed,
    Object? error = freezed,
    Object? existingAddresses = freezed,
    Object? newAddressPreselected = freezed,
    Object? merchandiseReturnNewAddress = freezed,
    Object? pickupAddressId = freezed,
    Object? showPickupAddress = freezed,
    Object? showPickupDate = freezed,
    Object? pickupDateRequired = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$MerchandiseReturnModelImpl(
        orderId:
            freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<OrderItemModel>?,
        availableReturnReasons:
            freezed == availableReturnReasons
                ? _value._availableReturnReasons
                : availableReturnReasons // ignore: cast_nullable_to_non_nullable
                    as List<MerchandiseReturnReasonModel>?,
        availableReturnActions:
            freezed == availableReturnActions
                ? _value._availableReturnActions
                : availableReturnActions // ignore: cast_nullable_to_non_nullable
                    as List<MerchandiseReturnActionModel>?,
        comments:
            freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                    as String?,
        pickupDate:
            freezed == pickupDate
                ? _value.pickupDate
                : pickupDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        result:
            freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as String?,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        existingAddresses:
            freezed == existingAddresses
                ? _value._existingAddresses
                : existingAddresses // ignore: cast_nullable_to_non_nullable
                    as List<AddressModel>?,
        newAddressPreselected:
            freezed == newAddressPreselected
                ? _value.newAddressPreselected
                : newAddressPreselected // ignore: cast_nullable_to_non_nullable
                    as bool?,
        merchandiseReturnNewAddress:
            freezed == merchandiseReturnNewAddress
                ? _value.merchandiseReturnNewAddress
                : merchandiseReturnNewAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        pickupAddressId:
            freezed == pickupAddressId
                ? _value.pickupAddressId
                : pickupAddressId // ignore: cast_nullable_to_non_nullable
                    as String?,
        showPickupAddress:
            freezed == showPickupAddress
                ? _value.showPickupAddress
                : showPickupAddress // ignore: cast_nullable_to_non_nullable
                    as bool?,
        showPickupDate:
            freezed == showPickupDate
                ? _value.showPickupDate
                : showPickupDate // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pickupDateRequired:
            freezed == pickupDateRequired
                ? _value.pickupDateRequired
                : pickupDateRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$MerchandiseReturnModelImpl implements _MerchandiseReturnModel {
  _$MerchandiseReturnModelImpl({
    @JsonKey(name: 'OrderId', includeIfNull: false) this.orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) this.orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) this.orderCode,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<OrderItemModel>? items = const [],
    @JsonKey(name: 'AvailableReturnReasons', includeIfNull: false)
    final List<MerchandiseReturnReasonModel>? availableReturnReasons = const [],
    @JsonKey(name: 'AvailableReturnActions', includeIfNull: false)
    final List<MerchandiseReturnActionModel>? availableReturnActions = const [],
    @JsonKey(name: 'Comments', includeIfNull: false) this.comments,
    @JsonKey(name: 'PickupDate', includeIfNull: false) this.pickupDate = null,
    @JsonKey(name: 'Result', includeIfNull: false) this.result,
    @JsonKey(name: 'Error', includeIfNull: false) this.error,
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    final List<AddressModel>? existingAddresses = const [],
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    this.newAddressPreselected = false,
    @JsonKey(name: 'MerchandiseReturnNewAddress', includeIfNull: false)
    this.merchandiseReturnNewAddress,
    @JsonKey(name: 'PickupAddressId', includeIfNull: false)
    this.pickupAddressId,
    @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
    this.showPickupAddress = false,
    @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
    this.showPickupDate = false,
    @JsonKey(name: 'PickupDateRequired', includeIfNull: false)
    this.pickupDateRequired = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _items = items,
       _availableReturnReasons = availableReturnReasons,
       _availableReturnActions = availableReturnActions,
       _existingAddresses = existingAddresses,
       _userFields = userFields;

  factory _$MerchandiseReturnModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MerchandiseReturnModelImplFromJson(json);

  @override
  @JsonKey(name: 'OrderId', includeIfNull: false)
  final String? orderId;
  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  final int? orderNumber;
  @override
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  final String? orderCode;
  final List<OrderItemModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<OrderItemModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<MerchandiseReturnReasonModel>? _availableReturnReasons;
  @override
  @JsonKey(name: 'AvailableReturnReasons', includeIfNull: false)
  List<MerchandiseReturnReasonModel>? get availableReturnReasons {
    final value = _availableReturnReasons;
    if (value == null) return null;
    if (_availableReturnReasons is EqualUnmodifiableListView)
      return _availableReturnReasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<MerchandiseReturnActionModel>? _availableReturnActions;
  @override
  @JsonKey(name: 'AvailableReturnActions', includeIfNull: false)
  List<MerchandiseReturnActionModel>? get availableReturnActions {
    final value = _availableReturnActions;
    if (value == null) return null;
    if (_availableReturnActions is EqualUnmodifiableListView)
      return _availableReturnActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'Comments', includeIfNull: false)
  final String? comments;
  @override
  @JsonKey(name: 'PickupDate', includeIfNull: false)
  final DateTime? pickupDate;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  final String? result;
  @override
  @JsonKey(name: 'Error', includeIfNull: false)
  final String? error;
  final List<AddressModel>? _existingAddresses;
  @override
  @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
  List<AddressModel>? get existingAddresses {
    final value = _existingAddresses;
    if (value == null) return null;
    if (_existingAddresses is EqualUnmodifiableListView)
      return _existingAddresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
  final bool? newAddressPreselected;
  @override
  @JsonKey(name: 'MerchandiseReturnNewAddress', includeIfNull: false)
  final AddressModel? merchandiseReturnNewAddress;
  @override
  @JsonKey(name: 'PickupAddressId', includeIfNull: false)
  final String? pickupAddressId;
  @override
  @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
  final bool? showPickupAddress;
  @override
  @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
  final bool? showPickupDate;
  @override
  @JsonKey(name: 'PickupDateRequired', includeIfNull: false)
  final bool? pickupDateRequired;
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
    return 'MerchandiseReturnModel(orderId: $orderId, orderNumber: $orderNumber, orderCode: $orderCode, items: $items, availableReturnReasons: $availableReturnReasons, availableReturnActions: $availableReturnActions, comments: $comments, pickupDate: $pickupDate, result: $result, error: $error, existingAddresses: $existingAddresses, newAddressPreselected: $newAddressPreselected, merchandiseReturnNewAddress: $merchandiseReturnNewAddress, pickupAddressId: $pickupAddressId, showPickupAddress: $showPickupAddress, showPickupDate: $showPickupDate, pickupDateRequired: $pickupDateRequired, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchandiseReturnModelImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.orderCode, orderCode) ||
                other.orderCode == orderCode) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._availableReturnReasons,
              _availableReturnReasons,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableReturnActions,
              _availableReturnActions,
            ) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.pickupDate, pickupDate) ||
                other.pickupDate == pickupDate) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(
              other._existingAddresses,
              _existingAddresses,
            ) &&
            (identical(other.newAddressPreselected, newAddressPreselected) ||
                other.newAddressPreselected == newAddressPreselected) &&
            (identical(
                  other.merchandiseReturnNewAddress,
                  merchandiseReturnNewAddress,
                ) ||
                other.merchandiseReturnNewAddress ==
                    merchandiseReturnNewAddress) &&
            (identical(other.pickupAddressId, pickupAddressId) ||
                other.pickupAddressId == pickupAddressId) &&
            (identical(other.showPickupAddress, showPickupAddress) ||
                other.showPickupAddress == showPickupAddress) &&
            (identical(other.showPickupDate, showPickupDate) ||
                other.showPickupDate == showPickupDate) &&
            (identical(other.pickupDateRequired, pickupDateRequired) ||
                other.pickupDateRequired == pickupDateRequired) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderId,
    orderNumber,
    orderCode,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_availableReturnReasons),
    const DeepCollectionEquality().hash(_availableReturnActions),
    comments,
    pickupDate,
    result,
    error,
    const DeepCollectionEquality().hash(_existingAddresses),
    newAddressPreselected,
    merchandiseReturnNewAddress,
    pickupAddressId,
    showPickupAddress,
    showPickupDate,
    pickupDateRequired,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchandiseReturnModelImplCopyWith<_$MerchandiseReturnModelImpl>
  get copyWith =>
      __$$MerchandiseReturnModelImplCopyWithImpl<_$MerchandiseReturnModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchandiseReturnModelImplToJson(this);
  }
}

abstract class _MerchandiseReturnModel implements MerchandiseReturnModel {
  factory _MerchandiseReturnModel({
    @JsonKey(name: 'OrderId', includeIfNull: false) final String? orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) final int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) final String? orderCode,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<OrderItemModel>? items,
    @JsonKey(name: 'AvailableReturnReasons', includeIfNull: false)
    final List<MerchandiseReturnReasonModel>? availableReturnReasons,
    @JsonKey(name: 'AvailableReturnActions', includeIfNull: false)
    final List<MerchandiseReturnActionModel>? availableReturnActions,
    @JsonKey(name: 'Comments', includeIfNull: false) final String? comments,
    @JsonKey(name: 'PickupDate', includeIfNull: false)
    final DateTime? pickupDate,
    @JsonKey(name: 'Result', includeIfNull: false) final String? result,
    @JsonKey(name: 'Error', includeIfNull: false) final String? error,
    @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
    final List<AddressModel>? existingAddresses,
    @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
    final bool? newAddressPreselected,
    @JsonKey(name: 'MerchandiseReturnNewAddress', includeIfNull: false)
    final AddressModel? merchandiseReturnNewAddress,
    @JsonKey(name: 'PickupAddressId', includeIfNull: false)
    final String? pickupAddressId,
    @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
    final bool? showPickupAddress,
    @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
    final bool? showPickupDate,
    @JsonKey(name: 'PickupDateRequired', includeIfNull: false)
    final bool? pickupDateRequired,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$MerchandiseReturnModelImpl;

  factory _MerchandiseReturnModel.fromJson(Map<String, dynamic> json) =
      _$MerchandiseReturnModelImpl.fromJson;

  @override
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId;
  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber;
  @override
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  String? get orderCode;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<OrderItemModel>? get items;
  @override
  @JsonKey(name: 'AvailableReturnReasons', includeIfNull: false)
  List<MerchandiseReturnReasonModel>? get availableReturnReasons;
  @override
  @JsonKey(name: 'AvailableReturnActions', includeIfNull: false)
  List<MerchandiseReturnActionModel>? get availableReturnActions;
  @override
  @JsonKey(name: 'Comments', includeIfNull: false)
  String? get comments;
  @override
  @JsonKey(name: 'PickupDate', includeIfNull: false)
  DateTime? get pickupDate;
  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result;
  @override
  @JsonKey(name: 'Error', includeIfNull: false)
  String? get error;
  @override
  @JsonKey(name: 'ExistingAddresses', includeIfNull: false)
  List<AddressModel>? get existingAddresses;
  @override
  @JsonKey(name: 'NewAddressPreselected', includeIfNull: false)
  bool? get newAddressPreselected;
  @override
  @JsonKey(name: 'MerchandiseReturnNewAddress', includeIfNull: false)
  AddressModel? get merchandiseReturnNewAddress;
  @override
  @JsonKey(name: 'PickupAddressId', includeIfNull: false)
  String? get pickupAddressId;
  @override
  @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
  bool? get showPickupAddress;
  @override
  @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
  bool? get showPickupDate;
  @override
  @JsonKey(name: 'PickupDateRequired', includeIfNull: false)
  bool? get pickupDateRequired;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchandiseReturnModelImplCopyWith<_$MerchandiseReturnModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
