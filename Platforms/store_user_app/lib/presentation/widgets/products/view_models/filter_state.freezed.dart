// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FilterState {
  String get query => throw _privateConstructorUsedError;
  String? get selectedCategory => throw _privateConstructorUsedError;
  CategoryModel? get selectedCategoryModel =>
      throw _privateConstructorUsedError;
  String? get selectedCollectionId => throw _privateConstructorUsedError;
  double? get maxPrice => throw _privateConstructorUsedError;
  double? get minPrice => throw _privateConstructorUsedError;
  bool get attributeFilterEnbaled => throw _privateConstructorUsedError;
  List<String> get attributeFilters => throw _privateConstructorUsedError;
  List<SpecificationFilterItem> get alreadyFilteredItems =>
      throw _privateConstructorUsedError;
  List<SpecificationFilterItem> get notFilteredItems =>
      throw _privateConstructorUsedError;
  List<SelectListItem> get availableCategories =>
      throw _privateConstructorUsedError;
  List<CategoryModel> get allCategories => throw _privateConstructorUsedError;
  List<SelectListItem> get availableCollections =>
      throw _privateConstructorUsedError;
  List<SelectListItem> get availableVendors =>
      throw _privateConstructorUsedError;
  List<SelectListItem> get ratingOptions => throw _privateConstructorUsedError;
  bool get sortOptionEnabled => throw _privateConstructorUsedError;
  List<SelectListItem> get availableSortOptions =>
      throw _privateConstructorUsedError;
  int get orderBy => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  ShippingFilterType get shippingFilter => throw _privateConstructorUsedError;
  String? get vendorId => throw _privateConstructorUsedError;
  bool get priceFilterEnebale => throw _privateConstructorUsedError;
  CatalogPagingFilteringModel? get pagingFilterModel =>
      throw _privateConstructorUsedError;

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilterStateCopyWith<FilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterStateCopyWith<$Res> {
  factory $FilterStateCopyWith(
    FilterState value,
    $Res Function(FilterState) then,
  ) = _$FilterStateCopyWithImpl<$Res, FilterState>;
  @useResult
  $Res call({
    String query,
    String? selectedCategory,
    CategoryModel? selectedCategoryModel,
    String? selectedCollectionId,
    double? maxPrice,
    double? minPrice,
    bool attributeFilterEnbaled,
    List<String> attributeFilters,
    List<SpecificationFilterItem> alreadyFilteredItems,
    List<SpecificationFilterItem> notFilteredItems,
    List<SelectListItem> availableCategories,
    List<CategoryModel> allCategories,
    List<SelectListItem> availableCollections,
    List<SelectListItem> availableVendors,
    List<SelectListItem> ratingOptions,
    bool sortOptionEnabled,
    List<SelectListItem> availableSortOptions,
    int orderBy,
    double? rating,
    ShippingFilterType shippingFilter,
    String? vendorId,
    bool priceFilterEnebale,
    CatalogPagingFilteringModel? pagingFilterModel,
  });

  $CategoryModelCopyWith<$Res>? get selectedCategoryModel;
  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilterModel;
}

