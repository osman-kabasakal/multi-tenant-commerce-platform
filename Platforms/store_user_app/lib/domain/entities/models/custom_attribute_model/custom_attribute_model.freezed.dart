// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_attribute_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomAttributeModel _$CustomAttributeModelFromJson(Map<String, dynamic> json) {
  return _CustomAttributeModel.fromJson(json);
}

/// @nodoc
mixin _$CustomAttributeModel {
  @JsonKey(name: 'Key', includeIfNull: false)
  String? get key => throw _privateConstructorUsedError;
  @JsonKey(name: 'Value', includeIfNull: false)
  String? get value => throw _privateConstructorUsedError;

  /// Serializes this CustomAttributeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomAttributeModelCopyWith<CustomAttributeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomAttributeModelCopyWith<$Res> {
  factory $CustomAttributeModelCopyWith(
    CustomAttributeModel value,
    $Res Function(CustomAttributeModel) then,
  ) = _$CustomAttributeModelCopyWithImpl<$Res, CustomAttributeModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Key', includeIfNull: false) String? key,
    @JsonKey(name: 'Value', includeIfNull: false) String? value,
  });
}

/// @nodoc
class _$CustomAttributeModelCopyWithImpl<
  $Res,
  $Val extends CustomAttributeModel
>
    implements $CustomAttributeModelCopyWith<$Res> {
  _$CustomAttributeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = freezed, Object? value = freezed}) {
    return _then(
      _value.copyWith(
            key:
                freezed == key
                    ? _value.key
                    : key // ignore: cast_nullable_to_non_nullable
                        as String?,
            value:
                freezed == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomAttributeModelImplCopyWith<$Res>
    implements $CustomAttributeModelCopyWith<$Res> {
  factory _$$CustomAttributeModelImplCopyWith(
    _$CustomAttributeModelImpl value,
    $Res Function(_$CustomAttributeModelImpl) then,
  ) = __$$CustomAttributeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Key', includeIfNull: false) String? key,
    @JsonKey(name: 'Value', includeIfNull: false) String? value,
  });
}

/// @nodoc
class __$$CustomAttributeModelImplCopyWithImpl<$Res>
    extends _$CustomAttributeModelCopyWithImpl<$Res, _$CustomAttributeModelImpl>
    implements _$$CustomAttributeModelImplCopyWith<$Res> {
  __$$CustomAttributeModelImplCopyWithImpl(
    _$CustomAttributeModelImpl _value,
    $Res Function(_$CustomAttributeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = freezed, Object? value = freezed}) {
    return _then(
      _$CustomAttributeModelImpl(
        key:
            freezed == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                    as String?,
        value:
            freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomAttributeModelImpl implements _CustomAttributeModel {
  _$CustomAttributeModelImpl({
    @JsonKey(name: 'Key', includeIfNull: false) this.key,
    @JsonKey(name: 'Value', includeIfNull: false) this.value,
  });

  factory _$CustomAttributeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomAttributeModelImplFromJson(json);

  @override
  @JsonKey(name: 'Key', includeIfNull: false)
  final String? key;
  @override
  @JsonKey(name: 'Value', includeIfNull: false)
  final String? value;

  @override
  String toString() {
    return 'CustomAttributeModel(key: $key, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomAttributeModelImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value);

  /// Create a copy of CustomAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomAttributeModelImplCopyWith<_$CustomAttributeModelImpl>
  get copyWith =>
      __$$CustomAttributeModelImplCopyWithImpl<_$CustomAttributeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomAttributeModelImplToJson(this);
  }
}

abstract class _CustomAttributeModel implements CustomAttributeModel {
  factory _CustomAttributeModel({
    @JsonKey(name: 'Key', includeIfNull: false) final String? key,
    @JsonKey(name: 'Value', includeIfNull: false) final String? value,
  }) = _$CustomAttributeModelImpl;

  factory _CustomAttributeModel.fromJson(Map<String, dynamic> json) =
      _$CustomAttributeModelImpl.fromJson;

  @override
  @JsonKey(name: 'Key', includeIfNull: false)
  String? get key;
  @override
  @JsonKey(name: 'Value', includeIfNull: false)
  String? get value;

  /// Create a copy of CustomAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomAttributeModelImplCopyWith<_$CustomAttributeModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
