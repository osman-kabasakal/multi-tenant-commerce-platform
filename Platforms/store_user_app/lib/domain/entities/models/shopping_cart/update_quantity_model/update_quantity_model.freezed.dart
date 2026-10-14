// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_quantity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdateQuantityModel _$UpdateQuantityModelFromJson(Map<String, dynamic> json) {
  return _UpdateQuantityModel.fromJson(json);
}

/// @nodoc
mixin _$UpdateQuantityModel {
  @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
  String? get shoppingCartId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShoppingCartType', includeIfNull: false)
  ShoppingCartType? get shoppingCartType => throw _privateConstructorUsedError;

  /// Serializes this UpdateQuantityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateQuantityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateQuantityModelCopyWith<UpdateQuantityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateQuantityModelCopyWith<$Res> {
  factory $UpdateQuantityModelCopyWith(
    UpdateQuantityModel value,
    $Res Function(UpdateQuantityModel) then,
  ) = _$UpdateQuantityModelCopyWithImpl<$Res, UpdateQuantityModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
    String? shoppingCartId,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'ShoppingCartType', includeIfNull: false)
    ShoppingCartType? shoppingCartType,
  });
}

/// @nodoc
class _$UpdateQuantityModelCopyWithImpl<$Res, $Val extends UpdateQuantityModel>
    implements $UpdateQuantityModelCopyWith<$Res> {
  _$UpdateQuantityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateQuantityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shoppingCartId = freezed,
    Object? quantity = freezed,
    Object? shoppingCartType = freezed,
  }) {
    return _then(
      _value.copyWith(
            shoppingCartId:
                freezed == shoppingCartId
                    ? _value.shoppingCartId
                    : shoppingCartId // ignore: cast_nullable_to_non_nullable
                        as String?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            shoppingCartType:
                freezed == shoppingCartType
                    ? _value.shoppingCartType
                    : shoppingCartType // ignore: cast_nullable_to_non_nullable
                        as ShoppingCartType?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateQuantityModelImplCopyWith<$Res>
    implements $UpdateQuantityModelCopyWith<$Res> {
  factory _$$UpdateQuantityModelImplCopyWith(
    _$UpdateQuantityModelImpl value,
    $Res Function(_$UpdateQuantityModelImpl) then,
  ) = __$$UpdateQuantityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
    String? shoppingCartId,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'ShoppingCartType', includeIfNull: false)
    ShoppingCartType? shoppingCartType,
  });
}

/// @nodoc
class __$$UpdateQuantityModelImplCopyWithImpl<$Res>
    extends _$UpdateQuantityModelCopyWithImpl<$Res, _$UpdateQuantityModelImpl>
    implements _$$UpdateQuantityModelImplCopyWith<$Res> {
  __$$UpdateQuantityModelImplCopyWithImpl(
    _$UpdateQuantityModelImpl _value,
    $Res Function(_$UpdateQuantityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateQuantityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shoppingCartId = freezed,
    Object? quantity = freezed,
    Object? shoppingCartType = freezed,
  }) {
    return _then(
      _$UpdateQuantityModelImpl(
        shoppingCartId:
            freezed == shoppingCartId
                ? _value.shoppingCartId
                : shoppingCartId // ignore: cast_nullable_to_non_nullable
                    as String?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        shoppingCartType:
            freezed == shoppingCartType
                ? _value.shoppingCartType
                : shoppingCartType // ignore: cast_nullable_to_non_nullable
                    as ShoppingCartType?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateQuantityModelImpl implements _UpdateQuantityModel {
  _$UpdateQuantityModelImpl({
    @JsonKey(name: 'ShoppingCartId', includeIfNull: false) this.shoppingCartId,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'ShoppingCartType', includeIfNull: false)
    this.shoppingCartType = ShoppingCartType.onHoldCart,
  });

  factory _$UpdateQuantityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateQuantityModelImplFromJson(json);

  @override
  @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
  final String? shoppingCartId;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
  @override
  @JsonKey(name: 'ShoppingCartType', includeIfNull: false)
  final ShoppingCartType? shoppingCartType;

  @override
  String toString() {
    return 'UpdateQuantityModel(shoppingCartId: $shoppingCartId, quantity: $quantity, shoppingCartType: $shoppingCartType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateQuantityModelImpl &&
            (identical(other.shoppingCartId, shoppingCartId) ||
                other.shoppingCartId == shoppingCartId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.shoppingCartType, shoppingCartType) ||
                other.shoppingCartType == shoppingCartType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, shoppingCartId, quantity, shoppingCartType);

  /// Create a copy of UpdateQuantityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateQuantityModelImplCopyWith<_$UpdateQuantityModelImpl> get copyWith =>
      __$$UpdateQuantityModelImplCopyWithImpl<_$UpdateQuantityModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateQuantityModelImplToJson(this);
  }
}

abstract class _UpdateQuantityModel implements UpdateQuantityModel {
  factory _UpdateQuantityModel({
    @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
    final String? shoppingCartId,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'ShoppingCartType', includeIfNull: false)
    final ShoppingCartType? shoppingCartType,
  }) = _$UpdateQuantityModelImpl;

  factory _UpdateQuantityModel.fromJson(Map<String, dynamic> json) =
      _$UpdateQuantityModelImpl.fromJson;

  @override
  @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
  String? get shoppingCartId;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'ShoppingCartType', includeIfNull: false)
  ShoppingCartType? get shoppingCartType;

  /// Create a copy of UpdateQuantityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateQuantityModelImplCopyWith<_$UpdateQuantityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
