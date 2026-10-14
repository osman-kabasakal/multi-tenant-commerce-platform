// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_specification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductSpecificationModel _$ProductSpecificationModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProductSpecificationModel.fromJson(json);
}

/// @nodoc
mixin _$ProductSpecificationModel {
  @JsonKey(name: 'SpecificationAttributeId', includeIfNull: false)
  String? get specificationAttributeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'SpecificationAttributeName', includeIfNull: false)
  String? get specificationAttributeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ValueRaw', includeIfNull: false)
  String? get valueRaw => throw _privateConstructorUsedError;
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  String? get colorSquaresRgb => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductSpecificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductSpecificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductSpecificationModelCopyWith<ProductSpecificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSpecificationModelCopyWith<$Res> {
  factory $ProductSpecificationModelCopyWith(
    ProductSpecificationModel value,
    $Res Function(ProductSpecificationModel) then,
  ) = _$ProductSpecificationModelCopyWithImpl<$Res, ProductSpecificationModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'SpecificationAttributeId', includeIfNull: false)
    String? specificationAttributeId,
    @JsonKey(name: 'SpecificationAttributeName', includeIfNull: false)
    String? specificationAttributeName,
    @JsonKey(name: 'ValueRaw', includeIfNull: false) String? valueRaw,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    String? colorSquaresRgb,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ProductSpecificationModelCopyWithImpl<
  $Res,
  $Val extends ProductSpecificationModel
