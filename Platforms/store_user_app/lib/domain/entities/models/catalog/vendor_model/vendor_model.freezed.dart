// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VendorModel _$VendorModelFromJson(Map<String, dynamic> json) {
  return _VendorModel.fromJson(json);
}

/// @nodoc
mixin _$VendorModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaKeywords', includeIfNull: false)
  String? get metaKeywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaDescription', includeIfNull: false)
  String? get metaDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaTitle', includeIfNull: false)
  String? get metaTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowCustomersToContactVendors', includeIfNull: false)
  bool? get allowCustomersToContactVendors =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'RenderCaptcha', includeIfNull: false)
  bool? get renderCaptcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Address', includeIfNull: false)
  VendorAddressModel? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  CatalogPagingFilteringModel? get pagingFilteringContext =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
  VendorReviewOverviewModel? get vendorReviewOverview =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this VendorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorModelCopyWith<VendorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorModelCopyWith<$Res> {
  factory $VendorModelCopyWith(
    VendorModel value,
    $Res Function(VendorModel) then,
  ) = _$VendorModelCopyWithImpl<$Res, VendorModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'AllowCustomersToContactVendors', includeIfNull: false)
    bool? allowCustomersToContactVendors,
    @JsonKey(name: 'RenderCaptcha', includeIfNull: false) bool? renderCaptcha,
    @JsonKey(name: 'Address', includeIfNull: false) VendorAddressModel? address,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
    VendorReviewOverviewModel? vendorReviewOverview,
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $VendorAddressModelCopyWith<$Res>? get address;
  $PictureModelCopyWith<$Res>? get pictureModel;
  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
  $VendorReviewOverviewModelCopyWith<$Res>? get vendorReviewOverview;
}

