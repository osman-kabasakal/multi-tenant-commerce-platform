// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_post_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BlogPostListModel _$BlogPostListModelFromJson(Map<String, dynamic> json) {
  return _BlogPostListModel.fromJson(json);
}

/// @nodoc
mixin _$BlogPostListModel {
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
  String? get workingLanguageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  BlogPagingFilteringModel? get pagingFilteringContext =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'BlogPosts', includeIfNull: false)
  List<BlogPostModel>? get blogPosts => throw _privateConstructorUsedError;
  @JsonKey(name: 'SearchKeyword', includeIfNull: false)
  String? get searchKeyword => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this BlogPostListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlogPostListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlogPostListModelCopyWith<BlogPostListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogPostListModelCopyWith<$Res> {
  factory $BlogPostListModelCopyWith(
    BlogPostListModel value,
    $Res Function(BlogPostListModel) then,
  ) = _$BlogPostListModelCopyWithImpl<$Res, BlogPostListModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
    String? workingLanguageId,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    BlogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'BlogPosts', includeIfNull: false)
    List<BlogPostModel>? blogPosts,
    @JsonKey(name: 'SearchKeyword', includeIfNull: false) String? searchKeyword,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $PictureModelCopyWith<$Res>? get pictureModel;
  $BlogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
}

