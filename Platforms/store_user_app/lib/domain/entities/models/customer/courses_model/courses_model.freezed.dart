// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'courses_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CoursesModel _$CoursesModelFromJson(Map<String, dynamic> json) {
  return _CoursesModel.fromJson(json);
}

/// @nodoc
mixin _$CoursesModel {
  @JsonKey(name: 'CourseList', includeIfNull: false)
  List<Course>? get courseList => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CoursesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CoursesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoursesModelCopyWith<CoursesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoursesModelCopyWith<$Res> {
  factory $CoursesModelCopyWith(
    CoursesModel value,
    $Res Function(CoursesModel) then,
  ) = _$CoursesModelCopyWithImpl<$Res, CoursesModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CourseList', includeIfNull: false) List<Course>? courseList,
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CoursesModelCopyWithImpl<$Res, $Val extends CoursesModel>
    implements $CoursesModelCopyWith<$Res> {
  _$CoursesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoursesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseList = freezed,
    Object? customerId = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            courseList:
                freezed == courseList
                    ? _value.courseList
                    : courseList // ignore: cast_nullable_to_non_nullable
                        as List<Course>?,
            customerId:
                freezed == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CoursesModelImplCopyWith<$Res>
    implements $CoursesModelCopyWith<$Res> {
  factory _$$CoursesModelImplCopyWith(
    _$CoursesModelImpl value,
    $Res Function(_$CoursesModelImpl) then,
  ) = __$$CoursesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CourseList', includeIfNull: false) List<Course>? courseList,
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CoursesModelImplCopyWithImpl<$Res>
    extends _$CoursesModelCopyWithImpl<$Res, _$CoursesModelImpl>
    implements _$$CoursesModelImplCopyWith<$Res> {
  __$$CoursesModelImplCopyWithImpl(
    _$CoursesModelImpl _value,
    $Res Function(_$CoursesModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoursesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseList = freezed,
    Object? customerId = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CoursesModelImpl(
        courseList:
            freezed == courseList
                ? _value._courseList
                : courseList // ignore: cast_nullable_to_non_nullable
                    as List<Course>?,
        customerId:
            freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
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
class _$CoursesModelImpl implements _CoursesModel {
  _$CoursesModelImpl({
    @JsonKey(name: 'CourseList', includeIfNull: false)
    final List<Course>? courseList = const [],
    @JsonKey(name: 'CustomerId', includeIfNull: false) this.customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _courseList = courseList,
       _userFields = userFields;

  factory _$CoursesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoursesModelImplFromJson(json);

  final List<Course>? _courseList;
  @override
  @JsonKey(name: 'CourseList', includeIfNull: false)
  List<Course>? get courseList {
    final value = _courseList;
    if (value == null) return null;
    if (_courseList is EqualUnmodifiableListView) return _courseList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  final String? customerId;
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
    return 'CoursesModel(courseList: $courseList, customerId: $customerId, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoursesModelImpl &&
            const DeepCollectionEquality().equals(
              other._courseList,
              _courseList,
            ) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_courseList),
    customerId,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CoursesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoursesModelImplCopyWith<_$CoursesModelImpl> get copyWith =>
      __$$CoursesModelImplCopyWithImpl<_$CoursesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoursesModelImplToJson(this);
  }
}

abstract class _CoursesModel implements CoursesModel {
  factory _CoursesModel({
    @JsonKey(name: 'CourseList', includeIfNull: false)
    final List<Course>? courseList,
    @JsonKey(name: 'CustomerId', includeIfNull: false) final String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CoursesModelImpl;

  factory _CoursesModel.fromJson(Map<String, dynamic> json) =
      _$CoursesModelImpl.fromJson;

  @override
  @JsonKey(name: 'CourseList', includeIfNull: false)
  List<Course>? get courseList;
  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CoursesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoursesModelImplCopyWith<_$CoursesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
