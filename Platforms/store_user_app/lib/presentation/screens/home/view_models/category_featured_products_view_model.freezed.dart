// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_featured_products_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CategoryFeaturedProductsViewModel {
  dynamic get selectedCategoryIndex => throw _privateConstructorUsedError;
  List<CategoryModel> get categories => throw _privateConstructorUsedError;
  List<ProductOverviewModel> get featuredProducts =>
      throw _privateConstructorUsedError;
  List<CategoryModel> get activeCategories =>
      throw _privateConstructorUsedError;

  /// Create a copy of CategoryFeaturedProductsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryFeaturedProductsViewModelCopyWith<CategoryFeaturedProductsViewModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryFeaturedProductsViewModelCopyWith<$Res> {
  factory $CategoryFeaturedProductsViewModelCopyWith(
    CategoryFeaturedProductsViewModel value,
    $Res Function(CategoryFeaturedProductsViewModel) then,
  ) =
      _$CategoryFeaturedProductsViewModelCopyWithImpl<
        $Res,
        CategoryFeaturedProductsViewModel
      >;
  @useResult
  $Res call({
    dynamic selectedCategoryIndex,
    List<CategoryModel> categories,
    List<ProductOverviewModel> featuredProducts,
    List<CategoryModel> activeCategories,
  });
}

/// @nodoc
class _$CategoryFeaturedProductsViewModelCopyWithImpl<
  $Res,
  $Val extends CategoryFeaturedProductsViewModel
>
    implements $CategoryFeaturedProductsViewModelCopyWith<$Res> {
  _$CategoryFeaturedProductsViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryFeaturedProductsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCategoryIndex = freezed,
    Object? categories = null,
    Object? featuredProducts = null,
    Object? activeCategories = null,
  }) {
    return _then(
      _value.copyWith(
            selectedCategoryIndex:
                freezed == selectedCategoryIndex
                    ? _value.selectedCategoryIndex
                    : selectedCategoryIndex // ignore: cast_nullable_to_non_nullable
                        as dynamic,
            categories:
                null == categories
                    ? _value.categories
                    : categories // ignore: cast_nullable_to_non_nullable
                        as List<CategoryModel>,
            featuredProducts:
                null == featuredProducts
                    ? _value.featuredProducts
                    : featuredProducts // ignore: cast_nullable_to_non_nullable
                        as List<ProductOverviewModel>,
            activeCategories:
                null == activeCategories
                    ? _value.activeCategories
                    : activeCategories // ignore: cast_nullable_to_non_nullable
                        as List<CategoryModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryFeaturedProductsViewModelImplCopyWith<$Res>
    implements $CategoryFeaturedProductsViewModelCopyWith<$Res> {
  factory _$$CategoryFeaturedProductsViewModelImplCopyWith(
    _$CategoryFeaturedProductsViewModelImpl value,
    $Res Function(_$CategoryFeaturedProductsViewModelImpl) then,
  ) = __$$CategoryFeaturedProductsViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    dynamic selectedCategoryIndex,
    List<CategoryModel> categories,
    List<ProductOverviewModel> featuredProducts,
    List<CategoryModel> activeCategories,
  });
}

/// @nodoc
class __$$CategoryFeaturedProductsViewModelImplCopyWithImpl<$Res>
    extends
        _$CategoryFeaturedProductsViewModelCopyWithImpl<
          $Res,
          _$CategoryFeaturedProductsViewModelImpl
        >
    implements _$$CategoryFeaturedProductsViewModelImplCopyWith<$Res> {
  __$$CategoryFeaturedProductsViewModelImplCopyWithImpl(
    _$CategoryFeaturedProductsViewModelImpl _value,
    $Res Function(_$CategoryFeaturedProductsViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryFeaturedProductsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCategoryIndex = freezed,
    Object? categories = null,
    Object? featuredProducts = null,
    Object? activeCategories = null,
  }) {
    return _then(
      _$CategoryFeaturedProductsViewModelImpl(
        selectedCategoryIndex:
            freezed == selectedCategoryIndex
                ? _value.selectedCategoryIndex!
                : selectedCategoryIndex,
        categories:
            null == categories
                ? _value._categories
                : categories // ignore: cast_nullable_to_non_nullable
                    as List<CategoryModel>,
        featuredProducts:
            null == featuredProducts
                ? _value._featuredProducts
                : featuredProducts // ignore: cast_nullable_to_non_nullable
                    as List<ProductOverviewModel>,
        activeCategories:
            null == activeCategories
                ? _value._activeCategories
                : activeCategories // ignore: cast_nullable_to_non_nullable
                    as List<CategoryModel>,
      ),
    );
  }
}

/// @nodoc

class _$CategoryFeaturedProductsViewModelImpl
    implements _CategoryFeaturedProductsViewModel {
  const _$CategoryFeaturedProductsViewModelImpl({
    this.selectedCategoryIndex = 0,
    final List<CategoryModel> categories = const [],
    final List<ProductOverviewModel> featuredProducts = const [],
    final List<CategoryModel> activeCategories = const [],
  }) : _categories = categories,
       _featuredProducts = featuredProducts,
       _activeCategories = activeCategories;

  @override
  @JsonKey()
  final dynamic selectedCategoryIndex;
  final List<CategoryModel> _categories;
  @override
  @JsonKey()
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<ProductOverviewModel> _featuredProducts;
  @override
  @JsonKey()
  List<ProductOverviewModel> get featuredProducts {
    if (_featuredProducts is EqualUnmodifiableListView)
      return _featuredProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_featuredProducts);
  }

  final List<CategoryModel> _activeCategories;
  @override
  @JsonKey()
  List<CategoryModel> get activeCategories {
    if (_activeCategories is EqualUnmodifiableListView)
      return _activeCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeCategories);
  }

  @override
  String toString() {
    return 'CategoryFeaturedProductsViewModel(selectedCategoryIndex: $selectedCategoryIndex, categories: $categories, featuredProducts: $featuredProducts, activeCategories: $activeCategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryFeaturedProductsViewModelImpl &&
            const DeepCollectionEquality().equals(
              other.selectedCategoryIndex,
              selectedCategoryIndex,
            ) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(
              other._featuredProducts,
              _featuredProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._activeCategories,
              _activeCategories,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(selectedCategoryIndex),
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_featuredProducts),
    const DeepCollectionEquality().hash(_activeCategories),
  );

  /// Create a copy of CategoryFeaturedProductsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryFeaturedProductsViewModelImplCopyWith<
    _$CategoryFeaturedProductsViewModelImpl
  >
  get copyWith => __$$CategoryFeaturedProductsViewModelImplCopyWithImpl<
    _$CategoryFeaturedProductsViewModelImpl
  >(this, _$identity);
}

abstract class _CategoryFeaturedProductsViewModel
    implements CategoryFeaturedProductsViewModel {
  const factory _CategoryFeaturedProductsViewModel({
    final dynamic selectedCategoryIndex,
    final List<CategoryModel> categories,
    final List<ProductOverviewModel> featuredProducts,
    final List<CategoryModel> activeCategories,
  }) = _$CategoryFeaturedProductsViewModelImpl;

  @override
  dynamic get selectedCategoryIndex;
  @override
  List<CategoryModel> get categories;
  @override
  List<ProductOverviewModel> get featuredProducts;
  @override
  List<CategoryModel> get activeCategories;

  /// Create a copy of CategoryFeaturedProductsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryFeaturedProductsViewModelImplCopyWith<
    _$CategoryFeaturedProductsViewModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
