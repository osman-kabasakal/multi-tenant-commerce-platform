// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Slider _$SliderFromJson(Map<String, dynamic> json) {
  return _Slider.fromJson(json);
}

/// @nodoc
mixin _$Slider {
  @JsonKey(name: 'PictureUrl')
  String? get pictureUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'Link')
  String? get link => throw _privateConstructorUsedError;
  @JsonKey(name: 'FullWidth')
  bool? get fullWidth => throw _privateConstructorUsedError;
  @JsonKey(name: 'CssClass')
  String? get cssClass => throw _privateConstructorUsedError;

  /// Serializes this Slider to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Slider
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SliderCopyWith<Slider> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SliderCopyWith<$Res> {
  factory $SliderCopyWith(Slider value, $Res Function(Slider) then) =
      _$SliderCopyWithImpl<$Res, Slider>;
  @useResult
  $Res call({
    @JsonKey(name: 'PictureUrl') String? pictureUrl,
    @JsonKey(name: 'Name') String? name,
    @JsonKey(name: 'Description') String? description,
    @JsonKey(name: 'Link') String? link,
    @JsonKey(name: 'FullWidth') bool? fullWidth,
    @JsonKey(name: 'CssClass') String? cssClass,
  });
}

/// @nodoc
class _$SliderCopyWithImpl<$Res, $Val extends Slider>
    implements $SliderCopyWith<$Res> {
  _$SliderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Slider
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pictureUrl = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? link = freezed,
    Object? fullWidth = freezed,
    Object? cssClass = freezed,
  }) {
    return _then(
      _value.copyWith(
            pictureUrl:
                freezed == pictureUrl
                    ? _value.pictureUrl
                    : pictureUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            link:
                freezed == link
                    ? _value.link
                    : link // ignore: cast_nullable_to_non_nullable
                        as String?,
            fullWidth:
                freezed == fullWidth
                    ? _value.fullWidth
                    : fullWidth // ignore: cast_nullable_to_non_nullable
                        as bool?,
            cssClass:
                freezed == cssClass
                    ? _value.cssClass
                    : cssClass // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SliderImplCopyWith<$Res> implements $SliderCopyWith<$Res> {
  factory _$$SliderImplCopyWith(
    _$SliderImpl value,
    $Res Function(_$SliderImpl) then,
  ) = __$$SliderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PictureUrl') String? pictureUrl,
    @JsonKey(name: 'Name') String? name,
    @JsonKey(name: 'Description') String? description,
    @JsonKey(name: 'Link') String? link,
    @JsonKey(name: 'FullWidth') bool? fullWidth,
    @JsonKey(name: 'CssClass') String? cssClass,
  });
}

/// @nodoc
class __$$SliderImplCopyWithImpl<$Res>
    extends _$SliderCopyWithImpl<$Res, _$SliderImpl>
    implements _$$SliderImplCopyWith<$Res> {
  __$$SliderImplCopyWithImpl(
    _$SliderImpl _value,
    $Res Function(_$SliderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Slider
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pictureUrl = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? link = freezed,
    Object? fullWidth = freezed,
    Object? cssClass = freezed,
  }) {
    return _then(
      _$SliderImpl(
        pictureUrl:
            freezed == pictureUrl
                ? _value.pictureUrl
                : pictureUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        link:
            freezed == link
                ? _value.link
                : link // ignore: cast_nullable_to_non_nullable
                    as String?,
        fullWidth:
            freezed == fullWidth
                ? _value.fullWidth
                : fullWidth // ignore: cast_nullable_to_non_nullable
                    as bool?,
        cssClass:
            freezed == cssClass
                ? _value.cssClass
                : cssClass // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SliderImpl implements _Slider {
  const _$SliderImpl({
    @JsonKey(name: 'PictureUrl') this.pictureUrl,
    @JsonKey(name: 'Name') this.name,
    @JsonKey(name: 'Description') this.description,
    @JsonKey(name: 'Link') this.link,
    @JsonKey(name: 'FullWidth') this.fullWidth = false,
    @JsonKey(name: 'CssClass') this.cssClass,
  });

  factory _$SliderImpl.fromJson(Map<String, dynamic> json) =>
      _$$SliderImplFromJson(json);

  @override
  @JsonKey(name: 'PictureUrl')
  final String? pictureUrl;
  @override
  @JsonKey(name: 'Name')
  final String? name;
  @override
  @JsonKey(name: 'Description')
  final String? description;
  @override
  @JsonKey(name: 'Link')
  final String? link;
  @override
  @JsonKey(name: 'FullWidth')
  final bool? fullWidth;
  @override
  @JsonKey(name: 'CssClass')
  final String? cssClass;

  @override
  String toString() {
    return 'Slider(pictureUrl: $pictureUrl, name: $name, description: $description, link: $link, fullWidth: $fullWidth, cssClass: $cssClass)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SliderImpl &&
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.fullWidth, fullWidth) ||
                other.fullWidth == fullWidth) &&
            (identical(other.cssClass, cssClass) ||
                other.cssClass == cssClass));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pictureUrl,
    name,
    description,
    link,
    fullWidth,
    cssClass,
  );

  /// Create a copy of Slider
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SliderImplCopyWith<_$SliderImpl> get copyWith =>
      __$$SliderImplCopyWithImpl<_$SliderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SliderImplToJson(this);
  }
}

abstract class _Slider implements Slider {
  const factory _Slider({
    @JsonKey(name: 'PictureUrl') final String? pictureUrl,
    @JsonKey(name: 'Name') final String? name,
    @JsonKey(name: 'Description') final String? description,
    @JsonKey(name: 'Link') final String? link,
    @JsonKey(name: 'FullWidth') final bool? fullWidth,
    @JsonKey(name: 'CssClass') final String? cssClass,
  }) = _$SliderImpl;

  factory _Slider.fromJson(Map<String, dynamic> json) = _$SliderImpl.fromJson;

  @override
  @JsonKey(name: 'PictureUrl')
  String? get pictureUrl;
  @override
  @JsonKey(name: 'Name')
  String? get name;
  @override
  @JsonKey(name: 'Description')
  String? get description;
  @override
  @JsonKey(name: 'Link')
  String? get link;
  @override
  @JsonKey(name: 'FullWidth')
  bool? get fullWidth;
  @override
  @JsonKey(name: 'CssClass')
  String? get cssClass;

  /// Create a copy of Slider
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SliderImplCopyWith<_$SliderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
