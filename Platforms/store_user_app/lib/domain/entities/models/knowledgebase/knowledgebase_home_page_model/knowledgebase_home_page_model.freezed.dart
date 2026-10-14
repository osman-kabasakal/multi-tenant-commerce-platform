// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knowledgebase_home_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KnowledgebaseHomePageModel _$KnowledgebaseHomePageModelFromJson(
  Map<String, dynamic> json,
) {
  return _KnowledgebaseHomePageModel.fromJson(json);
}

/// @nodoc
mixin _$KnowledgebaseHomePageModel {
  @JsonKey(name: 'Items', includeIfNull: false)
  List<KnowledgebaseItemModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'Categories', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get categories =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentCategoryId', includeIfNull: false)
  String? get currentCategoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentCategoryDescription', includeIfNull: false)
  String? get currentCategoryDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentCategoryMetaTitle', includeIfNull: false)
  String? get currentCategoryMetaTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentCategoryMetaDescription', includeIfNull: false)
  String? get currentCategoryMetaDescription =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentCategoryMetaKeywords', includeIfNull: false)
  String? get currentCategoryMetaKeywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentCategoryName', includeIfNull: false)
  String? get currentCategoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentCategorySeName', includeIfNull: false)
  String? get currentCategorySeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get categoryBreadcrumb =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'SearchKeyword', includeIfNull: false)
  String? get searchKeyword => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this KnowledgebaseHomePageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KnowledgebaseHomePageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KnowledgebaseHomePageModelCopyWith<KnowledgebaseHomePageModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KnowledgebaseHomePageModelCopyWith<$Res> {
  factory $KnowledgebaseHomePageModelCopyWith(
    KnowledgebaseHomePageModel value,
    $Res Function(KnowledgebaseHomePageModel) then,
  ) =
      _$KnowledgebaseHomePageModelCopyWithImpl<
        $Res,
        KnowledgebaseHomePageModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Items', includeIfNull: false)
    List<KnowledgebaseItemModel>? items,
    @JsonKey(name: 'Categories', includeIfNull: false)
    List<KnowledgebaseCategoryModel>? categories,
    @JsonKey(name: 'CurrentCategoryId', includeIfNull: false)
    String? currentCategoryId,
    @JsonKey(name: 'CurrentCategoryDescription', includeIfNull: false)
    String? currentCategoryDescription,
    @JsonKey(name: 'CurrentCategoryMetaTitle', includeIfNull: false)
    String? currentCategoryMetaTitle,
    @JsonKey(name: 'CurrentCategoryMetaDescription', includeIfNull: false)
    String? currentCategoryMetaDescription,
    @JsonKey(name: 'CurrentCategoryMetaKeywords', includeIfNull: false)
    String? currentCategoryMetaKeywords,
    @JsonKey(name: 'CurrentCategoryName', includeIfNull: false)
    String? currentCategoryName,
    @JsonKey(name: 'CurrentCategorySeName', includeIfNull: false)
    String? currentCategorySeName,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    List<KnowledgebaseCategoryModel>? categoryBreadcrumb,
    @JsonKey(name: 'SearchKeyword', includeIfNull: false) String? searchKeyword,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$KnowledgebaseHomePageModelCopyWithImpl<
  $Res,
  $Val extends KnowledgebaseHomePageModel
>
    implements $KnowledgebaseHomePageModelCopyWith<$Res> {
  _$KnowledgebaseHomePageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KnowledgebaseHomePageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? categories = freezed,
    Object? currentCategoryId = freezed,
    Object? currentCategoryDescription = freezed,
    Object? currentCategoryMetaTitle = freezed,
    Object? currentCategoryMetaDescription = freezed,
    Object? currentCategoryMetaKeywords = freezed,
    Object? currentCategoryName = freezed,
    Object? currentCategorySeName = freezed,
    Object? categoryBreadcrumb = freezed,
    Object? searchKeyword = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<KnowledgebaseItemModel>?,
            categories:
                freezed == categories
                    ? _value.categories
                    : categories // ignore: cast_nullable_to_non_nullable
                        as List<KnowledgebaseCategoryModel>?,
            currentCategoryId:
                freezed == currentCategoryId
                    ? _value.currentCategoryId
                    : currentCategoryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentCategoryDescription:
                freezed == currentCategoryDescription
                    ? _value.currentCategoryDescription
                    : currentCategoryDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentCategoryMetaTitle:
                freezed == currentCategoryMetaTitle
                    ? _value.currentCategoryMetaTitle
                    : currentCategoryMetaTitle // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentCategoryMetaDescription:
                freezed == currentCategoryMetaDescription
                    ? _value.currentCategoryMetaDescription
                    : currentCategoryMetaDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentCategoryMetaKeywords:
                freezed == currentCategoryMetaKeywords
                    ? _value.currentCategoryMetaKeywords
                    : currentCategoryMetaKeywords // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentCategoryName:
                freezed == currentCategoryName
                    ? _value.currentCategoryName
                    : currentCategoryName // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentCategorySeName:
                freezed == currentCategorySeName
                    ? _value.currentCategorySeName
                    : currentCategorySeName // ignore: cast_nullable_to_non_nullable
                        as String?,
            categoryBreadcrumb:
                freezed == categoryBreadcrumb
                    ? _value.categoryBreadcrumb
                    : categoryBreadcrumb // ignore: cast_nullable_to_non_nullable
                        as List<KnowledgebaseCategoryModel>?,
            searchKeyword:
                freezed == searchKeyword
                    ? _value.searchKeyword
                    : searchKeyword // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$KnowledgebaseHomePageModelImplCopyWith<$Res>
    implements $KnowledgebaseHomePageModelCopyWith<$Res> {
  factory _$$KnowledgebaseHomePageModelImplCopyWith(
    _$KnowledgebaseHomePageModelImpl value,
    $Res Function(_$KnowledgebaseHomePageModelImpl) then,
  ) = __$$KnowledgebaseHomePageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Items', includeIfNull: false)
    List<KnowledgebaseItemModel>? items,
    @JsonKey(name: 'Categories', includeIfNull: false)
    List<KnowledgebaseCategoryModel>? categories,
    @JsonKey(name: 'CurrentCategoryId', includeIfNull: false)
    String? currentCategoryId,
    @JsonKey(name: 'CurrentCategoryDescription', includeIfNull: false)
    String? currentCategoryDescription,
    @JsonKey(name: 'CurrentCategoryMetaTitle', includeIfNull: false)
    String? currentCategoryMetaTitle,
    @JsonKey(name: 'CurrentCategoryMetaDescription', includeIfNull: false)
    String? currentCategoryMetaDescription,
    @JsonKey(name: 'CurrentCategoryMetaKeywords', includeIfNull: false)
    String? currentCategoryMetaKeywords,
    @JsonKey(name: 'CurrentCategoryName', includeIfNull: false)
    String? currentCategoryName,
    @JsonKey(name: 'CurrentCategorySeName', includeIfNull: false)
    String? currentCategorySeName,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    List<KnowledgebaseCategoryModel>? categoryBreadcrumb,
    @JsonKey(name: 'SearchKeyword', includeIfNull: false) String? searchKeyword,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$KnowledgebaseHomePageModelImplCopyWithImpl<$Res>
    extends
        _$KnowledgebaseHomePageModelCopyWithImpl<
          $Res,
          _$KnowledgebaseHomePageModelImpl
        >
    implements _$$KnowledgebaseHomePageModelImplCopyWith<$Res> {
  __$$KnowledgebaseHomePageModelImplCopyWithImpl(
    _$KnowledgebaseHomePageModelImpl _value,
    $Res Function(_$KnowledgebaseHomePageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KnowledgebaseHomePageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? categories = freezed,
    Object? currentCategoryId = freezed,
    Object? currentCategoryDescription = freezed,
    Object? currentCategoryMetaTitle = freezed,
    Object? currentCategoryMetaDescription = freezed,
    Object? currentCategoryMetaKeywords = freezed,
    Object? currentCategoryName = freezed,
    Object? currentCategorySeName = freezed,
    Object? categoryBreadcrumb = freezed,
    Object? searchKeyword = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$KnowledgebaseHomePageModelImpl(
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<KnowledgebaseItemModel>?,
        categories:
            freezed == categories
                ? _value._categories
                : categories // ignore: cast_nullable_to_non_nullable
                    as List<KnowledgebaseCategoryModel>?,
        currentCategoryId:
            freezed == currentCategoryId
                ? _value.currentCategoryId
                : currentCategoryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentCategoryDescription:
            freezed == currentCategoryDescription
                ? _value.currentCategoryDescription
                : currentCategoryDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentCategoryMetaTitle:
            freezed == currentCategoryMetaTitle
                ? _value.currentCategoryMetaTitle
                : currentCategoryMetaTitle // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentCategoryMetaDescription:
            freezed == currentCategoryMetaDescription
                ? _value.currentCategoryMetaDescription
                : currentCategoryMetaDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentCategoryMetaKeywords:
            freezed == currentCategoryMetaKeywords
                ? _value.currentCategoryMetaKeywords
                : currentCategoryMetaKeywords // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentCategoryName:
            freezed == currentCategoryName
                ? _value.currentCategoryName
                : currentCategoryName // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentCategorySeName:
            freezed == currentCategorySeName
                ? _value.currentCategorySeName
                : currentCategorySeName // ignore: cast_nullable_to_non_nullable
                    as String?,
        categoryBreadcrumb:
            freezed == categoryBreadcrumb
                ? _value._categoryBreadcrumb
                : categoryBreadcrumb // ignore: cast_nullable_to_non_nullable
                    as List<KnowledgebaseCategoryModel>?,
        searchKeyword:
            freezed == searchKeyword
                ? _value.searchKeyword
                : searchKeyword // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$KnowledgebaseHomePageModelImpl implements _KnowledgebaseHomePageModel {
  _$KnowledgebaseHomePageModelImpl({
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<KnowledgebaseItemModel>? items = const [],
    @JsonKey(name: 'Categories', includeIfNull: false)
    final List<KnowledgebaseCategoryModel>? categories = const [],
    @JsonKey(name: 'CurrentCategoryId', includeIfNull: false)
    this.currentCategoryId,
    @JsonKey(name: 'CurrentCategoryDescription', includeIfNull: false)
    this.currentCategoryDescription,
    @JsonKey(name: 'CurrentCategoryMetaTitle', includeIfNull: false)
    this.currentCategoryMetaTitle,
    @JsonKey(name: 'CurrentCategoryMetaDescription', includeIfNull: false)
    this.currentCategoryMetaDescription,
    @JsonKey(name: 'CurrentCategoryMetaKeywords', includeIfNull: false)
    this.currentCategoryMetaKeywords,
    @JsonKey(name: 'CurrentCategoryName', includeIfNull: false)
    this.currentCategoryName,
    @JsonKey(name: 'CurrentCategorySeName', includeIfNull: false)
    this.currentCategorySeName,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    final List<KnowledgebaseCategoryModel>? categoryBreadcrumb = const [],
    @JsonKey(name: 'SearchKeyword', includeIfNull: false) this.searchKeyword,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _items = items,
       _categories = categories,
       _categoryBreadcrumb = categoryBreadcrumb,
       _userFields = userFields;

  factory _$KnowledgebaseHomePageModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$KnowledgebaseHomePageModelImplFromJson(json);

  final List<KnowledgebaseItemModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<KnowledgebaseItemModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<KnowledgebaseCategoryModel>? _categories;
  @override
  @JsonKey(name: 'Categories', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'CurrentCategoryId', includeIfNull: false)
  final String? currentCategoryId;
  @override
  @JsonKey(name: 'CurrentCategoryDescription', includeIfNull: false)
  final String? currentCategoryDescription;
  @override
  @JsonKey(name: 'CurrentCategoryMetaTitle', includeIfNull: false)
  final String? currentCategoryMetaTitle;
  @override
  @JsonKey(name: 'CurrentCategoryMetaDescription', includeIfNull: false)
  final String? currentCategoryMetaDescription;
  @override
  @JsonKey(name: 'CurrentCategoryMetaKeywords', includeIfNull: false)
  final String? currentCategoryMetaKeywords;
  @override
  @JsonKey(name: 'CurrentCategoryName', includeIfNull: false)
  final String? currentCategoryName;
  @override
  @JsonKey(name: 'CurrentCategorySeName', includeIfNull: false)
  final String? currentCategorySeName;
  final List<KnowledgebaseCategoryModel>? _categoryBreadcrumb;
  @override
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get categoryBreadcrumb {
    final value = _categoryBreadcrumb;
    if (value == null) return null;
    if (_categoryBreadcrumb is EqualUnmodifiableListView)
      return _categoryBreadcrumb;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'SearchKeyword', includeIfNull: false)
  final String? searchKeyword;
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
    return 'KnowledgebaseHomePageModel(items: $items, categories: $categories, currentCategoryId: $currentCategoryId, currentCategoryDescription: $currentCategoryDescription, currentCategoryMetaTitle: $currentCategoryMetaTitle, currentCategoryMetaDescription: $currentCategoryMetaDescription, currentCategoryMetaKeywords: $currentCategoryMetaKeywords, currentCategoryName: $currentCategoryName, currentCategorySeName: $currentCategorySeName, categoryBreadcrumb: $categoryBreadcrumb, searchKeyword: $searchKeyword, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KnowledgebaseHomePageModelImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.currentCategoryId, currentCategoryId) ||
                other.currentCategoryId == currentCategoryId) &&
            (identical(
                  other.currentCategoryDescription,
                  currentCategoryDescription,
                ) ||
                other.currentCategoryDescription ==
                    currentCategoryDescription) &&
            (identical(
                  other.currentCategoryMetaTitle,
                  currentCategoryMetaTitle,
                ) ||
                other.currentCategoryMetaTitle == currentCategoryMetaTitle) &&
            (identical(
                  other.currentCategoryMetaDescription,
                  currentCategoryMetaDescription,
                ) ||
                other.currentCategoryMetaDescription ==
                    currentCategoryMetaDescription) &&
            (identical(
                  other.currentCategoryMetaKeywords,
                  currentCategoryMetaKeywords,
                ) ||
                other.currentCategoryMetaKeywords ==
                    currentCategoryMetaKeywords) &&
            (identical(other.currentCategoryName, currentCategoryName) ||
                other.currentCategoryName == currentCategoryName) &&
            (identical(other.currentCategorySeName, currentCategorySeName) ||
                other.currentCategorySeName == currentCategorySeName) &&
            const DeepCollectionEquality().equals(
              other._categoryBreadcrumb,
              _categoryBreadcrumb,
            ) &&
            (identical(other.searchKeyword, searchKeyword) ||
                other.searchKeyword == searchKeyword) &&
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
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_categories),
    currentCategoryId,
    currentCategoryDescription,
    currentCategoryMetaTitle,
    currentCategoryMetaDescription,
    currentCategoryMetaKeywords,
    currentCategoryName,
    currentCategorySeName,
    const DeepCollectionEquality().hash(_categoryBreadcrumb),
    searchKeyword,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of KnowledgebaseHomePageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KnowledgebaseHomePageModelImplCopyWith<_$KnowledgebaseHomePageModelImpl>
  get copyWith => __$$KnowledgebaseHomePageModelImplCopyWithImpl<
    _$KnowledgebaseHomePageModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KnowledgebaseHomePageModelImplToJson(this);
  }
}

abstract class _KnowledgebaseHomePageModel
    implements KnowledgebaseHomePageModel {
  factory _KnowledgebaseHomePageModel({
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<KnowledgebaseItemModel>? items,
    @JsonKey(name: 'Categories', includeIfNull: false)
    final List<KnowledgebaseCategoryModel>? categories,
    @JsonKey(name: 'CurrentCategoryId', includeIfNull: false)
    final String? currentCategoryId,
    @JsonKey(name: 'CurrentCategoryDescription', includeIfNull: false)
    final String? currentCategoryDescription,
    @JsonKey(name: 'CurrentCategoryMetaTitle', includeIfNull: false)
    final String? currentCategoryMetaTitle,
    @JsonKey(name: 'CurrentCategoryMetaDescription', includeIfNull: false)
    final String? currentCategoryMetaDescription,
    @JsonKey(name: 'CurrentCategoryMetaKeywords', includeIfNull: false)
    final String? currentCategoryMetaKeywords,
    @JsonKey(name: 'CurrentCategoryName', includeIfNull: false)
    final String? currentCategoryName,
    @JsonKey(name: 'CurrentCategorySeName', includeIfNull: false)
    final String? currentCategorySeName,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    final List<KnowledgebaseCategoryModel>? categoryBreadcrumb,
    @JsonKey(name: 'SearchKeyword', includeIfNull: false)
    final String? searchKeyword,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$KnowledgebaseHomePageModelImpl;

  factory _KnowledgebaseHomePageModel.fromJson(Map<String, dynamic> json) =
      _$KnowledgebaseHomePageModelImpl.fromJson;

  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<KnowledgebaseItemModel>? get items;
  @override
  @JsonKey(name: 'Categories', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get categories;
  @override
  @JsonKey(name: 'CurrentCategoryId', includeIfNull: false)
  String? get currentCategoryId;
  @override
  @JsonKey(name: 'CurrentCategoryDescription', includeIfNull: false)
  String? get currentCategoryDescription;
  @override
  @JsonKey(name: 'CurrentCategoryMetaTitle', includeIfNull: false)
  String? get currentCategoryMetaTitle;
  @override
  @JsonKey(name: 'CurrentCategoryMetaDescription', includeIfNull: false)
  String? get currentCategoryMetaDescription;
  @override
  @JsonKey(name: 'CurrentCategoryMetaKeywords', includeIfNull: false)
  String? get currentCategoryMetaKeywords;
  @override
  @JsonKey(name: 'CurrentCategoryName', includeIfNull: false)
  String? get currentCategoryName;
  @override
  @JsonKey(name: 'CurrentCategorySeName', includeIfNull: false)
  String? get currentCategorySeName;
  @override
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get categoryBreadcrumb;
  @override
  @JsonKey(name: 'SearchKeyword', includeIfNull: false)
  String? get searchKeyword;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of KnowledgebaseHomePageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KnowledgebaseHomePageModelImplCopyWith<_$KnowledgebaseHomePageModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
