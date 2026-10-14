// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BlogCommentModel _$BlogCommentModelFromJson(Map<String, dynamic> json) {
  return _BlogCommentModel.fromJson(json);
}

/// @nodoc
mixin _$BlogCommentModel {
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerName', includeIfNull: false)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'CommentText', includeIfNull: false)
  String? get commentText => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this BlogCommentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BlogCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlogCommentModelCopyWith<BlogCommentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogCommentModelCopyWith<$Res> {
  factory $BlogCommentModelCopyWith(
    BlogCommentModel value,
    $Res Function(BlogCommentModel) then,
  ) = _$BlogCommentModelCopyWithImpl<$Res, BlogCommentModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'CustomerName', includeIfNull: false) String? customerName,
    @JsonKey(name: 'CommentText', includeIfNull: false) String? commentText,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$BlogCommentModelCopyWithImpl<$Res, $Val extends BlogCommentModel>
    implements $BlogCommentModelCopyWith<$Res> {
  _$BlogCommentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlogCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? commentText = freezed,
    Object? createdOn = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            customerId:
                freezed == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerName:
                freezed == customerName
                    ? _value.customerName
                    : customerName // ignore: cast_nullable_to_non_nullable
                        as String?,
            commentText:
                freezed == commentText
                    ? _value.commentText
                    : commentText // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdOn:
                freezed == createdOn
                    ? _value.createdOn
                    : createdOn // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
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
abstract class _$$BlogCommentModelImplCopyWith<$Res>
    implements $BlogCommentModelCopyWith<$Res> {
  factory _$$BlogCommentModelImplCopyWith(
    _$BlogCommentModelImpl value,
    $Res Function(_$BlogCommentModelImpl) then,
  ) = __$$BlogCommentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'CustomerName', includeIfNull: false) String? customerName,
    @JsonKey(name: 'CommentText', includeIfNull: false) String? commentText,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$BlogCommentModelImplCopyWithImpl<$Res>
    extends _$BlogCommentModelCopyWithImpl<$Res, _$BlogCommentModelImpl>
    implements _$$BlogCommentModelImplCopyWith<$Res> {
  __$$BlogCommentModelImplCopyWithImpl(
    _$BlogCommentModelImpl _value,
    $Res Function(_$BlogCommentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BlogCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = freezed,
    Object? customerName = freezed,
    Object? commentText = freezed,
    Object? createdOn = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$BlogCommentModelImpl(
        customerId:
            freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerName:
            freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                    as String?,
        commentText:
            freezed == commentText
                ? _value.commentText
                : commentText // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdOn:
            freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
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
class _$BlogCommentModelImpl implements _BlogCommentModel {
  _$BlogCommentModelImpl({
    @JsonKey(name: 'CustomerId', includeIfNull: false) this.customerId,
    @JsonKey(name: 'CustomerName', includeIfNull: false) this.customerName,
    @JsonKey(name: 'CommentText', includeIfNull: false) this.commentText,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$BlogCommentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogCommentModelImplFromJson(json);

  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  final String? customerId;
  @override
  @JsonKey(name: 'CustomerName', includeIfNull: false)
  final String? customerName;
  @override
  @JsonKey(name: 'CommentText', includeIfNull: false)
  final String? commentText;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
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
    return 'BlogCommentModel(customerId: $customerId, customerName: $customerName, commentText: $commentText, createdOn: $createdOn, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogCommentModelImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.commentText, commentText) ||
                other.commentText == commentText) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
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
    customerId,
    customerName,
    commentText,
    createdOn,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of BlogCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogCommentModelImplCopyWith<_$BlogCommentModelImpl> get copyWith =>
      __$$BlogCommentModelImplCopyWithImpl<_$BlogCommentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogCommentModelImplToJson(this);
  }
}

abstract class _BlogCommentModel implements BlogCommentModel {
  factory _BlogCommentModel({
    @JsonKey(name: 'CustomerId', includeIfNull: false) final String? customerId,
    @JsonKey(name: 'CustomerName', includeIfNull: false)
    final String? customerName,
    @JsonKey(name: 'CommentText', includeIfNull: false)
    final String? commentText,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$BlogCommentModelImpl;

  factory _BlogCommentModel.fromJson(Map<String, dynamic> json) =
      _$BlogCommentModelImpl.fromJson;

  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId;
  @override
  @JsonKey(name: 'CustomerName', includeIfNull: false)
  String? get customerName;
  @override
  @JsonKey(name: 'CommentText', includeIfNull: false)
  String? get commentText;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of BlogCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlogCommentModelImplCopyWith<_$BlogCommentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
