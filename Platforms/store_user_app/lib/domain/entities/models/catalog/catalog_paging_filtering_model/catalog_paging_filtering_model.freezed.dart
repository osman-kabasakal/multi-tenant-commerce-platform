// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_paging_filtering_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CatalogPagingFilteringModel _$CatalogPagingFilteringModelFromJson(
  Map<String, dynamic> json,
) {
  return _CatalogPagingFilteringModel.fromJson(json);
}

/// @nodoc
mixin _$CatalogPagingFilteringModel {
  @JsonKey(name: 'SpecificationFilter', includeIfNull: false)
  SpecificationFilterModel? get specificationFilter =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowProductSorting', includeIfNull: false)
  bool? get allowProductSorting => throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableSortOptions', includeIfNull: false)
  List<SelectListItem>? get availableSortOptions =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowProductViewModeChanging', includeIfNull: false)
  bool? get allowProductViewModeChanging => throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableViewModes', includeIfNull: false)
  List<SelectListItem>? get availableViewModes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowCustomersToSelectPageSize', includeIfNull: false)
  bool? get allowCustomersToSelectPageSize =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'PageSizeOptions', includeIfNull: false)
  List<SelectListItem>? get pageSizeOptions =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderBy', includeIfNull: false)
  int? get orderBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'Rating', includeIfNull: false)
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'RatingOptions', includeIfNull: false)
  List<SelectListItem>? get ratingOptions => throw _privateConstructorUsedError;
  @JsonKey(name: 'ViewMode', includeIfNull: false)
  String? get viewMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'FirstItem', includeIfNull: false)
  int? get firstItem => throw _privateConstructorUsedError;
  @JsonKey(name: 'HasNextPage', includeIfNull: false)
  bool? get hasNextPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
  bool? get hasPreviousPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'LastItem', includeIfNull: false)
  int? get lastItem => throw _privateConstructorUsedError;
  @JsonKey(name: 'PageIndex', includeIfNull: false)
  int? get pageIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'PageNumber', includeIfNull: false)
  int? get pageNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'PageSize', includeIfNull: false)
  int? get pageSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalItems', includeIfNull: false)
  int? get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalPages', includeIfNull: false)
  int? get totalPages => throw _privateConstructorUsedError;

  /// Serializes this CatalogPagingFilteringModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CatalogPagingFilteringModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogPagingFilteringModelCopyWith<CatalogPagingFilteringModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogPagingFilteringModelCopyWith<$Res> {
  factory $CatalogPagingFilteringModelCopyWith(
    CatalogPagingFilteringModel value,
    $Res Function(CatalogPagingFilteringModel) then,
  ) =
      _$CatalogPagingFilteringModelCopyWithImpl<
        $Res,
        CatalogPagingFilteringModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'SpecificationFilter', includeIfNull: false)
    SpecificationFilterModel? specificationFilter,
    @JsonKey(name: 'AllowProductSorting', includeIfNull: false)
    bool? allowProductSorting,
    @JsonKey(name: 'AvailableSortOptions', includeIfNull: false)
    List<SelectListItem>? availableSortOptions,
    @JsonKey(name: 'AllowProductViewModeChanging', includeIfNull: false)
    bool? allowProductViewModeChanging,
    @JsonKey(name: 'AvailableViewModes', includeIfNull: false)
    List<SelectListItem>? availableViewModes,
    @JsonKey(name: 'AllowCustomersToSelectPageSize', includeIfNull: false)
    bool? allowCustomersToSelectPageSize,
    @JsonKey(name: 'PageSizeOptions', includeIfNull: false)
    List<SelectListItem>? pageSizeOptions,
    @JsonKey(name: 'OrderBy', includeIfNull: false) int? orderBy,
    @JsonKey(name: 'Rating', includeIfNull: false) double? rating,
    @JsonKey(name: 'RatingOptions', includeIfNull: false)
    List<SelectListItem>? ratingOptions,
    @JsonKey(name: 'ViewMode', includeIfNull: false) String? viewMode,
    @JsonKey(name: 'FirstItem', includeIfNull: false) int? firstItem,
    @JsonKey(name: 'HasNextPage', includeIfNull: false) bool? hasNextPage,
    @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
    bool? hasPreviousPage,
    @JsonKey(name: 'LastItem', includeIfNull: false) int? lastItem,
    @JsonKey(name: 'PageIndex', includeIfNull: false) int? pageIndex,
    @JsonKey(name: 'PageNumber', includeIfNull: false) int? pageNumber,
    @JsonKey(name: 'PageSize', includeIfNull: false) int? pageSize,
    @JsonKey(name: 'TotalItems', includeIfNull: false) int? totalItems,
    @JsonKey(name: 'TotalPages', includeIfNull: false) int? totalPages,
  });

  $SpecificationFilterModelCopyWith<$Res>? get specificationFilter;
}