/// @nodoc
class _$FilterStateCopyWithImpl<$Res, $Val extends FilterState>
    implements $FilterStateCopyWith<$Res> {
  _$FilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? selectedCategory = freezed,
    Object? selectedCategoryModel = freezed,
    Object? selectedCollectionId = freezed,
    Object? maxPrice = freezed,
    Object? minPrice = freezed,
    Object? attributeFilterEnbaled = null,
    Object? attributeFilters = null,
    Object? alreadyFilteredItems = null,
    Object? notFilteredItems = null,
    Object? availableCategories = null,
    Object? allCategories = null,
    Object? availableCollections = null,
    Object? availableVendors = null,
    Object? ratingOptions = null,
    Object? sortOptionEnabled = null,
    Object? availableSortOptions = null,
    Object? orderBy = null,
    Object? rating = freezed,
    Object? shippingFilter = null,
    Object? vendorId = freezed,
    Object? priceFilterEnebale = null,
    Object? pagingFilterModel = freezed,
  }) {
    return _then(
      _value.copyWith(
            query:
                null == query
                    ? _value.query
                    : query // ignore: cast_nullable_to_non_nullable
                        as String,
            selectedCategory:
                freezed == selectedCategory
                    ? _value.selectedCategory
                    : selectedCategory // ignore: cast_nullable_to_non_nullable
                        as String?,
            selectedCategoryModel:
                freezed == selectedCategoryModel
                    ? _value.selectedCategoryModel
                    : selectedCategoryModel // ignore: cast_nullable_to_non_nullable
                        as CategoryModel?,
            selectedCollectionId:
                freezed == selectedCollectionId
                    ? _value.selectedCollectionId
                    : selectedCollectionId // ignore: cast_nullable_to_non_nullable
                        as String?,
            maxPrice:
                freezed == maxPrice
                    ? _value.maxPrice
                    : maxPrice // ignore: cast_nullable_to_non_nullable
                        as double?,
            minPrice:
                freezed == minPrice
                    ? _value.minPrice
                    : minPrice // ignore: cast_nullable_to_non_nullable
                        as double?,
            attributeFilterEnbaled:
                null == attributeFilterEnbaled
                    ? _value.attributeFilterEnbaled
                    : attributeFilterEnbaled // ignore: cast_nullable_to_non_nullable
                        as bool,
            attributeFilters:
                null == attributeFilters
                    ? _value.attributeFilters
                    : attributeFilters // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            alreadyFilteredItems:
                null == alreadyFilteredItems
                    ? _value.alreadyFilteredItems
                    : alreadyFilteredItems // ignore: cast_nullable_to_non_nullable
                        as List<SpecificationFilterItem>,
            notFilteredItems:
                null == notFilteredItems
                    ? _value.notFilteredItems
                    : notFilteredItems // ignore: cast_nullable_to_non_nullable
                        as List<SpecificationFilterItem>,
            availableCategories:
                null == availableCategories
                    ? _value.availableCategories
                    : availableCategories // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>,
            allCategories:
                null == allCategories
                    ? _value.allCategories
                    : allCategories // ignore: cast_nullable_to_non_nullable
                        as List<CategoryModel>,
            availableCollections:
                null == availableCollections
                    ? _value.availableCollections
                    : availableCollections // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>,
            availableVendors:
                null == availableVendors
                    ? _value.availableVendors
                    : availableVendors // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>,
            ratingOptions:
                null == ratingOptions
                    ? _value.ratingOptions
                    : ratingOptions // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>,
            sortOptionEnabled:
                null == sortOptionEnabled
                    ? _value.sortOptionEnabled
                    : sortOptionEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            availableSortOptions:
                null == availableSortOptions
                    ? _value.availableSortOptions
                    : availableSortOptions // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>,
            orderBy:
                null == orderBy
                    ? _value.orderBy
                    : orderBy // ignore: cast_nullable_to_non_nullable
                        as int,
            rating:
                freezed == rating
                    ? _value.rating
                    : rating // ignore: cast_nullable_to_non_nullable
                        as double?,
            shippingFilter:
                null == shippingFilter
                    ? _value.shippingFilter
                    : shippingFilter // ignore: cast_nullable_to_non_nullable
                        as ShippingFilterType,
            vendorId:
                freezed == vendorId
                    ? _value.vendorId
                    : vendorId // ignore: cast_nullable_to_non_nullable
                        as String?,
            priceFilterEnebale:
                null == priceFilterEnebale
                    ? _value.priceFilterEnebale
                    : priceFilterEnebale // ignore: cast_nullable_to_non_nullable
                        as bool,
            pagingFilterModel:
                freezed == pagingFilterModel
                    ? _value.pagingFilterModel
                    : pagingFilterModel // ignore: cast_nullable_to_non_nullable
                        as CatalogPagingFilteringModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<$Res>? get selectedCategoryModel {
    if (_value.selectedCategoryModel == null) {
      return null;
    }

    return $CategoryModelCopyWith<$Res>(_value.selectedCategoryModel!, (value) {
      return _then(_value.copyWith(selectedCategoryModel: value) as $Val);
    });
  }

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilterModel {
    if (_value.pagingFilterModel == null) {
      return null;
    }

    return $CatalogPagingFilteringModelCopyWith<$Res>(
      _value.pagingFilterModel!,
      (value) {
        return _then(_value.copyWith(pagingFilterModel: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$FilterStateImplCopyWith<$Res>
    implements $FilterStateCopyWith<$Res> {
  factory _$$FilterStateImplCopyWith(
    _$FilterStateImpl value,
    $Res Function(_$FilterStateImpl) then,
  ) = __$$FilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String query,
    String? selectedCategory,
    CategoryModel? selectedCategoryModel,
    String? selectedCollectionId,
    double? maxPrice,
    double? minPrice,
    bool attributeFilterEnbaled,
    List<String> attributeFilters,
    List<SpecificationFilterItem> alreadyFilteredItems,
    List<SpecificationFilterItem> notFilteredItems,
    List<SelectListItem> availableCategories,
    List<CategoryModel> allCategories,
    List<SelectListItem> availableCollections,
    List<SelectListItem> availableVendors,
    List<SelectListItem> ratingOptions,
    bool sortOptionEnabled,
    List<SelectListItem> availableSortOptions,
    int orderBy,
    double? rating,
    ShippingFilterType shippingFilter,
    String? vendorId,
    bool priceFilterEnebale,
    CatalogPagingFilteringModel? pagingFilterModel,
  });

  @override
  $CategoryModelCopyWith<$Res>? get selectedCategoryModel;
  @override
  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilterModel;
}

/// @nodoc
class __$$FilterStateImplCopyWithImpl<$Res>
    extends _$FilterStateCopyWithImpl<$Res, _$FilterStateImpl>
    implements _$$FilterStateImplCopyWith<$Res> {
  __$$FilterStateImplCopyWithImpl(
    _$FilterStateImpl _value,
    $Res Function(_$FilterStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? selectedCategory = freezed,
    Object? selectedCategoryModel = freezed,
    Object? selectedCollectionId = freezed,
    Object? maxPrice = freezed,
    Object? minPrice = freezed,
    Object? attributeFilterEnbaled = null,
    Object? attributeFilters = null,
    Object? alreadyFilteredItems = null,
    Object? notFilteredItems = null,
    Object? availableCategories = null,
    Object? allCategories = null,
    Object? availableCollections = null,
    Object? availableVendors = null,
    Object? ratingOptions = null,
    Object? sortOptionEnabled = null,
    Object? availableSortOptions = null,
    Object? orderBy = null,
    Object? rating = freezed,
    Object? shippingFilter = null,
    Object? vendorId = freezed,
    Object? priceFilterEnebale = null,
    Object? pagingFilterModel = freezed,
  }) {
    return _then(
      _$FilterStateImpl(
        query:
            null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                    as String,
        selectedCategory:
            freezed == selectedCategory
                ? _value.selectedCategory
                : selectedCategory // ignore: cast_nullable_to_non_nullable
                    as String?,
        selectedCategoryModel:
            freezed == selectedCategoryModel
                ? _value.selectedCategoryModel
                : selectedCategoryModel // ignore: cast_nullable_to_non_nullable
                    as CategoryModel?,
        selectedCollectionId:
            freezed == selectedCollectionId
                ? _value.selectedCollectionId
                : selectedCollectionId // ignore: cast_nullable_to_non_nullable
                    as String?,
        maxPrice:
            freezed == maxPrice
                ? _value.maxPrice
                : maxPrice // ignore: cast_nullable_to_non_nullable
                    as double?,
        minPrice:
            freezed == minPrice
                ? _value.minPrice
                : minPrice // ignore: cast_nullable_to_non_nullable
                    as double?,
        attributeFilterEnbaled:
            null == attributeFilterEnbaled
                ? _value.attributeFilterEnbaled
                : attributeFilterEnbaled // ignore: cast_nullable_to_non_nullable
                    as bool,
        attributeFilters:
            null == attributeFilters
                ? _value._attributeFilters
                : attributeFilters // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        alreadyFilteredItems:
            null == alreadyFilteredItems
                ? _value._alreadyFilteredItems
                : alreadyFilteredItems // ignore: cast_nullable_to_non_nullable
                    as List<SpecificationFilterItem>,
        notFilteredItems:
            null == notFilteredItems
                ? _value._notFilteredItems
                : notFilteredItems // ignore: cast_nullable_to_non_nullable
                    as List<SpecificationFilterItem>,
        availableCategories:
            null == availableCategories
                ? _value._availableCategories
                : availableCategories // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>,
        allCategories:
            null == allCategories
                ? _value._allCategories
                : allCategories // ignore: cast_nullable_to_non_nullable
                    as List<CategoryModel>,
        availableCollections:
            null == availableCollections
                ? _value._availableCollections
                : availableCollections // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>,
        availableVendors:
            null == availableVendors
                ? _value._availableVendors
                : availableVendors // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>,
        ratingOptions:
            null == ratingOptions
                ? _value._ratingOptions
                : ratingOptions // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>,
        sortOptionEnabled:
            null == sortOptionEnabled
                ? _value.sortOptionEnabled
                : sortOptionEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        availableSortOptions:
            null == availableSortOptions
                ? _value._availableSortOptions
                : availableSortOptions // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>,
        orderBy:
            null == orderBy
                ? _value.orderBy
                : orderBy // ignore: cast_nullable_to_non_nullable
                    as int,
        rating:
            freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                    as double?,
        shippingFilter:
            null == shippingFilter
                ? _value.shippingFilter
                : shippingFilter // ignore: cast_nullable_to_non_nullable
                    as ShippingFilterType,
        vendorId:
            freezed == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                    as String?,
        priceFilterEnebale:
            null == priceFilterEnebale
                ? _value.priceFilterEnebale
                : priceFilterEnebale // ignore: cast_nullable_to_non_nullable
                    as bool,
        pagingFilterModel:
            freezed == pagingFilterModel
                ? _value.pagingFilterModel
                : pagingFilterModel // ignore: cast_nullable_to_non_nullable
                    as CatalogPagingFilteringModel?,
      ),
    );
  }
}

/// @nodoc

class _$FilterStateImpl implements _FilterState {
  const _$FilterStateImpl({
    this.query = '',
    this.selectedCategory = null,
    this.selectedCategoryModel = null,
    this.selectedCollectionId = null,
    this.maxPrice = null,
    this.minPrice = null,
    this.attributeFilterEnbaled = true,
    final List<String> attributeFilters = const [],
    final List<SpecificationFilterItem> alreadyFilteredItems = const [],
    final List<SpecificationFilterItem> notFilteredItems = const [],
    final List<SelectListItem> availableCategories = const [],
    final List<CategoryModel> allCategories = const [],
    final List<SelectListItem> availableCollections = const [],
    final List<SelectListItem> availableVendors = const [],
    final List<SelectListItem> ratingOptions = const [],
    this.sortOptionEnabled = false,
    final List<SelectListItem> availableSortOptions = const [],
    this.orderBy = 0,
    this.rating = null,
    this.shippingFilter = ShippingFilterType.all,
    this.vendorId = null,
    this.priceFilterEnebale = true,
    this.pagingFilterModel = null,
  }) : _attributeFilters = attributeFilters,
       _alreadyFilteredItems = alreadyFilteredItems,
       _notFilteredItems = notFilteredItems,
       _availableCategories = availableCategories,
       _allCategories = allCategories,
       _availableCollections = availableCollections,
       _availableVendors = availableVendors,
       _ratingOptions = ratingOptions,
       _availableSortOptions = availableSortOptions;

  @override
  @JsonKey()
  final String query;
  @override
  @JsonKey()
  final String? selectedCategory;
  @override
  @JsonKey()
  final CategoryModel? selectedCategoryModel;
  @override
  @JsonKey()
  final String? selectedCollectionId;
  @override
  @JsonKey()
  final double? maxPrice;
  @override
  @JsonKey()
  final double? minPrice;
  @override
  @JsonKey()
  final bool attributeFilterEnbaled;
  final List<String> _attributeFilters;
  @override
  @JsonKey()
  List<String> get attributeFilters {
    if (_attributeFilters is EqualUnmodifiableListView)
      return _attributeFilters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attributeFilters);
  }

  final List<SpecificationFilterItem> _alreadyFilteredItems;
  @override
  @JsonKey()
  List<SpecificationFilterItem> get alreadyFilteredItems {
    if (_alreadyFilteredItems is EqualUnmodifiableListView)
      return _alreadyFilteredItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alreadyFilteredItems);
  }

  final List<SpecificationFilterItem> _notFilteredItems;
  @override
  @JsonKey()
  List<SpecificationFilterItem> get notFilteredItems {
    if (_notFilteredItems is EqualUnmodifiableListView)
      return _notFilteredItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notFilteredItems);
  }

  final List<SelectListItem> _availableCategories;
  @override
  @JsonKey()
  List<SelectListItem> get availableCategories {
    if (_availableCategories is EqualUnmodifiableListView)
      return _availableCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableCategories);
  }

  final List<CategoryModel> _allCategories;
  @override
  @JsonKey()
  List<CategoryModel> get allCategories {
    if (_allCategories is EqualUnmodifiableListView) return _allCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allCategories);
  }

  final List<SelectListItem> _availableCollections;
  @override
  @JsonKey()
  List<SelectListItem> get availableCollections {
    if (_availableCollections is EqualUnmodifiableListView)
      return _availableCollections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableCollections);
  }

  final List<SelectListItem> _availableVendors;
  @override
  @JsonKey()
  List<SelectListItem> get availableVendors {
    if (_availableVendors is EqualUnmodifiableListView)
      return _availableVendors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableVendors);
  }

  final List<SelectListItem> _ratingOptions;
  @override
  @JsonKey()
  List<SelectListItem> get ratingOptions {
    if (_ratingOptions is EqualUnmodifiableListView) return _ratingOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ratingOptions);
  }

  @override
  @JsonKey()
  final bool sortOptionEnabled;
  final List<SelectListItem> _availableSortOptions;
  @override
  @JsonKey()
  List<SelectListItem> get availableSortOptions {
    if (_availableSortOptions is EqualUnmodifiableListView)
      return _availableSortOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableSortOptions);
  }

  @override
  @JsonKey()
  final int orderBy;
  @override
  @JsonKey()
  final double? rating;
  @override
  @JsonKey()
  final ShippingFilterType shippingFilter;
  @override
  @JsonKey()
  final String? vendorId;
  @override
  @JsonKey()
  final bool priceFilterEnebale;
  @override
  @JsonKey()
  final CatalogPagingFilteringModel? pagingFilterModel;

  @override
  String toString() {
    return 'FilterState(query: $query, selectedCategory: $selectedCategory, selectedCategoryModel: $selectedCategoryModel, selectedCollectionId: $selectedCollectionId, maxPrice: $maxPrice, minPrice: $minPrice, attributeFilterEnbaled: $attributeFilterEnbaled, attributeFilters: $attributeFilters, alreadyFilteredItems: $alreadyFilteredItems, notFilteredItems: $notFilteredItems, availableCategories: $availableCategories, allCategories: $allCategories, availableCollections: $availableCollections, availableVendors: $availableVendors, ratingOptions: $ratingOptions, sortOptionEnabled: $sortOptionEnabled, availableSortOptions: $availableSortOptions, orderBy: $orderBy, rating: $rating, shippingFilter: $shippingFilter, vendorId: $vendorId, priceFilterEnebale: $priceFilterEnebale, pagingFilterModel: $pagingFilterModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterStateImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedCategoryModel, selectedCategoryModel) ||
                other.selectedCategoryModel == selectedCategoryModel) &&
            (identical(other.selectedCollectionId, selectedCollectionId) ||
                other.selectedCollectionId == selectedCollectionId) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.attributeFilterEnbaled, attributeFilterEnbaled) ||
                other.attributeFilterEnbaled == attributeFilterEnbaled) &&
            const DeepCollectionEquality().equals(
              other._attributeFilters,
              _attributeFilters,
            ) &&
            const DeepCollectionEquality().equals(
              other._alreadyFilteredItems,
              _alreadyFilteredItems,
            ) &&
            const DeepCollectionEquality().equals(
              other._notFilteredItems,
              _notFilteredItems,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableCategories,
              _availableCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._allCategories,
              _allCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableCollections,
              _availableCollections,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableVendors,
              _availableVendors,
            ) &&
            const DeepCollectionEquality().equals(
              other._ratingOptions,
              _ratingOptions,
            ) &&
            (identical(other.sortOptionEnabled, sortOptionEnabled) ||
                other.sortOptionEnabled == sortOptionEnabled) &&
            const DeepCollectionEquality().equals(
              other._availableSortOptions,
              _availableSortOptions,
            ) &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.shippingFilter, shippingFilter) ||
                other.shippingFilter == shippingFilter) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.priceFilterEnebale, priceFilterEnebale) ||
                other.priceFilterEnebale == priceFilterEnebale) &&
            (identical(other.pagingFilterModel, pagingFilterModel) ||
                other.pagingFilterModel == pagingFilterModel));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    query,
    selectedCategory,
    selectedCategoryModel,
    selectedCollectionId,
    maxPrice,
    minPrice,
    attributeFilterEnbaled,
    const DeepCollectionEquality().hash(_attributeFilters),
    const DeepCollectionEquality().hash(_alreadyFilteredItems),
    const DeepCollectionEquality().hash(_notFilteredItems),
    const DeepCollectionEquality().hash(_availableCategories),
    const DeepCollectionEquality().hash(_allCategories),
    const DeepCollectionEquality().hash(_availableCollections),
    const DeepCollectionEquality().hash(_availableVendors),
    const DeepCollectionEquality().hash(_ratingOptions),
    sortOptionEnabled,
    const DeepCollectionEquality().hash(_availableSortOptions),
    orderBy,
    rating,
    shippingFilter,
    vendorId,
    priceFilterEnebale,
    pagingFilterModel,
  ]);

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterStateImplCopyWith<_$FilterStateImpl> get copyWith =>
      __$$FilterStateImplCopyWithImpl<_$FilterStateImpl>(this, _$identity);
}

