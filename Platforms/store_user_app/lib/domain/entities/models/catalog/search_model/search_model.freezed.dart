// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchModel _$SearchModelFromJson(Map<String, dynamic> json) {
  return _SearchModel.fromJson(json);
}

/// @nodoc
mixin _$SearchModel {
  @JsonKey(name: 'Warning', includeIfNull: false)
  String? get warning => throw _privateConstructorUsedError;
  @JsonKey(name: 'NoResults', includeIfNull: false)
  bool? get noResults => throw _privateConstructorUsedError;
  @JsonKey(name: 'SearchCategoryId', includeIfNull: false)
  String? get searchCategoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'q', includeIfNull: false)
  String? get q => throw _privateConstructorUsedError;
  @JsonKey(name: 'cid', includeIfNull: false)
  String? get cid => throw _privateConstructorUsedError;
  @JsonKey(name: 'isc', includeIfNull: false)
  bool? get isc => throw _privateConstructorUsedError;
  @JsonKey(name: 'mid', includeIfNull: false)
  String? get mid => throw _privateConstructorUsedError;
  @JsonKey(name: 'vid', includeIfNull: false)
  String? get vid => throw _privateConstructorUsedError;
  @JsonKey(name: 'pf', includeIfNull: false)
  String? get pf => throw _privateConstructorUsedError;
  @JsonKey(name: 'pt', includeIfNull: false)
  String? get pt => throw _privateConstructorUsedError;
  @JsonKey(name: 'sid', includeIfNull: false)
  bool? get sid => throw _privateConstructorUsedError;
  @JsonKey(name: 'adv', includeIfNull: false)
  bool? get adv => throw _privateConstructorUsedError;
  @JsonKey(name: 'asv', includeIfNull: false)
  bool? get asv => throw _privateConstructorUsedError;
  @JsonKey(name: 'Box', includeIfNull: false)
  bool? get box => throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableCategories', includeIfNull: false)
  List<SelectListItem>? get availableCategories =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableCollections', includeIfNull: false)
  List<SelectListItem>? get availableCollections =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableVendors', includeIfNull: false)
  List<SelectListItem>? get availableVendors =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  CatalogPagingFilteringModel? get pagingFilteringContext =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this SearchModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchModelCopyWith<SearchModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchModelCopyWith<$Res> {
  factory $SearchModelCopyWith(
    SearchModel value,
    $Res Function(SearchModel) then,
  ) = _$SearchModelCopyWithImpl<$Res, SearchModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Warning', includeIfNull: false) String? warning,
    @JsonKey(name: 'NoResults', includeIfNull: false) bool? noResults,
    @JsonKey(name: 'SearchCategoryId', includeIfNull: false)
    String? searchCategoryId,
    @JsonKey(name: 'q', includeIfNull: false) String? q,
    @JsonKey(name: 'cid', includeIfNull: false) String? cid,
    @JsonKey(name: 'isc', includeIfNull: false) bool? isc,
    @JsonKey(name: 'mid', includeIfNull: false) String? mid,
    @JsonKey(name: 'vid', includeIfNull: false) String? vid,
    @JsonKey(name: 'pf', includeIfNull: false) String? pf,
    @JsonKey(name: 'pt', includeIfNull: false) String? pt,
    @JsonKey(name: 'sid', includeIfNull: false) bool? sid,
    @JsonKey(name: 'adv', includeIfNull: false) bool? adv,
    @JsonKey(name: 'asv', includeIfNull: false) bool? asv,
    @JsonKey(name: 'Box', includeIfNull: false) bool? box,
    @JsonKey(name: 'AvailableCategories', includeIfNull: false)
    List<SelectListItem>? availableCategories,
    @JsonKey(name: 'AvailableCollections', includeIfNull: false)
    List<SelectListItem>? availableCollections,
    @JsonKey(name: 'AvailableVendors', includeIfNull: false)
    List<SelectListItem>? availableVendors,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
}

