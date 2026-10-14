// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_attribute_value_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductAttributeValueModel _$ProductAttributeValueModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProductAttributeValueModel.fromJson(json);
}

/// @nodoc
mixin _$ProductAttributeValueModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  String? get colorSquaresRgb => throw _privateConstructorUsedError;
  @JsonKey(name: 'ImageSquaresPictureModel', includeIfNull: false)
  PictureModel? get imageSquaresPictureModel =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductAttributeValueModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductAttributeValueModelCopyWith<ProductAttributeValueModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductAttributeValueModelCopyWith<$Res> {
  factory $ProductAttributeValueModelCopyWith(
    ProductAttributeValueModel value,
    $Res Function(ProductAttributeValueModel) then,
  ) =
      _$ProductAttributeValueModelCopyWithImpl<
        $Res,
        ProductAttributeValueModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    String? colorSquaresRgb,
    @JsonKey(name: 'ImageSquaresPictureModel', includeIfNull: false)
    PictureModel? imageSquaresPictureModel,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $PictureModelCopyWith<$Res>? get imageSquaresPictureModel;
  $PictureModelCopyWith<$Res>? get pictureModel;
}

/// @nodoc
class _$ProductAttributeValueModelCopyWithImpl<
  $Res,
  $Val extends ProductAttributeValueModel
>
    implements $ProductAttributeValueModelCopyWith<$Res> {
  _$ProductAttributeValueModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? colorSquaresRgb = freezed,
    Object? imageSquaresPictureModel = freezed,
    Object? pictureModel = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            colorSquaresRgb:
                freezed == colorSquaresRgb
                    ? _value.colorSquaresRgb
                    : colorSquaresRgb // ignore: cast_nullable_to_non_nullable
                        as String?,
            imageSquaresPictureModel:
                freezed == imageSquaresPictureModel
                    ? _value.imageSquaresPictureModel
                    : imageSquaresPictureModel // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            pictureModel:
                freezed == pictureModel
                    ? _value.pictureModel
                    : pictureModel // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PictureModelCopyWith<$Res>? get imageSquaresPictureModel {
    if (_value.imageSquaresPictureModel == null) {
      return null;
    }

    return $PictureModelCopyWith<$Res>(_value.imageSquaresPictureModel!, (
      value,
    ) {
      return _then(_value.copyWith(imageSquaresPictureModel: value) as $Val);
    });
  }

  /// Create a copy of ProductAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PictureModelCopyWith<$Res>? get pictureModel {
    if (_value.pictureModel == null) {
      return null;
    }

    return $PictureModelCopyWith<$Res>(_value.pictureModel!, (value) {
      return _then(_value.copyWith(pictureModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductAttributeValueModelImplCopyWith<$Res>
    implements $ProductAttributeValueModelCopyWith<$Res> {
  factory _$$ProductAttributeValueModelImplCopyWith(
    _$ProductAttributeValueModelImpl value,
    $Res Function(_$ProductAttributeValueModelImpl) then,
  ) = __$$ProductAttributeValueModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    String? colorSquaresRgb,
    @JsonKey(name: 'ImageSquaresPictureModel', includeIfNull: false)
    PictureModel? imageSquaresPictureModel,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $PictureModelCopyWith<$Res>? get imageSquaresPictureModel;
  @override
  $PictureModelCopyWith<$Res>? get pictureModel;
}

/// @nodoc
class __$$ProductAttributeValueModelImplCopyWithImpl<$Res>
    extends
        _$ProductAttributeValueModelCopyWithImpl<
          $Res,
          _$ProductAttributeValueModelImpl
        >
    implements _$$ProductAttributeValueModelImplCopyWith<$Res> {
  __$$ProductAttributeValueModelImplCopyWithImpl(
    _$ProductAttributeValueModelImpl _value,
    $Res Function(_$ProductAttributeValueModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? colorSquaresRgb = freezed,
    Object? imageSquaresPictureModel = freezed,
    Object? pictureModel = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductAttributeValueModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        colorSquaresRgb:
            freezed == colorSquaresRgb
                ? _value.colorSquaresRgb
                : colorSquaresRgb // ignore: cast_nullable_to_non_nullable
                    as String?,
        imageSquaresPictureModel:
            freezed == imageSquaresPictureModel
                ? _value.imageSquaresPictureModel
                : imageSquaresPictureModel // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
        pictureModel:
            freezed == pictureModel
                ? _value.pictureModel
                : pictureModel // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
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
class _$ProductAttributeValueModelImpl implements _ProductAttributeValueModel {
  _$ProductAttributeValueModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    this.colorSquaresRgb,
    @JsonKey(name: 'ImageSquaresPictureModel', includeIfNull: false)
    this.imageSquaresPictureModel,
    @JsonKey(name: 'PictureModel', includeIfNull: false) this.pictureModel,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ProductAttributeValueModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ProductAttributeValueModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  final String? colorSquaresRgb;
  @override
  @JsonKey(name: 'ImageSquaresPictureModel', includeIfNull: false)
  final PictureModel? imageSquaresPictureModel;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  final PictureModel? pictureModel;
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
    return 'ProductAttributeValueModel(name: $name, colorSquaresRgb: $colorSquaresRgb, imageSquaresPictureModel: $imageSquaresPictureModel, pictureModel: $pictureModel, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductAttributeValueModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.colorSquaresRgb, colorSquaresRgb) ||
                other.colorSquaresRgb == colorSquaresRgb) &&
            (identical(
                  other.imageSquaresPictureModel,
                  imageSquaresPictureModel,
                ) ||
                other.imageSquaresPictureModel == imageSquaresPictureModel) &&
            (identical(other.pictureModel, pictureModel) ||
                other.pictureModel == pictureModel) &&
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
    colorSquaresRgb,
    imageSquaresPictureModel,
    pictureModel,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductAttributeValueModelImplCopyWith<_$ProductAttributeValueModelImpl>
  get copyWith => __$$ProductAttributeValueModelImplCopyWithImpl<
    _$ProductAttributeValueModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductAttributeValueModelImplToJson(this);
  }
}

abstract class _ProductAttributeValueModel
    implements ProductAttributeValueModel {
  factory _ProductAttributeValueModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    final String? colorSquaresRgb,
    @JsonKey(name: 'ImageSquaresPictureModel', includeIfNull: false)
    final PictureModel? imageSquaresPictureModel,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    final PictureModel? pictureModel,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductAttributeValueModelImpl;

  factory _ProductAttributeValueModel.fromJson(Map<String, dynamic> json) =
      _$ProductAttributeValueModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  String? get colorSquaresRgb;
  @override
  @JsonKey(name: 'ImageSquaresPictureModel', includeIfNull: false)
  PictureModel? get imageSquaresPictureModel;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductAttributeValueModelImplCopyWith<_$ProductAttributeValueModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
