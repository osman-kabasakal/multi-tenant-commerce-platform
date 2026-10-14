// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_merchandise_returns_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerMerchandiseReturnsModel _$CustomerMerchandiseReturnsModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerMerchandiseReturnsModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerMerchandiseReturnsModel {
  @JsonKey(name: 'Items', includeIfNull: false)
  List<MerchandiseReturnModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerMerchandiseReturnsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerMerchandiseReturnsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerMerchandiseReturnsModelCopyWith<CustomerMerchandiseReturnsModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerMerchandiseReturnsModelCopyWith<$Res> {
  factory $CustomerMerchandiseReturnsModelCopyWith(
    CustomerMerchandiseReturnsModel value,
    $Res Function(CustomerMerchandiseReturnsModel) then,
  ) =
      _$CustomerMerchandiseReturnsModelCopyWithImpl<
        $Res,
        CustomerMerchandiseReturnsModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Items', includeIfNull: false)
    List<MerchandiseReturnModel>? items,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CustomerMerchandiseReturnsModelCopyWithImpl<
  $Res,
  $Val extends CustomerMerchandiseReturnsModel
>
    implements $CustomerMerchandiseReturnsModelCopyWith<$Res> {
  _$CustomerMerchandiseReturnsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerMerchandiseReturnsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = freezed, Object? userFields = freezed}) {
    return _then(
      _value.copyWith(
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<MerchandiseReturnModel>?,
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
abstract class _$$CustomerMerchandiseReturnsModelImplCopyWith<$Res>
    implements $CustomerMerchandiseReturnsModelCopyWith<$Res> {
  factory _$$CustomerMerchandiseReturnsModelImplCopyWith(
    _$CustomerMerchandiseReturnsModelImpl value,
    $Res Function(_$CustomerMerchandiseReturnsModelImpl) then,
  ) = __$$CustomerMerchandiseReturnsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Items', includeIfNull: false)
    List<MerchandiseReturnModel>? items,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CustomerMerchandiseReturnsModelImplCopyWithImpl<$Res>
    extends
        _$CustomerMerchandiseReturnsModelCopyWithImpl<
          $Res,
          _$CustomerMerchandiseReturnsModelImpl
        >
    implements _$$CustomerMerchandiseReturnsModelImplCopyWith<$Res> {
  __$$CustomerMerchandiseReturnsModelImplCopyWithImpl(
    _$CustomerMerchandiseReturnsModelImpl _value,
    $Res Function(_$CustomerMerchandiseReturnsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerMerchandiseReturnsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = freezed, Object? userFields = freezed}) {
    return _then(
      _$CustomerMerchandiseReturnsModelImpl(
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<MerchandiseReturnModel>?,
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
class _$CustomerMerchandiseReturnsModelImpl
    implements _CustomerMerchandiseReturnsModel {
  _$CustomerMerchandiseReturnsModelImpl({
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<MerchandiseReturnModel>? items = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _items = items,
       _userFields = userFields;

  factory _$CustomerMerchandiseReturnsModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CustomerMerchandiseReturnsModelImplFromJson(json);

  final List<MerchandiseReturnModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<MerchandiseReturnModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
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
    return 'CustomerMerchandiseReturnsModel(items: $items, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerMerchandiseReturnsModelImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CustomerMerchandiseReturnsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerMerchandiseReturnsModelImplCopyWith<
    _$CustomerMerchandiseReturnsModelImpl
  >
  get copyWith => __$$CustomerMerchandiseReturnsModelImplCopyWithImpl<
    _$CustomerMerchandiseReturnsModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerMerchandiseReturnsModelImplToJson(this);
  }
}

abstract class _CustomerMerchandiseReturnsModel
    implements CustomerMerchandiseReturnsModel {
  factory _CustomerMerchandiseReturnsModel({
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<MerchandiseReturnModel>? items,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerMerchandiseReturnsModelImpl;

  factory _CustomerMerchandiseReturnsModel.fromJson(Map<String, dynamic> json) =
      _$CustomerMerchandiseReturnsModelImpl.fromJson;

  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<MerchandiseReturnModel>? get items;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerMerchandiseReturnsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerMerchandiseReturnsModelImplCopyWith<
    _$CustomerMerchandiseReturnsModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
