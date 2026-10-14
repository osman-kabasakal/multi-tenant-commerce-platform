// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CatalogState {
  List<ProductOverviewModel> get products => throw _privateConstructorUsedError;
  List<CategoryModel> get categories => throw _privateConstructorUsedError;
  List<BrandModel> get brands => throw _privateConstructorUsedError;
  List<CollectionModel> get collections => throw _privateConstructorUsedError;
  List<VendorModel> get vendors => throw _privateConstructorUsedError;
  FilterState get filter => throw _privateConstructorUsedError;
  ProductViewType get viewType => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get totalProducts => throw _privateConstructorUsedError;

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogStateCopyWith<CatalogState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogStateCopyWith<$Res> {
  factory $CatalogStateCopyWith(
    CatalogState value,
    $Res Function(CatalogState) then,
  ) = _$CatalogStateCopyWithImpl<$Res, CatalogState>;
  @useResult
  $Res call({
    List<ProductOverviewModel> products,
    List<CategoryModel> categories,
    List<BrandModel> brands,
    List<CollectionModel> collections,
    List<VendorModel> vendors,
    FilterState filter,
    ProductViewType viewType,
    bool isLoading,
    bool hasMore,
    String? error,
    int totalProducts,
  });

  $FilterStateCopyWith<$Res> get filter;
}