/// @nodoc
class _$VendorModelCopyWithImpl<$Res, $Val extends VendorModel>
    implements $VendorModelCopyWith<$Res> {
  _$VendorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? seName = freezed,
    Object? allowCustomersToContactVendors = freezed,
    Object? renderCaptcha = freezed,
    Object? address = freezed,
    Object? pictureModel = freezed,
    Object? pagingFilteringContext = freezed,
    Object? vendorReviewOverview = freezed,
    Object? products = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            metaKeywords:
                freezed == metaKeywords
                    ? _value.metaKeywords
                    : metaKeywords // ignore: cast_nullable_to_non_nullable
                        as String?,
            metaDescription:
                freezed == metaDescription
                    ? _value.metaDescription
                    : metaDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            metaTitle:
                freezed == metaTitle
                    ? _value.metaTitle
                    : metaTitle // ignore: cast_nullable_to_non_nullable
                        as String?,
            seName:
                freezed == seName
                    ? _value.seName
                    : seName // ignore: cast_nullable_to_non_nullable
                        as String?,
            allowCustomersToContactVendors:
                freezed == allowCustomersToContactVendors
                    ? _value.allowCustomersToContactVendors
                    : allowCustomersToContactVendors // ignore: cast_nullable_to_non_nullable
                        as bool?,
            renderCaptcha:
                freezed == renderCaptcha
                    ? _value.renderCaptcha
                    : renderCaptcha // ignore: cast_nullable_to_non_nullable
                        as bool?,
            address:
                freezed == address
                    ? _value.address
                    : address // ignore: cast_nullable_to_non_nullable
                        as VendorAddressModel?,
            pictureModel:
                freezed == pictureModel
                    ? _value.pictureModel
                    : pictureModel // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            pagingFilteringContext:
                freezed == pagingFilteringContext
                    ? _value.pagingFilteringContext
                    : pagingFilteringContext // ignore: cast_nullable_to_non_nullable
                        as CatalogPagingFilteringModel?,
            vendorReviewOverview:
                freezed == vendorReviewOverview
                    ? _value.vendorReviewOverview
                    : vendorReviewOverview // ignore: cast_nullable_to_non_nullable
                        as VendorReviewOverviewModel?,
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

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorAddressModelCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $VendorAddressModelCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PictureModelCopyWith<$Res>? get pictureModel {
    if (_value.pictureModel == null) {
      return null;
    }

    return $PictureModelCopyWith<$Res>(_value.pictureModel!, (value) {
      return _then(_value.copyWith(pictureModel: value) as $Val);
    });
  }

  /// Create a copy of VendorModel
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

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorReviewOverviewModelCopyWith<$Res>? get vendorReviewOverview {
    if (_value.vendorReviewOverview == null) {
      return null;
    }

    return $VendorReviewOverviewModelCopyWith<$Res>(
      _value.vendorReviewOverview!,
      (value) {
        return _then(_value.copyWith(vendorReviewOverview: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$VendorModelImplCopyWith<$Res>
    implements $VendorModelCopyWith<$Res> {
  factory _$$VendorModelImplCopyWith(
    _$VendorModelImpl value,
    $Res Function(_$VendorModelImpl) then,
  ) = __$$VendorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'AllowCustomersToContactVendors', includeIfNull: false)
    bool? allowCustomersToContactVendors,
    @JsonKey(name: 'RenderCaptcha', includeIfNull: false) bool? renderCaptcha,
    @JsonKey(name: 'Address', includeIfNull: false) VendorAddressModel? address,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
    VendorReviewOverviewModel? vendorReviewOverview,
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $VendorAddressModelCopyWith<$Res>? get address;
  @override
  $PictureModelCopyWith<$Res>? get pictureModel;
  @override
  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
  @override
  $VendorReviewOverviewModelCopyWith<$Res>? get vendorReviewOverview;
}

/// @nodoc
class __$$VendorModelImplCopyWithImpl<$Res>
    extends _$VendorModelCopyWithImpl<$Res, _$VendorModelImpl>
    implements _$$VendorModelImplCopyWith<$Res> {
  __$$VendorModelImplCopyWithImpl(
    _$VendorModelImpl _value,
    $Res Function(_$VendorModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? seName = freezed,
    Object? allowCustomersToContactVendors = freezed,
    Object? renderCaptcha = freezed,
    Object? address = freezed,
    Object? pictureModel = freezed,
    Object? pagingFilteringContext = freezed,
    Object? vendorReviewOverview = freezed,
    Object? products = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$VendorModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        metaKeywords:
            freezed == metaKeywords
                ? _value.metaKeywords
                : metaKeywords // ignore: cast_nullable_to_non_nullable
                    as String?,
        metaDescription:
            freezed == metaDescription
                ? _value.metaDescription
                : metaDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        metaTitle:
            freezed == metaTitle
                ? _value.metaTitle
                : metaTitle // ignore: cast_nullable_to_non_nullable
                    as String?,
        seName:
            freezed == seName
                ? _value.seName
                : seName // ignore: cast_nullable_to_non_nullable
                    as String?,
        allowCustomersToContactVendors:
            freezed == allowCustomersToContactVendors
                ? _value.allowCustomersToContactVendors
                : allowCustomersToContactVendors // ignore: cast_nullable_to_non_nullable
                    as bool?,
        renderCaptcha:
            freezed == renderCaptcha
                ? _value.renderCaptcha
                : renderCaptcha // ignore: cast_nullable_to_non_nullable
                    as bool?,
        address:
            freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                    as VendorAddressModel?,
        pictureModel:
            freezed == pictureModel
                ? _value.pictureModel
                : pictureModel // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
        pagingFilteringContext:
            freezed == pagingFilteringContext
                ? _value.pagingFilteringContext
                : pagingFilteringContext // ignore: cast_nullable_to_non_nullable
                    as CatalogPagingFilteringModel?,
        vendorReviewOverview:
            freezed == vendorReviewOverview
                ? _value.vendorReviewOverview
                : vendorReviewOverview // ignore: cast_nullable_to_non_nullable
                    as VendorReviewOverviewModel?,
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
class _$VendorModelImpl implements _VendorModel {
  _$VendorModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) this.metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    this.metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) this.metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'AllowCustomersToContactVendors', includeIfNull: false)
    this.allowCustomersToContactVendors = false,
    @JsonKey(name: 'RenderCaptcha', includeIfNull: false)
    this.renderCaptcha = false,
    @JsonKey(name: 'Address', includeIfNull: false) this.address,
    @JsonKey(name: 'PictureModel', includeIfNull: false) this.pictureModel,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    this.pagingFilteringContext,
    @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
    this.vendorReviewOverview,
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _products = products,
       _userFields = userFields;

  factory _$VendorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'MetaKeywords', includeIfNull: false)
  final String? metaKeywords;
  @override
  @JsonKey(name: 'MetaDescription', includeIfNull: false)
  final String? metaDescription;
  @override
  @JsonKey(name: 'MetaTitle', includeIfNull: false)
  final String? metaTitle;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
  @override
  @JsonKey(name: 'AllowCustomersToContactVendors', includeIfNull: false)
  final bool? allowCustomersToContactVendors;
  @override
  @JsonKey(name: 'RenderCaptcha', includeIfNull: false)
  final bool? renderCaptcha;
  @override
  @JsonKey(name: 'Address', includeIfNull: false)
  final VendorAddressModel? address;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  final PictureModel? pictureModel;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  final CatalogPagingFilteringModel? pagingFilteringContext;
  @override
  @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
  final VendorReviewOverviewModel? vendorReviewOverview;
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
    return 'VendorModel(name: $name, description: $description, metaKeywords: $metaKeywords, metaDescription: $metaDescription, metaTitle: $metaTitle, seName: $seName, allowCustomersToContactVendors: $allowCustomersToContactVendors, renderCaptcha: $renderCaptcha, address: $address, pictureModel: $pictureModel, pagingFilteringContext: $pagingFilteringContext, vendorReviewOverview: $vendorReviewOverview, products: $products, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.metaKeywords, metaKeywords) ||
                other.metaKeywords == metaKeywords) &&
            (identical(other.metaDescription, metaDescription) ||
                other.metaDescription == metaDescription) &&
            (identical(other.metaTitle, metaTitle) ||
                other.metaTitle == metaTitle) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(
                  other.allowCustomersToContactVendors,
                  allowCustomersToContactVendors,
                ) ||
                other.allowCustomersToContactVendors ==
                    allowCustomersToContactVendors) &&
            (identical(other.renderCaptcha, renderCaptcha) ||
                other.renderCaptcha == renderCaptcha) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.pictureModel, pictureModel) ||
                other.pictureModel == pictureModel) &&
            (identical(other.pagingFilteringContext, pagingFilteringContext) ||
                other.pagingFilteringContext == pagingFilteringContext) &&
            (identical(other.vendorReviewOverview, vendorReviewOverview) ||
                other.vendorReviewOverview == vendorReviewOverview) &&
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
    name,
    description,
    metaKeywords,
    metaDescription,
    metaTitle,
    seName,
    allowCustomersToContactVendors,
    renderCaptcha,
    address,
    pictureModel,
    pagingFilteringContext,
    vendorReviewOverview,
    const DeepCollectionEquality().hash(_products),
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorModelImplCopyWith<_$VendorModelImpl> get copyWith =>
      __$$VendorModelImplCopyWithImpl<_$VendorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorModelImplToJson(this);
  }
}

