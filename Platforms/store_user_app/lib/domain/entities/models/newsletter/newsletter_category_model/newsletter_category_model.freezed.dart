// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'newsletter_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NewsletterCategoryModel _$NewsletterCategoryModelFromJson(
  Map<String, dynamic> json,
) {
  return _NewsletterCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$NewsletterCategoryModel {
  @JsonKey(name: 'NewsletterEmailId', includeIfNull: false)
  String? get newsletterEmailId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Category', includeIfNull: false)
  List<String>? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'NewsletterCategories', includeIfNull: false)
  List<NewsletterSimpleCategory>? get newsletterCategories =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this NewsletterCategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NewsletterCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsletterCategoryModelCopyWith<NewsletterCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsletterCategoryModelCopyWith<$Res> {
  factory $NewsletterCategoryModelCopyWith(
    NewsletterCategoryModel value,
    $Res Function(NewsletterCategoryModel) then,
  ) = _$NewsletterCategoryModelCopyWithImpl<$Res, NewsletterCategoryModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'NewsletterEmailId', includeIfNull: false)
    String? newsletterEmailId,
    @JsonKey(name: 'Category', includeIfNull: false) List<String>? category,
    @JsonKey(name: 'NewsletterCategories', includeIfNull: false)
    List<NewsletterSimpleCategory>? newsletterCategories,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$NewsletterCategoryModelCopyWithImpl<
  $Res,
  $Val extends NewsletterCategoryModel
>
    implements $NewsletterCategoryModelCopyWith<$Res> {
  _$NewsletterCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewsletterCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newsletterEmailId = freezed,
    Object? category = freezed,
    Object? newsletterCategories = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            newsletterEmailId:
                freezed == newsletterEmailId
                    ? _value.newsletterEmailId
                    : newsletterEmailId // ignore: cast_nullable_to_non_nullable
                        as String?,
            category:
                freezed == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            newsletterCategories:
                freezed == newsletterCategories
                    ? _value.newsletterCategories
                    : newsletterCategories // ignore: cast_nullable_to_non_nullable
                        as List<NewsletterSimpleCategory>?,
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
abstract class _$$NewsletterCategoryModelImplCopyWith<$Res>
    implements $NewsletterCategoryModelCopyWith<$Res> {
  factory _$$NewsletterCategoryModelImplCopyWith(
    _$NewsletterCategoryModelImpl value,
    $Res Function(_$NewsletterCategoryModelImpl) then,
  ) = __$$NewsletterCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'NewsletterEmailId', includeIfNull: false)
    String? newsletterEmailId,
    @JsonKey(name: 'Category', includeIfNull: false) List<String>? category,
    @JsonKey(name: 'NewsletterCategories', includeIfNull: false)
    List<NewsletterSimpleCategory>? newsletterCategories,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$NewsletterCategoryModelImplCopyWithImpl<$Res>
    extends
        _$NewsletterCategoryModelCopyWithImpl<
          $Res,
          _$NewsletterCategoryModelImpl
        >
    implements _$$NewsletterCategoryModelImplCopyWith<$Res> {
  __$$NewsletterCategoryModelImplCopyWithImpl(
    _$NewsletterCategoryModelImpl _value,
    $Res Function(_$NewsletterCategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NewsletterCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newsletterEmailId = freezed,
    Object? category = freezed,
    Object? newsletterCategories = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$NewsletterCategoryModelImpl(
        newsletterEmailId:
            freezed == newsletterEmailId
                ? _value.newsletterEmailId
                : newsletterEmailId // ignore: cast_nullable_to_non_nullable
                    as String?,
        category:
            freezed == category
                ? _value._category
                : category // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        newsletterCategories:
            freezed == newsletterCategories
                ? _value._newsletterCategories
                : newsletterCategories // ignore: cast_nullable_to_non_nullable
                    as List<NewsletterSimpleCategory>?,
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
class _$NewsletterCategoryModelImpl implements _NewsletterCategoryModel {
  _$NewsletterCategoryModelImpl({
    @JsonKey(name: 'NewsletterEmailId', includeIfNull: false)
    this.newsletterEmailId,
    @JsonKey(name: 'Category', includeIfNull: false)
    final List<String>? category = const [],
    @JsonKey(name: 'NewsletterCategories', includeIfNull: false)
    final List<NewsletterSimpleCategory>? newsletterCategories = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _category = category,
       _newsletterCategories = newsletterCategories,
       _userFields = userFields;

  factory _$NewsletterCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsletterCategoryModelImplFromJson(json);

  @override
  @JsonKey(name: 'NewsletterEmailId', includeIfNull: false)
  final String? newsletterEmailId;
  final List<String>? _category;
  @override
  @JsonKey(name: 'Category', includeIfNull: false)
  List<String>? get category {
    final value = _category;
    if (value == null) return null;
    if (_category is EqualUnmodifiableListView) return _category;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<NewsletterSimpleCategory>? _newsletterCategories;
  @override
  @JsonKey(name: 'NewsletterCategories', includeIfNull: false)
  List<NewsletterSimpleCategory>? get newsletterCategories {
    final value = _newsletterCategories;
    if (value == null) return null;
    if (_newsletterCategories is EqualUnmodifiableListView)
      return _newsletterCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'NewsletterCategoryModel(newsletterEmailId: $newsletterEmailId, category: $category, newsletterCategories: $newsletterCategories, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsletterCategoryModelImpl &&
            (identical(other.newsletterEmailId, newsletterEmailId) ||
                other.newsletterEmailId == newsletterEmailId) &&
            const DeepCollectionEquality().equals(other._category, _category) &&
            const DeepCollectionEquality().equals(
              other._newsletterCategories,
              _newsletterCategories,
            ) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    newsletterEmailId,
    const DeepCollectionEquality().hash(_category),
    const DeepCollectionEquality().hash(_newsletterCategories),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of NewsletterCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsletterCategoryModelImplCopyWith<_$NewsletterCategoryModelImpl>
  get copyWith => __$$NewsletterCategoryModelImplCopyWithImpl<
    _$NewsletterCategoryModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsletterCategoryModelImplToJson(this);
  }
}

abstract class _NewsletterCategoryModel implements NewsletterCategoryModel {
  factory _NewsletterCategoryModel({
    @JsonKey(name: 'NewsletterEmailId', includeIfNull: false)
    final String? newsletterEmailId,
    @JsonKey(name: 'Category', includeIfNull: false)
    final List<String>? category,
    @JsonKey(name: 'NewsletterCategories', includeIfNull: false)
    final List<NewsletterSimpleCategory>? newsletterCategories,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$NewsletterCategoryModelImpl;

  factory _NewsletterCategoryModel.fromJson(Map<String, dynamic> json) =
      _$NewsletterCategoryModelImpl.fromJson;

  @override
  @JsonKey(name: 'NewsletterEmailId', includeIfNull: false)
  String? get newsletterEmailId;
  @override
  @JsonKey(name: 'Category', includeIfNull: false)
  List<String>? get category;
  @override
  @JsonKey(name: 'NewsletterCategories', includeIfNull: false)
  List<NewsletterSimpleCategory>? get newsletterCategories;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of NewsletterCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsletterCategoryModelImplCopyWith<_$NewsletterCategoryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
