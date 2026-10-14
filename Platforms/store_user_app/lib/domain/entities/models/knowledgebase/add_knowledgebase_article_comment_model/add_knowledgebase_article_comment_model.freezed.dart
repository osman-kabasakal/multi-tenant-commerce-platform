// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_knowledgebase_article_comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddKnowledgebaseArticleCommentModel
_$AddKnowledgebaseArticleCommentModelFromJson(Map<String, dynamic> json) {
  return _AddKnowledgebaseArticleCommentModel.fromJson(json);
}

/// @nodoc
mixin _$AddKnowledgebaseArticleCommentModel {
  @JsonKey(name: 'CommentText', includeIfNull: false)
  String? get commentText => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this AddKnowledgebaseArticleCommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddKnowledgebaseArticleCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddKnowledgebaseArticleCommentModelCopyWith<
    AddKnowledgebaseArticleCommentModel
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddKnowledgebaseArticleCommentModelCopyWith<$Res> {
  factory $AddKnowledgebaseArticleCommentModelCopyWith(
    AddKnowledgebaseArticleCommentModel value,
    $Res Function(AddKnowledgebaseArticleCommentModel) then,
  ) =
      _$AddKnowledgebaseArticleCommentModelCopyWithImpl<
        $Res,
        AddKnowledgebaseArticleCommentModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'CommentText', includeIfNull: false) String? commentText,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$AddKnowledgebaseArticleCommentModelCopyWithImpl<
  $Res,
  $Val extends AddKnowledgebaseArticleCommentModel
>
    implements $AddKnowledgebaseArticleCommentModelCopyWith<$Res> {
  _$AddKnowledgebaseArticleCommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddKnowledgebaseArticleCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentText = freezed,
    Object? displayCaptcha = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            commentText:
                freezed == commentText
                    ? _value.commentText
                    : commentText // ignore: cast_nullable_to_non_nullable
                        as String?,
            displayCaptcha:
                freezed == displayCaptcha
                    ? _value.displayCaptcha
                    : displayCaptcha // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
abstract class _$$AddKnowledgebaseArticleCommentModelImplCopyWith<$Res>
    implements $AddKnowledgebaseArticleCommentModelCopyWith<$Res> {
  factory _$$AddKnowledgebaseArticleCommentModelImplCopyWith(
    _$AddKnowledgebaseArticleCommentModelImpl value,
    $Res Function(_$AddKnowledgebaseArticleCommentModelImpl) then,
  ) = __$$AddKnowledgebaseArticleCommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CommentText', includeIfNull: false) String? commentText,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$AddKnowledgebaseArticleCommentModelImplCopyWithImpl<$Res>
    extends
        _$AddKnowledgebaseArticleCommentModelCopyWithImpl<
          $Res,
          _$AddKnowledgebaseArticleCommentModelImpl
        >
    implements _$$AddKnowledgebaseArticleCommentModelImplCopyWith<$Res> {
  __$$AddKnowledgebaseArticleCommentModelImplCopyWithImpl(
    _$AddKnowledgebaseArticleCommentModelImpl _value,
    $Res Function(_$AddKnowledgebaseArticleCommentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddKnowledgebaseArticleCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentText = freezed,
    Object? displayCaptcha = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$AddKnowledgebaseArticleCommentModelImpl(
        commentText:
            freezed == commentText
                ? _value.commentText
                : commentText // ignore: cast_nullable_to_non_nullable
                    as String?,
        displayCaptcha:
            freezed == displayCaptcha
                ? _value.displayCaptcha
                : displayCaptcha // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$AddKnowledgebaseArticleCommentModelImpl
    implements _AddKnowledgebaseArticleCommentModel {
  _$AddKnowledgebaseArticleCommentModelImpl({
    @JsonKey(name: 'CommentText', includeIfNull: false) this.commentText,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    this.displayCaptcha = false,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$AddKnowledgebaseArticleCommentModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$AddKnowledgebaseArticleCommentModelImplFromJson(json);

  @override
  @JsonKey(name: 'CommentText', includeIfNull: false)
  final String? commentText;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  final bool? displayCaptcha;
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
    return 'AddKnowledgebaseArticleCommentModel(commentText: $commentText, displayCaptcha: $displayCaptcha, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddKnowledgebaseArticleCommentModelImpl &&
            (identical(other.commentText, commentText) ||
                other.commentText == commentText) &&
            (identical(other.displayCaptcha, displayCaptcha) ||
                other.displayCaptcha == displayCaptcha) &&
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
    commentText,
    displayCaptcha,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of AddKnowledgebaseArticleCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddKnowledgebaseArticleCommentModelImplCopyWith<
    _$AddKnowledgebaseArticleCommentModelImpl
  >
  get copyWith => __$$AddKnowledgebaseArticleCommentModelImplCopyWithImpl<
    _$AddKnowledgebaseArticleCommentModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddKnowledgebaseArticleCommentModelImplToJson(this);
  }
}

abstract class _AddKnowledgebaseArticleCommentModel
    implements AddKnowledgebaseArticleCommentModel {
  factory _AddKnowledgebaseArticleCommentModel({
    @JsonKey(name: 'CommentText', includeIfNull: false)
    final String? commentText,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    final bool? displayCaptcha,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$AddKnowledgebaseArticleCommentModelImpl;

  factory _AddKnowledgebaseArticleCommentModel.fromJson(
    Map<String, dynamic> json,
  ) = _$AddKnowledgebaseArticleCommentModelImpl.fromJson;

  @override
  @JsonKey(name: 'CommentText', includeIfNull: false)
  String? get commentText;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of AddKnowledgebaseArticleCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddKnowledgebaseArticleCommentModelImplCopyWith<
    _$AddKnowledgebaseArticleCommentModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