abstract class _VendorModel implements VendorModel {
  factory _VendorModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false)
    final String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    final String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) final String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'AllowCustomersToContactVendors', includeIfNull: false)
    final bool? allowCustomersToContactVendors,
    @JsonKey(name: 'RenderCaptcha', includeIfNull: false)
    final bool? renderCaptcha,
    @JsonKey(name: 'Address', includeIfNull: false)
    final VendorAddressModel? address,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    final PictureModel? pictureModel,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    final CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
    final VendorReviewOverviewModel? vendorReviewOverview,
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$VendorModelImpl;

  factory _VendorModel.fromJson(Map<String, dynamic> json) =
      _$VendorModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'MetaKeywords', includeIfNull: false)
  String? get metaKeywords;
  @override
  @JsonKey(name: 'MetaDescription', includeIfNull: false)
  String? get metaDescription;
  @override
  @JsonKey(name: 'MetaTitle', includeIfNull: false)
  String? get metaTitle;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'AllowCustomersToContactVendors', includeIfNull: false)
  bool? get allowCustomersToContactVendors;
  @override
  @JsonKey(name: 'RenderCaptcha', includeIfNull: false)
  bool? get renderCaptcha;
  @override
  @JsonKey(name: 'Address', includeIfNull: false)
  VendorAddressModel? get address;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  CatalogPagingFilteringModel? get pagingFilteringContext;
  @override
  @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
  VendorReviewOverviewModel? get vendorReviewOverview;
  @override
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of VendorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorModelImplCopyWith<_$VendorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
