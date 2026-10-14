// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picture_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PictureModel _$PictureModelFromJson(Map<String, dynamic> json) {
  return _PictureModel.fromJson(json);
}

/// @nodoc
mixin _$PictureModel {
  @JsonKey(name: 'ImageUrl', includeIfNull: false)
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'ThumbImageUrl', includeIfNull: false)
  String? get thumbImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'FullSizeImageUrl', includeIfNull: false)
  String? get fullSizeImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'AlternateText', includeIfNull: false)
  String? get alternateText => throw _privateConstructorUsedError;
  @JsonKey(name: 'Style', includeIfNull: false)
  String? get style => throw _privateConstructorUsedError;
  @JsonKey(name: 'ExtraField', includeIfNull: false)
  String? get extraField => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this PictureModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PictureModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PictureModelCopyWith<PictureModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PictureModelCopyWith<$Res> {
  factory $PictureModelCopyWith(
    PictureModel value,
    $Res Function(PictureModel) then,
  ) = _$PictureModelCopyWithImpl<$Res, PictureModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ImageUrl', includeIfNull: false) String? imageUrl,
    @JsonKey(name: 'ThumbImageUrl', includeIfNull: false) String? thumbImageUrl,
    @JsonKey(name: 'FullSizeImageUrl', includeIfNull: false)
    String? fullSizeImageUrl,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'AlternateText', includeIfNull: false) String? alternateText,
    @JsonKey(name: 'Style', includeIfNull: false) String? style,
    @JsonKey(name: 'ExtraField', includeIfNull: false) String? extraField,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$PictureModelCopyWithImpl<$Res, $Val extends PictureModel>
    implements $PictureModelCopyWith<$Res> {
  _$PictureModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PictureModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = freezed,
    Object? thumbImageUrl = freezed,
    Object? fullSizeImageUrl = freezed,
    Object? title = freezed,
    Object? alternateText = freezed,
    Object? style = freezed,
    Object? extraField = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            imageUrl:
                freezed == imageUrl
                    ? _value.imageUrl
                    : imageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            thumbImageUrl:
                freezed == thumbImageUrl
                    ? _value.thumbImageUrl
                    : thumbImageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            fullSizeImageUrl:
                freezed == fullSizeImageUrl
                    ? _value.fullSizeImageUrl
                    : fullSizeImageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            title:
                freezed == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String?,
            alternateText:
                freezed == alternateText
                    ? _value.alternateText
                    : alternateText // ignore: cast_nullable_to_non_nullable
                        as String?,
            style:
                freezed == style
                    ? _value.style
                    : style // ignore: cast_nullable_to_non_nullable
                        as String?,
            extraField:
                freezed == extraField
                    ? _value.extraField
                    : extraField // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$PictureModelImplCopyWith<$Res>
    implements $PictureModelCopyWith<$Res> {
  factory _$$PictureModelImplCopyWith(
    _$PictureModelImpl value,
    $Res Function(_$PictureModelImpl) then,
  ) = __$$PictureModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ImageUrl', includeIfNull: false) String? imageUrl,
    @JsonKey(name: 'ThumbImageUrl', includeIfNull: false) String? thumbImageUrl,
    @JsonKey(name: 'FullSizeImageUrl', includeIfNull: false)
    String? fullSizeImageUrl,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'AlternateText', includeIfNull: false) String? alternateText,
    @JsonKey(name: 'Style', includeIfNull: false) String? style,
    @JsonKey(name: 'ExtraField', includeIfNull: false) String? extraField,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$PictureModelImplCopyWithImpl<$Res>
    extends _$PictureModelCopyWithImpl<$Res, _$PictureModelImpl>
    implements _$$PictureModelImplCopyWith<$Res> {
  __$$PictureModelImplCopyWithImpl(
    _$PictureModelImpl _value,
    $Res Function(_$PictureModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PictureModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = freezed,
    Object? thumbImageUrl = freezed,
    Object? fullSizeImageUrl = freezed,
    Object? title = freezed,
    Object? alternateText = freezed,
    Object? style = freezed,
    Object? extraField = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$PictureModelImpl(
        imageUrl:
            freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        thumbImageUrl:
            freezed == thumbImageUrl
                ? _value.thumbImageUrl
                : thumbImageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        fullSizeImageUrl:
            freezed == fullSizeImageUrl
                ? _value.fullSizeImageUrl
                : fullSizeImageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        title:
            freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String?,
        alternateText:
            freezed == alternateText
                ? _value.alternateText
                : alternateText // ignore: cast_nullable_to_non_nullable
                    as String?,
        style:
            freezed == style
                ? _value.style
                : style // ignore: cast_nullable_to_non_nullable
                    as String?,
        extraField:
            freezed == extraField
                ? _value.extraField
                : extraField // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$PictureModelImpl implements _PictureModel {
  _$PictureModelImpl({
    @JsonKey(name: 'ImageUrl', includeIfNull: false) this.imageUrl,
    @JsonKey(name: 'ThumbImageUrl', includeIfNull: false) this.thumbImageUrl,
    @JsonKey(name: 'FullSizeImageUrl', includeIfNull: false)
    this.fullSizeImageUrl,
    @JsonKey(name: 'Title', includeIfNull: false) this.title,
    @JsonKey(name: 'AlternateText', includeIfNull: false) this.alternateText,
    @JsonKey(name: 'Style', includeIfNull: false) this.style,
    @JsonKey(name: 'ExtraField', includeIfNull: false) this.extraField,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$PictureModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PictureModelImplFromJson(json);

  @override
  @JsonKey(name: 'ImageUrl', includeIfNull: false)
  final String? imageUrl;
  @override
  @JsonKey(name: 'ThumbImageUrl', includeIfNull: false)
  final String? thumbImageUrl;
  @override
  @JsonKey(name: 'FullSizeImageUrl', includeIfNull: false)
  final String? fullSizeImageUrl;
  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  final String? title;
  @override
  @JsonKey(name: 'AlternateText', includeIfNull: false)
  final String? alternateText;
  @override
  @JsonKey(name: 'Style', includeIfNull: false)
  final String? style;
  @override
  @JsonKey(name: 'ExtraField', includeIfNull: false)
  final String? extraField;
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
    return 'PictureModel(imageUrl: $imageUrl, thumbImageUrl: $thumbImageUrl, fullSizeImageUrl: $fullSizeImageUrl, title: $title, alternateText: $alternateText, style: $style, extraField: $extraField, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PictureModelImpl &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.thumbImageUrl, thumbImageUrl) ||
                other.thumbImageUrl == thumbImageUrl) &&
            (identical(other.fullSizeImageUrl, fullSizeImageUrl) ||
                other.fullSizeImageUrl == fullSizeImageUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.alternateText, alternateText) ||
                other.alternateText == alternateText) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.extraField, extraField) ||
                other.extraField == extraField) &&
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
    imageUrl,
    thumbImageUrl,
    fullSizeImageUrl,
    title,
    alternateText,
    style,
    extraField,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of PictureModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PictureModelImplCopyWith<_$PictureModelImpl> get copyWith =>
      __$$PictureModelImplCopyWithImpl<_$PictureModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PictureModelImplToJson(this);
  }
}

abstract class _PictureModel implements PictureModel {
  factory _PictureModel({
    @JsonKey(name: 'ImageUrl', includeIfNull: false) final String? imageUrl,
    @JsonKey(name: 'ThumbImageUrl', includeIfNull: false)
    final String? thumbImageUrl,
    @JsonKey(name: 'FullSizeImageUrl', includeIfNull: false)
    final String? fullSizeImageUrl,
    @JsonKey(name: 'Title', includeIfNull: false) final String? title,
    @JsonKey(name: 'AlternateText', includeIfNull: false)
    final String? alternateText,
    @JsonKey(name: 'Style', includeIfNull: false) final String? style,
    @JsonKey(name: 'ExtraField', includeIfNull: false) final String? extraField,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$PictureModelImpl;

  factory _PictureModel.fromJson(Map<String, dynamic> json) =
      _$PictureModelImpl.fromJson;

  @override
  @JsonKey(name: 'ImageUrl', includeIfNull: false)
  String? get imageUrl;
  @override
  @JsonKey(name: 'ThumbImageUrl', includeIfNull: false)
  String? get thumbImageUrl;
  @override
  @JsonKey(name: 'FullSizeImageUrl', includeIfNull: false)
  String? get fullSizeImageUrl;
  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title;
  @override
  @JsonKey(name: 'AlternateText', includeIfNull: false)
  String? get alternateText;
  @override
  @JsonKey(name: 'Style', includeIfNull: false)
  String? get style;
  @override
  @JsonKey(name: 'ExtraField', includeIfNull: false)
  String? get extraField;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of PictureModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PictureModelImplCopyWith<_$PictureModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
