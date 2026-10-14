// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LessonModel _$LessonModelFromJson(Map<String, dynamic> json) {
  return _LessonModel.fromJson(json);
}

/// @nodoc
mixin _$LessonModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  String? get shortDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'PictureUrl', includeIfNull: false)
  String? get pictureUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'DownloadFile', includeIfNull: false)
  bool? get downloadFile => throw _privateConstructorUsedError;
  @JsonKey(name: 'VideoFile', includeIfNull: false)
  bool? get videoFile => throw _privateConstructorUsedError;
  @JsonKey(name: 'CourseId', includeIfNull: false)
  String? get courseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CourseName', includeIfNull: false)
  String? get courseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'CourseSeName', includeIfNull: false)
  String? get courseSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'CourseLevel', includeIfNull: false)
  String? get courseLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'CourseDescription', includeIfNull: false)
  String? get courseDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaKeywords', includeIfNull: false)
  String? get metaKeywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaDescription', includeIfNull: false)
  String? get metaDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaTitle', includeIfNull: false)
  String? get metaTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'Approved', includeIfNull: false)
  bool? get approved => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this LessonModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LessonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LessonModelCopyWith<LessonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonModelCopyWith<$Res> {
  factory $LessonModelCopyWith(
    LessonModel value,
    $Res Function(LessonModel) then,
  ) = _$LessonModelCopyWithImpl<$Res, LessonModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    String? shortDescription,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) String? pictureUrl,
    @JsonKey(name: 'DownloadFile', includeIfNull: false) bool? downloadFile,
    @JsonKey(name: 'VideoFile', includeIfNull: false) bool? videoFile,
    @JsonKey(name: 'CourseId', includeIfNull: false) String? courseId,
    @JsonKey(name: 'CourseName', includeIfNull: false) String? courseName,
    @JsonKey(name: 'CourseSeName', includeIfNull: false) String? courseSeName,
    @JsonKey(name: 'CourseLevel', includeIfNull: false) String? courseLevel,
    @JsonKey(name: 'CourseDescription', includeIfNull: false)
    String? courseDescription,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'Approved', includeIfNull: false) bool? approved,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$LessonModelCopyWithImpl<$Res, $Val extends LessonModel>
    implements $LessonModelCopyWith<$Res> {
  _$LessonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LessonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? shortDescription = freezed,
    Object? description = freezed,
    Object? pictureUrl = freezed,
    Object? downloadFile = freezed,
    Object? videoFile = freezed,
    Object? courseId = freezed,
    Object? courseName = freezed,
    Object? courseSeName = freezed,
    Object? courseLevel = freezed,
    Object? courseDescription = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
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
            shortDescription:
                freezed == shortDescription
                    ? _value.shortDescription
                    : shortDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            pictureUrl:
                freezed == pictureUrl
                    ? _value.pictureUrl
                    : pictureUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            downloadFile:
                freezed == downloadFile
                    ? _value.downloadFile
                    : downloadFile // ignore: cast_nullable_to_non_nullable
                        as bool?,
            videoFile:
                freezed == videoFile
                    ? _value.videoFile
                    : videoFile // ignore: cast_nullable_to_non_nullable
                        as bool?,
            courseId:
                freezed == courseId
                    ? _value.courseId
                    : courseId // ignore: cast_nullable_to_non_nullable
                        as String?,
            courseName:
                freezed == courseName
                    ? _value.courseName
                    : courseName // ignore: cast_nullable_to_non_nullable
                        as String?,
            courseSeName:
                freezed == courseSeName
                    ? _value.courseSeName
                    : courseSeName // ignore: cast_nullable_to_non_nullable
                        as String?,
            courseLevel:
                freezed == courseLevel
                    ? _value.courseLevel
                    : courseLevel // ignore: cast_nullable_to_non_nullable
                        as String?,
            courseDescription:
                freezed == courseDescription
                    ? _value.courseDescription
                    : courseDescription // ignore: cast_nullable_to_non_nullable
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
abstract class _$$LessonModelImplCopyWith<$Res>
    implements $LessonModelCopyWith<$Res> {
  factory _$$LessonModelImplCopyWith(
    _$LessonModelImpl value,
    $Res Function(_$LessonModelImpl) then,
  ) = __$$LessonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    String? shortDescription,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) String? pictureUrl,
    @JsonKey(name: 'DownloadFile', includeIfNull: false) bool? downloadFile,
    @JsonKey(name: 'VideoFile', includeIfNull: false) bool? videoFile,
    @JsonKey(name: 'CourseId', includeIfNull: false) String? courseId,
    @JsonKey(name: 'CourseName', includeIfNull: false) String? courseName,
    @JsonKey(name: 'CourseSeName', includeIfNull: false) String? courseSeName,
    @JsonKey(name: 'CourseLevel', includeIfNull: false) String? courseLevel,
    @JsonKey(name: 'CourseDescription', includeIfNull: false)
    String? courseDescription,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'Approved', includeIfNull: false) bool? approved,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$LessonModelImplCopyWithImpl<$Res>
    extends _$LessonModelCopyWithImpl<$Res, _$LessonModelImpl>
    implements _$$LessonModelImplCopyWith<$Res> {
  __$$LessonModelImplCopyWithImpl(
    _$LessonModelImpl _value,
    $Res Function(_$LessonModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LessonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? shortDescription = freezed,
    Object? description = freezed,
    Object? pictureUrl = freezed,
    Object? downloadFile = freezed,
    Object? videoFile = freezed,
    Object? courseId = freezed,
    Object? courseName = freezed,
    Object? courseSeName = freezed,
    Object? courseLevel = freezed,
    Object? courseDescription = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? approved = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$LessonModelImpl(
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
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        pictureUrl:
            freezed == pictureUrl
                ? _value.pictureUrl
                : pictureUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        downloadFile:
            freezed == downloadFile
                ? _value.downloadFile
                : downloadFile // ignore: cast_nullable_to_non_nullable
                    as bool?,
        videoFile:
            freezed == videoFile
                ? _value.videoFile
                : videoFile // ignore: cast_nullable_to_non_nullable
                    as bool?,
        courseId:
            freezed == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                    as String?,
        courseName:
            freezed == courseName
                ? _value.courseName
                : courseName // ignore: cast_nullable_to_non_nullable
                    as String?,
        courseSeName:
            freezed == courseSeName
                ? _value.courseSeName
                : courseSeName // ignore: cast_nullable_to_non_nullable
                    as String?,
        courseLevel:
            freezed == courseLevel
                ? _value.courseLevel
                : courseLevel // ignore: cast_nullable_to_non_nullable
                    as String?,
        courseDescription:
            freezed == courseDescription
                ? _value.courseDescription
                : courseDescription // ignore: cast_nullable_to_non_nullable
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
class _$LessonModelImpl implements _LessonModel {
  _$LessonModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    this.shortDescription,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) this.pictureUrl,
    @JsonKey(name: 'DownloadFile', includeIfNull: false)
    this.downloadFile = false,
    @JsonKey(name: 'VideoFile', includeIfNull: false) this.videoFile = false,
    @JsonKey(name: 'CourseId', includeIfNull: false) this.courseId,
    @JsonKey(name: 'CourseName', includeIfNull: false) this.courseName,
    @JsonKey(name: 'CourseSeName', includeIfNull: false) this.courseSeName,
    @JsonKey(name: 'CourseLevel', includeIfNull: false) this.courseLevel,
    @JsonKey(name: 'CourseDescription', includeIfNull: false)
    this.courseDescription,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) this.metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    this.metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) this.metaTitle,
    @JsonKey(name: 'Approved', includeIfNull: false) this.approved = false,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$LessonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  final String? shortDescription;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'PictureUrl', includeIfNull: false)
  final String? pictureUrl;
  @override
  @JsonKey(name: 'DownloadFile', includeIfNull: false)
  final bool? downloadFile;
  @override
  @JsonKey(name: 'VideoFile', includeIfNull: false)
  final bool? videoFile;
  @override
  @JsonKey(name: 'CourseId', includeIfNull: false)
  final String? courseId;
  @override
  @JsonKey(name: 'CourseName', includeIfNull: false)
  final String? courseName;
  @override
  @JsonKey(name: 'CourseSeName', includeIfNull: false)
  final String? courseSeName;
  @override
  @JsonKey(name: 'CourseLevel', includeIfNull: false)
  final String? courseLevel;
  @override
  @JsonKey(name: 'CourseDescription', includeIfNull: false)
  final String? courseDescription;
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
    return 'LessonModel(name: $name, shortDescription: $shortDescription, description: $description, pictureUrl: $pictureUrl, downloadFile: $downloadFile, videoFile: $videoFile, courseId: $courseId, courseName: $courseName, courseSeName: $courseSeName, courseLevel: $courseLevel, courseDescription: $courseDescription, metaKeywords: $metaKeywords, metaDescription: $metaDescription, metaTitle: $metaTitle, approved: $approved, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl) &&
            (identical(other.downloadFile, downloadFile) ||
                other.downloadFile == downloadFile) &&
            (identical(other.videoFile, videoFile) ||
                other.videoFile == videoFile) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.courseName, courseName) ||
                other.courseName == courseName) &&
            (identical(other.courseSeName, courseSeName) ||
                other.courseSeName == courseSeName) &&
            (identical(other.courseLevel, courseLevel) ||
                other.courseLevel == courseLevel) &&
            (identical(other.courseDescription, courseDescription) ||
                other.courseDescription == courseDescription) &&
            (identical(other.metaKeywords, metaKeywords) ||
                other.metaKeywords == metaKeywords) &&
            (identical(other.metaDescription, metaDescription) ||
                other.metaDescription == metaDescription) &&
            (identical(other.metaTitle, metaTitle) ||
                other.metaTitle == metaTitle) &&
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
    shortDescription,
    description,
    pictureUrl,
    downloadFile,
    videoFile,
    courseId,
    courseName,
    courseSeName,
    courseLevel,
    courseDescription,
    metaKeywords,
    metaDescription,
    metaTitle,
    approved,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of LessonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonModelImplCopyWith<_$LessonModelImpl> get copyWith =>
      __$$LessonModelImplCopyWithImpl<_$LessonModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonModelImplToJson(this);
  }
}

