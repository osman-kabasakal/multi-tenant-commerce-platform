// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knowledgebase_article_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KnowledgebaseArticleModel _$KnowledgebaseArticleModelFromJson(
  Map<String, dynamic> json,
) {
  return _KnowledgebaseArticleModel.fromJson(json);
}

/// @nodoc
mixin _$KnowledgebaseArticleModel {
  @JsonKey(name: 'ArticleId', includeIfNull: false)
  String? get articleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Content', includeIfNull: false)
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
  String? get parentCategoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaKeywords', includeIfNull: false)
  String? get metaKeywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaDescription', includeIfNull: false)
  String? get metaDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaTitle', includeIfNull: false)
  String? get metaTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowComments', includeIfNull: false)
  bool? get allowComments => throw _privateConstructorUsedError;
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'RelatedArticles', includeIfNull: false)
  List<KnowledgebaseArticleModel>? get relatedArticles =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get categoryBreadcrumb =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AddNewComment', includeIfNull: false)
  AddKnowledgebaseArticleCommentModel? get addNewComment =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Comments', includeIfNull: false)
  List<KnowledgebaseArticleCommentModel>? get comments =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this KnowledgebaseArticleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KnowledgebaseArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KnowledgebaseArticleModelCopyWith<KnowledgebaseArticleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KnowledgebaseArticleModelCopyWith<$Res> {
  factory $KnowledgebaseArticleModelCopyWith(
    KnowledgebaseArticleModel value,
    $Res Function(KnowledgebaseArticleModel) then,
  ) = _$KnowledgebaseArticleModelCopyWithImpl<$Res, KnowledgebaseArticleModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ArticleId', includeIfNull: false) String? articleId,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Content', includeIfNull: false) String? content,
    @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
    String? parentCategoryId,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'AllowComments', includeIfNull: false) bool? allowComments,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'RelatedArticles', includeIfNull: false)
    List<KnowledgebaseArticleModel>? relatedArticles,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    List<KnowledgebaseCategoryModel>? categoryBreadcrumb,
    @JsonKey(name: 'AddNewComment', includeIfNull: false)
    AddKnowledgebaseArticleCommentModel? addNewComment,
    @JsonKey(name: 'Comments', includeIfNull: false)
    List<KnowledgebaseArticleCommentModel>? comments,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $ICaptchaValidModelCopyWith<$Res>? get captcha;
  $AddKnowledgebaseArticleCommentModelCopyWith<$Res>? get addNewComment;
}

/// @nodoc
class _$KnowledgebaseArticleModelCopyWithImpl<
  $Res,
  $Val extends KnowledgebaseArticleModel
