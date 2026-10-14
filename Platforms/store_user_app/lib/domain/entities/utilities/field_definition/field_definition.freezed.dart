// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FieldDefinition _$FieldDefinitionFromJson(Map<String, dynamic> json) {
  return _FieldDefinition.fromJson(json);
}

/// @nodoc
mixin _$FieldDefinition {
  @JsonKey(name: 'Type', includeIfNull: false)
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'Label', includeIfNull: false)
  String? get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'Value', includeIfNull: false)
  Object? get value => throw _privateConstructorUsedError;
  @JsonKey(name: 'Required', includeIfNull: false)
  bool? get required => throw _privateConstructorUsedError;
  @JsonKey(name: 'Validations', includeIfNull: false)
  Map<String, Object>? get validations => throw _privateConstructorUsedError;
  @JsonKey(name: 'ValidationMessages', includeIfNull: false)
  Map<String, String>? get validationMessages =>
      throw _privateConstructorUsedError;

  /// Serializes this FieldDefinition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FieldDefinition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FieldDefinitionCopyWith<FieldDefinition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldDefinitionCopyWith<$Res> {
  factory $FieldDefinitionCopyWith(
    FieldDefinition value,
    $Res Function(FieldDefinition) then,
  ) = _$FieldDefinitionCopyWithImpl<$Res, FieldDefinition>;
  @useResult
  $Res call({
    @JsonKey(name: 'Type', includeIfNull: false) String? type,
    @JsonKey(name: 'Label', includeIfNull: false) String? label,
    @JsonKey(name: 'Value', includeIfNull: false) Object? value,
    @JsonKey(name: 'Required', includeIfNull: false) bool? required,
    @JsonKey(name: 'Validations', includeIfNull: false)
    Map<String, Object>? validations,
    @JsonKey(name: 'ValidationMessages', includeIfNull: false)
    Map<String, String>? validationMessages,
  });
}

