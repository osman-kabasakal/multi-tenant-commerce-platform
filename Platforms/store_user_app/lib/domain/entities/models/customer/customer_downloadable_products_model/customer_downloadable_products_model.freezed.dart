// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_downloadable_products_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerDownloadableProductsModel _$CustomerDownloadableProductsModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerDownloadableProductsModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerDownloadableProductsModel {
  @JsonKey(name: 'Items', includeIfNull: false)
  List<DownloadableProductsModel>? get items =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerDownloadableProductsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerDownloadableProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerDownloadableProductsModelCopyWith<CustomerDownloadableProductsModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerDownloadableProductsModelCopyWith<$Res> {
  factory $CustomerDownloadableProductsModelCopyWith(
    CustomerDownloadableProductsModel value,
    $Res Function(CustomerDownloadableProductsModel) then,
  ) =
      _$CustomerDownloadableProductsModelCopyWithImpl<
        $Res,
        CustomerDownloadableProductsModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Items', includeIfNull: false)
    List<DownloadableProductsModel>? items,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CustomerDownloadableProductsModelCopyWithImpl<
  $Res,
  $Val extends CustomerDownloadableProductsModel
>
    implements $CustomerDownloadableProductsModelCopyWith<$Res> {
  _$CustomerDownloadableProductsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerDownloadableProductsModel
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
                        as List<DownloadableProductsModel>?,
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
abstract class _$$CustomerDownloadableProductsModelImplCopyWith<$Res>
    implements $CustomerDownloadableProductsModelCopyWith<$Res> {
  factory _$$CustomerDownloadableProductsModelImplCopyWith(
    _$CustomerDownloadableProductsModelImpl value,
    $Res Function(_$CustomerDownloadableProductsModelImpl) then,
  ) = __$$CustomerDownloadableProductsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Items', includeIfNull: false)
    List<DownloadableProductsModel>? items,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CustomerDownloadableProductsModelImplCopyWithImpl<$Res>
    extends
        _$CustomerDownloadableProductsModelCopyWithImpl<
          $Res,
          _$CustomerDownloadableProductsModelImpl
        >
    implements _$$CustomerDownloadableProductsModelImplCopyWith<$Res> {
  __$$CustomerDownloadableProductsModelImplCopyWithImpl(
    _$CustomerDownloadableProductsModelImpl _value,
    $Res Function(_$CustomerDownloadableProductsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerDownloadableProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = freezed, Object? userFields = freezed}) {
    return _then(
      _$CustomerDownloadableProductsModelImpl(
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<DownloadableProductsModel>?,
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
class _$CustomerDownloadableProductsModelImpl
    implements _CustomerDownloadableProductsModel {
  _$CustomerDownloadableProductsModelImpl({
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<DownloadableProductsModel>? items = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _items = items,
       _userFields = userFields;

  factory _$CustomerDownloadableProductsModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CustomerDownloadableProductsModelImplFromJson(json);

  final List<DownloadableProductsModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<DownloadableProductsModel>? get items {
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
    return 'CustomerDownloadableProductsModel(items: $items, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerDownloadableProductsModelImpl &&
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

  /// Create a copy of CustomerDownloadableProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerDownloadableProductsModelImplCopyWith<
    _$CustomerDownloadableProductsModelImpl
  >
  get copyWith => __$$CustomerDownloadableProductsModelImplCopyWithImpl<
    _$CustomerDownloadableProductsModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerDownloadableProductsModelImplToJson(this);
  }
}

abstract class _CustomerDownloadableProductsModel
    implements CustomerDownloadableProductsModel {
  factory _CustomerDownloadableProductsModel({
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<DownloadableProductsModel>? items,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerDownloadableProductsModelImpl;

  factory _CustomerDownloadableProductsModel.fromJson(
    Map<String, dynamic> json,
  ) = _$CustomerDownloadableProductsModelImpl.fromJson;

  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<DownloadableProductsModel>? get items;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerDownloadableProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerDownloadableProductsModelImplCopyWith<
    _$CustomerDownloadableProductsModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
