// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authenticate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthenticateModel _$AuthenticateModelFromJson(Map<String, dynamic> json) {
  return _AuthenticateModel.fromJson(json);
}

/// @nodoc
mixin _$AuthenticateModel {
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Password', includeIfNull: false)
  String? get password => throw _privateConstructorUsedError;

  /// Serializes this AuthenticateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthenticateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthenticateModelCopyWith<AuthenticateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticateModelCopyWith<$Res> {
  factory $AuthenticateModelCopyWith(
    AuthenticateModel value,
    $Res Function(AuthenticateModel) then,
  ) = _$AuthenticateModelCopyWithImpl<$Res, AuthenticateModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'Password', includeIfNull: false) String? password,
  });
}

/// @nodoc
class _$AuthenticateModelCopyWithImpl<$Res, $Val extends AuthenticateModel>
    implements $AuthenticateModelCopyWith<$Res> {
  _$AuthenticateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthenticateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? password = freezed}) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            password:
                freezed == password
                    ? _value.password
                    : password // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthenticateModelImplCopyWith<$Res>
    implements $AuthenticateModelCopyWith<$Res> {
  factory _$$AuthenticateModelImplCopyWith(
    _$AuthenticateModelImpl value,
    $Res Function(_$AuthenticateModelImpl) then,
  ) = __$$AuthenticateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'Password', includeIfNull: false) String? password,
  });
}

/// @nodoc
class __$$AuthenticateModelImplCopyWithImpl<$Res>
    extends _$AuthenticateModelCopyWithImpl<$Res, _$AuthenticateModelImpl>
    implements _$$AuthenticateModelImplCopyWith<$Res> {
  __$$AuthenticateModelImplCopyWithImpl(
    _$AuthenticateModelImpl _value,
    $Res Function(_$AuthenticateModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthenticateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? password = freezed}) {
    return _then(
      _$AuthenticateModelImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        password:
            freezed == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthenticateModelImpl implements _AuthenticateModel {
  _$AuthenticateModelImpl({
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'Password', includeIfNull: false) this.password,
  });

  factory _$AuthenticateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthenticateModelImplFromJson(json);

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
  @override
  @JsonKey(name: 'Password', includeIfNull: false)
  final String? password;

  @override
  String toString() {
    return 'AuthenticateModel(id: $id, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, password);

  /// Create a copy of AuthenticateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticateModelImplCopyWith<_$AuthenticateModelImpl> get copyWith =>
      __$$AuthenticateModelImplCopyWithImpl<_$AuthenticateModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthenticateModelImplToJson(this);
  }
}

abstract class _AuthenticateModel implements AuthenticateModel {
  factory _AuthenticateModel({
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'Password', includeIfNull: false) final String? password,
  }) = _$AuthenticateModelImpl;

  factory _AuthenticateModel.fromJson(Map<String, dynamic> json) =
      _$AuthenticateModelImpl.fromJson;

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'Password', includeIfNull: false)
  String? get password;

  /// Create a copy of AuthenticateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthenticateModelImplCopyWith<_$AuthenticateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
