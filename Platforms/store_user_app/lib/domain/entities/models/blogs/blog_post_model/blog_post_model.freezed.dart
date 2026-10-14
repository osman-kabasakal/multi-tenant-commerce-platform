// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BlogPostModel _$BlogPostModelFromJson(Map<String, dynamic> json) {
  return _BlogPostModel.fromJson(json);
}

/// @nodoc
mixin _$BlogPostModel {
  @JsonKey(name: 'MetaKeywords', includeIfNull: false)
  String? get metaKeywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaDescription', includeIfNull: false)
  String? get metaDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaTitle', includeIfNull: false)
  String? get metaTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'Body', includeIfNull: false)
  String? get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'BodyOverview', includeIfNull: false)
  String? get bodyOverview => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowComments', includeIfNull: false)
  bool? get allowComments => throw _privateConstructorUsedError;
  @JsonKey(name: 'NumberOfComments', includeIfNull: false)
  int? get numberOfComments => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'Tags', includeIfNull: false)
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'Comments', includeIfNull: false)
  List<BlogCommentModel>? get comments => throw _privateConstructorUsedError;
  @JsonKey(name: 'AddNewComment', includeIfNull: false)
  AddBlogCommentModel? get addNewComment => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this BlogPostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlogPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlogPostModelCopyWith<BlogPostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogPostModelCopyWith<$Res> {
  factory $BlogPostModelCopyWith(
    BlogPostModel value,
    $Res Function(BlogPostModel) then,
  ) = _$BlogPostModelCopyWithImpl<$Res, BlogPostModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'Body', includeIfNull: false) String? body,
    @JsonKey(name: 'BodyOverview', includeIfNull: false) String? bodyOverview,
    @JsonKey(name: 'AllowComments', includeIfNull: false) bool? allowComments,
    @JsonKey(name: 'NumberOfComments', includeIfNull: false)
    int? numberOfComments,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'Tags', includeIfNull: false) List<String>? tags,
    @JsonKey(name: 'Comments', includeIfNull: false)
    List<BlogCommentModel>? comments,
    @JsonKey(name: 'AddNewComment', includeIfNull: false)
    AddBlogCommentModel? addNewComment,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $PictureModelCopyWith<$Res>? get pictureModel;
  $AddBlogCommentModelCopyWith<$Res>? get addNewComment;
}

