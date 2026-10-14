// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'popular_product_tags_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PopularProductTagsModel _$PopularProductTagsModelFromJson(
  Map<String, dynamic> json,
) {
  return _PopularProductTagsModel.fromJson(json);
}

/// @nodoc
mixin _$PopularProductTagsModel {
  @JsonKey(name: 'TotalTags', includeIfNull: false)
  int? get totalTags => throw _privateConstructorUsedError;
  @JsonKey(name: 'Tags', includeIfNull: false)
  List<ProductTagModel>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this PopularProductTagsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PopularProductTagsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PopularProductTagsModelCopyWith<PopularProductTagsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PopularProductTagsModelCopyWith<$Res> {
  factory $PopularProductTagsModelCopyWith(
    PopularProductTagsModel value,
    $Res Function(PopularProductTagsModel) then,
  ) = _$PopularProductTagsModelCopyWithImpl<$Res, PopularProductTagsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'TotalTags', includeIfNull: false) int? totalTags,
    @JsonKey(name: 'Tags', includeIfNull: false) List<ProductTagModel>? tags,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$PopularProductTagsModelCopyWithImpl<
  $Res,
  $Val extends PopularProductTagsModel
>
    implements $PopularProductTagsModelCopyWith<$Res> {
  _$PopularProductTagsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PopularProductTagsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTags = freezed,
    Object? tags = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalTags:
                freezed == totalTags
                    ? _value.totalTags
                    : totalTags // ignore: cast_nullable_to_non_nullable
                        as int?,
            tags:
                freezed == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<ProductTagModel>?,
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
abstract class _$$PopularProductTagsModelImplCopyWith<$Res>
    implements $PopularProductTagsModelCopyWith<$Res> {
  factory _$$PopularProductTagsModelImplCopyWith(
    _$PopularProductTagsModelImpl value,
    $Res Function(_$PopularProductTagsModelImpl) then,
  ) = __$$PopularProductTagsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'TotalTags', includeIfNull: false) int? totalTags,
    @JsonKey(name: 'Tags', includeIfNull: false) List<ProductTagModel>? tags,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$PopularProductTagsModelImplCopyWithImpl<$Res>
    extends
        _$PopularProductTagsModelCopyWithImpl<
          $Res,
          _$PopularProductTagsModelImpl
        >
    implements _$$PopularProductTagsModelImplCopyWith<$Res> {
  __$$PopularProductTagsModelImplCopyWithImpl(
    _$PopularProductTagsModelImpl _value,
    $Res Function(_$PopularProductTagsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PopularProductTagsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTags = freezed,
    Object? tags = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$PopularProductTagsModelImpl(
        totalTags:
            freezed == totalTags
                ? _value.totalTags
                : totalTags // ignore: cast_nullable_to_non_nullable
                    as int?,
        tags:
            freezed == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<ProductTagModel>?,
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
class _$PopularProductTagsModelImpl implements _PopularProductTagsModel {
  _$PopularProductTagsModelImpl({
    @JsonKey(name: 'TotalTags', includeIfNull: false) this.totalTags,
    @JsonKey(name: 'Tags', includeIfNull: false)
    final List<ProductTagModel>? tags = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _tags = tags,
       _userFields = userFields;

  factory _$PopularProductTagsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PopularProductTagsModelImplFromJson(json);

  @override
  @JsonKey(name: 'TotalTags', includeIfNull: false)
  final int? totalTags;
  final List<ProductTagModel>? _tags;
  @override
  @JsonKey(name: 'Tags', includeIfNull: false)
  List<ProductTagModel>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
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
    return 'PopularProductTagsModel(totalTags: $totalTags, tags: $tags, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PopularProductTagsModelImpl &&
            (identical(other.totalTags, totalTags) ||
                other.totalTags == totalTags) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalTags,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of PopularProductTagsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PopularProductTagsModelImplCopyWith<_$PopularProductTagsModelImpl>
  get copyWith => __$$PopularProductTagsModelImplCopyWithImpl<
    _$PopularProductTagsModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PopularProductTagsModelImplToJson(this);
  }
}

abstract class _PopularProductTagsModel implements PopularProductTagsModel {
  factory _PopularProductTagsModel({
    @JsonKey(name: 'TotalTags', includeIfNull: false) final int? totalTags,
    @JsonKey(name: 'Tags', includeIfNull: false)
    final List<ProductTagModel>? tags,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$PopularProductTagsModelImpl;

  factory _PopularProductTagsModel.fromJson(Map<String, dynamic> json) =
      _$PopularProductTagsModelImpl.fromJson;

  @override
  @JsonKey(name: 'TotalTags', includeIfNull: false)
  int? get totalTags;
  @override
  @JsonKey(name: 'Tags', includeIfNull: false)
  List<ProductTagModel>? get tags;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of PopularProductTagsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PopularProductTagsModelImplCopyWith<_$PopularProductTagsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
