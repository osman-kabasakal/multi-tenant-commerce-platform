// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'associated_external_auth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AssociatedExternalAuthModel _$AssociatedExternalAuthModelFromJson(
  Map<String, dynamic> json,
) {
  return _AssociatedExternalAuthModel.fromJson(json);
}

/// @nodoc
mixin _$AssociatedExternalAuthModel {
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'ExternalIdentifier', includeIfNull: false)
  String? get externalIdentifier => throw _privateConstructorUsedError;
  @JsonKey(name: 'AuthMethodName', includeIfNull: false)
  String? get authMethodName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this AssociatedExternalAuthModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssociatedExternalAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssociatedExternalAuthModelCopyWith<AssociatedExternalAuthModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssociatedExternalAuthModelCopyWith<$Res> {
  factory $AssociatedExternalAuthModelCopyWith(
    AssociatedExternalAuthModel value,
    $Res Function(AssociatedExternalAuthModel) then,
  ) =
      _$AssociatedExternalAuthModelCopyWithImpl<
        $Res,
        AssociatedExternalAuthModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'ExternalIdentifier', includeIfNull: false)
    String? externalIdentifier,
    @JsonKey(name: 'AuthMethodName', includeIfNull: false)
    String? authMethodName,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$AssociatedExternalAuthModelCopyWithImpl<
  $Res,
  $Val extends AssociatedExternalAuthModel
>
    implements $AssociatedExternalAuthModelCopyWith<$Res> {
  _$AssociatedExternalAuthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssociatedExternalAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? externalIdentifier = freezed,
    Object? authMethodName = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            email:
                freezed == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String?,
            externalIdentifier:
                freezed == externalIdentifier
                    ? _value.externalIdentifier
                    : externalIdentifier // ignore: cast_nullable_to_non_nullable
                        as String?,
            authMethodName:
                freezed == authMethodName
                    ? _value.authMethodName
                    : authMethodName // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$AssociatedExternalAuthModelImplCopyWith<$Res>
    implements $AssociatedExternalAuthModelCopyWith<$Res> {
  factory _$$AssociatedExternalAuthModelImplCopyWith(
    _$AssociatedExternalAuthModelImpl value,
    $Res Function(_$AssociatedExternalAuthModelImpl) then,
  ) = __$$AssociatedExternalAuthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'ExternalIdentifier', includeIfNull: false)
    String? externalIdentifier,
    @JsonKey(name: 'AuthMethodName', includeIfNull: false)
    String? authMethodName,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$AssociatedExternalAuthModelImplCopyWithImpl<$Res>
    extends
        _$AssociatedExternalAuthModelCopyWithImpl<
          $Res,
          _$AssociatedExternalAuthModelImpl
        >
    implements _$$AssociatedExternalAuthModelImplCopyWith<$Res> {
  __$$AssociatedExternalAuthModelImplCopyWithImpl(
    _$AssociatedExternalAuthModelImpl _value,
    $Res Function(_$AssociatedExternalAuthModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssociatedExternalAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? externalIdentifier = freezed,
    Object? authMethodName = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$AssociatedExternalAuthModelImpl(
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        externalIdentifier:
            freezed == externalIdentifier
                ? _value.externalIdentifier
                : externalIdentifier // ignore: cast_nullable_to_non_nullable
                    as String?,
        authMethodName:
            freezed == authMethodName
                ? _value.authMethodName
                : authMethodName // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$AssociatedExternalAuthModelImpl
    implements _AssociatedExternalAuthModel {
  _$AssociatedExternalAuthModelImpl({
    @JsonKey(name: 'Email', includeIfNull: false) this.email,
    @JsonKey(name: 'ExternalIdentifier', includeIfNull: false)
    this.externalIdentifier,
    @JsonKey(name: 'AuthMethodName', includeIfNull: false) this.authMethodName,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$AssociatedExternalAuthModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$AssociatedExternalAuthModelImplFromJson(json);

  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  final String? email;
  @override
  @JsonKey(name: 'ExternalIdentifier', includeIfNull: false)
  final String? externalIdentifier;
  @override
  @JsonKey(name: 'AuthMethodName', includeIfNull: false)
  final String? authMethodName;
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
    return 'AssociatedExternalAuthModel(email: $email, externalIdentifier: $externalIdentifier, authMethodName: $authMethodName, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssociatedExternalAuthModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.externalIdentifier, externalIdentifier) ||
                other.externalIdentifier == externalIdentifier) &&
            (identical(other.authMethodName, authMethodName) ||
                other.authMethodName == authMethodName) &&
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
    email,
    externalIdentifier,
    authMethodName,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of AssociatedExternalAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssociatedExternalAuthModelImplCopyWith<_$AssociatedExternalAuthModelImpl>
  get copyWith => __$$AssociatedExternalAuthModelImplCopyWithImpl<
    _$AssociatedExternalAuthModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssociatedExternalAuthModelImplToJson(this);
  }
}

abstract class _AssociatedExternalAuthModel
    implements AssociatedExternalAuthModel {
  factory _AssociatedExternalAuthModel({
    @JsonKey(name: 'Email', includeIfNull: false) final String? email,
    @JsonKey(name: 'ExternalIdentifier', includeIfNull: false)
    final String? externalIdentifier,
    @JsonKey(name: 'AuthMethodName', includeIfNull: false)
    final String? authMethodName,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$AssociatedExternalAuthModelImpl;

  factory _AssociatedExternalAuthModel.fromJson(Map<String, dynamic> json) =
      _$AssociatedExternalAuthModelImpl.fromJson;

  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email;
  @override
  @JsonKey(name: 'ExternalIdentifier', includeIfNull: false)
  String? get externalIdentifier;
  @override
  @JsonKey(name: 'AuthMethodName', includeIfNull: false)
  String? get authMethodName;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of AssociatedExternalAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssociatedExternalAuthModelImplCopyWith<_$AssociatedExternalAuthModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
