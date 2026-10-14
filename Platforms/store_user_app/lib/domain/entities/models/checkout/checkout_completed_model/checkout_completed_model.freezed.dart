// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_completed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutCompletedModel _$CheckoutCompletedModelFromJson(
  Map<String, dynamic> json,
) {
  return _CheckoutCompletedModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutCompletedModel {
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  String? get orderCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CheckoutCompletedModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutCompletedModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutCompletedModelCopyWith<CheckoutCompletedModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutCompletedModelCopyWith<$Res> {
  factory $CheckoutCompletedModelCopyWith(
    CheckoutCompletedModel value,
    $Res Function(CheckoutCompletedModel) then,
  ) = _$CheckoutCompletedModelCopyWithImpl<$Res, CheckoutCompletedModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CheckoutCompletedModelCopyWithImpl<
  $Res,
  $Val extends CheckoutCompletedModel
>
    implements $CheckoutCompletedModelCopyWith<$Res> {
  _$CheckoutCompletedModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutCompletedModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
    Object? orderNumber = freezed,
    Object? orderCode = freezed,
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
abstract class _$$CheckoutCompletedModelImplCopyWith<$Res>
    implements $CheckoutCompletedModelCopyWith<$Res> {
  factory _$$CheckoutCompletedModelImplCopyWith(
    _$CheckoutCompletedModelImpl value,
    $Res Function(_$CheckoutCompletedModelImpl) then,
  ) = __$$CheckoutCompletedModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) String? orderCode,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CheckoutCompletedModelImplCopyWithImpl<$Res>
    extends
        _$CheckoutCompletedModelCopyWithImpl<$Res, _$CheckoutCompletedModelImpl>
    implements _$$CheckoutCompletedModelImplCopyWith<$Res> {
  __$$CheckoutCompletedModelImplCopyWithImpl(
    _$CheckoutCompletedModelImpl _value,
    $Res Function(_$CheckoutCompletedModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutCompletedModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = freezed,
    Object? orderNumber = freezed,
    Object? orderCode = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CheckoutCompletedModelImpl(
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
class _$CheckoutCompletedModelImpl implements _CheckoutCompletedModel {
  _$CheckoutCompletedModelImpl({
    @JsonKey(name: 'OrderId', includeIfNull: false) this.orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) this.orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) this.orderCode,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$CheckoutCompletedModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutCompletedModelImplFromJson(json);

  @override
  @JsonKey(name: 'OrderId', includeIfNull: false)
  final String? orderId;
  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  final int? orderNumber;
  @override
  @JsonKey(name: 'OrderCode', includeIfNull: false)
  final String? orderCode;
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
    return 'CheckoutCompletedModel(orderId: $orderId, orderNumber: $orderNumber, orderCode: $orderCode, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutCompletedModelImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.orderCode, orderCode) ||
                other.orderCode == orderCode) &&
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
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CheckoutCompletedModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutCompletedModelImplCopyWith<_$CheckoutCompletedModelImpl>
  get copyWith =>
      __$$CheckoutCompletedModelImplCopyWithImpl<_$CheckoutCompletedModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutCompletedModelImplToJson(this);
  }
}

abstract class _CheckoutCompletedModel implements CheckoutCompletedModel {
  factory _CheckoutCompletedModel({
    @JsonKey(name: 'OrderId', includeIfNull: false) final String? orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) final int? orderNumber,
    @JsonKey(name: 'OrderCode', includeIfNull: false) final String? orderCode,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CheckoutCompletedModelImpl;

  factory _CheckoutCompletedModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutCompletedModelImpl.fromJson;

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
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CheckoutCompletedModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutCompletedModelImplCopyWith<_$CheckoutCompletedModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
