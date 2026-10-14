// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return _CategoryModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryModel {
  @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
  String? get parentCategoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'BottomDescription', includeIfNull: false)
  String? get bottomDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaKeywords', includeIfNull: false)
  String? get metaKeywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaDescription', includeIfNull: false)
  String? get metaDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaTitle', includeIfNull: false)
  String? get metaTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Flag', includeIfNull: false)
  String? get flag => throw _privateConstructorUsedError;
  @JsonKey(name: 'FlagStyle', includeIfNull: false)
  String? get flagStyle => throw _privateConstructorUsedError;
  @JsonKey(name: 'Icon', includeIfNull: false)
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  CatalogPagingFilteringModel? get pagingFilteringContext =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayCategoryBreadcrumb', includeIfNull: false)
  bool? get displayCategoryBreadcrumb => throw _privateConstructorUsedError;
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<CategoryModel>? get categoryBreadcrumb =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'SubCategories', includeIfNull: false)
  List<SubCategoryModel>? get subCategories =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'FeaturedProducts', includeIfNull: false)
  List<ProductOverviewModel>? get featuredProducts =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryModelCopyWith<CategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryModelCopyWith<$Res> {
  factory $CategoryModelCopyWith(
    CategoryModel value,
    $Res Function(CategoryModel) then,
  ) = _$CategoryModelCopyWithImpl<$Res, CategoryModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
    String? parentCategoryId,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'BottomDescription', includeIfNull: false)
    String? bottomDescription,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) String? flagStyle,
    @JsonKey(name: 'Icon', includeIfNull: false) String? icon,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'DisplayCategoryBreadcrumb', includeIfNull: false)
    bool? displayCategoryBreadcrumb,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    List<CategoryModel>? categoryBreadcrumb,
    @JsonKey(name: 'SubCategories', includeIfNull: false)
    List<SubCategoryModel>? subCategories,
    @JsonKey(name: 'FeaturedProducts', includeIfNull: false)
    List<ProductOverviewModel>? featuredProducts,
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $PictureModelCopyWith<$Res>? get pictureModel;
  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
}

/// @nodoc
class _$CategoryModelCopyWithImpl<$Res, $Val extends CategoryModel>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parentCategoryId = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? bottomDescription = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? seName = freezed,
    Object? flag = freezed,
    Object? flagStyle = freezed,
    Object? icon = freezed,
    Object? pictureModel = freezed,
    Object? pagingFilteringContext = freezed,
    Object? displayCategoryBreadcrumb = freezed,
    Object? categoryBreadcrumb = freezed,
    Object? subCategories = freezed,
    Object? featuredProducts = freezed,
    Object? products = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            parentCategoryId:
                freezed == parentCategoryId
                    ? _value.parentCategoryId
                    : parentCategoryId // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            bottomDescription:
                freezed == bottomDescription
                    ? _value.bottomDescription
                    : bottomDescription // ignore: cast_nullable_to_non_nullable
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
            flag:
                freezed == flag
                    ? _value.flag
                    : flag // ignore: cast_nullable_to_non_nullable
                        as String?,
            flagStyle:
                freezed == flagStyle
                    ? _value.flagStyle
                    : flagStyle // ignore: cast_nullable_to_non_nullable
                        as String?,
            icon:
                freezed == icon
                    ? _value.icon
                    : icon // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            displayCategoryBreadcrumb:
                freezed == displayCategoryBreadcrumb
                    ? _value.displayCategoryBreadcrumb
                    : displayCategoryBreadcrumb // ignore: cast_nullable_to_non_nullable
                        as bool?,
            categoryBreadcrumb:
                freezed == categoryBreadcrumb
                    ? _value.categoryBreadcrumb
                    : categoryBreadcrumb // ignore: cast_nullable_to_non_nullable
                        as List<CategoryModel>?,
            subCategories:
                freezed == subCategories
                    ? _value.subCategories
                    : subCategories // ignore: cast_nullable_to_non_nullable
                        as List<SubCategoryModel>?,
            featuredProducts:
                freezed == featuredProducts
                    ? _value.featuredProducts
                    : featuredProducts // ignore: cast_nullable_to_non_nullable
                        as List<ProductOverviewModel>?,
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

  /// Create a copy of CategoryModel
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

  /// Create a copy of CategoryModel
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
abstract class _$$CategoryModelImplCopyWith<$Res>
    implements $CategoryModelCopyWith<$Res> {
  factory _$$CategoryModelImplCopyWith(
    _$CategoryModelImpl value,
    $Res Function(_$CategoryModelImpl) then,
  ) = __$$CategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
    String? parentCategoryId,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'BottomDescription', includeIfNull: false)
    String? bottomDescription,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) String? flagStyle,
    @JsonKey(name: 'Icon', includeIfNull: false) String? icon,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'DisplayCategoryBreadcrumb', includeIfNull: false)
    bool? displayCategoryBreadcrumb,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    List<CategoryModel>? categoryBreadcrumb,
    @JsonKey(name: 'SubCategories', includeIfNull: false)
    List<SubCategoryModel>? subCategories,
    @JsonKey(name: 'FeaturedProducts', includeIfNull: false)
    List<ProductOverviewModel>? featuredProducts,
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $PictureModelCopyWith<$Res>? get pictureModel;
  @override
  $CatalogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
}

