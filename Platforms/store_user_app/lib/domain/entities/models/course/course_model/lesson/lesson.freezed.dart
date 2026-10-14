// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return _Lesson.fromJson(json);
}

/// @nodoc
mixin _$Lesson {
  @JsonKey(name: 'SubjectId', includeIfNull: false)
  String? get subjectId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  String? get shortDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayOrder', includeIfNull: false)
  int? get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'PictureUrl', includeIfNull: false)
  String? get pictureUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'Approved', includeIfNull: false)
  bool? get approved => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LessonCopyWith<Lesson> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonCopyWith<$Res> {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) then) =
      _$LessonCopyWithImpl<$Res, Lesson>;
  @useResult
  $Res call({
    @JsonKey(name: 'SubjectId', includeIfNull: false) String? subjectId,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    String? shortDescription,
    @JsonKey(name: 'DisplayOrder', includeIfNull: false) int? displayOrder,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) String? pictureUrl,
    @JsonKey(name: 'Approved', includeIfNull: false) bool? approved,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$LessonCopyWithImpl<$Res, $Val extends Lesson>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subjectId = freezed,
    Object? name = freezed,
    Object? shortDescription = freezed,
    Object? displayOrder = freezed,
    Object? pictureUrl = freezed,
    Object? approved = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            subjectId:
                freezed == subjectId
                    ? _value.subjectId
                    : subjectId // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            shortDescription:
                freezed == shortDescription
                    ? _value.shortDescription
                    : shortDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            displayOrder:
                freezed == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int?,
            pictureUrl:
                freezed == pictureUrl
                    ? _value.pictureUrl
                    : pictureUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            approved:
                freezed == approved
                    ? _value.approved
                    : approved // ignore: cast_nullable_to_non_nullable
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
abstract class _$$LessonImplCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$$LessonImplCopyWith(
    _$LessonImpl value,
    $Res Function(_$LessonImpl) then,
  ) = __$$LessonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'SubjectId', includeIfNull: false) String? subjectId,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    String? shortDescription,
    @JsonKey(name: 'DisplayOrder', includeIfNull: false) int? displayOrder,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) String? pictureUrl,
    @JsonKey(name: 'Approved', includeIfNull: false) bool? approved,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$LessonImplCopyWithImpl<$Res>
    extends _$LessonCopyWithImpl<$Res, _$LessonImpl>
    implements _$$LessonImplCopyWith<$Res> {
  __$$LessonImplCopyWithImpl(
    _$LessonImpl _value,
    $Res Function(_$LessonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subjectId = freezed,
    Object? name = freezed,
    Object? shortDescription = freezed,
    Object? displayOrder = freezed,
    Object? pictureUrl = freezed,
    Object? approved = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$LessonImpl(
        subjectId:
            freezed == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        shortDescription:
            freezed == shortDescription
                ? _value.shortDescription
                : shortDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        displayOrder:
            freezed == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int?,
        pictureUrl:
            freezed == pictureUrl
                ? _value.pictureUrl
                : pictureUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        approved:
            freezed == approved
                ? _value.approved
                : approved // ignore: cast_nullable_to_non_nullable
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
class _$LessonImpl implements _Lesson {
  _$LessonImpl({
    @JsonKey(name: 'SubjectId', includeIfNull: false) this.subjectId,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    this.shortDescription,
    @JsonKey(name: 'DisplayOrder', includeIfNull: false) this.displayOrder,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) this.pictureUrl,
    @JsonKey(name: 'Approved', includeIfNull: false) this.approved = false,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$LessonImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonImplFromJson(json);

  @override
  @JsonKey(name: 'SubjectId', includeIfNull: false)
  final String? subjectId;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  final String? shortDescription;
  @override
  @JsonKey(name: 'DisplayOrder', includeIfNull: false)
  final int? displayOrder;
  @override
  @JsonKey(name: 'PictureUrl', includeIfNull: false)
  final String? pictureUrl;
  @override
  @JsonKey(name: 'Approved', includeIfNull: false)
  final bool? approved;
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
    return 'Lesson(subjectId: $subjectId, name: $name, shortDescription: $shortDescription, displayOrder: $displayOrder, pictureUrl: $pictureUrl, approved: $approved, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonImpl &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl) &&
            (identical(other.approved, approved) ||
                other.approved == approved) &&
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
    subjectId,
    name,
    shortDescription,
    displayOrder,
    pictureUrl,
    approved,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      __$$LessonImplCopyWithImpl<_$LessonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonImplToJson(this);
  }
}

abstract class _Lesson implements Lesson {
  factory _Lesson({
    @JsonKey(name: 'SubjectId', includeIfNull: false) final String? subjectId,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    final String? shortDescription,
    @JsonKey(name: 'DisplayOrder', includeIfNull: false)
    final int? displayOrder,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) final String? pictureUrl,
    @JsonKey(name: 'Approved', includeIfNull: false) final bool? approved,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$LessonImpl;

  factory _Lesson.fromJson(Map<String, dynamic> json) = _$LessonImpl.fromJson;

  @override
  @JsonKey(name: 'SubjectId', includeIfNull: false)
  String? get subjectId;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  String? get shortDescription;
  @override
  @JsonKey(name: 'DisplayOrder', includeIfNull: false)
  int? get displayOrder;
  @override
  @JsonKey(name: 'PictureUrl', includeIfNull: false)
  String? get pictureUrl;
  @override
  @JsonKey(name: 'Approved', includeIfNull: false)
  bool? get approved;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
