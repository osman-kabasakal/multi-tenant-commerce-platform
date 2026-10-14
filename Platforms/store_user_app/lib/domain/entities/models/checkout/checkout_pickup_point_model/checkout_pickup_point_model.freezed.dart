// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_pickup_point_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutPickupPointModel _$CheckoutPickupPointModelFromJson(
  Map<String, dynamic> json,
) {
  return _CheckoutPickupPointModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutPickupPointModel {
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'Address', includeIfNull: false)
  Address? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupFee', includeIfNull: false)
  String? get pickupFee => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CheckoutPickupPointModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutPickupPointModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutPickupPointModelCopyWith<CheckoutPickupPointModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutPickupPointModelCopyWith<$Res> {
  factory $CheckoutPickupPointModelCopyWith(
    CheckoutPickupPointModel value,
    $Res Function(CheckoutPickupPointModel) then,
  ) = _$CheckoutPickupPointModelCopyWithImpl<$Res, CheckoutPickupPointModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'Address', includeIfNull: false) Address? address,
    @JsonKey(name: 'PickupFee', includeIfNull: false) String? pickupFee,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $AddressCopyWith<$Res>? get address;
}

/// @nodoc
class _$CheckoutPickupPointModelCopyWithImpl<
  $Res,
  $Val extends CheckoutPickupPointModel
>
    implements $CheckoutPickupPointModelCopyWith<$Res> {
  _$CheckoutPickupPointModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutPickupPointModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? address = freezed,
    Object? pickupFee = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            address:
                freezed == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as Address?,
            pickupFee:
                freezed == pickupFee
                    ? _value.pickupFee
                    : pickupFee // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of CheckoutPickupPointModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $AddressCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckoutPickupPointModelImplCopyWith<$Res>
    implements $CheckoutPickupPointModelCopyWith<$Res> {
  factory _$$CheckoutPickupPointModelImplCopyWith(
    _$CheckoutPickupPointModelImpl value,
    $Res Function(_$CheckoutPickupPointModelImpl) then,
  ) = __$$CheckoutPickupPointModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'Address', includeIfNull: false) Address? address,
    @JsonKey(name: 'PickupFee', includeIfNull: false) String? pickupFee,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $AddressCopyWith<$Res>? get address;
}

/// @nodoc
class __$$CheckoutPickupPointModelImplCopyWithImpl<$Res>
    extends
        _$CheckoutPickupPointModelCopyWithImpl<
          $Res,
          _$CheckoutPickupPointModelImpl
        >
    implements _$$CheckoutPickupPointModelImplCopyWith<$Res> {
  __$$CheckoutPickupPointModelImplCopyWithImpl(
    _$CheckoutPickupPointModelImpl _value,
    $Res Function(_$CheckoutPickupPointModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutPickupPointModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? address = freezed,
    Object? pickupFee = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CheckoutPickupPointModelImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        address:
            freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as Address?,
        pickupFee:
            freezed == pickupFee
                ? _value.pickupFee
                : pickupFee // ignore: cast_nullable_to_non_nullable
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
class _$CheckoutPickupPointModelImpl implements _CheckoutPickupPointModel {
  _$CheckoutPickupPointModelImpl({
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'Address', includeIfNull: false) this.address,
    @JsonKey(name: 'PickupFee', includeIfNull: false) this.pickupFee,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$CheckoutPickupPointModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutPickupPointModelImplFromJson(json);

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'Address', includeIfNull: false)
  final Address? address;
  @override
  @JsonKey(name: 'PickupFee', includeIfNull: false)
  final String? pickupFee;
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
    return 'CheckoutPickupPointModel(id: $id, name: $name, description: $description, address: $address, pickupFee: $pickupFee, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutPickupPointModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.pickupFee, pickupFee) ||
                other.pickupFee == pickupFee) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    address,
    pickupFee,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CheckoutPickupPointModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutPickupPointModelImplCopyWith<_$CheckoutPickupPointModelImpl>
  get copyWith => __$$CheckoutPickupPointModelImplCopyWithImpl<
    _$CheckoutPickupPointModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutPickupPointModelImplToJson(this);
  }
}

abstract class _CheckoutPickupPointModel implements CheckoutPickupPointModel {
  factory _CheckoutPickupPointModel({
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'Address', includeIfNull: false) final Address? address,
    @JsonKey(name: 'PickupFee', includeIfNull: false) final String? pickupFee,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CheckoutPickupPointModelImpl;

  factory _CheckoutPickupPointModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutPickupPointModelImpl.fromJson;

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'Address', includeIfNull: false)
  Address? get address;
  @override
  @JsonKey(name: 'PickupFee', includeIfNull: false)
  String? get pickupFee;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CheckoutPickupPointModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutPickupPointModelImplCopyWith<_$CheckoutPickupPointModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
