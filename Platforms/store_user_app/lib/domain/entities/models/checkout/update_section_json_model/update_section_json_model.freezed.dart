// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_section_json_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdateSectionJsonModel _$UpdateSectionJsonModelFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateSectionJsonModel.fromJson(json);
}

/// @nodoc
mixin _$UpdateSectionJsonModel {
  @JsonKey(name: 'name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'model', includeIfNull: false)
  Map<String, dynamic>? get model => throw _privateConstructorUsedError;

  /// Serializes this UpdateSectionJsonModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateSectionJsonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateSectionJsonModelCopyWith<UpdateSectionJsonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateSectionJsonModelCopyWith<$Res> {
  factory $UpdateSectionJsonModelCopyWith(
    UpdateSectionJsonModel value,
    $Res Function(UpdateSectionJsonModel) then,
  ) = _$UpdateSectionJsonModelCopyWithImpl<$Res, UpdateSectionJsonModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'name', includeIfNull: false) String? name,
    @JsonKey(name: 'model', includeIfNull: false) Map<String, dynamic>? model,
  });
}

/// @nodoc
class _$UpdateSectionJsonModelCopyWithImpl<
  $Res,
  $Val extends UpdateSectionJsonModel
>
    implements $UpdateSectionJsonModelCopyWith<$Res> {
  _$UpdateSectionJsonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateSectionJsonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? model = freezed}) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            model:
                freezed == model
                    ? _value.model
                    : model // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateSectionJsonModelImplCopyWith<$Res>
    implements $UpdateSectionJsonModelCopyWith<$Res> {
  factory _$$UpdateSectionJsonModelImplCopyWith(
    _$UpdateSectionJsonModelImpl value,
    $Res Function(_$UpdateSectionJsonModelImpl) then,
  ) = __$$UpdateSectionJsonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'name', includeIfNull: false) String? name,
    @JsonKey(name: 'model', includeIfNull: false) Map<String, dynamic>? model,
  });
}

/// @nodoc
class __$$UpdateSectionJsonModelImplCopyWithImpl<$Res>
    extends
        _$UpdateSectionJsonModelCopyWithImpl<$Res, _$UpdateSectionJsonModelImpl>
    implements _$$UpdateSectionJsonModelImplCopyWith<$Res> {
  __$$UpdateSectionJsonModelImplCopyWithImpl(
    _$UpdateSectionJsonModelImpl _value,
    $Res Function(_$UpdateSectionJsonModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateSectionJsonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = freezed, Object? model = freezed}) {
    return _then(
      _$UpdateSectionJsonModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        model:
            freezed == model
                ? _value._model
                : model // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateSectionJsonModelImpl implements _UpdateSectionJsonModel {
  _$UpdateSectionJsonModelImpl({
    @JsonKey(name: 'name', includeIfNull: false) this.name,
    @JsonKey(name: 'model', includeIfNull: false)
    final Map<String, dynamic>? model,
  }) : _model = model;

  factory _$UpdateSectionJsonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateSectionJsonModelImplFromJson(json);

  @override
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  final Map<String, dynamic>? _model;
  @override
  @JsonKey(name: 'model', includeIfNull: false)
  Map<String, dynamic>? get model {
    final value = _model;
    if (value == null) return null;
    if (_model is EqualUnmodifiableMapView) return _model;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UpdateSectionJsonModel(name: $name, model: $model)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSectionJsonModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._model, _model));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    const DeepCollectionEquality().hash(_model),
  );

  /// Create a copy of UpdateSectionJsonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSectionJsonModelImplCopyWith<_$UpdateSectionJsonModelImpl>
  get copyWith =>
      __$$UpdateSectionJsonModelImplCopyWithImpl<_$UpdateSectionJsonModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateSectionJsonModelImplToJson(this);
  }
}

abstract class _UpdateSectionJsonModel implements UpdateSectionJsonModel {
  factory _UpdateSectionJsonModel({
    @JsonKey(name: 'name', includeIfNull: false) final String? name,
    @JsonKey(name: 'model', includeIfNull: false)
    final Map<String, dynamic>? model,
  }) = _$UpdateSectionJsonModelImpl;

  factory _UpdateSectionJsonModel.fromJson(Map<String, dynamic> json) =
      _$UpdateSectionJsonModelImpl.fromJson;

  @override
  @JsonKey(name: 'name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'model', includeIfNull: false)
  Map<String, dynamic>? get model;

  /// Create a copy of UpdateSectionJsonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSectionJsonModelImplCopyWith<_$UpdateSectionJsonModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
