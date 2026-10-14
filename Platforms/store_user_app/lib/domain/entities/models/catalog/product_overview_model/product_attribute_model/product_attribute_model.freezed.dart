// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_attribute_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductAttributeModel _$ProductAttributeModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProductAttributeModel.fromJson(json);
}

/// @nodoc
mixin _$ProductAttributeModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'TextPrompt', includeIfNull: false)
  String? get textPrompt => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  bool? get isRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  AttributeControlType? get attributeControlType =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Values', includeIfNull: false)
  List<ProductAttributeValueModel>? get values =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductAttributeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductAttributeModelCopyWith<ProductAttributeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductAttributeModelCopyWith<$Res> {
  factory $ProductAttributeModelCopyWith(
    ProductAttributeModel value,
    $Res Function(ProductAttributeModel) then,
  ) = _$ProductAttributeModelCopyWithImpl<$Res, ProductAttributeModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) String? textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) bool? isRequired,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    List<ProductAttributeValueModel>? values,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ProductAttributeModelCopyWithImpl<
  $Res,
  $Val extends ProductAttributeModel
>
    implements $ProductAttributeModelCopyWith<$Res> {
  _$ProductAttributeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? textPrompt = freezed,
    Object? isRequired = freezed,
    Object? attributeControlType = freezed,
    Object? values = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            seName:
                freezed == seName
                    ? _value.seName
                    : seName // ignore: cast_nullable_to_non_nullable
                        as String?,
            textPrompt:
                freezed == textPrompt
                    ? _value.textPrompt
                    : textPrompt // ignore: cast_nullable_to_non_nullable
                        as String?,
            isRequired:
                freezed == isRequired
                    ? _value.isRequired
                    : isRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            attributeControlType:
                freezed == attributeControlType
                    ? _value.attributeControlType
                    : attributeControlType // ignore: cast_nullable_to_non_nullable
                        as AttributeControlType?,
            values:
                freezed == values
                    ? _value.values
                    : values // ignore: cast_nullable_to_non_nullable
                        as List<ProductAttributeValueModel>?,
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
abstract class _$$ProductAttributeModelImplCopyWith<$Res>
    implements $ProductAttributeModelCopyWith<$Res> {
  factory _$$ProductAttributeModelImplCopyWith(
    _$ProductAttributeModelImpl value,
    $Res Function(_$ProductAttributeModelImpl) then,
  ) = __$$ProductAttributeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) String? textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) bool? isRequired,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    List<ProductAttributeValueModel>? values,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ProductAttributeModelImplCopyWithImpl<$Res>
    extends
        _$ProductAttributeModelCopyWithImpl<$Res, _$ProductAttributeModelImpl>
    implements _$$ProductAttributeModelImplCopyWith<$Res> {
  __$$ProductAttributeModelImplCopyWithImpl(
    _$ProductAttributeModelImpl _value,
    $Res Function(_$ProductAttributeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? textPrompt = freezed,
    Object? isRequired = freezed,
    Object? attributeControlType = freezed,
    Object? values = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductAttributeModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        seName:
            freezed == seName
                ? _value.seName
                : seName // ignore: cast_nullable_to_non_nullable
                    as String?,
        textPrompt:
            freezed == textPrompt
                ? _value.textPrompt
                : textPrompt // ignore: cast_nullable_to_non_nullable
                    as String?,
        isRequired:
            freezed == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
        attributeControlType:
            freezed == attributeControlType
                ? _value.attributeControlType
                : attributeControlType // ignore: cast_nullable_to_non_nullable
                    as AttributeControlType?,
        values:
            freezed == values
                ? _value._values
                : values // ignore: cast_nullable_to_non_nullable
                    as List<ProductAttributeValueModel>?,
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
class _$ProductAttributeModelImpl implements _ProductAttributeModel {
  _$ProductAttributeModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) this.textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) this.isRequired = false,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    this.attributeControlType = AttributeControlType.dropdownList,
    @JsonKey(name: 'Values', includeIfNull: false)
    final List<ProductAttributeValueModel>? values = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _values = values,
       _userFields = userFields;

  factory _$ProductAttributeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductAttributeModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
  @override
  @JsonKey(name: 'TextPrompt', includeIfNull: false)
  final String? textPrompt;
  @override
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  final bool? isRequired;
  @override
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  final AttributeControlType? attributeControlType;
  final List<ProductAttributeValueModel>? _values;
  @override
  @JsonKey(name: 'Values', includeIfNull: false)
  List<ProductAttributeValueModel>? get values {
    final value = _values;
    if (value == null) return null;
    if (_values is EqualUnmodifiableListView) return _values;
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
    return 'ProductAttributeModel(name: $name, seName: $seName, textPrompt: $textPrompt, isRequired: $isRequired, attributeControlType: $attributeControlType, values: $values, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductAttributeModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.textPrompt, textPrompt) ||
                other.textPrompt == textPrompt) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.attributeControlType, attributeControlType) ||
                other.attributeControlType == attributeControlType) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
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
    seName,
    textPrompt,
    isRequired,
    attributeControlType,
    const DeepCollectionEquality().hash(_values),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductAttributeModelImplCopyWith<_$ProductAttributeModelImpl>
  get copyWith =>
      __$$ProductAttributeModelImplCopyWithImpl<_$ProductAttributeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductAttributeModelImplToJson(this);
  }
}

abstract class _ProductAttributeModel implements ProductAttributeModel {
  factory _ProductAttributeModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) final String? textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) final bool? isRequired,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    final AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    final List<ProductAttributeValueModel>? values,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductAttributeModelImpl;

  factory _ProductAttributeModel.fromJson(Map<String, dynamic> json) =
      _$ProductAttributeModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'TextPrompt', includeIfNull: false)
  String? get textPrompt;
  @override
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  bool? get isRequired;
  @override
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  AttributeControlType? get attributeControlType;
  @override
  @JsonKey(name: 'Values', includeIfNull: false)
  List<ProductAttributeValueModel>? get values;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductAttributeModelImplCopyWith<_$ProductAttributeModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