/// @nodoc
class _$BlogPostModelCopyWithImpl<$Res, $Val extends BlogPostModel>
    implements $BlogPostModelCopyWith<$Res> {
  _$BlogPostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlogPostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? seName = freezed,
    Object? title = freezed,
    Object? pictureModel = freezed,
    Object? body = freezed,
    Object? bodyOverview = freezed,
    Object? allowComments = freezed,
    Object? numberOfComments = freezed,
    Object? createdOn = freezed,
    Object? tags = freezed,
    Object? comments = freezed,
    Object? addNewComment = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            title:
                freezed == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String?,
            pictureModel:
                freezed == pictureModel
                    ? _value.pictureModel
                    : pictureModel // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            body:
                freezed == body
                    ? _value.body
                    : body // ignore: cast_nullable_to_non_nullable
                        as String?,
            bodyOverview:
                freezed == bodyOverview
                    ? _value.bodyOverview
                    : bodyOverview // ignore: cast_nullable_to_non_nullable
                        as String?,
            allowComments:
                freezed == allowComments
                    ? _value.allowComments
                    : allowComments // ignore: cast_nullable_to_non_nullable
                        as bool?,
            numberOfComments:
                freezed == numberOfComments
                    ? _value.numberOfComments
                    : numberOfComments // ignore: cast_nullable_to_non_nullable
                        as int?,
            createdOn:
                freezed == createdOn
                    ? _value.createdOn
                    : createdOn // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            tags:
                freezed == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            comments:
                freezed == comments
                    ? _value.comments
                    : comments // ignore: cast_nullable_to_non_nullable
                        as List<BlogCommentModel>?,
            addNewComment:
                freezed == addNewComment
                    ? _value.addNewComment
                    : addNewComment // ignore: cast_nullable_to_non_nullable
                        as AddBlogCommentModel?,
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

  /// Create a copy of BlogPostModel
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

  /// Create a copy of BlogPostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddBlogCommentModelCopyWith<$Res>? get addNewComment {
    if (_value.addNewComment == null) {
      return null;
    }

    return $AddBlogCommentModelCopyWith<$Res>(_value.addNewComment!, (value) {
      return _then(_value.copyWith(addNewComment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BlogPostModelImplCopyWith<$Res>
    implements $BlogPostModelCopyWith<$Res> {
  factory _$$BlogPostModelImplCopyWith(
    _$BlogPostModelImpl value,
    $Res Function(_$BlogPostModelImpl) then,
  ) = __$$BlogPostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'Body', includeIfNull: false) String? body,
    @JsonKey(name: 'BodyOverview', includeIfNull: false) String? bodyOverview,
    @JsonKey(name: 'AllowComments', includeIfNull: false) bool? allowComments,
    @JsonKey(name: 'NumberOfComments', includeIfNull: false)
    int? numberOfComments,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'Tags', includeIfNull: false) List<String>? tags,
    @JsonKey(name: 'Comments', includeIfNull: false)
    List<BlogCommentModel>? comments,
    @JsonKey(name: 'AddNewComment', includeIfNull: false)
    AddBlogCommentModel? addNewComment,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $PictureModelCopyWith<$Res>? get pictureModel;
  @override
  $AddBlogCommentModelCopyWith<$Res>? get addNewComment;
}

/// @nodoc
class __$$BlogPostModelImplCopyWithImpl<$Res>
    extends _$BlogPostModelCopyWithImpl<$Res, _$BlogPostModelImpl>
    implements _$$BlogPostModelImplCopyWith<$Res> {
  __$$BlogPostModelImplCopyWithImpl(
    _$BlogPostModelImpl _value,
    $Res Function(_$BlogPostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlogPostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? seName = freezed,
    Object? title = freezed,
    Object? pictureModel = freezed,
    Object? body = freezed,
    Object? bodyOverview = freezed,
    Object? allowComments = freezed,
    Object? numberOfComments = freezed,
    Object? createdOn = freezed,
    Object? tags = freezed,
    Object? comments = freezed,
    Object? addNewComment = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$BlogPostModelImpl(
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
        title:
            freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String?,
        pictureModel:
            freezed == pictureModel
                ? _value.pictureModel
                : pictureModel // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
        body:
            freezed == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                    as String?,
        bodyOverview:
            freezed == bodyOverview
                ? _value.bodyOverview
                : bodyOverview // ignore: cast_nullable_to_non_nullable
                    as String?,
        allowComments:
            freezed == allowComments
                ? _value.allowComments
                : allowComments // ignore: cast_nullable_to_non_nullable
                    as bool?,
        numberOfComments:
            freezed == numberOfComments
                ? _value.numberOfComments
                : numberOfComments // ignore: cast_nullable_to_non_nullable
                    as int?,
        createdOn:
            freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        tags:
            freezed == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        comments:
            freezed == comments
                ? _value._comments
                : comments // ignore: cast_nullable_to_non_nullable
                    as List<BlogCommentModel>?,
        addNewComment:
            freezed == addNewComment
                ? _value.addNewComment
                : addNewComment // ignore: cast_nullable_to_non_nullable
                    as AddBlogCommentModel?,
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
class _$BlogPostModelImpl implements _BlogPostModel {
  _$BlogPostModelImpl({
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) this.metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    this.metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) this.metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'Title', includeIfNull: false) this.title,
    @JsonKey(name: 'PictureModel', includeIfNull: false) this.pictureModel,
    @JsonKey(name: 'Body', includeIfNull: false) this.body,
    @JsonKey(name: 'BodyOverview', includeIfNull: false) this.bodyOverview,
    @JsonKey(name: 'AllowComments', includeIfNull: false)
    this.allowComments = false,
    @JsonKey(name: 'NumberOfComments', includeIfNull: false)
    this.numberOfComments,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'Tags', includeIfNull: false)
    final List<String>? tags = const [],
    @JsonKey(name: 'Comments', includeIfNull: false)
    final List<BlogCommentModel>? comments = const [],
    @JsonKey(name: 'AddNewComment', includeIfNull: false) this.addNewComment,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _tags = tags,
       _comments = comments,
       _userFields = userFields;

  factory _$BlogPostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogPostModelImplFromJson(json);

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
  @JsonKey(name: 'Title', includeIfNull: false)
  final String? title;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  final PictureModel? pictureModel;
  @override
  @JsonKey(name: 'Body', includeIfNull: false)
  final String? body;
  @override
  @JsonKey(name: 'BodyOverview', includeIfNull: false)
  final String? bodyOverview;
  @override
  @JsonKey(name: 'AllowComments', includeIfNull: false)
  final bool? allowComments;
  @override
  @JsonKey(name: 'NumberOfComments', includeIfNull: false)
  final int? numberOfComments;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
  final List<String>? _tags;
  @override
  @JsonKey(name: 'Tags', includeIfNull: false)
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<BlogCommentModel>? _comments;
  @override
  @JsonKey(name: 'Comments', includeIfNull: false)
  List<BlogCommentModel>? get comments {
    final value = _comments;
    if (value == null) return null;
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'AddNewComment', includeIfNull: false)
  final AddBlogCommentModel? addNewComment;
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
    return 'BlogPostModel(metaKeywords: $metaKeywords, metaDescription: $metaDescription, metaTitle: $metaTitle, seName: $seName, title: $title, pictureModel: $pictureModel, body: $body, bodyOverview: $bodyOverview, allowComments: $allowComments, numberOfComments: $numberOfComments, createdOn: $createdOn, tags: $tags, comments: $comments, addNewComment: $addNewComment, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogPostModelImpl &&
            (identical(other.metaKeywords, metaKeywords) ||
                other.metaKeywords == metaKeywords) &&
            (identical(other.metaDescription, metaDescription) ||
                other.metaDescription == metaDescription) &&
            (identical(other.metaTitle, metaTitle) ||
                other.metaTitle == metaTitle) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.pictureModel, pictureModel) ||
                other.pictureModel == pictureModel) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.bodyOverview, bodyOverview) ||
                other.bodyOverview == bodyOverview) &&
            (identical(other.allowComments, allowComments) ||
                other.allowComments == allowComments) &&
            (identical(other.numberOfComments, numberOfComments) ||
                other.numberOfComments == numberOfComments) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.addNewComment, addNewComment) ||
                other.addNewComment == addNewComment) &&
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
    metaKeywords,
    metaDescription,
    metaTitle,
    seName,
    title,
    pictureModel,
    body,
    bodyOverview,
    allowComments,
    numberOfComments,
    createdOn,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_comments),
    addNewComment,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of BlogPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogPostModelImplCopyWith<_$BlogPostModelImpl> get copyWith =>
      __$$BlogPostModelImplCopyWithImpl<_$BlogPostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogPostModelImplToJson(this);
  }
}