/// @nodoc
class _$CatalogStateCopyWithImpl<$Res, $Val extends CatalogState>
    implements $CatalogStateCopyWith<$Res> {
  _$CatalogStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? categories = null,
    Object? brands = null,
    Object? collections = null,
    Object? vendors = null,
    Object? filter = null,
    Object? viewType = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? error = freezed,
    Object? totalProducts = null,
  }) {
    return _then(
      _value.copyWith(
            products:
                null == products
                    ? _value.products
                    : products // ignore: cast_nullable_to_non_nullable
                        as List<ProductOverviewModel>,
            categories:
                null == categories
                    ? _value.categories
                    : categories // ignore: cast_nullable_to_non_nullable
                        as List<CategoryModel>,
            brands:
                null == brands
                    ? _value.brands
                    : brands // ignore: cast_nullable_to_non_nullable
                        as List<BrandModel>,
            collections:
                null == collections
                    ? _value.collections
                    : collections // ignore: cast_nullable_to_non_nullable
                        as List<CollectionModel>,
            vendors:
                null == vendors
                    ? _value.vendors
                    : vendors // ignore: cast_nullable_to_non_nullable
                        as List<VendorModel>,
            filter:
                null == filter
                    ? _value.filter
                    : filter // ignore: cast_nullable_to_non_nullable
                        as FilterState,
            viewType:
                null == viewType
                    ? _value.viewType
                    : viewType // ignore: cast_nullable_to_non_nullable
                        as ProductViewType,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            hasMore:
                null == hasMore
                    ? _value.hasMore
                    : hasMore // ignore: cast_nullable_to_non_nullable
                        as bool,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            totalProducts:
                null == totalProducts
                    ? _value.totalProducts
                    : totalProducts // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FilterStateCopyWith<$Res> get filter {
    return $FilterStateCopyWith<$Res>(_value.filter, (value) {
      return _then(_value.copyWith(filter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CatalogStateImplCopyWith<$Res>
    implements $CatalogStateCopyWith<$Res> {
  factory _$$CatalogStateImplCopyWith(
    _$CatalogStateImpl value,
    $Res Function(_$CatalogStateImpl) then,
  ) = __$$CatalogStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ProductOverviewModel> products,
    List<CategoryModel> categories,
    List<BrandModel> brands,
    List<CollectionModel> collections,
    List<VendorModel> vendors,
    FilterState filter,
    ProductViewType viewType,
    bool isLoading,
    bool hasMore,
    String? error,
    int totalProducts,
  });

  @override
  $FilterStateCopyWith<$Res> get filter;
}

/// @nodoc
class __$$CatalogStateImplCopyWithImpl<$Res>
    extends _$CatalogStateCopyWithImpl<$Res, _$CatalogStateImpl>
    implements _$$CatalogStateImplCopyWith<$Res> {
  __$$CatalogStateImplCopyWithImpl(
    _$CatalogStateImpl _value,
    $Res Function(_$CatalogStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? categories = null,
    Object? brands = null,
    Object? collections = null,
    Object? vendors = null,
    Object? filter = null,
    Object? viewType = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? error = freezed,
    Object? totalProducts = null,
  }) {
    return _then(
      _$CatalogStateImpl(
        products:
            null == products
                ? _value._products
                : products // ignore: cast_nullable_to_non_nullable
                    as List<ProductOverviewModel>,
        categories:
            null == categories
                ? _value._categories
                : categories // ignore: cast_nullable_to_non_nullable
                    as List<CategoryModel>,
        brands:
            null == brands
                ? _value._brands
                : brands // ignore: cast_nullable_to_non_nullable
                    as List<BrandModel>,
        collections:
            null == collections
                ? _value._collections
                : collections // ignore: cast_nullable_to_non_nullable
                    as List<CollectionModel>,
        vendors:
            null == vendors
                ? _value._vendors
                : vendors // ignore: cast_nullable_to_non_nullable
                    as List<VendorModel>,
        filter:
            null == filter
                ? _value.filter
                : filter // ignore: cast_nullable_to_non_nullable
                    as FilterState,
        viewType:
            null == viewType
                ? _value.viewType
                : viewType // ignore: cast_nullable_to_non_nullable
                    as ProductViewType,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        hasMore:
            null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                    as bool,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        totalProducts:
            null == totalProducts
                ? _value.totalProducts
                : totalProducts // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc

class _$CatalogStateImpl extends _CatalogState {
  const _$CatalogStateImpl({
    final List<ProductOverviewModel> products = const [],
    final List<CategoryModel> categories = const [],
    final List<BrandModel> brands = const [],
    final List<CollectionModel> collections = const [],
    final List<VendorModel> vendors = const [],
    this.filter = const FilterState(),
    this.viewType = ProductViewType.list,
    this.isLoading = false,
    this.hasMore = false,
    this.error,
    this.totalProducts = 0,
  }) : _products = products,
       _categories = categories,
       _brands = brands,
       _collections = collections,
       _vendors = vendors,
       super._();

  final List<ProductOverviewModel> _products;
  @override
  @JsonKey()
  List<ProductOverviewModel> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  final List<CategoryModel> _categories;
  @override
  @JsonKey()
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<BrandModel> _brands;
  @override
  @JsonKey()
  List<BrandModel> get brands {
    if (_brands is EqualUnmodifiableListView) return _brands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_brands);
  }

  final List<CollectionModel> _collections;
  @override
  @JsonKey()
  List<CollectionModel> get collections {
    if (_collections is EqualUnmodifiableListView) return _collections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_collections);
  }

  final List<VendorModel> _vendors;
  @override
  @JsonKey()
  List<VendorModel> get vendors {
    if (_vendors is EqualUnmodifiableListView) return _vendors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vendors);
  }

  @override
  @JsonKey()
  final FilterState filter;
  @override
  @JsonKey()
  final ProductViewType viewType;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  final String? error;
  @override
  @JsonKey()
  final int totalProducts;

  @override
  String toString() {
    return 'CatalogState(products: $products, categories: $categories, brands: $brands, collections: $collections, vendors: $vendors, filter: $filter, viewType: $viewType, isLoading: $isLoading, hasMore: $hasMore, error: $error, totalProducts: $totalProducts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogStateImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(other._brands, _brands) &&
            const DeepCollectionEquality().equals(
              other._collections,
              _collections,
            ) &&
            const DeepCollectionEquality().equals(other._vendors, _vendors) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.viewType, viewType) ||
                other.viewType == viewType) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_products),
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_brands),
    const DeepCollectionEquality().hash(_collections),
    const DeepCollectionEquality().hash(_vendors),
    filter,
    viewType,
    isLoading,
    hasMore,
    error,
    totalProducts,
  );

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogStateImplCopyWith<_$CatalogStateImpl> get copyWith =>
      __$$CatalogStateImplCopyWithImpl<_$CatalogStateImpl>(this, _$identity);
}

abstract class _CatalogState extends CatalogState {
  const factory _CatalogState({
    final List<ProductOverviewModel> products,
    final List<CategoryModel> categories,
    final List<BrandModel> brands,
    final List<CollectionModel> collections,
    final List<VendorModel> vendors,
    final FilterState filter,
    final ProductViewType viewType,
    final bool isLoading,
    final bool hasMore,
    final String? error,
    final int totalProducts,
  }) = _$CatalogStateImpl;
  const _CatalogState._() : super._();

  @override
  List<ProductOverviewModel> get products;
  @override
  List<CategoryModel> get categories;
  @override
  List<BrandModel> get brands;
  @override
  List<CollectionModel> get collections;
  @override
  List<VendorModel> get vendors;
  @override
  FilterState get filter;
  @override
  ProductViewType get viewType;
  @override
  bool get isLoading;
  @override
  bool get hasMore;
  @override
  String? get error;
  @override
  int get totalProducts;

  /// Create a copy of CatalogState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogStateImplCopyWith<_$CatalogStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
