// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_attribute_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddressAttributeModel _$AddressAttributeModelFromJson(
  Map<String, dynamic> json,
) {
  return _AddressAttributeModel.fromJson(json);
}

/// @nodoc
mixin _$AddressAttributeModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  bool? get isRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'DefaultValue', includeIfNull: false)
  String? get defaultValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  AttributeControlType? get attributeControlType =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Values', includeIfNull: false)
  List<AddressAttributeValueModel>? get values =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this AddressAttributeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressAttributeModelCopyWith<AddressAttributeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressAttributeModelCopyWith<$Res> {
  factory $AddressAttributeModelCopyWith(
    AddressAttributeModel value,
    $Res Function(AddressAttributeModel) then,
  ) = _$AddressAttributeModelCopyWithImpl<$Res, AddressAttributeModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'IsRequired', includeIfNull: false) bool? isRequired,
    @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    List<AddressAttributeValueModel>? values,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$AddressAttributeModelCopyWithImpl<
  $Res,
  $Val extends AddressAttributeModel
>
    implements $AddressAttributeModelCopyWith<$Res> {
  _$AddressAttributeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? isRequired = freezed,
    Object? defaultValue = freezed,
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
            isRequired:
                freezed == isRequired
                    ? _value.isRequired
                    : isRequired // ignore: cast_nullable_to_non_nullable
                        as bool?,
            defaultValue:
                freezed == defaultValue
                    ? _value.defaultValue
                    : defaultValue // ignore: cast_nullable_to_non_nullable
                        as String?,
            attributeControlType:
                freezed == attributeControlType
                    ? _value.attributeControlType
                    : attributeControlType // ignore: cast_nullable_to_non_nullable
                        as AttributeControlType?,
            values:
                freezed == values
                    ? _value.values
                    : values // ignore: cast_nullable_to_non_nullable
                        as List<AddressAttributeValueModel>?,
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
abstract class _$$AddressAttributeModelImplCopyWith<$Res>
    implements $AddressAttributeModelCopyWith<$Res> {
  factory _$$AddressAttributeModelImplCopyWith(
    _$AddressAttributeModelImpl value,
    $Res Function(_$AddressAttributeModelImpl) then,
  ) = __$$AddressAttributeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'IsRequired', includeIfNull: false) bool? isRequired,
    @JsonKey(name: 'DefaultValue', includeIfNull: false) String? defaultValue,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    List<AddressAttributeValueModel>? values,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$AddressAttributeModelImplCopyWithImpl<$Res>
    extends
        _$AddressAttributeModelCopyWithImpl<$Res, _$AddressAttributeModelImpl>
    implements _$$AddressAttributeModelImplCopyWith<$Res> {
  __$$AddressAttributeModelImplCopyWithImpl(
    _$AddressAttributeModelImpl _value,
    $Res Function(_$AddressAttributeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddressAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? isRequired = freezed,
    Object? defaultValue = freezed,
    Object? attributeControlType = freezed,
    Object? values = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$AddressAttributeModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        isRequired:
            freezed == isRequired
                ? _value.isRequired
                : isRequired // ignore: cast_nullable_to_non_nullable
                    as bool?,
        defaultValue:
            freezed == defaultValue
                ? _value.defaultValue
                : defaultValue // ignore: cast_nullable_to_non_nullable
                    as String?,
        attributeControlType:
            freezed == attributeControlType
                ? _value.attributeControlType
                : attributeControlType // ignore: cast_nullable_to_non_nullable
                    as AttributeControlType?,
        values:
            freezed == values
                ? _value._values
                : values // ignore: cast_nullable_to_non_nullable
                    as List<AddressAttributeValueModel>?,
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
class _$AddressAttributeModelImpl implements _AddressAttributeModel {
  _$AddressAttributeModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'IsRequired', includeIfNull: false) this.isRequired = false,
    @JsonKey(name: 'DefaultValue', includeIfNull: false) this.defaultValue,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    this.attributeControlType = AttributeControlType.dropdownList,
    @JsonKey(name: 'Values', includeIfNull: false)
    final List<AddressAttributeValueModel>? values = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _values = values,
       _userFields = userFields;

  factory _$AddressAttributeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressAttributeModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  final bool? isRequired;
  @override
  @JsonKey(name: 'DefaultValue', includeIfNull: false)
  final String? defaultValue;
  @override
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  final AttributeControlType? attributeControlType;
  final List<AddressAttributeValueModel>? _values;
  @override
  @JsonKey(name: 'Values', includeIfNull: false)
  List<AddressAttributeValueModel>? get values {
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
    return 'AddressAttributeModel(name: $name, isRequired: $isRequired, defaultValue: $defaultValue, attributeControlType: $attributeControlType, values: $values, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressAttributeModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
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
    isRequired,
    defaultValue,
    attributeControlType,
    const DeepCollectionEquality().hash(_values),
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of AddressAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressAttributeModelImplCopyWith<_$AddressAttributeModelImpl>
  get copyWith =>
      __$$AddressAttributeModelImplCopyWithImpl<_$AddressAttributeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressAttributeModelImplToJson(this);
  }
}

abstract class _AddressAttributeModel implements AddressAttributeModel {
  factory _AddressAttributeModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'IsRequired', includeIfNull: false) final bool? isRequired,
    @JsonKey(name: 'DefaultValue', includeIfNull: false)
    final String? defaultValue,
    @JsonKey(name: 'AttributeControlType', includeIfNull: false)
    final AttributeControlType? attributeControlType,
    @JsonKey(name: 'Values', includeIfNull: false)
    final List<AddressAttributeValueModel>? values,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$AddressAttributeModelImpl;

  factory _AddressAttributeModel.fromJson(Map<String, dynamic> json) =
      _$AddressAttributeModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'IsRequired', includeIfNull: false)
  bool? get isRequired;
  @override
  @JsonKey(name: 'DefaultValue', includeIfNull: false)
  String? get defaultValue;
  @override
  @JsonKey(name: 'AttributeControlType', includeIfNull: false)
  AttributeControlType? get attributeControlType;
  @override
  @JsonKey(name: 'Values', includeIfNull: false)
  List<AddressAttributeValueModel>? get values;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of AddressAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressAttributeModelImplCopyWith<_$AddressAttributeModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