abstract class _BlogPostModel implements BlogPostModel {
  factory _BlogPostModel({
    @JsonKey(name: 'MetaKeywords', includeIfNull: false)
    final String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    final String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) final String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'Title', includeIfNull: false) final String? title,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    final PictureModel? pictureModel,
    @JsonKey(name: 'Body', includeIfNull: false) final String? body,
    @JsonKey(name: 'BodyOverview', includeIfNull: false)
    final String? bodyOverview,
    @JsonKey(name: 'AllowComments', includeIfNull: false)
    final bool? allowComments,
    @JsonKey(name: 'NumberOfComments', includeIfNull: false)
    final int? numberOfComments,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'Tags', includeIfNull: false) final List<String>? tags,
    @JsonKey(name: 'Comments', includeIfNull: false)
    final List<BlogCommentModel>? comments,
    @JsonKey(name: 'AddNewComment', includeIfNull: false)
    final AddBlogCommentModel? addNewComment,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$BlogPostModelImpl;

  factory _BlogPostModel.fromJson(Map<String, dynamic> json) =
      _$BlogPostModelImpl.fromJson;

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
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel;
  @override
  @JsonKey(name: 'Body', includeIfNull: false)
  String? get body;
  @override
  @JsonKey(name: 'BodyOverview', includeIfNull: false)
  String? get bodyOverview;
  @override
  @JsonKey(name: 'AllowComments', includeIfNull: false)
  bool? get allowComments;
  @override
  @JsonKey(name: 'NumberOfComments', includeIfNull: false)
  int? get numberOfComments;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;
  @override
  @JsonKey(name: 'Tags', includeIfNull: false)
  List<String>? get tags;
  @override
  @JsonKey(name: 'Comments', includeIfNull: false)
  List<BlogCommentModel>? get comments;
  @override
  @JsonKey(name: 'AddNewComment', includeIfNull: false)
  AddBlogCommentModel? get addNewComment;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of BlogPostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlogPostModelImplCopyWith<_$BlogPostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
