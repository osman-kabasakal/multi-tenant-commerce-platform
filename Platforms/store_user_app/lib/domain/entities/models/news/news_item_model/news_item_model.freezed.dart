// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NewsItemModel _$NewsItemModelFromJson(Map<String, dynamic> json) {
  return _NewsItemModel.fromJson(json);
}

/// @nodoc
mixin _$NewsItemModel {
  @JsonKey(name: 'NewsItemId', includeIfNull: false)
  String? get newsItemId => throw _privateConstructorUsedError;
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
  @JsonKey(name: 'Short', includeIfNull: false)
  String? get short => throw _privateConstructorUsedError;
  @JsonKey(name: 'Full', includeIfNull: false)
  String? get full => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowComments', includeIfNull: false)
  bool? get allowComments => throw _privateConstructorUsedError;
  @JsonKey(name: 'NumberOfComments', includeIfNull: false)
  int? get numberOfComments => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'Comments', includeIfNull: false)
  List<NewsCommentModel>? get comments => throw _privateConstructorUsedError;
  @JsonKey(name: 'AddNewComment', includeIfNull: false)
  AddNewsCommentModel? get addNewComment => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this NewsItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsItemModelCopyWith<NewsItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsItemModelCopyWith<$Res> {
  factory $NewsItemModelCopyWith(
    NewsItemModel value,
    $Res Function(NewsItemModel) then,
  ) = _$NewsItemModelCopyWithImpl<$Res, NewsItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'NewsItemId', includeIfNull: false) String? newsItemId,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'Short', includeIfNull: false) String? short,
    @JsonKey(name: 'Full', includeIfNull: false) String? full,
    @JsonKey(name: 'AllowComments', includeIfNull: false) bool? allowComments,
    @JsonKey(name: 'NumberOfComments', includeIfNull: false)
    int? numberOfComments,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'Comments', includeIfNull: false)
    List<NewsCommentModel>? comments,
    @JsonKey(name: 'AddNewComment', includeIfNull: false)
    AddNewsCommentModel? addNewComment,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $PictureModelCopyWith<$Res>? get pictureModel;
  $AddNewsCommentModelCopyWith<$Res>? get addNewComment;
}

