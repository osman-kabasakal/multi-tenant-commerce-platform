// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state_province_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StateProvinceModel _$StateProvinceModelFromJson(Map<String, dynamic> json) {
  return _StateProvinceModel.fromJson(json);
}

/// @nodoc
mixin _$StateProvinceModel {
  @JsonKey(name: 'id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this StateProvinceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StateProvinceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StateProvinceModelCopyWith<StateProvinceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateProvinceModelCopyWith<$Res> {
  factory $StateProvinceModelCopyWith(
    StateProvinceModel value,
    $Res Function(StateProvinceModel) then,
  ) = _$StateProvinceModelCopyWithImpl<$Res, StateProvinceModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'id', includeIfNull: false) String? id,
    @JsonKey(name: 'name', includeIfNull: false) String? name,
  });
}

/// @nodoc
class _$StateProvinceModelCopyWithImpl<$Res, $Val extends StateProvinceModel>
    implements $StateProvinceModelCopyWith<$Res> {
  _$StateProvinceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StateProvinceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? name = freezed}) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$StateProvinceModelImplCopyWith<$Res>
    implements $StateProvinceModelCopyWith<$Res> {
  factory _$$StateProvinceModelImplCopyWith(
    _$StateProvinceModelImpl value,
    $Res Function(_$StateProvinceModelImpl) then,
  ) = __$$StateProvinceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id', includeIfNull: false) String? id,
    @JsonKey(name: 'name', includeIfNull: false) String? name,
  });
}

/// @nodoc
class __$$StateProvinceModelImplCopyWithImpl<$Res>
    extends _$StateProvinceModelCopyWithImpl<$Res, _$StateProvinceModelImpl>
    implements _$$StateProvinceModelImplCopyWith<$Res> {
  __$$StateProvinceModelImplCopyWithImpl(
    _$StateProvinceModelImpl _value,
    $Res Function(_$StateProvinceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StateProvinceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? name = freezed}) {
    return _then(
      _$StateProvinceModelImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$StateProvinceModelImpl implements _StateProvinceModel {
  _$StateProvinceModelImpl({
    @JsonKey(name: 'id', includeIfNull: false) this.id,
    @JsonKey(name: 'name', includeIfNull: false) this.name,
  });

  factory _$StateProvinceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StateProvinceModelImplFromJson(json);

  @override
  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;
  @override
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;

  @override
  String toString() {
    return 'StateProvinceModel(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateProvinceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of StateProvinceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateProvinceModelImplCopyWith<_$StateProvinceModelImpl> get copyWith =>
      __$$StateProvinceModelImplCopyWithImpl<_$StateProvinceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StateProvinceModelImplToJson(this);
  }
}

abstract class _StateProvinceModel implements StateProvinceModel {
  factory _StateProvinceModel({
    @JsonKey(name: 'id', includeIfNull: false) final String? id,
    @JsonKey(name: 'name', includeIfNull: false) final String? name,
  }) = _$StateProvinceModelImpl;

  factory _StateProvinceModel.fromJson(Map<String, dynamic> json) =
      _$StateProvinceModelImpl.fromJson;

  @override
  @JsonKey(name: 'id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'name', includeIfNull: false)
  String? get name;

  /// Create a copy of StateProvinceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateProvinceModelImplCopyWith<_$StateProvinceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