/// @nodoc
class _$FieldDefinitionCopyWithImpl<$Res, $Val extends FieldDefinition>
    implements $FieldDefinitionCopyWith<$Res> {
  _$FieldDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FieldDefinition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? label = freezed,
    Object? value = freezed,
    Object? required = freezed,
    Object? validations = freezed,
    Object? validationMessages = freezed,
  }) {
    return _then(
      _value.copyWith(
            type:
                freezed == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String?,
            label:
                freezed == label
                    ? _value.label
                    : label // ignore: cast_nullable_to_non_nullable
                        as String?,
            value: freezed == value ? _value.value : value,
            required:
                freezed == required
                    ? _value.required
                    : required // ignore: cast_nullable_to_non_nullable
                        as bool?,
            validations:
                freezed == validations
                    ? _value.validations
                    : validations // ignore: cast_nullable_to_non_nullable
                        as Map<String, Object>?,
            validationMessages:
                freezed == validationMessages
                    ? _value.validationMessages
                    : validationMessages // ignore: cast_nullable_to_non_nullable
                        as Map<String, String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FieldDefinitionImplCopyWith<$Res>
    implements $FieldDefinitionCopyWith<$Res> {
  factory _$$FieldDefinitionImplCopyWith(
    _$FieldDefinitionImpl value,
    $Res Function(_$FieldDefinitionImpl) then,
  ) = __$$FieldDefinitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Type', includeIfNull: false) String? type,
    @JsonKey(name: 'Label', includeIfNull: false) String? label,
    @JsonKey(name: 'Value', includeIfNull: false) Object? value,
    @JsonKey(name: 'Required', includeIfNull: false) bool? required,
    @JsonKey(name: 'Validations', includeIfNull: false)
    Map<String, Object>? validations,
    @JsonKey(name: 'ValidationMessages', includeIfNull: false)
    Map<String, String>? validationMessages,
  });
}

/// @nodoc
class __$$FieldDefinitionImplCopyWithImpl<$Res>
    extends _$FieldDefinitionCopyWithImpl<$Res, _$FieldDefinitionImpl>
    implements _$$FieldDefinitionImplCopyWith<$Res> {
  __$$FieldDefinitionImplCopyWithImpl(
    _$FieldDefinitionImpl _value,
    $Res Function(_$FieldDefinitionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FieldDefinition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? label = freezed,
    Object? value = freezed,
    Object? required = freezed,
    Object? validations = freezed,
    Object? validationMessages = freezed,
  }) {
    return _then(
      _$FieldDefinitionImpl(
        type:
            freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String?,
        label:
            freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                    as String?,
        value: freezed == value ? _value.value : value,
        required:
            freezed == required
                ? _value.required
                : required // ignore: cast_nullable_to_non_nullable
                    as bool?,
        validations:
            freezed == validations
                ? _value._validations
                : validations // ignore: cast_nullable_to_non_nullable
                    as Map<String, Object>?,
        validationMessages:
            freezed == validationMessages
                ? _value._validationMessages
                : validationMessages // ignore: cast_nullable_to_non_nullable
                    as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FieldDefinitionImpl implements _FieldDefinition {
  _$FieldDefinitionImpl({
    @JsonKey(name: 'Type', includeIfNull: false) this.type,
    @JsonKey(name: 'Label', includeIfNull: false) this.label,
    @JsonKey(name: 'Value', includeIfNull: false) this.value,
    @JsonKey(name: 'Required', includeIfNull: false) this.required = false,
    @JsonKey(name: 'Validations', includeIfNull: false)
    final Map<String, Object>? validations = const {},
    @JsonKey(name: 'ValidationMessages', includeIfNull: false)
    final Map<String, String>? validationMessages = const {},
  }) : _validations = validations,
       _validationMessages = validationMessages;

  factory _$FieldDefinitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FieldDefinitionImplFromJson(json);

  @override
  @JsonKey(name: 'Type', includeIfNull: false)
  final String? type;
  @override
  @JsonKey(name: 'Label', includeIfNull: false)
  final String? label;
  @override
  @JsonKey(name: 'Value', includeIfNull: false)
  final Object? value;
  @override
  @JsonKey(name: 'Required', includeIfNull: false)
  final bool? required;
  final Map<String, Object>? _validations;
  @override
  @JsonKey(name: 'Validations', includeIfNull: false)
  Map<String, Object>? get validations {
    final value = _validations;
    if (value == null) return null;
    if (_validations is EqualUnmodifiableMapView) return _validations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, String>? _validationMessages;
  @override
  @JsonKey(name: 'ValidationMessages', includeIfNull: false)
  Map<String, String>? get validationMessages {
    final value = _validationMessages;
    if (value == null) return null;
    if (_validationMessages is EqualUnmodifiableMapView)
      return _validationMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'FieldDefinition(type: $type, label: $label, value: $value, required: $required, validations: $validations, validationMessages: $validationMessages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldDefinitionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.required, required) ||
                other.required == required) &&
            const DeepCollectionEquality().equals(
              other._validations,
              _validations,
            ) &&
            const DeepCollectionEquality().equals(
              other._validationMessages,
              _validationMessages,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    label,
    const DeepCollectionEquality().hash(value),
    required,
    const DeepCollectionEquality().hash(_validations),
    const DeepCollectionEquality().hash(_validationMessages),
  );

  /// Create a copy of FieldDefinition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldDefinitionImplCopyWith<_$FieldDefinitionImpl> get copyWith =>
      __$$FieldDefinitionImplCopyWithImpl<_$FieldDefinitionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FieldDefinitionImplToJson(this);
  }
}

abstract class _FieldDefinition implements FieldDefinition {
  factory _FieldDefinition({
    @JsonKey(name: 'Type', includeIfNull: false) final String? type,
    @JsonKey(name: 'Label', includeIfNull: false) final String? label,
    @JsonKey(name: 'Value', includeIfNull: false) final Object? value,
    @JsonKey(name: 'Required', includeIfNull: false) final bool? required,
    @JsonKey(name: 'Validations', includeIfNull: false)
    final Map<String, Object>? validations,
    @JsonKey(name: 'ValidationMessages', includeIfNull: false)
    final Map<String, String>? validationMessages,
  }) = _$FieldDefinitionImpl;

  factory _FieldDefinition.fromJson(Map<String, dynamic> json) =
      _$FieldDefinitionImpl.fromJson;

  @override
  @JsonKey(name: 'Type', includeIfNull: false)
  String? get type;
  @override
  @JsonKey(name: 'Label', includeIfNull: false)
  String? get label;
  @override
  @JsonKey(name: 'Value', includeIfNull: false)
  Object? get value;
  @override
  @JsonKey(name: 'Required', includeIfNull: false)
  bool? get required;
  @override
  @JsonKey(name: 'Validations', includeIfNull: false)
  Map<String, Object>? get validations;
  @override
  @JsonKey(name: 'ValidationMessages', includeIfNull: false)
  Map<String, String>? get validationMessages;

  /// Create a copy of FieldDefinition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FieldDefinitionImplCopyWith<_$FieldDefinitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