/// @nodoc
class __$$CategoryModelImplCopyWithImpl<$Res>
    extends _$CategoryModelCopyWithImpl<$Res, _$CategoryModelImpl>
    implements _$$CategoryModelImplCopyWith<$Res> {
  __$$CategoryModelImplCopyWithImpl(
    _$CategoryModelImpl _value,
    $Res Function(_$CategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parentCategoryId = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? bottomDescription = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? seName = freezed,
    Object? flag = freezed,
    Object? flagStyle = freezed,
    Object? icon = freezed,
    Object? pictureModel = freezed,
    Object? pagingFilteringContext = freezed,
    Object? displayCategoryBreadcrumb = freezed,
    Object? categoryBreadcrumb = freezed,
    Object? subCategories = freezed,
    Object? featuredProducts = freezed,
    Object? products = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CategoryModelImpl(
        parentCategoryId:
            freezed == parentCategoryId
                ? _value.parentCategoryId
                : parentCategoryId // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        bottomDescription:
            freezed == bottomDescription
                ? _value.bottomDescription
                : bottomDescription // ignore: cast_nullable_to_non_nullable
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
        flag:
            freezed == flag
                ? _value.flag
                : flag // ignore: cast_nullable_to_non_nullable
                    as String?,
        flagStyle:
            freezed == flagStyle
                ? _value.flagStyle
                : flagStyle // ignore: cast_nullable_to_non_nullable
                    as String?,
        icon:
            freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        displayCategoryBreadcrumb:
            freezed == displayCategoryBreadcrumb
                ? _value.displayCategoryBreadcrumb
                : displayCategoryBreadcrumb // ignore: cast_nullable_to_non_nullable
                    as bool?,
        categoryBreadcrumb:
            freezed == categoryBreadcrumb
                ? _value._categoryBreadcrumb
                : categoryBreadcrumb // ignore: cast_nullable_to_non_nullable
                    as List<CategoryModel>?,
        subCategories:
            freezed == subCategories
                ? _value._subCategories
                : subCategories // ignore: cast_nullable_to_non_nullable
                    as List<SubCategoryModel>?,
        featuredProducts:
            freezed == featuredProducts
                ? _value._featuredProducts
                : featuredProducts // ignore: cast_nullable_to_non_nullable
                    as List<ProductOverviewModel>?,
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
class _$CategoryModelImpl implements _CategoryModel {
  _$CategoryModelImpl({
    @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
    this.parentCategoryId,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'BottomDescription', includeIfNull: false)
    this.bottomDescription,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) this.metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    this.metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) this.metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'Flag', includeIfNull: false) this.flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) this.flagStyle,
    @JsonKey(name: 'Icon', includeIfNull: false) this.icon,
    @JsonKey(name: 'PictureModel', includeIfNull: false) this.pictureModel,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    this.pagingFilteringContext,
    @JsonKey(name: 'DisplayCategoryBreadcrumb', includeIfNull: false)
    this.displayCategoryBreadcrumb = false,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    final List<CategoryModel>? categoryBreadcrumb = const [],
    @JsonKey(name: 'SubCategories', includeIfNull: false)
    final List<SubCategoryModel>? subCategories = const [],
    @JsonKey(name: 'FeaturedProducts', includeIfNull: false)
    final List<ProductOverviewModel>? featuredProducts = const [],
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _categoryBreadcrumb = categoryBreadcrumb,
       _subCategories = subCategories,
       _featuredProducts = featuredProducts,
       _products = products,
       _userFields = userFields;

  factory _$CategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryModelImplFromJson(json);

  @override
  @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
  final String? parentCategoryId;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'BottomDescription', includeIfNull: false)
  final String? bottomDescription;
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
  @JsonKey(name: 'Flag', includeIfNull: false)
  final String? flag;
  @override
  @JsonKey(name: 'FlagStyle', includeIfNull: false)
  final String? flagStyle;
  @override
  @JsonKey(name: 'Icon', includeIfNull: false)
  final String? icon;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  final PictureModel? pictureModel;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  final CatalogPagingFilteringModel? pagingFilteringContext;
  @override
  @JsonKey(name: 'DisplayCategoryBreadcrumb', includeIfNull: false)
  final bool? displayCategoryBreadcrumb;
  final List<CategoryModel>? _categoryBreadcrumb;
  @override
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<CategoryModel>? get categoryBreadcrumb {
    final value = _categoryBreadcrumb;
    if (value == null) return null;
    if (_categoryBreadcrumb is EqualUnmodifiableListView)
      return _categoryBreadcrumb;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SubCategoryModel>? _subCategories;
  @override
  @JsonKey(name: 'SubCategories', includeIfNull: false)
  List<SubCategoryModel>? get subCategories {
    final value = _subCategories;
    if (value == null) return null;
    if (_subCategories is EqualUnmodifiableListView) return _subCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ProductOverviewModel>? _featuredProducts;
  @override
  @JsonKey(name: 'FeaturedProducts', includeIfNull: false)
  List<ProductOverviewModel>? get featuredProducts {
    final value = _featuredProducts;
    if (value == null) return null;
    if (_featuredProducts is EqualUnmodifiableListView)
      return _featuredProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'CategoryModel(parentCategoryId: $parentCategoryId, name: $name, description: $description, bottomDescription: $bottomDescription, metaKeywords: $metaKeywords, metaDescription: $metaDescription, metaTitle: $metaTitle, seName: $seName, flag: $flag, flagStyle: $flagStyle, icon: $icon, pictureModel: $pictureModel, pagingFilteringContext: $pagingFilteringContext, displayCategoryBreadcrumb: $displayCategoryBreadcrumb, categoryBreadcrumb: $categoryBreadcrumb, subCategories: $subCategories, featuredProducts: $featuredProducts, products: $products, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryModelImpl &&
            (identical(other.parentCategoryId, parentCategoryId) ||
                other.parentCategoryId == parentCategoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.bottomDescription, bottomDescription) ||
                other.bottomDescription == bottomDescription) &&
            (identical(other.metaKeywords, metaKeywords) ||
                other.metaKeywords == metaKeywords) &&
            (identical(other.metaDescription, metaDescription) ||
                other.metaDescription == metaDescription) &&
            (identical(other.metaTitle, metaTitle) ||
                other.metaTitle == metaTitle) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.flag, flag) || other.flag == flag) &&
            (identical(other.flagStyle, flagStyle) ||
                other.flagStyle == flagStyle) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.pictureModel, pictureModel) ||
                other.pictureModel == pictureModel) &&
            (identical(other.pagingFilteringContext, pagingFilteringContext) ||
                other.pagingFilteringContext == pagingFilteringContext) &&
            (identical(
                  other.displayCategoryBreadcrumb,
                  displayCategoryBreadcrumb,
                ) ||
                other.displayCategoryBreadcrumb == displayCategoryBreadcrumb) &&
            const DeepCollectionEquality().equals(
              other._categoryBreadcrumb,
              _categoryBreadcrumb,
            ) &&
            const DeepCollectionEquality().equals(
              other._subCategories,
              _subCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._featuredProducts,
              _featuredProducts,
            ) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    parentCategoryId,
    name,
    description,
    bottomDescription,
    metaKeywords,
    metaDescription,
    metaTitle,
    seName,
    flag,
    flagStyle,
    icon,
    pictureModel,
    pagingFilteringContext,
    displayCategoryBreadcrumb,
    const DeepCollectionEquality().hash(_categoryBreadcrumb),
    const DeepCollectionEquality().hash(_subCategories),
    const DeepCollectionEquality().hash(_featuredProducts),
    const DeepCollectionEquality().hash(_products),
    id,
    const DeepCollectionEquality().hash(_userFields),
  ]);

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      __$$CategoryModelImplCopyWithImpl<_$CategoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryModelImplToJson(this);
  }
}

