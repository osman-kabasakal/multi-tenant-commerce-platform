// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Course _$CourseFromJson(Map<String, dynamic> json) {
  return _Course.fromJson(json);
}

/// @nodoc
mixin _$Course {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  String? get shortDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'Level', includeIfNull: false)
  String? get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'Approved', includeIfNull: false)
  bool? get approved => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this Course to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseCopyWith<Course> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseCopyWith<$Res> {
  factory $CourseCopyWith(Course value, $Res Function(Course) then) =
      _$CourseCopyWithImpl<$Res, Course>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    String? shortDescription,
    @JsonKey(name: 'Level', includeIfNull: false) String? level,
    @JsonKey(name: 'Approved', includeIfNull: false) bool? approved,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CourseCopyWithImpl<$Res, $Val extends Course>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? shortDescription = freezed,
    Object? level = freezed,
    Object? approved = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            seName:
                freezed == seName
                    ? _value.seName
                    : seName // ignore: cast_nullable_to_non_nullable
                        as String?,
            shortDescription:
                freezed == shortDescription
                    ? _value.shortDescription
                    : shortDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            level:
                freezed == level
                    ? _value.level
                    : level // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CourseImplCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$$CourseImplCopyWith(
    _$CourseImpl value,
    $Res Function(_$CourseImpl) then,
  ) = __$$CourseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    String? shortDescription,
    @JsonKey(name: 'Level', includeIfNull: false) String? level,
    @JsonKey(name: 'Approved', includeIfNull: false) bool? approved,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CourseImplCopyWithImpl<$Res>
    extends _$CourseCopyWithImpl<$Res, _$CourseImpl>
    implements _$$CourseImplCopyWith<$Res> {
  __$$CourseImplCopyWithImpl(
    _$CourseImpl _value,
    $Res Function(_$CourseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? shortDescription = freezed,
    Object? level = freezed,
    Object? approved = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CourseImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        seName:
            freezed == seName
                ? _value.seName
                : seName // ignore: cast_nullable_to_non_nullable
                    as String?,
        shortDescription:
            freezed == shortDescription
                ? _value.shortDescription
                : shortDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        level:
            freezed == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
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
class _$CourseImpl implements _Course {
  _$CourseImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    this.shortDescription,
    @JsonKey(name: 'Level', includeIfNull: false) this.level,
    @JsonKey(name: 'Approved', includeIfNull: false) this.approved = false,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$CourseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
  @override
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  final String? shortDescription;
  @override
  @JsonKey(name: 'Level', includeIfNull: false)
  final String? level;
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
    return 'Course(name: $name, seName: $seName, shortDescription: $shortDescription, level: $level, approved: $approved, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.level, level) || other.level == level) &&
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
    name,
    seName,
    shortDescription,
    level,
    approved,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseImplCopyWith<_$CourseImpl> get copyWith =>
      __$$CourseImplCopyWithImpl<_$CourseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseImplToJson(this);
  }
}

abstract class _Course implements Course {
  factory _Course({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    final String? shortDescription,
    @JsonKey(name: 'Level', includeIfNull: false) final String? level,
    @JsonKey(name: 'Approved', includeIfNull: false) final bool? approved,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CourseImpl;

  factory _Course.fromJson(Map<String, dynamic> json) = _$CourseImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  String? get shortDescription;
  @override
  @JsonKey(name: 'Level', includeIfNull: false)
  String? get level;
  @override
  @JsonKey(name: 'Approved', includeIfNull: false)
  bool? get approved;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseImplCopyWith<_$CourseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
