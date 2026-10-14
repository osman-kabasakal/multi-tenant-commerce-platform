// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_attribute_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutAttributeModel _$CheckoutAttributeModelFromJson(
  Map<String, dynamic> json,
) {
  return _CheckoutAttributeModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutAttributeModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'DefaultValue', includeIfNull: false)
  String? get defaultValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'TextPrompt', includeIfNull: false)
  String? get textPrompt => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  bool? get isRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
  List<String>? get allowedFileExtensions => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  AttributeControlType? get attributeControlType =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Values', includeIfNull: false)
  List<CheckoutAttributeValueModel>? get values =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CheckoutAttributeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutAttributeModelCopyWith<CheckoutAttributeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutAttributeModelCopyWith<$Res> {
  factory $CheckoutAttributeModelCopyWith(
    CheckoutAttributeModel value,
    $Res Function(CheckoutAttributeModel) then,
  ) = _$CheckoutAttributeModelCopyWithImpl<$Res, CheckoutAttributeModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) String? textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) bool? isRequired,
    @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
    List<String>? allowedFileExtensions,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    List<CheckoutAttributeValueModel>? values,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CheckoutAttributeModelCopyWithImpl<
  $Res,
  $Val extends CheckoutAttributeModel
>
    implements $CheckoutAttributeModelCopyWith<$Res> {
  _$CheckoutAttributeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? defaultValue = freezed,
    Object? textPrompt = freezed,
    Object? isRequired = freezed,
    Object? allowedFileExtensions = freezed,
    Object? attributeControlType = freezed,
    Object? values = freezed,
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
            defaultValue:
                freezed == defaultValue
                    ? _value.defaultValue
                    : defaultValue // ignore: cast_nullable_to_non_nullable
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
            allowedFileExtensions:
                freezed == allowedFileExtensions
                    ? _value.allowedFileExtensions
                    : allowedFileExtensions // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            attributeControlType:
                freezed == attributeControlType
                    ? _value.attributeControlType
                    : attributeControlType // ignore: cast_nullable_to_non_nullable
                        as AttributeControlType?,
            values:
                freezed == values
                    ? _value.values
                    : values // ignore: cast_nullable_to_non_nullable
                        as List<CheckoutAttributeValueModel>?,
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
abstract class _$$CheckoutAttributeModelImplCopyWith<$Res>
    implements $CheckoutAttributeModelCopyWith<$Res> {
  factory _$$CheckoutAttributeModelImplCopyWith(
    _$CheckoutAttributeModelImpl value,
    $Res Function(_$CheckoutAttributeModelImpl) then,
  ) = __$$CheckoutAttributeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) String? textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) bool? isRequired,
    @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
    List<String>? allowedFileExtensions,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    List<CheckoutAttributeValueModel>? values,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CheckoutAttributeModelImplCopyWithImpl<$Res>
    extends
        _$CheckoutAttributeModelCopyWithImpl<$Res, _$CheckoutAttributeModelImpl>
    implements _$$CheckoutAttributeModelImplCopyWith<$Res> {
  __$$CheckoutAttributeModelImplCopyWithImpl(
    _$CheckoutAttributeModelImpl _value,
    $Res Function(_$CheckoutAttributeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? defaultValue = freezed,
    Object? textPrompt = freezed,
    Object? isRequired = freezed,
    Object? allowedFileExtensions = freezed,
    Object? attributeControlType = freezed,
    Object? values = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CheckoutAttributeModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        defaultValue:
            freezed == defaultValue
                ? _value.defaultValue
                : defaultValue // ignore: cast_nullable_to_non_nullable
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
        allowedFileExtensions:
            freezed == allowedFileExtensions
                ? _value._allowedFileExtensions
                : allowedFileExtensions // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        attributeControlType:
            freezed == attributeControlType
                ? _value.attributeControlType
                : attributeControlType // ignore: cast_nullable_to_non_nullable
                    as AttributeControlType?,
        values:
            freezed == values
                ? _value._values
                : values // ignore: cast_nullable_to_non_nullable
                    as List<CheckoutAttributeValueModel>?,
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
class _$CheckoutAttributeModelImpl implements _CheckoutAttributeModel {
  _$CheckoutAttributeModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'DefaultValue', includeIfNull: false) this.defaultValue,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) this.textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) this.isRequired = false,
    @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
    final List<String>? allowedFileExtensions = const [],
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    this.attributeControlType = AttributeControlType.dropdownList,
    @JsonKey(name: 'Values', includeIfNull: false)
    final List<CheckoutAttributeValueModel>? values = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _allowedFileExtensions = allowedFileExtensions,
       _values = values,
       _userFields = userFields;

  factory _$CheckoutAttributeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutAttributeModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'DefaultValue', includeIfNull: false)
  final String? defaultValue;
  @override
  @JsonKey(name: 'TextPrompt', includeIfNull: false)
  final String? textPrompt;
  @override
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  final bool? isRequired;
  final List<String>? _allowedFileExtensions;
  @override
  @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
  List<String>? get allowedFileExtensions {
    final value = _allowedFileExtensions;
    if (value == null) return null;
    if (_allowedFileExtensions is EqualUnmodifiableListView)
      return _allowedFileExtensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  final AttributeControlType? attributeControlType;
  final List<CheckoutAttributeValueModel>? _values;
  @override
  @JsonKey(name: 'Values', includeIfNull: false)
  List<CheckoutAttributeValueModel>? get values {
    final value = _values;
    if (value == null) return null;
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'CheckoutAttributeModel(name: $name, defaultValue: $defaultValue, textPrompt: $textPrompt, isRequired: $isRequired, allowedFileExtensions: $allowedFileExtensions, attributeControlType: $attributeControlType, values: $values, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutAttributeModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
            (identical(other.textPrompt, textPrompt) ||
                other.textPrompt == textPrompt) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            const DeepCollectionEquality().equals(
              other._allowedFileExtensions,
              _allowedFileExtensions,
            ) &&
            (identical(other.attributeControlType, attributeControlType) ||
                other.attributeControlType == attributeControlType) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
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
    defaultValue,
    textPrompt,
    isRequired,
    const DeepCollectionEquality().hash(_allowedFileExtensions),
    attributeControlType,
    const DeepCollectionEquality().hash(_values),
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CheckoutAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutAttributeModelImplCopyWith<_$CheckoutAttributeModelImpl>
  get copyWith =>
      __$$CheckoutAttributeModelImplCopyWithImpl<_$CheckoutAttributeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutAttributeModelImplToJson(this);
  }
}

abstract class _CheckoutAttributeModel implements CheckoutAttributeModel {
  factory _CheckoutAttributeModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'DefaultValue', includeIfNull: false)
    final String? defaultValue,
    @JsonKey(name: 'TextPrompt', includeIfNull: false) final String? textPrompt,
    @JsonKey(name: 'IsRequired', includeIfNull: false) final bool? isRequired,
    @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
    final List<String>? allowedFileExtensions,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    final AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    final List<CheckoutAttributeValueModel>? values,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CheckoutAttributeModelImpl;

  factory _CheckoutAttributeModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutAttributeModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'DefaultValue', includeIfNull: false)
  String? get defaultValue;
  @override
  @JsonKey(name: 'TextPrompt', includeIfNull: false)
  String? get textPrompt;
  @override
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  bool? get isRequired;
  @override
  @JsonKey(name: 'AllowedFileExtensions', includeIfNull: false)
  List<String>? get allowedFileExtensions;
  @override
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  AttributeControlType? get attributeControlType;
  @override
  @JsonKey(name: 'Values', includeIfNull: false)
  List<CheckoutAttributeValueModel>? get values;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CheckoutAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutAttributeModelImplCopyWith<_$CheckoutAttributeModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
