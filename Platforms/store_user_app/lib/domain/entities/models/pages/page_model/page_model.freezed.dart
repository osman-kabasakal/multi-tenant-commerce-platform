// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PageModel _$PageModelFromJson(Map<String, dynamic> json) {
  return _PageModel.fromJson(json);
}

/// @nodoc
mixin _$PageModel {
  @JsonKey(name: 'SystemName', includeIfNull: false)
  String? get systemName => throw _privateConstructorUsedError;
  @JsonKey(name: 'IncludeInSitemap', includeIfNull: false)
  bool? get includeInSitemap => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsPasswordProtected', includeIfNull: false)
  bool? get isPasswordProtected => throw _privateConstructorUsedError;
  @JsonKey(name: 'Password', includeIfNull: false)
  String? get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'Body', includeIfNull: false)
  String? get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaKeywords', includeIfNull: false)
  String? get metaKeywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaDescription', includeIfNull: false)
  String? get metaDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'MetaTitle', includeIfNull: false)
  String? get metaTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'PageLayoutId', includeIfNull: false)
  String? get pageLayoutId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Published', includeIfNull: false)
  bool? get published => throw _privateConstructorUsedError;
  @JsonKey(name: 'StartDate', includeIfNull: false)
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'EndDate', includeIfNull: false)
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this PageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageModelCopyWith<PageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageModelCopyWith<$Res> {
  factory $PageModelCopyWith(PageModel value, $Res Function(PageModel) then) =
      _$PageModelCopyWithImpl<$Res, PageModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'SystemName', includeIfNull: false) String? systemName,
    @JsonKey(name: 'IncludeInSitemap', includeIfNull: false)
    bool? includeInSitemap,
    @JsonKey(name: 'IsPasswordProtected', includeIfNull: false)
    bool? isPasswordProtected,
    @JsonKey(name: 'Password', includeIfNull: false) String? password,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'Body', includeIfNull: false) String? body,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'PageLayoutId', includeIfNull: false) String? pageLayoutId,
    @JsonKey(name: 'Published', includeIfNull: false) bool? published,
    @JsonKey(name: 'StartDate', includeIfNull: false) DateTime? startDate,
    @JsonKey(name: 'EndDate', includeIfNull: false) DateTime? endDate,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$PageModelCopyWithImpl<$Res, $Val extends PageModel>
    implements $PageModelCopyWith<$Res> {
  _$PageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? systemName = freezed,
    Object? includeInSitemap = freezed,
    Object? isPasswordProtected = freezed,
    Object? password = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? seName = freezed,
    Object? pageLayoutId = freezed,
    Object? published = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            systemName:
                freezed == systemName
                    ? _value.systemName
                    : systemName // ignore: cast_nullable_to_non_nullable
                        as String?,
            includeInSitemap:
                freezed == includeInSitemap
                    ? _value.includeInSitemap
                    : includeInSitemap // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isPasswordProtected:
                freezed == isPasswordProtected
                    ? _value.isPasswordProtected
                    : isPasswordProtected // ignore: cast_nullable_to_non_nullable
                        as bool?,
            password:
                freezed == password
                    ? _value.password
                    : password // ignore: cast_nullable_to_non_nullable
                        as String?,
            title:
                freezed == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String?,
            body:
                freezed == body
                    ? _value.body
                    : body // ignore: cast_nullable_to_non_nullable
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
            pageLayoutId:
                freezed == pageLayoutId
                    ? _value.pageLayoutId
                    : pageLayoutId // ignore: cast_nullable_to_non_nullable
                        as String?,
            published:
                freezed == published
                    ? _value.published
                    : published // ignore: cast_nullable_to_non_nullable
                        as bool?,
            startDate:
                freezed == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PageModelImplCopyWith<$Res>
    implements $PageModelCopyWith<$Res> {
  factory _$$PageModelImplCopyWith(
    _$PageModelImpl value,
    $Res Function(_$PageModelImpl) then,
  ) = __$$PageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'SystemName', includeIfNull: false) String? systemName,
    @JsonKey(name: 'IncludeInSitemap', includeIfNull: false)
    bool? includeInSitemap,
    @JsonKey(name: 'IsPasswordProtected', includeIfNull: false)
    bool? isPasswordProtected,
    @JsonKey(name: 'Password', includeIfNull: false) String? password,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'Body', includeIfNull: false) String? body,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'PageLayoutId', includeIfNull: false) String? pageLayoutId,
    @JsonKey(name: 'Published', includeIfNull: false) bool? published,
    @JsonKey(name: 'StartDate', includeIfNull: false) DateTime? startDate,
    @JsonKey(name: 'EndDate', includeIfNull: false) DateTime? endDate,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$PageModelImplCopyWithImpl<$Res>
    extends _$PageModelCopyWithImpl<$Res, _$PageModelImpl>
    implements _$$PageModelImplCopyWith<$Res> {
  __$$PageModelImplCopyWithImpl(
    _$PageModelImpl _value,
    $Res Function(_$PageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? systemName = freezed,
    Object? includeInSitemap = freezed,
    Object? isPasswordProtected = freezed,
    Object? password = freezed,
    Object? title = freezed,
    Object? body = freezed,
    Object? metaKeywords = freezed,
    Object? metaDescription = freezed,
    Object? metaTitle = freezed,
    Object? seName = freezed,
    Object? pageLayoutId = freezed,
    Object? published = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$PageModelImpl(
        systemName:
            freezed == systemName
                ? _value.systemName
                : systemName // ignore: cast_nullable_to_non_nullable
                    as String?,
        includeInSitemap:
            freezed == includeInSitemap
                ? _value.includeInSitemap
                : includeInSitemap // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isPasswordProtected:
            freezed == isPasswordProtected
                ? _value.isPasswordProtected
                : isPasswordProtected // ignore: cast_nullable_to_non_nullable
                    as bool?,
        password:
            freezed == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                    as String?,
        title:
            freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String?,
        body:
            freezed == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
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
        pageLayoutId:
            freezed == pageLayoutId
                ? _value.pageLayoutId
                : pageLayoutId // ignore: cast_nullable_to_non_nullable
                    as String?,
        published:
            freezed == published
                ? _value.published
                : published // ignore: cast_nullable_to_non_nullable
                    as bool?,
        startDate:
            freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
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
class _$PageModelImpl implements _PageModel {
  _$PageModelImpl({
    @JsonKey(name: 'SystemName', includeIfNull: false) this.systemName,
    @JsonKey(name: 'IncludeInSitemap', includeIfNull: false)
    this.includeInSitemap = false,
    @JsonKey(name: 'IsPasswordProtected', includeIfNull: false)
    this.isPasswordProtected = false,
    @JsonKey(name: 'Password', includeIfNull: false) this.password,
    @JsonKey(name: 'Title', includeIfNull: false) this.title,
    @JsonKey(name: 'Body', includeIfNull: false) this.body,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false) this.metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    this.metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) this.metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'PageLayoutId', includeIfNull: false) this.pageLayoutId,
    @JsonKey(name: 'Published', includeIfNull: false) this.published = false,
    @JsonKey(name: 'StartDate', includeIfNull: false) this.startDate = null,
    @JsonKey(name: 'EndDate', includeIfNull: false) this.endDate = null,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$PageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageModelImplFromJson(json);

  @override
  @JsonKey(name: 'SystemName', includeIfNull: false)
  final String? systemName;
  @override
  @JsonKey(name: 'IncludeInSitemap', includeIfNull: false)
  final bool? includeInSitemap;
  @override
  @JsonKey(name: 'IsPasswordProtected', includeIfNull: false)
  final bool? isPasswordProtected;
  @override
  @JsonKey(name: 'Password', includeIfNull: false)
  final String? password;
  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  final String? title;
  @override
  @JsonKey(name: 'Body', includeIfNull: false)
  final String? body;
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
  @JsonKey(name: 'PageLayoutId', includeIfNull: false)
  final String? pageLayoutId;
  @override
  @JsonKey(name: 'Published', includeIfNull: false)
  final bool? published;
  @override
  @JsonKey(name: 'StartDate', includeIfNull: false)
  final DateTime? startDate;
  @override
  @JsonKey(name: 'EndDate', includeIfNull: false)
  final DateTime? endDate;
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
    return 'PageModel(systemName: $systemName, includeInSitemap: $includeInSitemap, isPasswordProtected: $isPasswordProtected, password: $password, title: $title, body: $body, metaKeywords: $metaKeywords, metaDescription: $metaDescription, metaTitle: $metaTitle, seName: $seName, pageLayoutId: $pageLayoutId, published: $published, startDate: $startDate, endDate: $endDate, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageModelImpl &&
            (identical(other.systemName, systemName) ||
                other.systemName == systemName) &&
            (identical(other.includeInSitemap, includeInSitemap) ||
                other.includeInSitemap == includeInSitemap) &&
            (identical(other.isPasswordProtected, isPasswordProtected) ||
                other.isPasswordProtected == isPasswordProtected) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.metaKeywords, metaKeywords) ||
                other.metaKeywords == metaKeywords) &&
            (identical(other.metaDescription, metaDescription) ||
                other.metaDescription == metaDescription) &&
            (identical(other.metaTitle, metaTitle) ||
                other.metaTitle == metaTitle) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.pageLayoutId, pageLayoutId) ||
                other.pageLayoutId == pageLayoutId) &&
            (identical(other.published, published) ||
                other.published == published) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
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
    systemName,
    includeInSitemap,
    isPasswordProtected,
    password,
    title,
    body,
    metaKeywords,
    metaDescription,
    metaTitle,
    seName,
    pageLayoutId,
    published,
    startDate,
    endDate,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of PageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageModelImplCopyWith<_$PageModelImpl> get copyWith =>
      __$$PageModelImplCopyWithImpl<_$PageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PageModelImplToJson(this);
  }
}

