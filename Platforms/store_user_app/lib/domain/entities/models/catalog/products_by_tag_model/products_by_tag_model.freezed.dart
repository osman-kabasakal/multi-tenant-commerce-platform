// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_by_tag_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductsByTagModel _$ProductsByTagModelFromJson(Map<String, dynamic> json) {
  return _ProductsByTagModel.fromJson(json);
}

/// @nodoc
mixin _$ProductsByTagModel {
  @JsonKey(name: 'TagName', includeIfNull: false)
  String? get tagName => throw _privateConstructorUsedError;
  @JsonKey(name: 'TagSeName', includeIfNull: false)
  String? get tagSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  CatalogPagingFilteringModel? get pagingFilteringContext =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductsByTagModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductsByTagModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductsByTagModelCopyWith<ProductsByTagModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductsByTagModelCopyWith<$Res> {
  factory $ProductsByTagModelCopyWith(
    ProductsByTagModel value,
    $Res Function(ProductsByTagModel) then,
  ) = _$ProductsByTagModelCopyWithImpl<$Res, ProductsByTagModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'TagName', includeIfNull: false) String? tagName,
    @JsonKey(name: 'TagSeName', includeIfNull: false) String? tagSeName,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
}

/// @nodoc
class _$ProductsByTagModelCopyWithImpl<$Res, $Val extends ProductsByTagModel>
    implements $ProductsByTagModelCopyWith<$Res> {
  _$ProductsByTagModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductsByTagModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagName = freezed,
    Object? tagSeName = freezed,
    Object? pagingFilteringContext = freezed,
    Object? products = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            tagName:
                freezed == tagName
                    ? _value.tagName
                    : tagName // ignore: cast_nullable_to_non_nullable
                        as String?,
            tagSeName:
                freezed == tagSeName
                    ? _value.tagSeName
                    : tagSeName // ignore: cast_nullable_to_non_nullable
                        as String?,
            pagingFilteringContext:
                freezed == pagingFilteringContext
                    ? _value.pagingFilteringContext
                    : pagingFilteringContext // ignore: cast_nullable_to_non_nullable
                        as CatalogPagingFilteringModel?,
            products:
                freezed == products
                    ? _value.products
                    : products // ignore: cast_nullable_to_non_nullable
                        as List<ProductOverviewModel>?,
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

  /// Create a copy of ProductsByTagModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext {
    if (_value.pagingFilteringContext == null) {
      return null;
    }

    return $CatalogPagingFilteringModelCopyWith<$Res>(
      _value.pagingFilteringContext!,
      (value) {
        return _then(_value.copyWith(pagingFilteringContext: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$ProductsByTagModelImplCopyWith<$Res>
    implements $ProductsByTagModelCopyWith<$Res> {
  factory _$$ProductsByTagModelImplCopyWith(
    _$ProductsByTagModelImpl value,
    $Res Function(_$ProductsByTagModelImpl) then,
  ) = __$$ProductsByTagModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'TagName', includeIfNull: false) String? tagName,
    @JsonKey(name: 'TagSeName', includeIfNull: false) String? tagSeName,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
}

/// @nodoc
class __$$ProductsByTagModelImplCopyWithImpl<$Res>
    extends _$ProductsByTagModelCopyWithImpl<$Res, _$ProductsByTagModelImpl>
    implements _$$ProductsByTagModelImplCopyWith<$Res> {
  __$$ProductsByTagModelImplCopyWithImpl(
    _$ProductsByTagModelImpl _value,
    $Res Function(_$ProductsByTagModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductsByTagModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagName = freezed,
    Object? tagSeName = freezed,
    Object? pagingFilteringContext = freezed,
    Object? products = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductsByTagModelImpl(
        tagName:
            freezed == tagName
                ? _value.tagName
                : tagName // ignore: cast_nullable_to_non_nullable
                    as String?,
        tagSeName:
            freezed == tagSeName
                ? _value.tagSeName
                : tagSeName // ignore: cast_nullable_to_non_nullable
                    as String?,
        pagingFilteringContext:
            freezed == pagingFilteringContext
                ? _value.pagingFilteringContext
                : pagingFilteringContext // ignore: cast_nullable_to_non_nullable
                    as CatalogPagingFilteringModel?,
        products:
            freezed == products
                ? _value._products
                : products // ignore: cast_nullable_to_non_nullable
                    as List<ProductOverviewModel>?,
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
class _$ProductsByTagModelImpl implements _ProductsByTagModel {
  _$ProductsByTagModelImpl({
    @JsonKey(name: 'TagName', includeIfNull: false) this.tagName,
    @JsonKey(name: 'TagSeName', includeIfNull: false) this.tagSeName,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    this.pagingFilteringContext,
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _products = products,
       _userFields = userFields;

  factory _$ProductsByTagModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductsByTagModelImplFromJson(json);

  @override
  @JsonKey(name: 'TagName', includeIfNull: false)
  final String? tagName;
  @override
  @JsonKey(name: 'TagSeName', includeIfNull: false)
  final String? tagSeName;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  final CatalogPagingFilteringModel? pagingFilteringContext;
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
    return 'ProductsByTagModel(tagName: $tagName, tagSeName: $tagSeName, pagingFilteringContext: $pagingFilteringContext, products: $products, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductsByTagModelImpl &&
            (identical(other.tagName, tagName) || other.tagName == tagName) &&
            (identical(other.tagSeName, tagSeName) ||
                other.tagSeName == tagSeName) &&
            (identical(other.pagingFilteringContext, pagingFilteringContext) ||
                other.pagingFilteringContext == pagingFilteringContext) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
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
    tagName,
    tagSeName,
    pagingFilteringContext,
    const DeepCollectionEquality().hash(_products),
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductsByTagModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductsByTagModelImplCopyWith<_$ProductsByTagModelImpl> get copyWith =>
      __$$ProductsByTagModelImplCopyWithImpl<_$ProductsByTagModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductsByTagModelImplToJson(this);
  }
}

abstract class _ProductsByTagModel implements ProductsByTagModel {
  factory _ProductsByTagModel({
    @JsonKey(name: 'TagName', includeIfNull: false) final String? tagName,
    @JsonKey(name: 'TagSeName', includeIfNull: false) final String? tagSeName,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    final CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductsByTagModelImpl;

  factory _ProductsByTagModel.fromJson(Map<String, dynamic> json) =
      _$ProductsByTagModelImpl.fromJson;

  @override
  @JsonKey(name: 'TagName', includeIfNull: false)
  String? get tagName;
  @override
  @JsonKey(name: 'TagSeName', includeIfNull: false)
  String? get tagSeName;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  CatalogPagingFilteringModel? get pagingFilteringContext;
  @override
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductsByTagModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductsByTagModelImplCopyWith<_$ProductsByTagModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
