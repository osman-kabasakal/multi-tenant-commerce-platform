// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_address_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerAddressListModel _$CustomerAddressListModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerAddressListModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerAddressListModel {
  @JsonKey(name: 'Addresses', includeIfNull: false)
  List<AddressModel>? get addresses => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerAddressListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerAddressListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerAddressListModelCopyWith<CustomerAddressListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerAddressListModelCopyWith<$Res> {
  factory $CustomerAddressListModelCopyWith(
    CustomerAddressListModel value,
    $Res Function(CustomerAddressListModel) then,
  ) = _$CustomerAddressListModelCopyWithImpl<$Res, CustomerAddressListModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Addresses', includeIfNull: false)
    List<AddressModel>? addresses,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CustomerAddressListModelCopyWithImpl<
  $Res,
  $Val extends CustomerAddressListModel
>
    implements $CustomerAddressListModelCopyWith<$Res> {
  _$CustomerAddressListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerAddressListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? addresses = freezed, Object? userFields = freezed}) {
    return _then(
      _value.copyWith(
            addresses:
                freezed == addresses
                    ? _value.addresses
                    : addresses // ignore: cast_nullable_to_non_nullable
                        as List<AddressModel>?,
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
abstract class _$$CustomerAddressListModelImplCopyWith<$Res>
    implements $CustomerAddressListModelCopyWith<$Res> {
  factory _$$CustomerAddressListModelImplCopyWith(
    _$CustomerAddressListModelImpl value,
    $Res Function(_$CustomerAddressListModelImpl) then,
  ) = __$$CustomerAddressListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Addresses', includeIfNull: false)
    List<AddressModel>? addresses,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CustomerAddressListModelImplCopyWithImpl<$Res>
    extends
        _$CustomerAddressListModelCopyWithImpl<
          $Res,
          _$CustomerAddressListModelImpl
        >
    implements _$$CustomerAddressListModelImplCopyWith<$Res> {
  __$$CustomerAddressListModelImplCopyWithImpl(
    _$CustomerAddressListModelImpl _value,
    $Res Function(_$CustomerAddressListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerAddressListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? addresses = freezed, Object? userFields = freezed}) {
    return _then(
      _$CustomerAddressListModelImpl(
        addresses:
            freezed == addresses
                ? _value._addresses
                : addresses // ignore: cast_nullable_to_non_nullable
                    as List<AddressModel>?,
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
class _$CustomerAddressListModelImpl implements _CustomerAddressListModel {
  _$CustomerAddressListModelImpl({
    @JsonKey(name: 'Addresses', includeIfNull: false)
    final List<AddressModel>? addresses = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _addresses = addresses,
       _userFields = userFields;

  factory _$CustomerAddressListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerAddressListModelImplFromJson(json);

  final List<AddressModel>? _addresses;
  @override
  @JsonKey(name: 'Addresses', includeIfNull: false)
  List<AddressModel>? get addresses {
    final value = _addresses;
    if (value == null) return null;
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'CustomerAddressListModel(addresses: $addresses, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerAddressListModelImpl &&
            const DeepCollectionEquality().equals(
              other._addresses,
              _addresses,
            ) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_addresses),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CustomerAddressListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerAddressListModelImplCopyWith<_$CustomerAddressListModelImpl>
  get copyWith => __$$CustomerAddressListModelImplCopyWithImpl<
    _$CustomerAddressListModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerAddressListModelImplToJson(this);
  }
}

abstract class _CustomerAddressListModel implements CustomerAddressListModel {
  factory _CustomerAddressListModel({
    @JsonKey(name: 'Addresses', includeIfNull: false)
    final List<AddressModel>? addresses,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerAddressListModelImpl;

  factory _CustomerAddressListModel.fromJson(Map<String, dynamic> json) =
      _$CustomerAddressListModelImpl.fromJson;

  @override
  @JsonKey(name: 'Addresses', includeIfNull: false)
  List<AddressModel>? get addresses;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerAddressListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerAddressListModelImplCopyWith<_$CustomerAddressListModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