abstract class _PageModel implements PageModel {
  factory _PageModel({
    @JsonKey(name: 'SystemName', includeIfNull: false) final String? systemName,
    @JsonKey(name: 'IncludeInSitemap', includeIfNull: false)
    final bool? includeInSitemap,
    @JsonKey(name: 'IsPasswordProtected', includeIfNull: false)
    final bool? isPasswordProtected,
    @JsonKey(name: 'Password', includeIfNull: false) final String? password,
    @JsonKey(name: 'Title', includeIfNull: false) final String? title,
    @JsonKey(name: 'Body', includeIfNull: false) final String? body,
    @JsonKey(name: 'MetaKeywords', includeIfNull: false)
    final String? metaKeywords,
    @JsonKey(name: 'MetaDescription', includeIfNull: false)
    final String? metaDescription,
    @JsonKey(name: 'MetaTitle', includeIfNull: false) final String? metaTitle,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'PageLayoutId', includeIfNull: false)
    final String? pageLayoutId,
    @JsonKey(name: 'Published', includeIfNull: false) final bool? published,
    @JsonKey(name: 'StartDate', includeIfNull: false) final DateTime? startDate,
    @JsonKey(name: 'EndDate', includeIfNull: false) final DateTime? endDate,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$PageModelImpl;

  factory _PageModel.fromJson(Map<String, dynamic> json) =
      _$PageModelImpl.fromJson;

  @override
  @JsonKey(name: 'SystemName', includeIfNull: false)
  String? get systemName;
  @override
  @JsonKey(name: 'IncludeInSitemap', includeIfNull: false)
  bool? get includeInSitemap;
  @override
  @JsonKey(name: 'IsPasswordProtected', includeIfNull: false)
  bool? get isPasswordProtected;
  @override
  @JsonKey(name: 'Password', includeIfNull: false)
  String? get password;
  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title;
  @override
  @JsonKey(name: 'Body', includeIfNull: false)
  String? get body;
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
  @JsonKey(name: 'PageLayoutId', includeIfNull: false)
  String? get pageLayoutId;
  @override
  @JsonKey(name: 'Published', includeIfNull: false)
  bool? get published;
  @override
  @JsonKey(name: 'StartDate', includeIfNull: false)
  DateTime? get startDate;
  @override
  @JsonKey(name: 'EndDate', includeIfNull: false)
  DateTime? get endDate;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of PageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageModelImplCopyWith<_$PageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