>
    implements $KnowledgebaseArticleModelCopyWith<$Res> {
  _$KnowledgebaseArticleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KnowledgebaseArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? articleId = freezed,
    Object? name = freezed,
    Object? content = freezed,
    Object? parentCategoryId = freezed,
    Object? seName = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? allowComments = freezed,
    Object? captcha = freezed,
    Object? relatedArticles = freezed,
    Object? categoryBreadcrumb = freezed,
    Object? addNewComment = freezed,
    Object? comments = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            articleId:
                freezed == articleId
                    ? _value.articleId
                    : articleId // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            content:
                freezed == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as String?,
            parentCategoryId:
                freezed == parentCategoryId
                    ? _value.parentCategoryId
                    : parentCategoryId // ignore: cast_nullable_to_non_nullable
                        as String?,
            seName:
                freezed == seName
                    ? _value.seName
                    : seName // ignore: cast_nullable_to_non_nullable
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
            allowComments:
                freezed == allowComments
                    ? _value.allowComments
                    : allowComments // ignore: cast_nullable_to_non_nullable
                        as bool?,
            captcha:
                freezed == captcha
                    ? _value.captcha
                    : captcha // ignore: cast_nullable_to_non_nullable
                        as ICaptchaValidModel?,
            relatedArticles:
                freezed == relatedArticles
                    ? _value.relatedArticles
                    : relatedArticles // ignore: cast_nullable_to_non_nullable
                        as List<KnowledgebaseArticleModel>?,
            categoryBreadcrumb:
                freezed == categoryBreadcrumb
                    ? _value.categoryBreadcrumb
                    : categoryBreadcrumb // ignore: cast_nullable_to_non_nullable
                        as List<KnowledgebaseCategoryModel>?,
            addNewComment:
                freezed == addNewComment
                    ? _value.addNewComment
                    : addNewComment // ignore: cast_nullable_to_non_nullable
                        as AddKnowledgebaseArticleCommentModel?,
            comments:
                freezed == comments
                    ? _value.comments
                    : comments // ignore: cast_nullable_to_non_nullable
                        as List<KnowledgebaseArticleCommentModel>?,
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

  /// Create a copy of KnowledgebaseArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ICaptchaValidModelCopyWith<$Res>? get captcha {
    if (_value.captcha == null) {
      return null;
    }

    return $ICaptchaValidModelCopyWith<$Res>(_value.captcha!, (value) {
      return _then(_value.copyWith(captcha: value) as $Val);
    });
  }

  /// Create a copy of KnowledgebaseArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddKnowledgebaseArticleCommentModelCopyWith<$Res>? get addNewComment {
    if (_value.addNewComment == null) {
      return null;
    }

    return $AddKnowledgebaseArticleCommentModelCopyWith<$Res>(
      _value.addNewComment!,
      (value) {
        return _then(_value.copyWith(addNewComment: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$KnowledgebaseArticleModelImplCopyWith<$Res>
    implements $KnowledgebaseArticleModelCopyWith<$Res> {
  factory _$$KnowledgebaseArticleModelImplCopyWith(
    _$KnowledgebaseArticleModelImpl value,
    $Res Function(_$KnowledgebaseArticleModelImpl) then,
  ) = __$$KnowledgebaseArticleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ArticleId', includeIfNull: false) String? articleId,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Content', includeIfNull: false) String? content,
    @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
    String? parentCategoryId,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'AllowComments', includeIfNull: false) bool? allowComments,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'RelatedArticles', includeIfNull: false)
    List<KnowledgebaseArticleModel>? relatedArticles,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    List<KnowledgebaseCategoryModel>? categoryBreadcrumb,
    @JsonKey(name: 'AddNewComment', includeIfNull: false)
    AddKnowledgebaseArticleCommentModel? addNewComment,
    @JsonKey(name: 'Comments', includeIfNull: false)
    List<KnowledgebaseArticleCommentModel>? comments,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
  @override
  $AddKnowledgebaseArticleCommentModelCopyWith<$Res>? get addNewComment;
}

/// @nodoc
class __$$KnowledgebaseArticleModelImplCopyWithImpl<$Res>
    extends
        _$KnowledgebaseArticleModelCopyWithImpl<
          $Res,
          _$KnowledgebaseArticleModelImpl
        >
    implements _$$KnowledgebaseArticleModelImplCopyWith<$Res> {
  __$$KnowledgebaseArticleModelImplCopyWithImpl(
    _$KnowledgebaseArticleModelImpl _value,
    $Res Function(_$KnowledgebaseArticleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KnowledgebaseArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? articleId = freezed,
    Object? name = freezed,
    Object? content = freezed,
    Object? parentCategoryId = freezed,
    Object? seName = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? allowComments = freezed,
    Object? captcha = freezed,
    Object? relatedArticles = freezed,
    Object? categoryBreadcrumb = freezed,
    Object? addNewComment = freezed,
    Object? comments = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$KnowledgebaseArticleModelImpl(
        articleId:
            freezed == articleId
                ? _value.articleId
                : articleId // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        content:
            freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String?,
        parentCategoryId:
            freezed == parentCategoryId
                ? _value.parentCategoryId
                : parentCategoryId // ignore: cast_nullable_to_non_nullable
                    as String?,
        seName:
            freezed == seName
                ? _value.seName
                : seName // ignore: cast_nullable_to_non_nullable
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
        allowComments:
            freezed == allowComments
                ? _value.allowComments
                : allowComments // ignore: cast_nullable_to_non_nullable
                    as bool?,
        captcha:
            freezed == captcha
                ? _value.captcha
                : captcha // ignore: cast_nullable_to_non_nullable
                    as ICaptchaValidModel?,
        relatedArticles:
            freezed == relatedArticles
                ? _value._relatedArticles
                : relatedArticles // ignore: cast_nullable_to_non_nullable
                    as List<KnowledgebaseArticleModel>?,
        categoryBreadcrumb:
            freezed == categoryBreadcrumb
                ? _value._categoryBreadcrumb
                : categoryBreadcrumb // ignore: cast_nullable_to_non_nullable
                    as List<KnowledgebaseCategoryModel>?,
        addNewComment:
            freezed == addNewComment
                ? _value.addNewComment
                : addNewComment // ignore: cast_nullable_to_non_nullable
                    as AddKnowledgebaseArticleCommentModel?,
        comments:
            freezed == comments
                ? _value._comments
                : comments // ignore: cast_nullable_to_non_nullable
                    as List<KnowledgebaseArticleCommentModel>?,
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
class _$KnowledgebaseArticleModelImpl implements _KnowledgebaseArticleModel {
  _$KnowledgebaseArticleModelImpl({
    @JsonKey(name: 'ArticleId', includeIfNull: false) this.articleId,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Content', includeIfNull: false) this.content,
    @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
    this.parentCategoryId,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) this.metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    this.metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) this.metaTitle,
    @JsonKey(name: 'AllowComments', includeIfNull: false)
    this.allowComments = false,
    @JsonKey(name: 'Captcha', includeIfNull: false) this.captcha,
    @JsonKey(name: 'RelatedArticles', includeIfNull: false)
    final List<KnowledgebaseArticleModel>? relatedArticles = const [],
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    final List<KnowledgebaseCategoryModel>? categoryBreadcrumb = const [],
    @JsonKey(name: 'AddNewComment', includeIfNull: false) this.addNewComment,
    @JsonKey(name: 'Comments', includeIfNull: false)
    final List<KnowledgebaseArticleCommentModel>? comments = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _relatedArticles = relatedArticles,
       _categoryBreadcrumb = categoryBreadcrumb,
       _comments = comments,
       _userFields = userFields;

  factory _$KnowledgebaseArticleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$KnowledgebaseArticleModelImplFromJson(json);

  @override
  @JsonKey(name: 'ArticleId', includeIfNull: false)
  final String? articleId;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Content', includeIfNull: false)
  final String? content;
  @override
  @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
  final String? parentCategoryId;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
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
  @JsonKey(name: 'AllowComments', includeIfNull: false)
  final bool? allowComments;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  final ICaptchaValidModel? captcha;
  final List<KnowledgebaseArticleModel>? _relatedArticles;
  @override
  @JsonKey(name: 'RelatedArticles', includeIfNull: false)
  List<KnowledgebaseArticleModel>? get relatedArticles {
    final value = _relatedArticles;
    if (value == null) return null;
    if (_relatedArticles is EqualUnmodifiableListView) return _relatedArticles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
  @JsonKey(name: 'AddNewComment', includeIfNull: false)
  final AddKnowledgebaseArticleCommentModel? addNewComment;
  final List<KnowledgebaseArticleCommentModel>? _comments;
  @override
  @JsonKey(name: 'Comments', includeIfNull: false)
  List<KnowledgebaseArticleCommentModel>? get comments {
    final value = _comments;
    if (value == null) return null;
    if (_comments is EqualUnmodifiableListView) return _comments;
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
    return 'KnowledgebaseArticleModel(articleId: $articleId, name: $name, content: $content, parentCategoryId: $parentCategoryId, seName: $seName, metaKeywords: $metaKeywords, metaDescription: $metaDescription, metaTitle: $metaTitle, allowComments: $allowComments, captcha: $captcha, relatedArticles: $relatedArticles, categoryBreadcrumb: $categoryBreadcrumb, addNewComment: $addNewComment, comments: $comments, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KnowledgebaseArticleModelImpl &&
            (identical(other.articleId, articleId) ||
                other.articleId == articleId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.parentCategoryId, parentCategoryId) ||
                other.parentCategoryId == parentCategoryId) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.metaKeywords, metaKeywords) ||
                other.metaKeywords == metaKeywords) &&
            (identical(other.metaDescription, metaDescription) ||
                other.metaDescription == metaDescription) &&
            (identical(other.metaTitle, metaTitle) ||
                other.metaTitle == metaTitle) &&
            (identical(other.allowComments, allowComments) ||
                other.allowComments == allowComments) &&
            (identical(other.captcha, captcha) || other.captcha == captcha) &&
            const DeepCollectionEquality().equals(
              other._relatedArticles,
              _relatedArticles,
            ) &&
            const DeepCollectionEquality().equals(
              other._categoryBreadcrumb,
              _categoryBreadcrumb,
            ) &&
            (identical(other.addNewComment, addNewComment) ||
                other.addNewComment == addNewComment) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
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
    articleId,
    name,
    content,
    parentCategoryId,
    seName,
    metaKeywords,
    metaDescription,
    metaTitle,
    allowComments,
    captcha,
    const DeepCollectionEquality().hash(_relatedArticles),
    const DeepCollectionEquality().hash(_categoryBreadcrumb),
    addNewComment,
    const DeepCollectionEquality().hash(_comments),
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of KnowledgebaseArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KnowledgebaseArticleModelImplCopyWith<_$KnowledgebaseArticleModelImpl>
  get copyWith => __$$KnowledgebaseArticleModelImplCopyWithImpl<
    _$KnowledgebaseArticleModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KnowledgebaseArticleModelImplToJson(this);
  }
}

abstract class _KnowledgebaseArticleModel implements KnowledgebaseArticleModel {
  factory _KnowledgebaseArticleModel({
    @JsonKey(name: 'ArticleId', includeIfNull: false) final String? articleId,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Content', includeIfNull: false) final String? content,
    @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
    final String? parentCategoryId,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false)
    final String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    final String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) final String? metaTitle,
    @JsonKey(name: 'AllowComments', includeIfNull: false)
    final bool? allowComments,
    @JsonKey(name: 'Captcha', includeIfNull: false)
    final ICaptchaValidModel? captcha,
    @JsonKey(name: 'RelatedArticles', includeIfNull: false)
    final List<KnowledgebaseArticleModel>? relatedArticles,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    final List<KnowledgebaseCategoryModel>? categoryBreadcrumb,
    @JsonKey(name: 'AddNewComment', includeIfNull: false)
    final AddKnowledgebaseArticleCommentModel? addNewComment,
    @JsonKey(name: 'Comments', includeIfNull: false)
    final List<KnowledgebaseArticleCommentModel>? comments,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$KnowledgebaseArticleModelImpl;

  factory _KnowledgebaseArticleModel.fromJson(Map<String, dynamic> json) =
      _$KnowledgebaseArticleModelImpl.fromJson;

  @override
  @JsonKey(name: 'ArticleId', includeIfNull: false)
  String? get articleId;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Content', includeIfNull: false)
  String? get content;
  @override
  @JsonKey(name: 'ParentCategoryId', includeIfNull: false)
  String? get parentCategoryId;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
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
  @JsonKey(name: 'AllowComments', includeIfNull: false)
  bool? get allowComments;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha;
  @override
  @JsonKey(name: 'RelatedArticles', includeIfNull: false)
  List<KnowledgebaseArticleModel>? get relatedArticles;
  @override
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get categoryBreadcrumb;
  @override
  @JsonKey(name: 'AddNewComment', includeIfNull: false)
  AddKnowledgebaseArticleCommentModel? get addNewComment;
  @override
  @JsonKey(name: 'Comments', includeIfNull: false)
  List<KnowledgebaseArticleCommentModel>? get comments;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of KnowledgebaseArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KnowledgebaseArticleModelImplCopyWith<_$KnowledgebaseArticleModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
