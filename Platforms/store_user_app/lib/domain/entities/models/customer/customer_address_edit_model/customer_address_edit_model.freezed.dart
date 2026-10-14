// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_address_edit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerAddressEditModel _$CustomerAddressEditModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerAddressEditModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerAddressEditModel {
  @JsonKey(name: 'Address', includeIfNull: false)
  AddressModel? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerAddressEditModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerAddressEditModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerAddressEditModelCopyWith<CustomerAddressEditModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerAddressEditModelCopyWith<$Res> {
  factory $CustomerAddressEditModelCopyWith(
    CustomerAddressEditModel value,
    $Res Function(CustomerAddressEditModel) then,
  ) = _$CustomerAddressEditModelCopyWithImpl<$Res, CustomerAddressEditModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Address', includeIfNull: false) AddressModel? address,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $AddressModelCopyWith<$Res>? get address;
}

/// @nodoc
class _$CustomerAddressEditModelCopyWithImpl<
  $Res,
  $Val extends CustomerAddressEditModel
>
    implements $CustomerAddressEditModelCopyWith<$Res> {
  _$CustomerAddressEditModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerAddressEditModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? address = freezed, Object? userFields = freezed}) {
    return _then(
      _value.copyWith(
            address:
                freezed == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of CustomerAddressEditModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CustomerAddressEditModelImplCopyWith<$Res>
    implements $CustomerAddressEditModelCopyWith<$Res> {
  factory _$$CustomerAddressEditModelImplCopyWith(
    _$CustomerAddressEditModelImpl value,
    $Res Function(_$CustomerAddressEditModelImpl) then,
  ) = __$$CustomerAddressEditModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Address', includeIfNull: false) AddressModel? address,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $AddressModelCopyWith<$Res>? get address;
}

/// @nodoc
class __$$CustomerAddressEditModelImplCopyWithImpl<$Res>
    extends
        _$CustomerAddressEditModelCopyWithImpl<
          $Res,
          _$CustomerAddressEditModelImpl
        >
    implements _$$CustomerAddressEditModelImplCopyWith<$Res> {
  __$$CustomerAddressEditModelImplCopyWithImpl(
    _$CustomerAddressEditModelImpl _value,
    $Res Function(_$CustomerAddressEditModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerAddressEditModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? address = freezed, Object? userFields = freezed}) {
    return _then(
      _$CustomerAddressEditModelImpl(
        address:
            freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
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
class _$CustomerAddressEditModelImpl implements _CustomerAddressEditModel {
  _$CustomerAddressEditModelImpl({
    @JsonKey(name: 'Address', includeIfNull: false) this.address,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$CustomerAddressEditModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerAddressEditModelImplFromJson(json);

  @override
  @JsonKey(name: 'Address', includeIfNull: false)
  final AddressModel? address;
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
    return 'CustomerAddressEditModel(address: $address, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerAddressEditModelImpl &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    address,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CustomerAddressEditModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerAddressEditModelImplCopyWith<_$CustomerAddressEditModelImpl>
  get copyWith => __$$CustomerAddressEditModelImplCopyWithImpl<
    _$CustomerAddressEditModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerAddressEditModelImplToJson(this);
  }
}

abstract class _CustomerAddressEditModel implements CustomerAddressEditModel {
  factory _CustomerAddressEditModel({
    @JsonKey(name: 'Address', includeIfNull: false) final AddressModel? address,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerAddressEditModelImpl;

  factory _CustomerAddressEditModel.fromJson(Map<String, dynamic> json) =
      _$CustomerAddressEditModelImpl.fromJson;

  @override
  @JsonKey(name: 'Address', includeIfNull: false)
  AddressModel? get address;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerAddressEditModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerAddressEditModelImplCopyWith<_$CustomerAddressEditModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
