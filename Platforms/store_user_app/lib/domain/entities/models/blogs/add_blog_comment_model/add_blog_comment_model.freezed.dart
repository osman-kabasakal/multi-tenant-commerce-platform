// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_blog_comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddBlogCommentModel _$AddBlogCommentModelFromJson(Map<String, dynamic> json) {
  return _AddBlogCommentModel.fromJson(json);
}

/// @nodoc
mixin _$AddBlogCommentModel {
  @JsonKey(name: 'CommentText', includeIfNull: false)
  String? get commentText => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this AddBlogCommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddBlogCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddBlogCommentModelCopyWith<AddBlogCommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddBlogCommentModelCopyWith<$Res> {
  factory $AddBlogCommentModelCopyWith(
    AddBlogCommentModel value,
    $Res Function(AddBlogCommentModel) then,
  ) = _$AddBlogCommentModelCopyWithImpl<$Res, AddBlogCommentModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CommentText', includeIfNull: false) String? commentText,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class _$AddBlogCommentModelCopyWithImpl<$Res, $Val extends AddBlogCommentModel>
    implements $AddBlogCommentModelCopyWith<$Res> {
  _$AddBlogCommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddBlogCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentText = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
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
            captcha:
                freezed == captcha
                    ? _value.captcha
                    : captcha // ignore: cast_nullable_to_non_nullable
                        as ICaptchaValidModel?,
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

  /// Create a copy of AddBlogCommentModel
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
}

/// @nodoc
abstract class _$$AddBlogCommentModelImplCopyWith<$Res>
    implements $AddBlogCommentModelCopyWith<$Res> {
  factory _$$AddBlogCommentModelImplCopyWith(
    _$AddBlogCommentModelImpl value,
    $Res Function(_$AddBlogCommentModelImpl) then,
  ) = __$$AddBlogCommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CommentText', includeIfNull: false) String? commentText,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false) bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
}

/// @nodoc
class __$$AddBlogCommentModelImplCopyWithImpl<$Res>
    extends _$AddBlogCommentModelCopyWithImpl<$Res, _$AddBlogCommentModelImpl>
    implements _$$AddBlogCommentModelImplCopyWith<$Res> {
  __$$AddBlogCommentModelImplCopyWithImpl(
    _$AddBlogCommentModelImpl _value,
    $Res Function(_$AddBlogCommentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddBlogCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commentText = freezed,
    Object? displayCaptcha = freezed,
    Object? captcha = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$AddBlogCommentModelImpl(
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
        captcha:
            freezed == captcha
                ? _value.captcha
                : captcha // ignore: cast_nullable_to_non_nullable
                    as ICaptchaValidModel?,
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
class _$AddBlogCommentModelImpl implements _AddBlogCommentModel {
  _$AddBlogCommentModelImpl({
    @JsonKey(name: 'CommentText', includeIfNull: false) this.commentText,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    this.displayCaptcha = false,
    @JsonKey(name: 'Captcha', includeIfNull: false) this.captcha,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$AddBlogCommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddBlogCommentModelImplFromJson(json);

  @override
  @JsonKey(name: 'CommentText', includeIfNull: false)
  final String? commentText;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  final bool? displayCaptcha;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  final ICaptchaValidModel? captcha;
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
    return 'AddBlogCommentModel(commentText: $commentText, displayCaptcha: $displayCaptcha, captcha: $captcha, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddBlogCommentModelImpl &&
            (identical(other.commentText, commentText) ||
                other.commentText == commentText) &&
            (identical(other.displayCaptcha, displayCaptcha) ||
                other.displayCaptcha == displayCaptcha) &&
            (identical(other.captcha, captcha) || other.captcha == captcha) &&
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
    captcha,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of AddBlogCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddBlogCommentModelImplCopyWith<_$AddBlogCommentModelImpl> get copyWith =>
      __$$AddBlogCommentModelImplCopyWithImpl<_$AddBlogCommentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddBlogCommentModelImplToJson(this);
  }
}

abstract class _AddBlogCommentModel implements AddBlogCommentModel {
  factory _AddBlogCommentModel({
    @JsonKey(name: 'CommentText', includeIfNull: false)
    final String? commentText,
    @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
    final bool? displayCaptcha,
    @JsonKey(name: 'Captcha', includeIfNull: false)
    final ICaptchaValidModel? captcha,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$AddBlogCommentModelImpl;

  factory _AddBlogCommentModel.fromJson(Map<String, dynamic> json) =
      _$AddBlogCommentModelImpl.fromJson;

  @override
  @JsonKey(name: 'CommentText', includeIfNull: false)
  String? get commentText;
  @override
  @JsonKey(name: 'DisplayCaptcha', includeIfNull: false)
  bool? get displayCaptcha;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of AddBlogCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddBlogCommentModelImplCopyWith<_$AddBlogCommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