/// @nodoc
class _$NewsItemModelCopyWithImpl<$Res, $Val extends NewsItemModel>
    implements $NewsItemModelCopyWith<$Res> {
  _$NewsItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newsItemId = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? seName = freezed,
    Object? title = freezed,
    Object? pictureModel = freezed,
    Object? short = freezed,
    Object? full = freezed,
    Object? allowComments = freezed,
    Object? numberOfComments = freezed,
    Object? createdOn = freezed,
    Object? comments = freezed,
    Object? addNewComment = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            newsItemId:
                freezed == newsItemId
                    ? _value.newsItemId
                    : newsItemId // ignore: cast_nullable_to_non_nullable
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
            short:
                freezed == short
                    ? _value.short
                    : short // ignore: cast_nullable_to_non_nullable
                        as String?,
            full:
                freezed == full
                    ? _value.full
                    : full // ignore: cast_nullable_to_non_nullable
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
            comments:
                freezed == comments
                    ? _value.comments
                    : comments // ignore: cast_nullable_to_non_nullable
                        as List<NewsCommentModel>?,
            addNewComment:
                freezed == addNewComment
                    ? _value.addNewComment
                    : addNewComment // ignore: cast_nullable_to_non_nullable
                        as AddNewsCommentModel?,
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

  /// Create a copy of NewsItemModel
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

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddNewsCommentModelCopyWith<$Res>? get addNewComment {
    if (_value.addNewComment == null) {
      return null;
    }

    return $AddNewsCommentModelCopyWith<$Res>(_value.addNewComment!, (value) {
      return _then(_value.copyWith(addNewComment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NewsItemModelImplCopyWith<$Res>
    implements $NewsItemModelCopyWith<$Res> {
  factory _$$NewsItemModelImplCopyWith(
    _$NewsItemModelImpl value,
    $Res Function(_$NewsItemModelImpl) then,
  ) = __$$NewsItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'NewsItemId', includeIfNull: false) String? newsItemId,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'Short', includeIfNull: false) String? short,
    @JsonKey(name: 'Full', includeIfNull: false) String? full,
    @JsonKey(name: 'AllowComments', includeIfNull: false) bool? allowComments,
    @JsonKey(name: 'NumberOfComments', includeIfNull: false)
    int? numberOfComments,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'Comments', includeIfNull: false)
    List<NewsCommentModel>? comments,
    @JsonKey(name: 'AddNewComment', includeIfNull: false)
    AddNewsCommentModel? addNewComment,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $PictureModelCopyWith<$Res>? get pictureModel;
  @override
  $AddNewsCommentModelCopyWith<$Res>? get addNewComment;
}

/// @nodoc
class __$$NewsItemModelImplCopyWithImpl<$Res>
    extends _$NewsItemModelCopyWithImpl<$Res, _$NewsItemModelImpl>
    implements _$$NewsItemModelImplCopyWith<$Res> {
  __$$NewsItemModelImplCopyWithImpl(
    _$NewsItemModelImpl _value,
    $Res Function(_$NewsItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newsItemId = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? seName = freezed,
    Object? title = freezed,
    Object? pictureModel = freezed,
    Object? short = freezed,
    Object? full = freezed,
    Object? allowComments = freezed,
    Object? numberOfComments = freezed,
    Object? createdOn = freezed,
    Object? comments = freezed,
    Object? addNewComment = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$NewsItemModelImpl(
        newsItemId:
            freezed == newsItemId
                ? _value.newsItemId
                : newsItemId // ignore: cast_nullable_to_non_nullable
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
        short:
            freezed == short
                ? _value.short
                : short // ignore: cast_nullable_to_non_nullable
                    as String?,
        full:
            freezed == full
                ? _value.full
                : full // ignore: cast_nullable_to_non_nullable
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
        comments:
            freezed == comments
                ? _value._comments
                : comments // ignore: cast_nullable_to_non_nullable
                    as List<NewsCommentModel>?,
        addNewComment:
            freezed == addNewComment
                ? _value.addNewComment
                : addNewComment // ignore: cast_nullable_to_non_nullable
                    as AddNewsCommentModel?,
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
class _$NewsItemModelImpl implements _NewsItemModel {
  _$NewsItemModelImpl({
    @JsonKey(name: 'NewsItemId', includeIfNull: false) this.newsItemId,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) this.metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    this.metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) this.metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'Title', includeIfNull: false) this.title,
    @JsonKey(name: 'PictureModel', includeIfNull: false) this.pictureModel,
    @JsonKey(name: 'Short', includeIfNull: false) this.short,
    @JsonKey(name: 'Full', includeIfNull: false) this.full,
    @JsonKey(name: 'AllowComments', includeIfNull: false)
    this.allowComments = false,
    @JsonKey(name: 'NumberOfComments', includeIfNull: false)
    this.numberOfComments,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'Comments', includeIfNull: false)
    final List<NewsCommentModel>? comments = const [],
    @JsonKey(name: 'AddNewComment', includeIfNull: false) this.addNewComment,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _comments = comments,
       _userFields = userFields;

  factory _$NewsItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'NewsItemId', includeIfNull: false)
  final String? newsItemId;
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
  @JsonKey(name: 'Short', includeIfNull: false)
  final String? short;
  @override
  @JsonKey(name: 'Full', includeIfNull: false)
  final String? full;
  @override
  @JsonKey(name: 'AllowComments', includeIfNull: false)
  final bool? allowComments;
  @override
  @JsonKey(name: 'NumberOfComments', includeIfNull: false)
  final int? numberOfComments;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
  final List<NewsCommentModel>? _comments;
  @override
  @JsonKey(name: 'Comments', includeIfNull: false)
  List<NewsCommentModel>? get comments {
    final value = _comments;
    if (value == null) return null;
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'AddNewComment', includeIfNull: false)
  final AddNewsCommentModel? addNewComment;
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
    return 'NewsItemModel(newsItemId: $newsItemId, metaKeywords: $metaKeywords, metaDescription: $metaDescription, metaTitle: $metaTitle, seName: $seName, title: $title, pictureModel: $pictureModel, short: $short, full: $full, allowComments: $allowComments, numberOfComments: $numberOfComments, createdOn: $createdOn, comments: $comments, addNewComment: $addNewComment, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsItemModelImpl &&
            (identical(other.newsItemId, newsItemId) ||
                other.newsItemId == newsItemId) &&
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
            (identical(other.short, short) || other.short == short) &&
            (identical(other.full, full) || other.full == full) &&
            (identical(other.allowComments, allowComments) ||
                other.allowComments == allowComments) &&
            (identical(other.numberOfComments, numberOfComments) ||
                other.numberOfComments == numberOfComments) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
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
    newsItemId,
    metaKeywords,
    metaDescription,
    metaTitle,
    seName,
    title,
    pictureModel,
    short,
    full,
    allowComments,
    numberOfComments,
    createdOn,
    const DeepCollectionEquality().hash(_comments),
    addNewComment,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsItemModelImplCopyWith<_$NewsItemModelImpl> get copyWith =>
      __$$NewsItemModelImplCopyWithImpl<_$NewsItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsItemModelImplToJson(this);
  }
}

abstract class _NewsItemModel implements NewsItemModel {
  factory _NewsItemModel({
    @JsonKey(name: 'NewsItemId', includeIfNull: false) final String? newsItemId,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false)
    final String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    final String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) final String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'Title', includeIfNull: false) final String? title,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    final PictureModel? pictureModel,
    @JsonKey(name: 'Short', includeIfNull: false) final String? short,
    @JsonKey(name: 'Full', includeIfNull: false) final String? full,
    @JsonKey(name: 'AllowComments', includeIfNull: false)
    final bool? allowComments,
    @JsonKey(name: 'NumberOfComments', includeIfNull: false)
    final int? numberOfComments,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'Comments', includeIfNull: false)
    final List<NewsCommentModel>? comments,
    @JsonKey(name: 'AddNewComment', includeIfNull: false)
    final AddNewsCommentModel? addNewComment,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$NewsItemModelImpl;

  factory _NewsItemModel.fromJson(Map<String, dynamic> json) =
      _$NewsItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'NewsItemId', includeIfNull: false)
  String? get newsItemId;
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
  @JsonKey(name: 'Short', includeIfNull: false)
  String? get short;
  @override
  @JsonKey(name: 'Full', includeIfNull: false)
  String? get full;
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
  @JsonKey(name: 'Comments', includeIfNull: false)
  List<NewsCommentModel>? get comments;
  @override
  @JsonKey(name: 'AddNewComment', includeIfNull: false)
  AddNewsCommentModel? get addNewComment;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsItemModelImplCopyWith<_$NewsItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