/// @nodoc
class _$BlogPostListModelCopyWithImpl<$Res, $Val extends BlogPostListModel>
    implements $BlogPostListModelCopyWith<$Res> {
  _$BlogPostListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlogPostListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pictureModel = freezed,
    Object? workingLanguageId = freezed,
    Object? pagingFilteringContext = freezed,
    Object? blogPosts = freezed,
    Object? searchKeyword = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            pictureModel:
                freezed == pictureModel
                    ? _value.pictureModel
                    : pictureModel // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            workingLanguageId:
                freezed == workingLanguageId
                    ? _value.workingLanguageId
                    : workingLanguageId // ignore: cast_nullable_to_non_nullable
                        as String?,
            pagingFilteringContext:
                freezed == pagingFilteringContext
                    ? _value.pagingFilteringContext
                    : pagingFilteringContext // ignore: cast_nullable_to_non_nullable
                        as BlogPagingFilteringModel?,
            blogPosts:
                freezed == blogPosts
                    ? _value.blogPosts
                    : blogPosts // ignore: cast_nullable_to_non_nullable
                        as List<BlogPostModel>?,
            searchKeyword:
                freezed == searchKeyword
                    ? _value.searchKeyword
                    : searchKeyword // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of BlogPostListModel
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

  /// Create a copy of BlogPostListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BlogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext {
    if (_value.pagingFilteringContext == null) {
      return null;
    }

    return $BlogPagingFilteringModelCopyWith<$Res>(
      _value.pagingFilteringContext!,
      (value) {
        return _then(_value.copyWith(pagingFilteringContext: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$BlogPostListModelImplCopyWith<$Res>
    implements $BlogPostListModelCopyWith<$Res> {
  factory _$$BlogPostListModelImplCopyWith(
    _$BlogPostListModelImpl value,
    $Res Function(_$BlogPostListModelImpl) then,
  ) = __$$BlogPostListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
    String? workingLanguageId,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    BlogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'BlogPosts', includeIfNull: false)
    List<BlogPostModel>? blogPosts,
    @JsonKey(name: 'SearchKeyword', includeIfNull: false) String? searchKeyword,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $PictureModelCopyWith<$Res>? get pictureModel;
  @override
  $BlogPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
}

/// @nodoc
class __$$BlogPostListModelImplCopyWithImpl<$Res>
    extends _$BlogPostListModelCopyWithImpl<$Res, _$BlogPostListModelImpl>
    implements _$$BlogPostListModelImplCopyWith<$Res> {
  __$$BlogPostListModelImplCopyWithImpl(
    _$BlogPostListModelImpl _value,
    $Res Function(_$BlogPostListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlogPostListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pictureModel = freezed,
    Object? workingLanguageId = freezed,
    Object? pagingFilteringContext = freezed,
    Object? blogPosts = freezed,
    Object? searchKeyword = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$BlogPostListModelImpl(
        pictureModel:
            freezed == pictureModel
                ? _value.pictureModel
                : pictureModel // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
        workingLanguageId:
            freezed == workingLanguageId
                ? _value.workingLanguageId
                : workingLanguageId // ignore: cast_nullable_to_non_nullable
                    as String?,
        pagingFilteringContext:
            freezed == pagingFilteringContext
                ? _value.pagingFilteringContext
                : pagingFilteringContext // ignore: cast_nullable_to_non_nullable
                    as BlogPagingFilteringModel?,
        blogPosts:
            freezed == blogPosts
                ? _value._blogPosts
                : blogPosts // ignore: cast_nullable_to_non_nullable
                    as List<BlogPostModel>?,
        searchKeyword:
            freezed == searchKeyword
                ? _value.searchKeyword
                : searchKeyword // ignore: cast_nullable_to_non_nullable
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
class _$BlogPostListModelImpl implements _BlogPostListModel {
  _$BlogPostListModelImpl({
    @JsonKey(name: 'PictureModel', includeIfNull: false) this.pictureModel,
    @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
    this.workingLanguageId,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    this.pagingFilteringContext,
    @JsonKey(name: 'BlogPosts', includeIfNull: false)
    final List<BlogPostModel>? blogPosts = const [],
    @JsonKey(name: 'SearchKeyword', includeIfNull: false) this.searchKeyword,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _blogPosts = blogPosts,
       _userFields = userFields;

  factory _$BlogPostListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogPostListModelImplFromJson(json);

  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  final PictureModel? pictureModel;
  @override
  @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
  final String? workingLanguageId;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  final BlogPagingFilteringModel? pagingFilteringContext;
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

  @override
  @JsonKey(name: 'SearchKeyword', includeIfNull: false)
  final String? searchKeyword;
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
    return 'BlogPostListModel(pictureModel: $pictureModel, workingLanguageId: $workingLanguageId, pagingFilteringContext: $pagingFilteringContext, blogPosts: $blogPosts, searchKeyword: $searchKeyword, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogPostListModelImpl &&
            (identical(other.pictureModel, pictureModel) ||
                other.pictureModel == pictureModel) &&
            (identical(other.workingLanguageId, workingLanguageId) ||
                other.workingLanguageId == workingLanguageId) &&
            (identical(other.pagingFilteringContext, pagingFilteringContext) ||
                other.pagingFilteringContext == pagingFilteringContext) &&
            const DeepCollectionEquality().equals(
              other._blogPosts,
              _blogPosts,
            ) &&
            (identical(other.searchKeyword, searchKeyword) ||
                other.searchKeyword == searchKeyword) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pictureModel,
    workingLanguageId,
    pagingFilteringContext,
    const DeepCollectionEquality().hash(_blogPosts),
    searchKeyword,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of BlogPostListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogPostListModelImplCopyWith<_$BlogPostListModelImpl> get copyWith =>
      __$$BlogPostListModelImplCopyWithImpl<_$BlogPostListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogPostListModelImplToJson(this);
  }
}

abstract class _BlogPostListModel implements BlogPostListModel {
  factory _BlogPostListModel({
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    final PictureModel? pictureModel,
    @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
    final String? workingLanguageId,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    final BlogPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'BlogPosts', includeIfNull: false)
    final List<BlogPostModel>? blogPosts,
    @JsonKey(name: 'SearchKeyword', includeIfNull: false)
    final String? searchKeyword,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$BlogPostListModelImpl;

  factory _BlogPostListModel.fromJson(Map<String, dynamic> json) =
      _$BlogPostListModelImpl.fromJson;

  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel;
  @override
  @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
  String? get workingLanguageId;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  BlogPagingFilteringModel? get pagingFilteringContext;
  @override
  @JsonKey(name: 'BlogPosts', includeIfNull: false)
  List<BlogPostModel>? get blogPosts;
  @override
  @JsonKey(name: 'SearchKeyword', includeIfNull: false)
  String? get searchKeyword;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of BlogPostListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlogPostListModelImplCopyWith<_$BlogPostListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
