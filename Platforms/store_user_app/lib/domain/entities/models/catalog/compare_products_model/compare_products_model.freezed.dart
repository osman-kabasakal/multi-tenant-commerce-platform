// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compare_products_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CompareProductsModel _$CompareProductsModelFromJson(Map<String, dynamic> json) {
  return _CompareProductsModel.fromJson(json);
}

/// @nodoc
mixin _$CompareProductsModel {
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products =>
      throw _privateConstructorUsedError;
  @JsonKey(
    name: 'IncludeShortDescriptionInCompareProducts',
    includeIfNull: false,
  )
  bool? get includeShortDescriptionInCompareProducts =>
      throw _privateConstructorUsedError;
  @JsonKey(
    name: 'IncludeFullDescriptionInCompareProducts',
    includeIfNull: false,
  )
  bool? get includeFullDescriptionInCompareProducts =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CompareProductsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompareProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompareProductsModelCopyWith<CompareProductsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompareProductsModelCopyWith<$Res> {
  factory $CompareProductsModelCopyWith(
    CompareProductsModel value,
    $Res Function(CompareProductsModel) then,
  ) = _$CompareProductsModelCopyWithImpl<$Res, CompareProductsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(
      name: 'IncludeShortDescriptionInCompareProducts',
      includeIfNull: false,
    )
    bool? includeShortDescriptionInCompareProducts,
    @JsonKey(
      name: 'IncludeFullDescriptionInCompareProducts',
      includeIfNull: false,
    )
    bool? includeFullDescriptionInCompareProducts,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CompareProductsModelCopyWithImpl<
  $Res,
  $Val extends CompareProductsModel
>
    implements $CompareProductsModelCopyWith<$Res> {
  _$CompareProductsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompareProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = freezed,
    Object? includeShortDescriptionInCompareProducts = freezed,
    Object? includeFullDescriptionInCompareProducts = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            products:
                freezed == products
                    ? _value.products
                    : products // ignore: cast_nullable_to_non_nullable
                        as List<ProductOverviewModel>?,
            includeShortDescriptionInCompareProducts:
                freezed == includeShortDescriptionInCompareProducts
                    ? _value.includeShortDescriptionInCompareProducts
                    : includeShortDescriptionInCompareProducts // ignore: cast_nullable_to_non_nullable
                        as bool?,
            includeFullDescriptionInCompareProducts:
                freezed == includeFullDescriptionInCompareProducts
                    ? _value.includeFullDescriptionInCompareProducts
                    : includeFullDescriptionInCompareProducts // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
abstract class _$$CompareProductsModelImplCopyWith<$Res>
    implements $CompareProductsModelCopyWith<$Res> {
  factory _$$CompareProductsModelImplCopyWith(
    _$CompareProductsModelImpl value,
    $Res Function(_$CompareProductsModelImpl) then,
  ) = __$$CompareProductsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(
      name: 'IncludeShortDescriptionInCompareProducts',
      includeIfNull: false,
    )
    bool? includeShortDescriptionInCompareProducts,
    @JsonKey(
      name: 'IncludeFullDescriptionInCompareProducts',
      includeIfNull: false,
    )
    bool? includeFullDescriptionInCompareProducts,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CompareProductsModelImplCopyWithImpl<$Res>
    extends _$CompareProductsModelCopyWithImpl<$Res, _$CompareProductsModelImpl>
    implements _$$CompareProductsModelImplCopyWith<$Res> {
  __$$CompareProductsModelImplCopyWithImpl(
    _$CompareProductsModelImpl _value,
    $Res Function(_$CompareProductsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompareProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = freezed,
    Object? includeShortDescriptionInCompareProducts = freezed,
    Object? includeFullDescriptionInCompareProducts = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CompareProductsModelImpl(
        products:
            freezed == products
                ? _value._products
                : products // ignore: cast_nullable_to_non_nullable
                    as List<ProductOverviewModel>?,
        includeShortDescriptionInCompareProducts:
            freezed == includeShortDescriptionInCompareProducts
                ? _value.includeShortDescriptionInCompareProducts
                : includeShortDescriptionInCompareProducts // ignore: cast_nullable_to_non_nullable
                    as bool?,
        includeFullDescriptionInCompareProducts:
            freezed == includeFullDescriptionInCompareProducts
                ? _value.includeFullDescriptionInCompareProducts
                : includeFullDescriptionInCompareProducts // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$CompareProductsModelImpl implements _CompareProductsModel {
  _$CompareProductsModelImpl({
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products = const [],
    @JsonKey(
      name: 'IncludeShortDescriptionInCompareProducts',
      includeIfNull: false,
    )
    this.includeShortDescriptionInCompareProducts = false,
    @JsonKey(
      name: 'IncludeFullDescriptionInCompareProducts',
      includeIfNull: false,
    )
    this.includeFullDescriptionInCompareProducts = false,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _products = products,
       _userFields = userFields;

  factory _$CompareProductsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompareProductsModelImplFromJson(json);

  final List<ProductOverviewModel>? _products;
  @override
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products {
    final value = _products;
    if (value == null) return null;
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(
    name: 'IncludeShortDescriptionInCompareProducts',
    includeIfNull: false,
  )
  final bool? includeShortDescriptionInCompareProducts;
  @override
  @JsonKey(
    name: 'IncludeFullDescriptionInCompareProducts',
    includeIfNull: false,
  )
  final bool? includeFullDescriptionInCompareProducts;
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
    return 'CompareProductsModel(products: $products, includeShortDescriptionInCompareProducts: $includeShortDescriptionInCompareProducts, includeFullDescriptionInCompareProducts: $includeFullDescriptionInCompareProducts, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompareProductsModelImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(
                  other.includeShortDescriptionInCompareProducts,
                  includeShortDescriptionInCompareProducts,
                ) ||
                other.includeShortDescriptionInCompareProducts ==
                    includeShortDescriptionInCompareProducts) &&
            (identical(
                  other.includeFullDescriptionInCompareProducts,
                  includeFullDescriptionInCompareProducts,
                ) ||
                other.includeFullDescriptionInCompareProducts ==
                    includeFullDescriptionInCompareProducts) &&
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
    const DeepCollectionEquality().hash(_products),
    includeShortDescriptionInCompareProducts,
    includeFullDescriptionInCompareProducts,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CompareProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompareProductsModelImplCopyWith<_$CompareProductsModelImpl>
  get copyWith =>
      __$$CompareProductsModelImplCopyWithImpl<_$CompareProductsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompareProductsModelImplToJson(this);
  }
}

abstract class _CompareProductsModel implements CompareProductsModel {
  factory _CompareProductsModel({
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products,
    @JsonKey(
      name: 'IncludeShortDescriptionInCompareProducts',
      includeIfNull: false,
    )
    final bool? includeShortDescriptionInCompareProducts,
    @JsonKey(
      name: 'IncludeFullDescriptionInCompareProducts',
      includeIfNull: false,
    )
    final bool? includeFullDescriptionInCompareProducts,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CompareProductsModelImpl;

  factory _CompareProductsModel.fromJson(Map<String, dynamic> json) =
      _$CompareProductsModelImpl.fromJson;

  @override
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products;
  @override
  @JsonKey(
    name: 'IncludeShortDescriptionInCompareProducts',
    includeIfNull: false,
  )
  bool? get includeShortDescriptionInCompareProducts;
  @override
  @JsonKey(
    name: 'IncludeFullDescriptionInCompareProducts',
    includeIfNull: false,
  )
  bool? get includeFullDescriptionInCompareProducts;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CompareProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompareProductsModelImplCopyWith<_$CompareProductsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