>
    implements $ProductSpecificationModelCopyWith<$Res> {
  _$ProductSpecificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductSpecificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specificationAttributeId = freezed,
    Object? specificationAttributeName = freezed,
    Object? valueRaw = freezed,
    Object? colorSquaresRgb = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            specificationAttributeId:
                freezed == specificationAttributeId
                    ? _value.specificationAttributeId
                    : specificationAttributeId // ignore: cast_nullable_to_non_nullable
                        as String?,
            specificationAttributeName:
                freezed == specificationAttributeName
                    ? _value.specificationAttributeName
                    : specificationAttributeName // ignore: cast_nullable_to_non_nullable
                        as String?,
            valueRaw:
                freezed == valueRaw
                    ? _value.valueRaw
                    : valueRaw // ignore: cast_nullable_to_non_nullable
                        as String?,
            colorSquaresRgb:
                freezed == colorSquaresRgb
                    ? _value.colorSquaresRgb
                    : colorSquaresRgb // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ProductSpecificationModelImplCopyWith<$Res>
    implements $ProductSpecificationModelCopyWith<$Res> {
  factory _$$ProductSpecificationModelImplCopyWith(
    _$ProductSpecificationModelImpl value,
    $Res Function(_$ProductSpecificationModelImpl) then,
  ) = __$$ProductSpecificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'SpecificationAttributeId', includeIfNull: false)
    String? specificationAttributeId,
    @JsonKey(name: 'SpecificationAttributeName', includeIfNull: false)
    String? specificationAttributeName,
    @JsonKey(name: 'ValueRaw', includeIfNull: false) String? valueRaw,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    String? colorSquaresRgb,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ProductSpecificationModelImplCopyWithImpl<$Res>
    extends
        _$ProductSpecificationModelCopyWithImpl<
          $Res,
          _$ProductSpecificationModelImpl
        >
    implements _$$ProductSpecificationModelImplCopyWith<$Res> {
  __$$ProductSpecificationModelImplCopyWithImpl(
    _$ProductSpecificationModelImpl _value,
    $Res Function(_$ProductSpecificationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductSpecificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? specificationAttributeId = freezed,
    Object? specificationAttributeName = freezed,
    Object? valueRaw = freezed,
    Object? colorSquaresRgb = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductSpecificationModelImpl(
        specificationAttributeId:
            freezed == specificationAttributeId
                ? _value.specificationAttributeId
                : specificationAttributeId // ignore: cast_nullable_to_non_nullable
                    as String?,
        specificationAttributeName:
            freezed == specificationAttributeName
                ? _value.specificationAttributeName
                : specificationAttributeName // ignore: cast_nullable_to_non_nullable
                    as String?,
        valueRaw:
            freezed == valueRaw
                ? _value.valueRaw
                : valueRaw // ignore: cast_nullable_to_non_nullable
                    as String?,
        colorSquaresRgb:
            freezed == colorSquaresRgb
                ? _value.colorSquaresRgb
                : colorSquaresRgb // ignore: cast_nullable_to_non_nullable
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
class _$ProductSpecificationModelImpl implements _ProductSpecificationModel {
  _$ProductSpecificationModelImpl({
    @JsonKey(name: 'SpecificationAttributeId', includeIfNull: false)
    this.specificationAttributeId,
    @JsonKey(name: 'SpecificationAttributeName', includeIfNull: false)
    this.specificationAttributeName,
    @JsonKey(name: 'ValueRaw', includeIfNull: false) this.valueRaw,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    this.colorSquaresRgb,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ProductSpecificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSpecificationModelImplFromJson(json);

  @override
  @JsonKey(name: 'SpecificationAttributeId', includeIfNull: false)
  final String? specificationAttributeId;
  @override
  @JsonKey(name: 'SpecificationAttributeName', includeIfNull: false)
  final String? specificationAttributeName;
  @override
  @JsonKey(name: 'ValueRaw', includeIfNull: false)
  final String? valueRaw;
  @override
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  final String? colorSquaresRgb;
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
    return 'ProductSpecificationModel(specificationAttributeId: $specificationAttributeId, specificationAttributeName: $specificationAttributeName, valueRaw: $valueRaw, colorSquaresRgb: $colorSquaresRgb, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSpecificationModelImpl &&
            (identical(
                  other.specificationAttributeId,
                  specificationAttributeId,
                ) ||
                other.specificationAttributeId == specificationAttributeId) &&
            (identical(
                  other.specificationAttributeName,
                  specificationAttributeName,
                ) ||
                other.specificationAttributeName ==
                    specificationAttributeName) &&
            (identical(other.valueRaw, valueRaw) ||
                other.valueRaw == valueRaw) &&
            (identical(other.colorSquaresRgb, colorSquaresRgb) ||
                other.colorSquaresRgb == colorSquaresRgb) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    specificationAttributeId,
    specificationAttributeName,
    valueRaw,
    colorSquaresRgb,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductSpecificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSpecificationModelImplCopyWith<_$ProductSpecificationModelImpl>
  get copyWith => __$$ProductSpecificationModelImplCopyWithImpl<
    _$ProductSpecificationModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSpecificationModelImplToJson(this);
  }
}

abstract class _ProductSpecificationModel implements ProductSpecificationModel {
  factory _ProductSpecificationModel({
    @JsonKey(name: 'SpecificationAttributeId', includeIfNull: false)
    final String? specificationAttributeId,
    @JsonKey(name: 'SpecificationAttributeName', includeIfNull: false)
    final String? specificationAttributeName,
    @JsonKey(name: 'ValueRaw', includeIfNull: false) final String? valueRaw,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    final String? colorSquaresRgb,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductSpecificationModelImpl;

  factory _ProductSpecificationModel.fromJson(Map<String, dynamic> json) =
      _$ProductSpecificationModelImpl.fromJson;

  @override
  @JsonKey(name: 'SpecificationAttributeId', includeIfNull: false)
  String? get specificationAttributeId;
  @override
  @JsonKey(name: 'SpecificationAttributeName', includeIfNull: false)
  String? get specificationAttributeName;
  @override
  @JsonKey(name: 'ValueRaw', includeIfNull: false)
  String? get valueRaw;
  @override
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  String? get colorSquaresRgb;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductSpecificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductSpecificationModelImplCopyWith<_$ProductSpecificationModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