abstract class _LessonModel implements LessonModel {
  factory _LessonModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    final String? shortDescription,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'PictureUrl', includeIfNull: false) final String? pictureUrl,
    @JsonKey(name: 'DownloadFile', includeIfNull: false)
    final bool? downloadFile,
    @JsonKey(name: 'VideoFile', includeIfNull: false) final bool? videoFile,
    @JsonKey(name: 'CourseId', includeIfNull: false) final String? courseId,
    @JsonKey(name: 'CourseName', includeIfNull: false) final String? courseName,
    @JsonKey(name: 'CourseSeName', includeIfNull: false)
    final String? courseSeName,
    @JsonKey(name: 'CourseLevel', includeIfNull: false)
    final String? courseLevel,
    @JsonKey(name: 'CourseDescription', includeIfNull: false)
    final String? courseDescription,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false)
    final String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    final String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) final String? metaTitle,
    @JsonKey(name: 'Approved', includeIfNull: false) final bool? approved,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$LessonModelImpl;

  factory _LessonModel.fromJson(Map<String, dynamic> json) =
      _$LessonModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  String? get shortDescription;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'PictureUrl', includeIfNull: false)
  String? get pictureUrl;
  @override
  @JsonKey(name: 'DownloadFile', includeIfNull: false)
  bool? get downloadFile;
  @override
  @JsonKey(name: 'VideoFile', includeIfNull: false)
  bool? get videoFile;
  @override
  @JsonKey(name: 'CourseId', includeIfNull: false)
  String? get courseId;
  @override
  @JsonKey(name: 'CourseName', includeIfNull: false)
  String? get courseName;
  @override
  @JsonKey(name: 'CourseSeName', includeIfNull: false)
  String? get courseSeName;
  @override
  @JsonKey(name: 'CourseLevel', includeIfNull: false)
  String? get courseLevel;
  @override
  @JsonKey(name: 'CourseDescription', includeIfNull: false)
  String? get courseDescription;
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
  @JsonKey(name: 'Approved', includeIfNull: false)
  bool? get approved;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of LessonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LessonModelImplCopyWith<_$LessonModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