/// @nodoc
class _$CatalogPagingFilteringModelCopyWithImpl<
  $Res,
  $Val extends CatalogPagingFilteringModel
>
    implements $CatalogPagingFilteringModelCopyWith<$Res> {
  _$CatalogPagingFilteringModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CatalogPagingFilteringModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specificationFilter = freezed,
    Object? allowProductSorting = freezed,
    Object? availableSortOptions = freezed,
    Object? allowProductViewModeChanging = freezed,
    Object? availableViewModes = freezed,
    Object? allowCustomersToSelectPageSize = freezed,
    Object? pageSizeOptions = freezed,
    Object? orderBy = freezed,
    Object? rating = freezed,
    Object? ratingOptions = freezed,
    Object? viewMode = freezed,
    Object? firstItem = freezed,
    Object? hasNextPage = freezed,
    Object? hasPreviousPage = freezed,
    Object? lastItem = freezed,
    Object? pageIndex = freezed,
    Object? pageNumber = freezed,
    Object? pageSize = freezed,
    Object? totalItems = freezed,
    Object? totalPages = freezed,
  }) {
    return _then(
      _value.copyWith(
            specificationFilter:
                freezed == specificationFilter
                    ? _value.specificationFilter
                    : specificationFilter // ignore: cast_nullable_to_non_nullable
                        as SpecificationFilterModel?,
            allowProductSorting:
                freezed == allowProductSorting
                    ? _value.allowProductSorting
                    : allowProductSorting // ignore: cast_nullable_to_non_nullable
                        as bool?,
            availableSortOptions:
                freezed == availableSortOptions
                    ? _value.availableSortOptions
                    : availableSortOptions // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            allowProductViewModeChanging:
                freezed == allowProductViewModeChanging
                    ? _value.allowProductViewModeChanging
                    : allowProductViewModeChanging // ignore: cast_nullable_to_non_nullable
                        as bool?,
            availableViewModes:
                freezed == availableViewModes
                    ? _value.availableViewModes
                    : availableViewModes // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            allowCustomersToSelectPageSize:
                freezed == allowCustomersToSelectPageSize
                    ? _value.allowCustomersToSelectPageSize
                    : allowCustomersToSelectPageSize // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pageSizeOptions:
                freezed == pageSizeOptions
                    ? _value.pageSizeOptions
                    : pageSizeOptions // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            orderBy:
                freezed == orderBy
                    ? _value.orderBy
                    : orderBy // ignore: cast_nullable_to_non_nullable
                        as int?,
            rating:
                freezed == rating
                    ? _value.rating
                    : rating // ignore: cast_nullable_to_non_nullable
                        as double?,
            ratingOptions:
                freezed == ratingOptions
                    ? _value.ratingOptions
                    : ratingOptions // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            viewMode:
                freezed == viewMode
                    ? _value.viewMode
                    : viewMode // ignore: cast_nullable_to_non_nullable
                        as String?,
            firstItem:
                freezed == firstItem
                    ? _value.firstItem
                    : firstItem // ignore: cast_nullable_to_non_nullable
                        as int?,
            hasNextPage:
                freezed == hasNextPage
                    ? _value.hasNextPage
                    : hasNextPage // ignore: cast_nullable_to_non_nullable
                        as bool?,
            hasPreviousPage:
                freezed == hasPreviousPage
                    ? _value.hasPreviousPage
                    : hasPreviousPage // ignore: cast_nullable_to_non_nullable
                        as bool?,
            lastItem:
                freezed == lastItem
                    ? _value.lastItem
                    : lastItem // ignore: cast_nullable_to_non_nullable
                        as int?,
            pageIndex:
                freezed == pageIndex
                    ? _value.pageIndex
                    : pageIndex // ignore: cast_nullable_to_non_nullable
                        as int?,
            pageNumber:
                freezed == pageNumber
                    ? _value.pageNumber
                    : pageNumber // ignore: cast_nullable_to_non_nullable
                        as int?,
            pageSize:
                freezed == pageSize
                    ? _value.pageSize
                    : pageSize // ignore: cast_nullable_to_non_nullable
                        as int?,
            totalItems:
                freezed == totalItems
                    ? _value.totalItems
                    : totalItems // ignore: cast_nullable_to_non_nullable
                        as int?,
            totalPages:
                freezed == totalPages
                    ? _value.totalPages
                    : totalPages // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of CatalogPagingFilteringModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpecificationFilterModelCopyWith<$Res>? get specificationFilter {
    if (_value.specificationFilter == null) {
      return null;
    }

    return $SpecificationFilterModelCopyWith<$Res>(
      _value.specificationFilter!,
      (value) {
        return _then(_value.copyWith(specificationFilter: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$CatalogPagingFilteringModelImplCopyWith<$Res>
    implements $CatalogPagingFilteringModelCopyWith<$Res> {
  factory _$$CatalogPagingFilteringModelImplCopyWith(
    _$CatalogPagingFilteringModelImpl value,
    $Res Function(_$CatalogPagingFilteringModelImpl) then,
  ) = __$$CatalogPagingFilteringModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'SpecificationFilter', includeIfNull: false)
    SpecificationFilterModel? specificationFilter,
    @JsonKey(name: 'AllowProductSorting', includeIfNull: false)
    bool? allowProductSorting,
    @JsonKey(name: 'AvailableSortOptions', includeIfNull: false)
    List<SelectListItem>? availableSortOptions,
    @JsonKey(name: 'AllowProductViewModeChanging', includeIfNull: false)
    bool? allowProductViewModeChanging,
    @JsonKey(name: 'AvailableViewModes', includeIfNull: false)
    List<SelectListItem>? availableViewModes,
    @JsonKey(name: 'AllowCustomersToSelectPageSize', includeIfNull: false)
    bool? allowCustomersToSelectPageSize,
    @JsonKey(name: 'PageSizeOptions', includeIfNull: false)
    List<SelectListItem>? pageSizeOptions,
    @JsonKey(name: 'OrderBy', includeIfNull: false) int? orderBy,
    @JsonKey(name: 'Rating', includeIfNull: false) double? rating,
    @JsonKey(name: 'RatingOptions', includeIfNull: false)
    List<SelectListItem>? ratingOptions,
    @JsonKey(name: 'ViewMode', includeIfNull: false) String? viewMode,
    @JsonKey(name: 'FirstItem', includeIfNull: false) int? firstItem,
    @JsonKey(name: 'HasNextPage', includeIfNull: false) bool? hasNextPage,
    @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
    bool? hasPreviousPage,
    @JsonKey(name: 'LastItem', includeIfNull: false) int? lastItem,
    @JsonKey(name: 'PageIndex', includeIfNull: false) int? pageIndex,
    @JsonKey(name: 'PageNumber', includeIfNull: false) int? pageNumber,
    @JsonKey(name: 'PageSize', includeIfNull: false) int? pageSize,
    @JsonKey(name: 'TotalItems', includeIfNull: false) int? totalItems,
    @JsonKey(name: 'TotalPages', includeIfNull: false) int? totalPages,
  });

  @override
  $SpecificationFilterModelCopyWith<$Res>? get specificationFilter;
}

/// @nodoc
class __$$CatalogPagingFilteringModelImplCopyWithImpl<$Res>
    extends
        _$CatalogPagingFilteringModelCopyWithImpl<
          $Res,
          _$CatalogPagingFilteringModelImpl
        >
    implements _$$CatalogPagingFilteringModelImplCopyWith<$Res> {
  __$$CatalogPagingFilteringModelImplCopyWithImpl(
    _$CatalogPagingFilteringModelImpl _value,
    $Res Function(_$CatalogPagingFilteringModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CatalogPagingFilteringModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specificationFilter = freezed,
    Object? allowProductSorting = freezed,
    Object? availableSortOptions = freezed,
    Object? allowProductViewModeChanging = freezed,
    Object? availableViewModes = freezed,
    Object? allowCustomersToSelectPageSize = freezed,
    Object? pageSizeOptions = freezed,
    Object? orderBy = freezed,
    Object? rating = freezed,
    Object? ratingOptions = freezed,
    Object? viewMode = freezed,
    Object? firstItem = freezed,
    Object? hasNextPage = freezed,
    Object? hasPreviousPage = freezed,
    Object? lastItem = freezed,
    Object? pageIndex = freezed,
    Object? pageNumber = freezed,
    Object? pageSize = freezed,
    Object? totalItems = freezed,
    Object? totalPages = freezed,
  }) {
    return _then(
      _$CatalogPagingFilteringModelImpl(
        specificationFilter:
            freezed == specificationFilter
                ? _value.specificationFilter
                : specificationFilter // ignore: cast_nullable_to_non_nullable
                    as SpecificationFilterModel?,
        allowProductSorting:
            freezed == allowProductSorting
                ? _value.allowProductSorting
                : allowProductSorting // ignore: cast_nullable_to_non_nullable
                    as bool?,
        availableSortOptions:
            freezed == availableSortOptions
                ? _value._availableSortOptions
                : availableSortOptions // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        allowProductViewModeChanging:
            freezed == allowProductViewModeChanging
                ? _value.allowProductViewModeChanging
                : allowProductViewModeChanging // ignore: cast_nullable_to_non_nullable
                    as bool?,
        availableViewModes:
            freezed == availableViewModes
                ? _value._availableViewModes
                : availableViewModes // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        allowCustomersToSelectPageSize:
            freezed == allowCustomersToSelectPageSize
                ? _value.allowCustomersToSelectPageSize
                : allowCustomersToSelectPageSize // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pageSizeOptions:
            freezed == pageSizeOptions
                ? _value._pageSizeOptions
                : pageSizeOptions // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        orderBy:
            freezed == orderBy
                ? _value.orderBy
                : orderBy // ignore: cast_nullable_to_non_nullable
                    as int?,
        rating:
            freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                    as double?,
        ratingOptions:
            freezed == ratingOptions
                ? _value._ratingOptions
                : ratingOptions // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        viewMode:
            freezed == viewMode
                ? _value.viewMode
                : viewMode // ignore: cast_nullable_to_non_nullable
                    as String?,
        firstItem:
            freezed == firstItem
                ? _value.firstItem
                : firstItem // ignore: cast_nullable_to_non_nullable
                    as int?,
        hasNextPage:
            freezed == hasNextPage
                ? _value.hasNextPage
                : hasNextPage // ignore: cast_nullable_to_non_nullable
                    as bool?,
        hasPreviousPage:
            freezed == hasPreviousPage
                ? _value.hasPreviousPage
                : hasPreviousPage // ignore: cast_nullable_to_non_nullable
                    as bool?,
        lastItem:
            freezed == lastItem
                ? _value.lastItem
                : lastItem // ignore: cast_nullable_to_non_nullable
                    as int?,
        pageIndex:
            freezed == pageIndex
                ? _value.pageIndex
                : pageIndex // ignore: cast_nullable_to_non_nullable
                    as int?,
        pageNumber:
            freezed == pageNumber
                ? _value.pageNumber
                : pageNumber // ignore: cast_nullable_to_non_nullable
                    as int?,
        pageSize:
            freezed == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                    as int?,
        totalItems:
            freezed == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                    as int?,
        totalPages:
            freezed == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogPagingFilteringModelImpl
    implements _CatalogPagingFilteringModel {
  _$CatalogPagingFilteringModelImpl({
    @JsonKey(name: 'SpecificationFilter', includeIfNull: false)
    this.specificationFilter,
    @JsonKey(name: 'AllowProductSorting', includeIfNull: false)
    this.allowProductSorting = false,
    @JsonKey(name: 'AvailableSortOptions', includeIfNull: false)
    final List<SelectListItem>? availableSortOptions = const [],
    @JsonKey(name: 'AllowProductViewModeChanging', includeIfNull: false)
    this.allowProductViewModeChanging = false,
    @JsonKey(name: 'AvailableViewModes', includeIfNull: false)
    final List<SelectListItem>? availableViewModes = const [],
    @JsonKey(name: 'AllowCustomersToSelectPageSize', includeIfNull: false)
    this.allowCustomersToSelectPageSize = false,
    @JsonKey(name: 'PageSizeOptions', includeIfNull: false)
    final List<SelectListItem>? pageSizeOptions = const [],
    @JsonKey(name: 'OrderBy', includeIfNull: false) this.orderBy = null,
    @JsonKey(name: 'Rating', includeIfNull: false) this.rating = null,
    @JsonKey(name: 'RatingOptions', includeIfNull: false)
    final List<SelectListItem>? ratingOptions = const [],
    @JsonKey(name: 'ViewMode', includeIfNull: false) this.viewMode,
    @JsonKey(name: 'FirstItem', includeIfNull: false) this.firstItem,
    @JsonKey(name: 'HasNextPage', includeIfNull: false)
    this.hasNextPage = false,
    @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
    this.hasPreviousPage = false,
    @JsonKey(name: 'LastItem', includeIfNull: false) this.lastItem,
    @JsonKey(name: 'PageIndex', includeIfNull: false) this.pageIndex,
    @JsonKey(name: 'PageNumber', includeIfNull: false) this.pageNumber,
    @JsonKey(name: 'PageSize', includeIfNull: false) this.pageSize,
    @JsonKey(name: 'TotalItems', includeIfNull: false) this.totalItems,
    @JsonKey(name: 'TotalPages', includeIfNull: false) this.totalPages,
  }) : _availableSortOptions = availableSortOptions,
       _availableViewModes = availableViewModes,
       _pageSizeOptions = pageSizeOptions,
       _ratingOptions = ratingOptions;

  factory _$CatalogPagingFilteringModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CatalogPagingFilteringModelImplFromJson(json);

  @override
  @JsonKey(name: 'SpecificationFilter', includeIfNull: false)
  final SpecificationFilterModel? specificationFilter;
  @override
  @JsonKey(name: 'AllowProductSorting', includeIfNull: false)
  final bool? allowProductSorting;
  final List<SelectListItem>? _availableSortOptions;
  @override
  @JsonKey(name: 'AvailableSortOptions', includeIfNull: false)
  List<SelectListItem>? get availableSortOptions {
    final value = _availableSortOptions;
    if (value == null) return null;
    if (_availableSortOptions is EqualUnmodifiableListView)
      return _availableSortOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'AllowProductViewModeChanging', includeIfNull: false)
  final bool? allowProductViewModeChanging;
  final List<SelectListItem>? _availableViewModes;
  @override
  @JsonKey(name: 'AvailableViewModes', includeIfNull: false)
  List<SelectListItem>? get availableViewModes {
    final value = _availableViewModes;
    if (value == null) return null;
    if (_availableViewModes is EqualUnmodifiableListView)
      return _availableViewModes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'AllowCustomersToSelectPageSize', includeIfNull: false)
  final bool? allowCustomersToSelectPageSize;
  final List<SelectListItem>? _pageSizeOptions;
  @override
  @JsonKey(name: 'PageSizeOptions', includeIfNull: false)
  List<SelectListItem>? get pageSizeOptions {
    final value = _pageSizeOptions;
    if (value == null) return null;
    if (_pageSizeOptions is EqualUnmodifiableListView) return _pageSizeOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'OrderBy', includeIfNull: false)
  final int? orderBy;
  @override
  @JsonKey(name: 'Rating', includeIfNull: false)
  final double? rating;
  final List<SelectListItem>? _ratingOptions;
  @override
  @JsonKey(name: 'RatingOptions', includeIfNull: false)
  List<SelectListItem>? get ratingOptions {
    final value = _ratingOptions;
    if (value == null) return null;
    if (_ratingOptions is EqualUnmodifiableListView) return _ratingOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'ViewMode', includeIfNull: false)
  final String? viewMode;
  @override
  @JsonKey(name: 'FirstItem', includeIfNull: false)
  final int? firstItem;
  @override
  @JsonKey(name: 'HasNextPage', includeIfNull: false)
  final bool? hasNextPage;
  @override
  @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
  final bool? hasPreviousPage;
  @override
  @JsonKey(name: 'LastItem', includeIfNull: false)
  final int? lastItem;
  @override
  @JsonKey(name: 'PageIndex', includeIfNull: false)
  final int? pageIndex;
  @override
  @JsonKey(name: 'PageNumber', includeIfNull: false)
  final int? pageNumber;
  @override
  @JsonKey(name: 'PageSize', includeIfNull: false)
  final int? pageSize;
  @override
  @JsonKey(name: 'TotalItems', includeIfNull: false)
  final int? totalItems;
  @override
  @JsonKey(name: 'TotalPages', includeIfNull: false)
  final int? totalPages;

  @override
  String toString() {
    return 'CatalogPagingFilteringModel(specificationFilter: $specificationFilter, allowProductSorting: $allowProductSorting, availableSortOptions: $availableSortOptions, allowProductViewModeChanging: $allowProductViewModeChanging, availableViewModes: $availableViewModes, allowCustomersToSelectPageSize: $allowCustomersToSelectPageSize, pageSizeOptions: $pageSizeOptions, orderBy: $orderBy, rating: $rating, ratingOptions: $ratingOptions, viewMode: $viewMode, firstItem: $firstItem, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage, lastItem: $lastItem, pageIndex: $pageIndex, pageNumber: $pageNumber, pageSize: $pageSize, totalItems: $totalItems, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogPagingFilteringModelImpl &&
            (identical(other.specificationFilter, specificationFilter) ||
                other.specificationFilter == specificationFilter) &&
            (identical(other.allowProductSorting, allowProductSorting) ||
                other.allowProductSorting == allowProductSorting) &&
            const DeepCollectionEquality().equals(
              other._availableSortOptions,
              _availableSortOptions,
            ) &&
            (identical(
                  other.allowProductViewModeChanging,
                  allowProductViewModeChanging,
                ) ||
                other.allowProductViewModeChanging ==
                    allowProductViewModeChanging) &&
            const DeepCollectionEquality().equals(
              other._availableViewModes,
              _availableViewModes,
            ) &&
            (identical(
                  other.allowCustomersToSelectPageSize,
                  allowCustomersToSelectPageSize,
                ) ||
                other.allowCustomersToSelectPageSize ==
                    allowCustomersToSelectPageSize) &&
            const DeepCollectionEquality().equals(
              other._pageSizeOptions,
              _pageSizeOptions,
            ) &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(
              other._ratingOptions,
              _ratingOptions,
            ) &&
            (identical(other.viewMode, viewMode) ||
                other.viewMode == viewMode) &&
            (identical(other.firstItem, firstItem) ||
                other.firstItem == firstItem) &&
            (identical(other.hasNextPage, hasNextPage) ||
                other.hasNextPage == hasNextPage) &&
            (identical(other.hasPreviousPage, hasPreviousPage) ||
                other.hasPreviousPage == hasPreviousPage) &&
            (identical(other.lastItem, lastItem) ||
                other.lastItem == lastItem) &&
            (identical(other.pageIndex, pageIndex) ||
                other.pageIndex == pageIndex) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    specificationFilter,
    allowProductSorting,
    const DeepCollectionEquality().hash(_availableSortOptions),
    allowProductViewModeChanging,
    const DeepCollectionEquality().hash(_availableViewModes),
    allowCustomersToSelectPageSize,
    const DeepCollectionEquality().hash(_pageSizeOptions),
    orderBy,
    rating,
    const DeepCollectionEquality().hash(_ratingOptions),
    viewMode,
    firstItem,
    hasNextPage,
    hasPreviousPage,
    lastItem,
    pageIndex,
    pageNumber,
    pageSize,
    totalItems,
    totalPages,
  ]);

  /// Create a copy of CatalogPagingFilteringModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogPagingFilteringModelImplCopyWith<_$CatalogPagingFilteringModelImpl>
  get copyWith => __$$CatalogPagingFilteringModelImplCopyWithImpl<
    _$CatalogPagingFilteringModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogPagingFilteringModelImplToJson(this);
  }
}

abstract class _CatalogPagingFilteringModel
    implements CatalogPagingFilteringModel {
  factory _CatalogPagingFilteringModel({
    @JsonKey(name: 'SpecificationFilter', includeIfNull: false)
    final SpecificationFilterModel? specificationFilter,
    @JsonKey(name: 'AllowProductSorting', includeIfNull: false)
    final bool? allowProductSorting,
    @JsonKey(name: 'AvailableSortOptions', includeIfNull: false)
    final List<SelectListItem>? availableSortOptions,
    @JsonKey(name: 'AllowProductViewModeChanging', includeIfNull: false)
    final bool? allowProductViewModeChanging,
    @JsonKey(name: 'AvailableViewModes', includeIfNull: false)
    final List<SelectListItem>? availableViewModes,
    @JsonKey(name: 'AllowCustomersToSelectPageSize', includeIfNull: false)
    final bool? allowCustomersToSelectPageSize,
    @JsonKey(name: 'PageSizeOptions', includeIfNull: false)
    final List<SelectListItem>? pageSizeOptions,
    @JsonKey(name: 'OrderBy', includeIfNull: false) final int? orderBy,
    @JsonKey(name: 'Rating', includeIfNull: false) final double? rating,
    @JsonKey(name: 'RatingOptions', includeIfNull: false)
    final List<SelectListItem>? ratingOptions,
    @JsonKey(name: 'ViewMode', includeIfNull: false) final String? viewMode,
    @JsonKey(name: 'FirstItem', includeIfNull: false) final int? firstItem,
    @JsonKey(name: 'HasNextPage', includeIfNull: false) final bool? hasNextPage,
    @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
    final bool? hasPreviousPage,
    @JsonKey(name: 'LastItem', includeIfNull: false) final int? lastItem,
    @JsonKey(name: 'PageIndex', includeIfNull: false) final int? pageIndex,
    @JsonKey(name: 'PageNumber', includeIfNull: false) final int? pageNumber,
    @JsonKey(name: 'PageSize', includeIfNull: false) final int? pageSize,
    @JsonKey(name: 'TotalItems', includeIfNull: false) final int? totalItems,
    @JsonKey(name: 'TotalPages', includeIfNull: false) final int? totalPages,
  }) = _$CatalogPagingFilteringModelImpl;

  factory _CatalogPagingFilteringModel.fromJson(Map<String, dynamic> json) =
      _$CatalogPagingFilteringModelImpl.fromJson;

  @override
  @JsonKey(name: 'SpecificationFilter', includeIfNull: false)
  SpecificationFilterModel? get specificationFilter;
  @override
  @JsonKey(name: 'AllowProductSorting', includeIfNull: false)
  bool? get allowProductSorting;
  @override
  @JsonKey(name: 'AvailableSortOptions', includeIfNull: false)
  List<SelectListItem>? get availableSortOptions;
  @override
  @JsonKey(name: 'AllowProductViewModeChanging', includeIfNull: false)
  bool? get allowProductViewModeChanging;
  @override
  @JsonKey(name: 'AvailableViewModes', includeIfNull: false)
  List<SelectListItem>? get availableViewModes;
  @override
  @JsonKey(name: 'AllowCustomersToSelectPageSize', includeIfNull: false)
  bool? get allowCustomersToSelectPageSize;
  @override
  @JsonKey(name: 'PageSizeOptions', includeIfNull: false)
  List<SelectListItem>? get pageSizeOptions;
  @override
  @JsonKey(name: 'OrderBy', includeIfNull: false)
  int? get orderBy;
  @override
  @JsonKey(name: 'Rating', includeIfNull: false)
  double? get rating;
  @override
  @JsonKey(name: 'RatingOptions', includeIfNull: false)
  List<SelectListItem>? get ratingOptions;
  @override
  @JsonKey(name: 'ViewMode', includeIfNull: false)
  String? get viewMode;
  @override
  @JsonKey(name: 'FirstItem', includeIfNull: false)
  int? get firstItem;
  @override
  @JsonKey(name: 'HasNextPage', includeIfNull: false)
  bool? get hasNextPage;
  @override
  @JsonKey(name: 'HasPreviousPage', includeIfNull: false)
  bool? get hasPreviousPage;
  @override
  @JsonKey(name: 'LastItem', includeIfNull: false)
  int? get lastItem;
  @override
  @JsonKey(name: 'PageIndex', includeIfNull: false)
  int? get pageIndex;
  @override
  @JsonKey(name: 'PageNumber', includeIfNull: false)
  int? get pageNumber;
  @override
  @JsonKey(name: 'PageSize', includeIfNull: false)
  int? get pageSize;
  @override
  @JsonKey(name: 'TotalItems', includeIfNull: false)
  int? get totalItems;
  @override
  @JsonKey(name: 'TotalPages', includeIfNull: false)
  int? get totalPages;

  /// Create a copy of CatalogPagingFilteringModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogPagingFilteringModelImplCopyWith<_$CatalogPagingFilteringModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