abstract class _FilterState implements FilterState {
  const factory _FilterState({
    final String query,
    final String? selectedCategory,
    final CategoryModel? selectedCategoryModel,
    final String? selectedCollectionId,
    final double? maxPrice,
    final double? minPrice,
    final bool attributeFilterEnbaled,
    final List<String> attributeFilters,
    final List<SpecificationFilterItem> alreadyFilteredItems,
    final List<SpecificationFilterItem> notFilteredItems,
    final List<SelectListItem> availableCategories,
    final List<CategoryModel> allCategories,
    final List<SelectListItem> availableCollections,
    final List<SelectListItem> availableVendors,
    final List<SelectListItem> ratingOptions,
    final bool sortOptionEnabled,
    final List<SelectListItem> availableSortOptions,
    final int orderBy,
    final double? rating,
    final ShippingFilterType shippingFilter,
    final String? vendorId,
    final bool priceFilterEnebale,
    final CatalogPagingFilteringModel? pagingFilterModel,
  }) = _$FilterStateImpl;

  @override
  String get query;
  @override
  String? get selectedCategory;
  @override
  CategoryModel? get selectedCategoryModel;
  @override
  String? get selectedCollectionId;
  @override
  double? get maxPrice;
  @override
  double? get minPrice;
  @override
  bool get attributeFilterEnbaled;
  @override
  List<String> get attributeFilters;
  @override
  List<SpecificationFilterItem> get alreadyFilteredItems;
  @override
  List<SpecificationFilterItem> get notFilteredItems;
  @override
  List<SelectListItem> get availableCategories;
  @override
  List<CategoryModel> get allCategories;
  @override
  List<SelectListItem> get availableCollections;
  @override
  List<SelectListItem> get availableVendors;
  @override
  List<SelectListItem> get ratingOptions;
  @override
  bool get sortOptionEnabled;
  @override
  List<SelectListItem> get availableSortOptions;
  @override
  int get orderBy;
  @override
  double? get rating;
  @override
  ShippingFilterType get shippingFilter;
  @override
  String? get vendorId;
  @override
  bool get priceFilterEnebale;
  @override
  CatalogPagingFilteringModel? get pagingFilterModel;

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterStateImplCopyWith<_$FilterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
