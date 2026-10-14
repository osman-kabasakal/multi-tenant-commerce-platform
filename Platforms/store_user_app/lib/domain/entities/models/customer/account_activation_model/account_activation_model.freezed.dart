// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_activation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AccountActivationModel _$AccountActivationModelFromJson(
  Map<String, dynamic> json,
) {
  return _AccountActivationModel.fromJson(json);
}

/// @nodoc
mixin _$AccountActivationModel {
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this AccountActivationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountActivationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountActivationModelCopyWith<AccountActivationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountActivationModelCopyWith<$Res> {
  factory $AccountActivationModelCopyWith(
    AccountActivationModel value,
    $Res Function(AccountActivationModel) then,
  ) = _$AccountActivationModelCopyWithImpl<$Res, AccountActivationModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$AccountActivationModelCopyWithImpl<
  $Res,
  $Val extends AccountActivationModel
>
    implements $AccountActivationModelCopyWith<$Res> {
  _$AccountActivationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountActivationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? result = freezed, Object? userFields = freezed}) {
    return _then(
      _value.copyWith(
            result:
                freezed == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AccountActivationModelImplCopyWith<$Res>
    implements $AccountActivationModelCopyWith<$Res> {
  factory _$$AccountActivationModelImplCopyWith(
    _$AccountActivationModelImpl value,
    $Res Function(_$AccountActivationModelImpl) then,
  ) = __$$AccountActivationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Result', includeIfNull: false) String? result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$AccountActivationModelImplCopyWithImpl<$Res>
    extends
        _$AccountActivationModelCopyWithImpl<$Res, _$AccountActivationModelImpl>
    implements _$$AccountActivationModelImplCopyWith<$Res> {
  __$$AccountActivationModelImplCopyWithImpl(
    _$AccountActivationModelImpl _value,
    $Res Function(_$AccountActivationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccountActivationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? result = freezed, Object? userFields = freezed}) {
    return _then(
      _$AccountActivationModelImpl(
        result:
            freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
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
class _$AccountActivationModelImpl implements _AccountActivationModel {
  _$AccountActivationModelImpl({
    @JsonKey(name: 'Result', includeIfNull: false) this.result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$AccountActivationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountActivationModelImplFromJson(json);

  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  final String? result;
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
    return 'AccountActivationModel(result: $result, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountActivationModelImpl &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    result,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of AccountActivationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountActivationModelImplCopyWith<_$AccountActivationModelImpl>
  get copyWith =>
      __$$AccountActivationModelImplCopyWithImpl<_$AccountActivationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountActivationModelImplToJson(this);
  }
}

abstract class _AccountActivationModel implements AccountActivationModel {
  factory _AccountActivationModel({
    @JsonKey(name: 'Result', includeIfNull: false) final String? result,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$AccountActivationModelImpl;

  factory _AccountActivationModel.fromJson(Map<String, dynamic> json) =
      _$AccountActivationModelImpl.fromJson;

  @override
  @JsonKey(name: 'Result', includeIfNull: false)
  String? get result;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of AccountActivationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountActivationModelImplCopyWith<_$AccountActivationModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