/// @nodoc
class _$SearchModelCopyWithImpl<$Res, $Val extends SearchModel>
    implements $SearchModelCopyWith<$Res> {
  _$SearchModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warning = freezed,
    Object? noResults = freezed,
    Object? searchCategoryId = freezed,
    Object? q = freezed,
    Object? cid = freezed,
    Object? isc = freezed,
    Object? mid = freezed,
    Object? vid = freezed,
    Object? pf = freezed,
    Object? pt = freezed,
    Object? sid = freezed,
    Object? adv = freezed,
    Object? asv = freezed,
    Object? box = freezed,
    Object? availableCategories = freezed,
    Object? availableCollections = freezed,
    Object? availableVendors = freezed,
    Object? pagingFilteringContext = freezed,
    Object? products = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            warning:
                freezed == warning
                    ? _value.warning
                    : warning // ignore: cast_nullable_to_non_nullable
                        as String?,
            noResults:
                freezed == noResults
                    ? _value.noResults
                    : noResults // ignore: cast_nullable_to_non_nullable
                        as bool?,
            searchCategoryId:
                freezed == searchCategoryId
                    ? _value.searchCategoryId
                    : searchCategoryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            q:
                freezed == q
                    ? _value.q
                    : q // ignore: cast_nullable_to_non_nullable
                        as String?,
            cid:
                freezed == cid
                    ? _value.cid
                    : cid // ignore: cast_nullable_to_non_nullable
                        as String?,
            isc:
                freezed == isc
                    ? _value.isc
                    : isc // ignore: cast_nullable_to_non_nullable
                        as bool?,
            mid:
                freezed == mid
                    ? _value.mid
                    : mid // ignore: cast_nullable_to_non_nullable
                        as String?,
            vid:
                freezed == vid
                    ? _value.vid
                    : vid // ignore: cast_nullable_to_non_nullable
                        as String?,
            pf:
                freezed == pf
                    ? _value.pf
                    : pf // ignore: cast_nullable_to_non_nullable
                        as String?,
            pt:
                freezed == pt
                    ? _value.pt
                    : pt // ignore: cast_nullable_to_non_nullable
                        as String?,
            sid:
                freezed == sid
                    ? _value.sid
                    : sid // ignore: cast_nullable_to_non_nullable
                        as bool?,
            adv:
                freezed == adv
                    ? _value.adv
                    : adv // ignore: cast_nullable_to_non_nullable
                        as bool?,
            asv:
                freezed == asv
                    ? _value.asv
                    : asv // ignore: cast_nullable_to_non_nullable
                        as bool?,
            box:
                freezed == box
                    ? _value.box
                    : box // ignore: cast_nullable_to_non_nullable
                        as bool?,
            availableCategories:
                freezed == availableCategories
                    ? _value.availableCategories
                    : availableCategories // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            availableCollections:
                freezed == availableCollections
                    ? _value.availableCollections
                    : availableCollections // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            availableVendors:
                freezed == availableVendors
                    ? _value.availableVendors
                    : availableVendors // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
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
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of SearchModel
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
abstract class _$$SearchModelImplCopyWith<$Res>
    implements $SearchModelCopyWith<$Res> {
  factory _$$SearchModelImplCopyWith(
    _$SearchModelImpl value,
    $Res Function(_$SearchModelImpl) then,
  ) = __$$SearchModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Warning', includeIfNull: false) String? warning,
    @JsonKey(name: 'NoResults', includeIfNull: false) bool? noResults,
    @JsonKey(name: 'SearchCategoryId', includeIfNull: false)
    String? searchCategoryId,
    @JsonKey(name: 'q', includeIfNull: false) String? q,
    @JsonKey(name: 'cid', includeIfNull: false) String? cid,
    @JsonKey(name: 'isc', includeIfNull: false) bool? isc,
    @JsonKey(name: 'mid', includeIfNull: false) String? mid,
    @JsonKey(name: 'vid', includeIfNull: false) String? vid,
    @JsonKey(name: 'pf', includeIfNull: false) String? pf,
    @JsonKey(name: 'pt', includeIfNull: false) String? pt,
    @JsonKey(name: 'sid', includeIfNull: false) bool? sid,
    @JsonKey(name: 'adv', includeIfNull: false) bool? adv,
    @JsonKey(name: 'asv', includeIfNull: false) bool? asv,
    @JsonKey(name: 'Box', includeIfNull: false) bool? box,
    @JsonKey(name: 'AvailableCategories', includeIfNull: false)
    List<SelectListItem>? availableCategories,
    @JsonKey(name: 'AvailableCollections', includeIfNull: false)
    List<SelectListItem>? availableCollections,
    @JsonKey(name: 'AvailableVendors', includeIfNull: false)
    List<SelectListItem>? availableVendors,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
}

/// @nodoc
class __$$SearchModelImplCopyWithImpl<$Res>
    extends _$SearchModelCopyWithImpl<$Res, _$SearchModelImpl>
    implements _$$SearchModelImplCopyWith<$Res> {
  __$$SearchModelImplCopyWithImpl(
    _$SearchModelImpl _value,
    $Res Function(_$SearchModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warning = freezed,
    Object? noResults = freezed,
    Object? searchCategoryId = freezed,
    Object? q = freezed,
    Object? cid = freezed,
    Object? isc = freezed,
    Object? mid = freezed,
    Object? vid = freezed,
    Object? pf = freezed,
    Object? pt = freezed,
    Object? sid = freezed,
    Object? adv = freezed,
    Object? asv = freezed,
    Object? box = freezed,
    Object? availableCategories = freezed,
    Object? availableCollections = freezed,
    Object? availableVendors = freezed,
    Object? pagingFilteringContext = freezed,
    Object? products = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$SearchModelImpl(
        warning:
            freezed == warning
                ? _value.warning
                : warning // ignore: cast_nullable_to_non_nullable
                    as String?,
        noResults:
            freezed == noResults
                ? _value.noResults
                : noResults // ignore: cast_nullable_to_non_nullable
                    as bool?,
        searchCategoryId:
            freezed == searchCategoryId
                ? _value.searchCategoryId
                : searchCategoryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        q:
            freezed == q
                ? _value.q
                : q // ignore: cast_nullable_to_non_nullable
                    as String?,
        cid:
            freezed == cid
                ? _value.cid
                : cid // ignore: cast_nullable_to_non_nullable
                    as String?,
        isc:
            freezed == isc
                ? _value.isc
                : isc // ignore: cast_nullable_to_non_nullable
                    as bool?,
        mid:
            freezed == mid
                ? _value.mid
                : mid // ignore: cast_nullable_to_non_nullable
                    as String?,
        vid:
            freezed == vid
                ? _value.vid
                : vid // ignore: cast_nullable_to_non_nullable
                    as String?,
        pf:
            freezed == pf
                ? _value.pf
                : pf // ignore: cast_nullable_to_non_nullable
                    as String?,
        pt:
            freezed == pt
                ? _value.pt
                : pt // ignore: cast_nullable_to_non_nullable
                    as String?,
        sid:
            freezed == sid
                ? _value.sid
                : sid // ignore: cast_nullable_to_non_nullable
                    as bool?,
        adv:
            freezed == adv
                ? _value.adv
                : adv // ignore: cast_nullable_to_non_nullable
                    as bool?,
        asv:
            freezed == asv
                ? _value.asv
                : asv // ignore: cast_nullable_to_non_nullable
                    as bool?,
        box:
            freezed == box
                ? _value.box
                : box // ignore: cast_nullable_to_non_nullable
                    as bool?,
        availableCategories:
            freezed == availableCategories
                ? _value._availableCategories
                : availableCategories // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        availableCollections:
            freezed == availableCollections
                ? _value._availableCollections
                : availableCollections // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        availableVendors:
            freezed == availableVendors
                ? _value._availableVendors
                : availableVendors // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
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
class _$SearchModelImpl implements _SearchModel {
  _$SearchModelImpl({
    @JsonKey(name: 'Warning', includeIfNull: false) this.warning,
    @JsonKey(name: 'NoResults', includeIfNull: false) this.noResults = false,
    @JsonKey(name: 'SearchCategoryId', includeIfNull: false)
    this.searchCategoryId,
    @JsonKey(name: 'q', includeIfNull: false) this.q,
    @JsonKey(name: 'cid', includeIfNull: false) this.cid,
    @JsonKey(name: 'isc', includeIfNull: false) this.isc = false,
    @JsonKey(name: 'mid', includeIfNull: false) this.mid,
    @JsonKey(name: 'vid', includeIfNull: false) this.vid,
    @JsonKey(name: 'pf', includeIfNull: false) this.pf,
    @JsonKey(name: 'pt', includeIfNull: false) this.pt,
    @JsonKey(name: 'sid', includeIfNull: false) this.sid = false,
    @JsonKey(name: 'adv', includeIfNull: false) this.adv = false,
    @JsonKey(name: 'asv', includeIfNull: false) this.asv = false,
    @JsonKey(name: 'Box', includeIfNull: false) this.box = false,
    @JsonKey(name: 'AvailableCategories', includeIfNull: false)
    final List<SelectListItem>? availableCategories = const [],
    @JsonKey(name: 'AvailableCollections', includeIfNull: false)
    final List<SelectListItem>? availableCollections = const [],
    @JsonKey(name: 'AvailableVendors', includeIfNull: false)
    final List<SelectListItem>? availableVendors = const [],
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    this.pagingFilteringContext,
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _availableCategories = availableCategories,
       _availableCollections = availableCollections,
       _availableVendors = availableVendors,
       _products = products,
       _userFields = userFields;

  factory _$SearchModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchModelImplFromJson(json);

  @override
  @JsonKey(name: 'Warning', includeIfNull: false)
  final String? warning;
  @override
  @JsonKey(name: 'NoResults', includeIfNull: false)
  final bool? noResults;
  @override
  @JsonKey(name: 'SearchCategoryId', includeIfNull: false)
  final String? searchCategoryId;
  @override
  @JsonKey(name: 'q', includeIfNull: false)
  final String? q;
  @override
  @JsonKey(name: 'cid', includeIfNull: false)
  final String? cid;
  @override
  @JsonKey(name: 'isc', includeIfNull: false)
  final bool? isc;
  @override
  @JsonKey(name: 'mid', includeIfNull: false)
  final String? mid;
  @override
  @JsonKey(name: 'vid', includeIfNull: false)
  final String? vid;
  @override
  @JsonKey(name: 'pf', includeIfNull: false)
  final String? pf;
  @override
  @JsonKey(name: 'pt', includeIfNull: false)
  final String? pt;
  @override
  @JsonKey(name: 'sid', includeIfNull: false)
  final bool? sid;
  @override
  @JsonKey(name: 'adv', includeIfNull: false)
  final bool? adv;
  @override
  @JsonKey(name: 'asv', includeIfNull: false)
  final bool? asv;
  @override
  @JsonKey(name: 'Box', includeIfNull: false)
  final bool? box;
  final List<SelectListItem>? _availableCategories;
  @override
  @JsonKey(name: 'AvailableCategories', includeIfNull: false)
  List<SelectListItem>? get availableCategories {
    final value = _availableCategories;
    if (value == null) return null;
    if (_availableCategories is EqualUnmodifiableListView)
      return _availableCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SelectListItem>? _availableCollections;
  @override
  @JsonKey(name: 'AvailableCollections', includeIfNull: false)
  List<SelectListItem>? get availableCollections {
    final value = _availableCollections;
    if (value == null) return null;
    if (_availableCollections is EqualUnmodifiableListView)
      return _availableCollections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SelectListItem>? _availableVendors;
  @override
  @JsonKey(name: 'AvailableVendors', includeIfNull: false)
  List<SelectListItem>? get availableVendors {
    final value = _availableVendors;
    if (value == null) return null;
    if (_availableVendors is EqualUnmodifiableListView)
      return _availableVendors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'SearchModel(warning: $warning, noResults: $noResults, searchCategoryId: $searchCategoryId, q: $q, cid: $cid, isc: $isc, mid: $mid, vid: $vid, pf: $pf, pt: $pt, sid: $sid, adv: $adv, asv: $asv, box: $box, availableCategories: $availableCategories, availableCollections: $availableCollections, availableVendors: $availableVendors, pagingFilteringContext: $pagingFilteringContext, products: $products, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchModelImpl &&
            (identical(other.warning, warning) || other.warning == warning) &&
            (identical(other.noResults, noResults) ||
                other.noResults == noResults) &&
            (identical(other.searchCategoryId, searchCategoryId) ||
                other.searchCategoryId == searchCategoryId) &&
            (identical(other.q, q) || other.q == q) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.isc, isc) || other.isc == isc) &&
            (identical(other.mid, mid) || other.mid == mid) &&
            (identical(other.vid, vid) || other.vid == vid) &&
            (identical(other.pf, pf) || other.pf == pf) &&
            (identical(other.pt, pt) || other.pt == pt) &&
            (identical(other.sid, sid) || other.sid == sid) &&
            (identical(other.adv, adv) || other.adv == adv) &&
            (identical(other.asv, asv) || other.asv == asv) &&
            (identical(other.box, box) || other.box == box) &&
            const DeepCollectionEquality().equals(
              other._availableCategories,
              _availableCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableCollections,
              _availableCollections,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableVendors,
              _availableVendors,
            ) &&
            (identical(other.pagingFilteringContext, pagingFilteringContext) ||
                other.pagingFilteringContext == pagingFilteringContext) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    warning,
    noResults,
    searchCategoryId,
    q,
    cid,
    isc,
    mid,
    vid,
    pf,
    pt,
    sid,
    adv,
    asv,
    box,
    const DeepCollectionEquality().hash(_availableCategories),
    const DeepCollectionEquality().hash(_availableCollections),
    const DeepCollectionEquality().hash(_availableVendors),
    pagingFilteringContext,
    const DeepCollectionEquality().hash(_products),
    const DeepCollectionEquality().hash(_userFields),
  ]);

  /// Create a copy of SearchModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchModelImplCopyWith<_$SearchModelImpl> get copyWith =>
      __$$SearchModelImplCopyWithImpl<_$SearchModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchModelImplToJson(this);
  }
}

abstract class _SearchModel implements SearchModel {
  factory _SearchModel({
    @JsonKey(name: 'Warning', includeIfNull: false) final String? warning,
    @JsonKey(name: 'NoResults', includeIfNull: false) final bool? noResults,
    @JsonKey(name: 'SearchCategoryId', includeIfNull: false)
    final String? searchCategoryId,
    @JsonKey(name: 'q', includeIfNull: false) final String? q,
    @JsonKey(name: 'cid', includeIfNull: false) final String? cid,
    @JsonKey(name: 'isc', includeIfNull: false) final bool? isc,
    @JsonKey(name: 'mid', includeIfNull: false) final String? mid,
    @JsonKey(name: 'vid', includeIfNull: false) final String? vid,
    @JsonKey(name: 'pf', includeIfNull: false) final String? pf,
    @JsonKey(name: 'pt', includeIfNull: false) final String? pt,
    @JsonKey(name: 'sid', includeIfNull: false) final bool? sid,
    @JsonKey(name: 'adv', includeIfNull: false) final bool? adv,
    @JsonKey(name: 'asv', includeIfNull: false) final bool? asv,
    @JsonKey(name: 'Box', includeIfNull: false) final bool? box,
    @JsonKey(name: 'AvailableCategories', includeIfNull: false)
    final List<SelectListItem>? availableCategories,
    @JsonKey(name: 'AvailableCollections', includeIfNull: false)
    final List<SelectListItem>? availableCollections,
    @JsonKey(name: 'AvailableVendors', includeIfNull: false)
    final List<SelectListItem>? availableVendors,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    final CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$SearchModelImpl;

  factory _SearchModel.fromJson(Map<String, dynamic> json) =
      _$SearchModelImpl.fromJson;

  @override
  @JsonKey(name: 'Warning', includeIfNull: false)
  String? get warning;
  @override
  @JsonKey(name: 'NoResults', includeIfNull: false)
  bool? get noResults;
  @override
  @JsonKey(name: 'SearchCategoryId', includeIfNull: false)
  String? get searchCategoryId;
  @override
  @JsonKey(name: 'q', includeIfNull: false)
  String? get q;
  @override
  @JsonKey(name: 'cid', includeIfNull: false)
  String? get cid;
  @override
  @JsonKey(name: 'isc', includeIfNull: false)
  bool? get isc;
  @override
  @JsonKey(name: 'mid', includeIfNull: false)
  String? get mid;
  @override
  @JsonKey(name: 'vid', includeIfNull: false)
  String? get vid;
  @override
  @JsonKey(name: 'pf', includeIfNull: false)
  String? get pf;
  @override
  @JsonKey(name: 'pt', includeIfNull: false)
  String? get pt;
  @override
  @JsonKey(name: 'sid', includeIfNull: false)
  bool? get sid;
  @override
  @JsonKey(name: 'adv', includeIfNull: false)
  bool? get adv;
  @override
  @JsonKey(name: 'asv', includeIfNull: false)
  bool? get asv;
  @override
  @JsonKey(name: 'Box', includeIfNull: false)
  bool? get box;
  @override
  @JsonKey(name: 'AvailableCategories', includeIfNull: false)
  List<SelectListItem>? get availableCategories;
  @override
  @JsonKey(name: 'AvailableCollections', includeIfNull: false)
  List<SelectListItem>? get availableCollections;
  @override
  @JsonKey(name: 'AvailableVendors', includeIfNull: false)
  List<SelectListItem>? get availableVendors;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  CatalogPagingFilteringModel? get pagingFilteringContext;
  @override
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of SearchModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchModelImplCopyWith<_$SearchModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
