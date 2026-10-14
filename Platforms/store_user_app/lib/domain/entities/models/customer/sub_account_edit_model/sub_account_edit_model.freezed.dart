// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_account_edit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SubAccountEditModel _$SubAccountEditModelFromJson(Map<String, dynamic> json) {
  return _SubAccountEditModel.fromJson(json);
}

/// @nodoc
mixin _$SubAccountEditModel {
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'FirstName', includeIfNull: false)
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'LastName', includeIfNull: false)
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Active', includeIfNull: false)
  bool? get active => throw _privateConstructorUsedError;
  @JsonKey(name: 'Password', includeIfNull: false)
  String? get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this SubAccountEditModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubAccountEditModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubAccountEditModelCopyWith<SubAccountEditModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubAccountEditModelCopyWith<$Res> {
  factory $SubAccountEditModelCopyWith(
    SubAccountEditModel value,
    $Res Function(SubAccountEditModel) then,
  ) = _$SubAccountEditModelCopyWithImpl<$Res, SubAccountEditModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'FirstName', includeIfNull: false) String? firstName,
    @JsonKey(name: 'LastName', includeIfNull: false) String? lastName,
    @JsonKey(name: 'Active', includeIfNull: false) bool? active,
    @JsonKey(name: 'Password', includeIfNull: false) String? password,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$SubAccountEditModelCopyWithImpl<$Res, $Val extends SubAccountEditModel>
    implements $SubAccountEditModelCopyWith<$Res> {
  _$SubAccountEditModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubAccountEditModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? active = freezed,
    Object? password = freezed,
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
            firstName:
                freezed == firstName
                    ? _value.firstName
                    : firstName // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastName:
                freezed == lastName
                    ? _value.lastName
                    : lastName // ignore: cast_nullable_to_non_nullable
                        as String?,
            active:
                freezed == active
                    ? _value.active
                    : active // ignore: cast_nullable_to_non_nullable
                        as bool?,
            password:
                freezed == password
                    ? _value.password
                    : password // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SubAccountEditModelImplCopyWith<$Res>
    implements $SubAccountEditModelCopyWith<$Res> {
  factory _$$SubAccountEditModelImplCopyWith(
    _$SubAccountEditModelImpl value,
    $Res Function(_$SubAccountEditModelImpl) then,
  ) = __$$SubAccountEditModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Email', includeIfNull: false) String? email,
    @JsonKey(name: 'FirstName', includeIfNull: false) String? firstName,
    @JsonKey(name: 'LastName', includeIfNull: false) String? lastName,
    @JsonKey(name: 'Active', includeIfNull: false) bool? active,
    @JsonKey(name: 'Password', includeIfNull: false) String? password,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$SubAccountEditModelImplCopyWithImpl<$Res>
    extends _$SubAccountEditModelCopyWithImpl<$Res, _$SubAccountEditModelImpl>
    implements _$$SubAccountEditModelImplCopyWith<$Res> {
  __$$SubAccountEditModelImplCopyWithImpl(
    _$SubAccountEditModelImpl _value,
    $Res Function(_$SubAccountEditModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubAccountEditModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? active = freezed,
    Object? password = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$SubAccountEditModelImpl(
        email:
            freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String?,
        firstName:
            freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastName:
            freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                    as String?,
        active:
            freezed == active
                ? _value.active
                : active // ignore: cast_nullable_to_non_nullable
                    as bool?,
        password:
            freezed == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
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
class _$SubAccountEditModelImpl implements _SubAccountEditModel {
  _$SubAccountEditModelImpl({
    @JsonKey(name: 'Email', includeIfNull: false) this.email,
    @JsonKey(name: 'FirstName', includeIfNull: false) this.firstName,
    @JsonKey(name: 'LastName', includeIfNull: false) this.lastName,
    @JsonKey(name: 'Active', includeIfNull: false) this.active = false,
    @JsonKey(name: 'Password', includeIfNull: false) this.password,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$SubAccountEditModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubAccountEditModelImplFromJson(json);

  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  final String? email;
  @override
  @JsonKey(name: 'FirstName', includeIfNull: false)
  final String? firstName;
  @override
  @JsonKey(name: 'LastName', includeIfNull: false)
  final String? lastName;
  @override
  @JsonKey(name: 'Active', includeIfNull: false)
  final bool? active;
  @override
  @JsonKey(name: 'Password', includeIfNull: false)
  final String? password;
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
    return 'SubAccountEditModel(email: $email, firstName: $firstName, lastName: $lastName, active: $active, password: $password, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubAccountEditModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.password, password) ||
                other.password == password) &&
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
    firstName,
    lastName,
    active,
    password,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of SubAccountEditModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubAccountEditModelImplCopyWith<_$SubAccountEditModelImpl> get copyWith =>
      __$$SubAccountEditModelImplCopyWithImpl<_$SubAccountEditModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubAccountEditModelImplToJson(this);
  }
}

abstract class _SubAccountEditModel implements SubAccountEditModel {
  factory _SubAccountEditModel({
    @JsonKey(name: 'Email', includeIfNull: false) final String? email,
    @JsonKey(name: 'FirstName', includeIfNull: false) final String? firstName,
    @JsonKey(name: 'LastName', includeIfNull: false) final String? lastName,
    @JsonKey(name: 'Active', includeIfNull: false) final bool? active,
    @JsonKey(name: 'Password', includeIfNull: false) final String? password,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$SubAccountEditModelImpl;

  factory _SubAccountEditModel.fromJson(Map<String, dynamic> json) =
      _$SubAccountEditModelImpl.fromJson;

  @override
  @JsonKey(name: 'Email', includeIfNull: false)
  String? get email;
  @override
  @JsonKey(name: 'FirstName', includeIfNull: false)
  String? get firstName;
  @override
  @JsonKey(name: 'LastName', includeIfNull: false)
  String? get lastName;
  @override
  @JsonKey(name: 'Active', includeIfNull: false)
  bool? get active;
  @override
  @JsonKey(name: 'Password', includeIfNull: false)
  String? get password;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of SubAccountEditModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubAccountEditModelImplCopyWith<_$SubAccountEditModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