abstract class _CategoryModel implements CategoryModel {
  factory _CategoryModel({
    @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
    final String? parentCategoryId,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'BottomDescription', includeIfNull: false)
    final String? bottomDescription,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false)
    final String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    final String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) final String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'Flag', includeIfNull: false) final String? flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) final String? flagStyle,
    @JsonKey(name: 'Icon', includeIfNull: false) final String? icon,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    final PictureModel? pictureModel,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    final CatalogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'DisplayCategoryBreadcrumb', includeIfNull: false)
    final bool? displayCategoryBreadcrumb,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    final List<CategoryModel>? categoryBreadcrumb,
    @JsonKey(name: 'SubCategories', includeIfNull: false)
    final List<SubCategoryModel>? subCategories,
    @JsonKey(name: 'FeaturedProducts', includeIfNull: false)
    final List<ProductOverviewModel>? featuredProducts,
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CategoryModelImpl;

  factory _CategoryModel.fromJson(Map<String, dynamic> json) =
      _$CategoryModelImpl.fromJson;

  @override
  @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
  String? get parentCategoryId;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'BottomDescription', includeIfNull: false)
  String? get bottomDescription;
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
  @JsonKey(name: 'Flag', includeIfNull: false)
  String? get flag;
  @override
  @JsonKey(name: 'FlagStyle', includeIfNull: false)
  String? get flagStyle;
  @override
  @JsonKey(name: 'Icon', includeIfNull: false)
  String? get icon;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  CatalogPagingFilteringModel? get pagingFilteringContext;
  @override
  @JsonKey(name: 'DisplayCategoryBreadcrumb', includeIfNull: false)
  bool? get displayCategoryBreadcrumb;
  @override
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<CategoryModel>? get categoryBreadcrumb;
  @override
  @JsonKey(name: 'SubCategories', includeIfNull: false)
  List<SubCategoryModel>? get subCategories;
  @override
  @JsonKey(name: 'FeaturedProducts', includeIfNull: false)
  List<ProductOverviewModel>? get featuredProducts;
  @override
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
