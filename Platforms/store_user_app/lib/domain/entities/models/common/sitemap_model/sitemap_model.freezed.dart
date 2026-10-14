// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sitemap_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SitemapModel _$SitemapModelFromJson(Map<String, dynamic> json) {
  return _SitemapModel.fromJson(json);
}

/// @nodoc
mixin _$SitemapModel {
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Categories', includeIfNull: false)
  List<CategoryModel>? get categories => throw _privateConstructorUsedError;
  @JsonKey(name: 'Brands', includeIfNull: false)
  List<BrandModel>? get brands => throw _privateConstructorUsedError;
  @JsonKey(name: 'Pages', includeIfNull: false)
  List<PageModel>? get pages => throw _privateConstructorUsedError;
  @JsonKey(name: 'BlogPosts', includeIfNull: false)
  List<BlogPostModel>? get blogPosts => throw _privateConstructorUsedError;
  @JsonKey(name: 'KnowledgebaseArticles', includeIfNull: false)
  List<KnowledgebaseItemModel>? get knowledgebaseArticles =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'NewsEnabled', includeIfNull: false)
  bool? get newsEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'BlogEnabled', includeIfNull: false)
  bool? get blogEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'KnowledgebaseEnabled', includeIfNull: false)
  bool? get knowledgebaseEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this SitemapModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SitemapModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SitemapModelCopyWith<SitemapModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SitemapModelCopyWith<$Res> {
  factory $SitemapModelCopyWith(
    SitemapModel value,
    $Res Function(SitemapModel) then,
  ) = _$SitemapModelCopyWithImpl<$Res, SitemapModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(name: 'Categories', includeIfNull: false)
    List<CategoryModel>? categories,
    @JsonKey(name: 'Brands', includeIfNull: false) List<BrandModel>? brands,
    @JsonKey(name: 'Pages', includeIfNull: false) List<PageModel>? pages,
    @JsonKey(name: 'BlogPosts', includeIfNull: false)
    List<BlogPostModel>? blogPosts,
    @JsonKey(name: 'KnowledgebaseArticles', includeIfNull: false)
    List<KnowledgebaseItemModel>? knowledgebaseArticles,
    @JsonKey(name: 'NewsEnabled', includeIfNull: false) bool? newsEnabled,
    @JsonKey(name: 'BlogEnabled', includeIfNull: false) bool? blogEnabled,
    @JsonKey(name: 'KnowledgebaseEnabled', includeIfNull: false)
    bool? knowledgebaseEnabled,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$SitemapModelCopyWithImpl<$Res, $Val extends SitemapModel>
    implements $SitemapModelCopyWith<$Res> {
  _$SitemapModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SitemapModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = freezed,
    Object? categories = freezed,
    Object? brands = freezed,
    Object? pages = freezed,
    Object? blogPosts = freezed,
    Object? knowledgebaseArticles = freezed,
    Object? newsEnabled = freezed,
    Object? blogEnabled = freezed,
    Object? knowledgebaseEnabled = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            products:
                freezed == products
                    ? _value.products
                    : products // ignore: cast_nullable_to_non_nullable
                        as List<ProductOverviewModel>?,
            categories:
                freezed == categories
                    ? _value.categories
                    : categories // ignore: cast_nullable_to_non_nullable
                        as List<CategoryModel>?,
            brands:
                freezed == brands
                    ? _value.brands
                    : brands // ignore: cast_nullable_to_non_nullable
                        as List<BrandModel>?,
            pages:
                freezed == pages
                    ? _value.pages
                    : pages // ignore: cast_nullable_to_non_nullable
                        as List<PageModel>?,
            blogPosts:
                freezed == blogPosts
                    ? _value.blogPosts
                    : blogPosts // ignore: cast_nullable_to_non_nullable
                        as List<BlogPostModel>?,
            knowledgebaseArticles:
                freezed == knowledgebaseArticles
                    ? _value.knowledgebaseArticles
                    : knowledgebaseArticles // ignore: cast_nullable_to_non_nullable
                        as List<KnowledgebaseItemModel>?,
            newsEnabled:
                freezed == newsEnabled
                    ? _value.newsEnabled
                    : newsEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            blogEnabled:
                freezed == blogEnabled
                    ? _value.blogEnabled
                    : blogEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            knowledgebaseEnabled:
                freezed == knowledgebaseEnabled
                    ? _value.knowledgebaseEnabled
                    : knowledgebaseEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
abstract class _$$SitemapModelImplCopyWith<$Res>
    implements $SitemapModelCopyWith<$Res> {
  factory _$$SitemapModelImplCopyWith(
    _$SitemapModelImpl value,
    $Res Function(_$SitemapModelImpl) then,
  ) = __$$SitemapModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Products', includeIfNull: false)
    List<ProductOverviewModel>? products,
    @JsonKey(name: 'Categories', includeIfNull: false)
    List<CategoryModel>? categories,
    @JsonKey(name: 'Brands', includeIfNull: false) List<BrandModel>? brands,
    @JsonKey(name: 'Pages', includeIfNull: false) List<PageModel>? pages,
    @JsonKey(name: 'BlogPosts', includeIfNull: false)
    List<BlogPostModel>? blogPosts,
    @JsonKey(name: 'KnowledgebaseArticles', includeIfNull: false)
    List<KnowledgebaseItemModel>? knowledgebaseArticles,
    @JsonKey(name: 'NewsEnabled', includeIfNull: false) bool? newsEnabled,
    @JsonKey(name: 'BlogEnabled', includeIfNull: false) bool? blogEnabled,
    @JsonKey(name: 'KnowledgebaseEnabled', includeIfNull: false)
    bool? knowledgebaseEnabled,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$SitemapModelImplCopyWithImpl<$Res>
    extends _$SitemapModelCopyWithImpl<$Res, _$SitemapModelImpl>
    implements _$$SitemapModelImplCopyWith<$Res> {
  __$$SitemapModelImplCopyWithImpl(
    _$SitemapModelImpl _value,
    $Res Function(_$SitemapModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SitemapModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = freezed,
    Object? categories = freezed,
    Object? brands = freezed,
    Object? pages = freezed,
    Object? blogPosts = freezed,
    Object? knowledgebaseArticles = freezed,
    Object? newsEnabled = freezed,
    Object? blogEnabled = freezed,
    Object? knowledgebaseEnabled = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$SitemapModelImpl(
        products:
            freezed == products
                ? _value._products
                : products // ignore: cast_nullable_to_non_nullable
                    as List<ProductOverviewModel>?,
        categories:
            freezed == categories
                ? _value._categories
                : categories // ignore: cast_nullable_to_non_nullable
                    as List<CategoryModel>?,
        brands:
            freezed == brands
                ? _value._brands
                : brands // ignore: cast_nullable_to_non_nullable
                    as List<BrandModel>?,
        pages:
            freezed == pages
                ? _value._pages
                : pages // ignore: cast_nullable_to_non_nullable
                    as List<PageModel>?,
        blogPosts:
            freezed == blogPosts
                ? _value._blogPosts
                : blogPosts // ignore: cast_nullable_to_non_nullable
                    as List<BlogPostModel>?,
        knowledgebaseArticles:
            freezed == knowledgebaseArticles
                ? _value._knowledgebaseArticles
                : knowledgebaseArticles // ignore: cast_nullable_to_non_nullable
                    as List<KnowledgebaseItemModel>?,
        newsEnabled:
            freezed == newsEnabled
                ? _value.newsEnabled
                : newsEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        blogEnabled:
            freezed == blogEnabled
                ? _value.blogEnabled
                : blogEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        knowledgebaseEnabled:
            freezed == knowledgebaseEnabled
                ? _value.knowledgebaseEnabled
                : knowledgebaseEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$SitemapModelImpl implements _SitemapModel {
  _$SitemapModelImpl({
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products = const [],
    @JsonKey(name: 'Categories', includeIfNull: false)
    final List<CategoryModel>? categories = const [],
    @JsonKey(name: 'Brands', includeIfNull: false)
    final List<BrandModel>? brands = const [],
    @JsonKey(name: 'Pages', includeIfNull: false)
    final List<PageModel>? pages = const [],
    @JsonKey(name: 'BlogPosts', includeIfNull: false)
    final List<BlogPostModel>? blogPosts = const [],
    @JsonKey(name: 'KnowledgebaseArticles', includeIfNull: false)
    final List<KnowledgebaseItemModel>? knowledgebaseArticles = const [],
    @JsonKey(name: 'NewsEnabled', includeIfNull: false)
    this.newsEnabled = false,
    @JsonKey(name: 'BlogEnabled', includeIfNull: false)
    this.blogEnabled = false,
    @JsonKey(name: 'KnowledgebaseEnabled', includeIfNull: false)
    this.knowledgebaseEnabled = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _products = products,
       _categories = categories,
       _brands = brands,
       _pages = pages,
       _blogPosts = blogPosts,
       _knowledgebaseArticles = knowledgebaseArticles,
       _userFields = userFields;

  factory _$SitemapModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SitemapModelImplFromJson(json);

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

  final List<CategoryModel>? _categories;
  @override
  @JsonKey(name: 'Categories', includeIfNull: false)
  List<CategoryModel>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<BrandModel>? _brands;
  @override
  @JsonKey(name: 'Brands', includeIfNull: false)
  List<BrandModel>? get brands {
    final value = _brands;
    if (value == null) return null;
    if (_brands is EqualUnmodifiableListView) return _brands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PageModel>? _pages;
  @override
  @JsonKey(name: 'Pages', includeIfNull: false)
  List<PageModel>? get pages {
    final value = _pages;
    if (value == null) return null;
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<BlogPostModel>? _blogPosts;
  @override
  @JsonKey(name: 'BlogPosts', includeIfNull: false)
  List<BlogPostModel>? get blogPosts {
    final value = _blogPosts;
    if (value == null) return null;
    if (_blogPosts is EqualUnmodifiableListView) return _blogPosts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<KnowledgebaseItemModel>? _knowledgebaseArticles;
  @override
  @JsonKey(name: 'KnowledgebaseArticles', includeIfNull: false)
  List<KnowledgebaseItemModel>? get knowledgebaseArticles {
    final value = _knowledgebaseArticles;
    if (value == null) return null;
    if (_knowledgebaseArticles is EqualUnmodifiableListView)
      return _knowledgebaseArticles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'NewsEnabled', includeIfNull: false)
  final bool? newsEnabled;
  @override
  @JsonKey(name: 'BlogEnabled', includeIfNull: false)
  final bool? blogEnabled;
  @override
  @JsonKey(name: 'KnowledgebaseEnabled', includeIfNull: false)
  final bool? knowledgebaseEnabled;
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
    return 'SitemapModel(products: $products, categories: $categories, brands: $brands, pages: $pages, blogPosts: $blogPosts, knowledgebaseArticles: $knowledgebaseArticles, newsEnabled: $newsEnabled, blogEnabled: $blogEnabled, knowledgebaseEnabled: $knowledgebaseEnabled, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SitemapModelImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(other._brands, _brands) &&
            const DeepCollectionEquality().equals(other._pages, _pages) &&
            const DeepCollectionEquality().equals(
              other._blogPosts,
              _blogPosts,
            ) &&
            const DeepCollectionEquality().equals(
              other._knowledgebaseArticles,
              _knowledgebaseArticles,
            ) &&
            (identical(other.newsEnabled, newsEnabled) ||
                other.newsEnabled == newsEnabled) &&
            (identical(other.blogEnabled, blogEnabled) ||
                other.blogEnabled == blogEnabled) &&
            (identical(other.knowledgebaseEnabled, knowledgebaseEnabled) ||
                other.knowledgebaseEnabled == knowledgebaseEnabled) &&
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
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_brands),
    const DeepCollectionEquality().hash(_pages),
    const DeepCollectionEquality().hash(_blogPosts),
    const DeepCollectionEquality().hash(_knowledgebaseArticles),
    newsEnabled,
    blogEnabled,
    knowledgebaseEnabled,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of SitemapModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SitemapModelImplCopyWith<_$SitemapModelImpl> get copyWith =>
      __$$SitemapModelImplCopyWithImpl<_$SitemapModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SitemapModelImplToJson(this);
  }
}

abstract class _SitemapModel implements SitemapModel {
  factory _SitemapModel({
    @JsonKey(name: 'Products', includeIfNull: false)
    final List<ProductOverviewModel>? products,
    @JsonKey(name: 'Categories', includeIfNull: false)
    final List<CategoryModel>? categories,
    @JsonKey(name: 'Brands', includeIfNull: false)
    final List<BrandModel>? brands,
    @JsonKey(name: 'Pages', includeIfNull: false) final List<PageModel>? pages,
    @JsonKey(name: 'BlogPosts', includeIfNull: false)
    final List<BlogPostModel>? blogPosts,
    @JsonKey(name: 'KnowledgebaseArticles', includeIfNull: false)
    final List<KnowledgebaseItemModel>? knowledgebaseArticles,
    @JsonKey(name: 'NewsEnabled', includeIfNull: false) final bool? newsEnabled,
    @JsonKey(name: 'BlogEnabled', includeIfNull: false) final bool? blogEnabled,
    @JsonKey(name: 'KnowledgebaseEnabled', includeIfNull: false)
    final bool? knowledgebaseEnabled,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$SitemapModelImpl;

  factory _SitemapModel.fromJson(Map<String, dynamic> json) =
      _$SitemapModelImpl.fromJson;

  @override
  @JsonKey(name: 'Products', includeIfNull: false)
  List<ProductOverviewModel>? get products;
  @override
  @JsonKey(name: 'Categories', includeIfNull: false)
  List<CategoryModel>? get categories;
  @override
  @JsonKey(name: 'Brands', includeIfNull: false)
  List<BrandModel>? get brands;
  @override
  @JsonKey(name: 'Pages', includeIfNull: false)
  List<PageModel>? get pages;
  @override
  @JsonKey(name: 'BlogPosts', includeIfNull: false)
  List<BlogPostModel>? get blogPosts;
  @override
  @JsonKey(name: 'KnowledgebaseArticles', includeIfNull: false)
  List<KnowledgebaseItemModel>? get knowledgebaseArticles;
  @override
  @JsonKey(name: 'NewsEnabled', includeIfNull: false)
  bool? get newsEnabled;
  @override
  @JsonKey(name: 'BlogEnabled', includeIfNull: false)
  bool? get blogEnabled;
  @override
  @JsonKey(name: 'KnowledgebaseEnabled', includeIfNull: false)
  bool? get knowledgebaseEnabled;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of SitemapModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SitemapModelImplCopyWith<_$SitemapModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
