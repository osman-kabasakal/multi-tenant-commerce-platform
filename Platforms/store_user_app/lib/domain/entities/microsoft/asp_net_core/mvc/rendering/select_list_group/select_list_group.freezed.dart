// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_list_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SelectListGroup _$SelectListGroupFromJson(Map<String, dynamic> json) {
  return _SelectListGroup.fromJson(json);
}

/// @nodoc
mixin _$SelectListGroup {
  @JsonKey(name: 'Disabled', includeIfNull: false)
  bool? get disabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this SelectListGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectListGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectListGroupCopyWith<SelectListGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectListGroupCopyWith<$Res> {
  factory $SelectListGroupCopyWith(
    SelectListGroup value,
    $Res Function(SelectListGroup) then,
  ) = _$SelectListGroupCopyWithImpl<$Res, SelectListGroup>;
  @useResult
  $Res call({
    @JsonKey(name: 'Disabled', includeIfNull: false) bool? disabled,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
  });
}

/// @nodoc
class _$SelectListGroupCopyWithImpl<$Res, $Val extends SelectListGroup>
    implements $SelectListGroupCopyWith<$Res> {
  _$SelectListGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectListGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? disabled = freezed, Object? name = freezed}) {
    return _then(
      _value.copyWith(
            disabled:
                freezed == disabled
                    ? _value.disabled
                    : disabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SelectListGroupImplCopyWith<$Res>
    implements $SelectListGroupCopyWith<$Res> {
  factory _$$SelectListGroupImplCopyWith(
    _$SelectListGroupImpl value,
    $Res Function(_$SelectListGroupImpl) then,
  ) = __$$SelectListGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Disabled', includeIfNull: false) bool? disabled,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
  });
}

/// @nodoc
class __$$SelectListGroupImplCopyWithImpl<$Res>
    extends _$SelectListGroupCopyWithImpl<$Res, _$SelectListGroupImpl>
    implements _$$SelectListGroupImplCopyWith<$Res> {
  __$$SelectListGroupImplCopyWithImpl(
    _$SelectListGroupImpl _value,
    $Res Function(_$SelectListGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectListGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? disabled = freezed, Object? name = freezed}) {
    return _then(
      _$SelectListGroupImpl(
        disabled:
            freezed == disabled
                ? _value.disabled
                : disabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectListGroupImpl implements _SelectListGroup {
  _$SelectListGroupImpl({
    @JsonKey(name: 'Disabled', includeIfNull: false) this.disabled = false,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
  });

  factory _$SelectListGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectListGroupImplFromJson(json);

  @override
  @JsonKey(name: 'Disabled', includeIfNull: false)
  final bool? disabled;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;

  @override
  String toString() {
    return 'SelectListGroup(disabled: $disabled, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectListGroupImpl &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, disabled, name);

  /// Create a copy of SelectListGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectListGroupImplCopyWith<_$SelectListGroupImpl> get copyWith =>
      __$$SelectListGroupImplCopyWithImpl<_$SelectListGroupImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectListGroupImplToJson(this);
  }
}

abstract class _SelectListGroup implements SelectListGroup {
  factory _SelectListGroup({
    @JsonKey(name: 'Disabled', includeIfNull: false) final bool? disabled,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
  }) = _$SelectListGroupImpl;

  factory _SelectListGroup.fromJson(Map<String, dynamic> json) =
      _$SelectListGroupImpl.fromJson;

  @override
  @JsonKey(name: 'Disabled', includeIfNull: false)
  bool? get disabled;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;

  /// Create a copy of SelectListGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectListGroupImplCopyWith<_$SelectListGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
