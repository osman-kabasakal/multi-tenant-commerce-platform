// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PublicInfoModel _$PublicInfoModelFromJson(Map<String, dynamic> json) {
  return _PublicInfoModel.fromJson(json);
}

/// @nodoc
mixin _$PublicInfoModel {
  @JsonKey(name: 'Slide', includeIfNull: false)
  List<Slider>? get slide => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this PublicInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublicInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublicInfoModelCopyWith<PublicInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublicInfoModelCopyWith<$Res> {
  factory $PublicInfoModelCopyWith(
    PublicInfoModel value,
    $Res Function(PublicInfoModel) then,
  ) = _$PublicInfoModelCopyWithImpl<$Res, PublicInfoModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Slide', includeIfNull: false) List<Slider>? slide,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$PublicInfoModelCopyWithImpl<$Res, $Val extends PublicInfoModel>
    implements $PublicInfoModelCopyWith<$Res> {
  _$PublicInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublicInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? slide = freezed, Object? userFields = freezed}) {
    return _then(
      _value.copyWith(
            slide:
                freezed == slide
                    ? _value.slide
                    : slide // ignore: cast_nullable_to_non_nullable
                        as List<Slider>?,
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
abstract class _$$PublicInfoModelImplCopyWith<$Res>
    implements $PublicInfoModelCopyWith<$Res> {
  factory _$$PublicInfoModelImplCopyWith(
    _$PublicInfoModelImpl value,
    $Res Function(_$PublicInfoModelImpl) then,
  ) = __$$PublicInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Slide', includeIfNull: false) List<Slider>? slide,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$PublicInfoModelImplCopyWithImpl<$Res>
    extends _$PublicInfoModelCopyWithImpl<$Res, _$PublicInfoModelImpl>
    implements _$$PublicInfoModelImplCopyWith<$Res> {
  __$$PublicInfoModelImplCopyWithImpl(
    _$PublicInfoModelImpl _value,
    $Res Function(_$PublicInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PublicInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? slide = freezed, Object? userFields = freezed}) {
    return _then(
      _$PublicInfoModelImpl(
        slide:
            freezed == slide
                ? _value._slide
                : slide // ignore: cast_nullable_to_non_nullable
                    as List<Slider>?,
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
class _$PublicInfoModelImpl implements _PublicInfoModel {
  const _$PublicInfoModelImpl({
    @JsonKey(name: 'Slide', includeIfNull: false)
    final List<Slider>? slide = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _slide = slide,
       _userFields = userFields;

  factory _$PublicInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublicInfoModelImplFromJson(json);

  final List<Slider>? _slide;
  @override
  @JsonKey(name: 'Slide', includeIfNull: false)
  List<Slider>? get slide {
    final value = _slide;
    if (value == null) return null;
    if (_slide is EqualUnmodifiableListView) return _slide;
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
    return 'PublicInfoModel(slide: $slide, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublicInfoModelImpl &&
            const DeepCollectionEquality().equals(other._slide, _slide) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_slide),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of PublicInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublicInfoModelImplCopyWith<_$PublicInfoModelImpl> get copyWith =>
      __$$PublicInfoModelImplCopyWithImpl<_$PublicInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PublicInfoModelImplToJson(this);
  }
}

abstract class _PublicInfoModel implements PublicInfoModel {
  const factory _PublicInfoModel({
    @JsonKey(name: 'Slide', includeIfNull: false) final List<Slider>? slide,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$PublicInfoModelImpl;

  factory _PublicInfoModel.fromJson(Map<String, dynamic> json) =
      _$PublicInfoModelImpl.fromJson;

  @override
  @JsonKey(name: 'Slide', includeIfNull: false)
  List<Slider>? get slide;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of PublicInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublicInfoModelImplCopyWith<_$PublicInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
