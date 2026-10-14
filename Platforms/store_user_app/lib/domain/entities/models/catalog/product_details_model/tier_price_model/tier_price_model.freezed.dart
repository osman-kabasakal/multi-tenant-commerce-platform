// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tier_price_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TierPriceModel _$TierPriceModelFromJson(Map<String, dynamic> json) {
  return _TierPriceModel.fromJson(json);
}

/// @nodoc
mixin _$TierPriceModel {
  @JsonKey(name: 'Price', includeIfNull: false)
  String? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this TierPriceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TierPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TierPriceModelCopyWith<TierPriceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TierPriceModelCopyWith<$Res> {
  factory $TierPriceModelCopyWith(
    TierPriceModel value,
    $Res Function(TierPriceModel) then,
  ) = _$TierPriceModelCopyWithImpl<$Res, TierPriceModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Price', includeIfNull: false) String? price,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$TierPriceModelCopyWithImpl<$Res, $Val extends TierPriceModel>
    implements $TierPriceModelCopyWith<$Res> {
  _$TierPriceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TierPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = freezed,
    Object? quantity = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            price:
                freezed == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as String?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
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
abstract class _$$TierPriceModelImplCopyWith<$Res>
    implements $TierPriceModelCopyWith<$Res> {
  factory _$$TierPriceModelImplCopyWith(
    _$TierPriceModelImpl value,
    $Res Function(_$TierPriceModelImpl) then,
  ) = __$$TierPriceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Price', includeIfNull: false) String? price,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$TierPriceModelImplCopyWithImpl<$Res>
    extends _$TierPriceModelCopyWithImpl<$Res, _$TierPriceModelImpl>
    implements _$$TierPriceModelImplCopyWith<$Res> {
  __$$TierPriceModelImplCopyWithImpl(
    _$TierPriceModelImpl _value,
    $Res Function(_$TierPriceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TierPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? price = freezed,
    Object? quantity = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$TierPriceModelImpl(
        price:
            freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as String?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
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
class _$TierPriceModelImpl implements _TierPriceModel {
  _$TierPriceModelImpl({
    @JsonKey(name: 'Price', includeIfNull: false) this.price,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$TierPriceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TierPriceModelImplFromJson(json);

  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  final String? price;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
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
    return 'TierPriceModel(price: $price, quantity: $quantity, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TierPriceModelImpl &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    price,
    quantity,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of TierPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TierPriceModelImplCopyWith<_$TierPriceModelImpl> get copyWith =>
      __$$TierPriceModelImplCopyWithImpl<_$TierPriceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TierPriceModelImplToJson(this);
  }
}

abstract class _TierPriceModel implements TierPriceModel {
  factory _TierPriceModel({
    @JsonKey(name: 'Price', includeIfNull: false) final String? price,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$TierPriceModelImpl;

  factory _TierPriceModel.fromJson(Map<String, dynamic> json) =
      _$TierPriceModelImpl.fromJson;

  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  String? get price;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of TierPriceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TierPriceModelImplCopyWith<_$TierPriceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
