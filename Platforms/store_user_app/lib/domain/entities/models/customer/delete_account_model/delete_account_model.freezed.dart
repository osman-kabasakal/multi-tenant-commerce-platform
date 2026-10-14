// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_account_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeleteAccountModel _$DeleteAccountModelFromJson(Map<String, dynamic> json) {
  return _DeleteAccountModel.fromJson(json);
}

/// @nodoc
mixin _$DeleteAccountModel {
  @JsonKey(name: 'Password', includeIfNull: false)
  String? get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this DeleteAccountModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeleteAccountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteAccountModelCopyWith<DeleteAccountModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteAccountModelCopyWith<$Res> {
  factory $DeleteAccountModelCopyWith(
    DeleteAccountModel value,
    $Res Function(DeleteAccountModel) then,
  ) = _$DeleteAccountModelCopyWithImpl<$Res, DeleteAccountModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Password', includeIfNull: false) String? password,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$DeleteAccountModelCopyWithImpl<$Res, $Val extends DeleteAccountModel>
    implements $DeleteAccountModelCopyWith<$Res> {
  _$DeleteAccountModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteAccountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? password = freezed, Object? userFields = freezed}) {
    return _then(
      _value.copyWith(
            password:
                freezed == password
                    ? _value.password
                    : password // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DeleteAccountModelImplCopyWith<$Res>
    implements $DeleteAccountModelCopyWith<$Res> {
  factory _$$DeleteAccountModelImplCopyWith(
    _$DeleteAccountModelImpl value,
    $Res Function(_$DeleteAccountModelImpl) then,
  ) = __$$DeleteAccountModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Password', includeIfNull: false) String? password,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$DeleteAccountModelImplCopyWithImpl<$Res>
    extends _$DeleteAccountModelCopyWithImpl<$Res, _$DeleteAccountModelImpl>
    implements _$$DeleteAccountModelImplCopyWith<$Res> {
  __$$DeleteAccountModelImplCopyWithImpl(
    _$DeleteAccountModelImpl _value,
    $Res Function(_$DeleteAccountModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteAccountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? password = freezed, Object? userFields = freezed}) {
    return _then(
      _$DeleteAccountModelImpl(
        password:
            freezed == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
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
class _$DeleteAccountModelImpl implements _DeleteAccountModel {
  _$DeleteAccountModelImpl({
    @JsonKey(name: 'Password', includeIfNull: false) this.password,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$DeleteAccountModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeleteAccountModelImplFromJson(json);

  @override
  @JsonKey(name: 'Password', includeIfNull: false)
  final String? password;
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
    return 'DeleteAccountModel(password: $password, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteAccountModelImpl &&
            (identical(other.password, password) ||
                other.password == password) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    password,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of DeleteAccountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteAccountModelImplCopyWith<_$DeleteAccountModelImpl> get copyWith =>
      __$$DeleteAccountModelImplCopyWithImpl<_$DeleteAccountModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeleteAccountModelImplToJson(this);
  }
}

abstract class _DeleteAccountModel implements DeleteAccountModel {
  factory _DeleteAccountModel({
    @JsonKey(name: 'Password', includeIfNull: false) final String? password,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$DeleteAccountModelImpl;

  factory _DeleteAccountModel.fromJson(Map<String, dynamic> json) =
      _$DeleteAccountModelImpl.fromJson;

  @override
  @JsonKey(name: 'Password', includeIfNull: false)
  String? get password;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of DeleteAccountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteAccountModelImplCopyWith<_$DeleteAccountModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
