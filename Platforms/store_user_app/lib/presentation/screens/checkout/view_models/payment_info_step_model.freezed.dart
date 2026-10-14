// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_info_step_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentInfoStepModel _$PaymentInfoStepModelFromJson(Map<String, dynamic> json) {
  return _PaymentInfoStepModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentInfoStepModel {
  @JsonKey(name: 'PaymentUrl', includeIfNull: false)
  String? get paymentUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'SystemName', includeIfNull: false)
  String? get systemName => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this PaymentInfoStepModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentInfoStepModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentInfoStepModelCopyWith<PaymentInfoStepModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentInfoStepModelCopyWith<$Res> {
  factory $PaymentInfoStepModelCopyWith(
    PaymentInfoStepModel value,
    $Res Function(PaymentInfoStepModel) then,
  ) = _$PaymentInfoStepModelCopyWithImpl<$Res, PaymentInfoStepModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'PaymentUrl', includeIfNull: false) String? paymentUrl,
    @JsonKey(name: 'SystemName', includeIfNull: false) String? systemName,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$PaymentInfoStepModelCopyWithImpl<
  $Res,
  $Val extends PaymentInfoStepModel
>
    implements $PaymentInfoStepModelCopyWith<$Res> {
  _$PaymentInfoStepModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentInfoStepModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentUrl = freezed,
    Object? systemName = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            paymentUrl:
                freezed == paymentUrl
                    ? _value.paymentUrl
                    : paymentUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            systemName:
                freezed == systemName
                    ? _value.systemName
                    : systemName // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PaymentInfoStepModelImplCopyWith<$Res>
    implements $PaymentInfoStepModelCopyWith<$Res> {
  factory _$$PaymentInfoStepModelImplCopyWith(
    _$PaymentInfoStepModelImpl value,
    $Res Function(_$PaymentInfoStepModelImpl) then,
  ) = __$$PaymentInfoStepModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PaymentUrl', includeIfNull: false) String? paymentUrl,
    @JsonKey(name: 'SystemName', includeIfNull: false) String? systemName,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$PaymentInfoStepModelImplCopyWithImpl<$Res>
    extends _$PaymentInfoStepModelCopyWithImpl<$Res, _$PaymentInfoStepModelImpl>
    implements _$$PaymentInfoStepModelImplCopyWith<$Res> {
  __$$PaymentInfoStepModelImplCopyWithImpl(
    _$PaymentInfoStepModelImpl _value,
    $Res Function(_$PaymentInfoStepModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentInfoStepModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentUrl = freezed,
    Object? systemName = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$PaymentInfoStepModelImpl(
        paymentUrl:
            freezed == paymentUrl
                ? _value.paymentUrl
                : paymentUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        systemName:
            freezed == systemName
                ? _value.systemName
                : systemName // ignore: cast_nullable_to_non_nullable
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
class _$PaymentInfoStepModelImpl implements _PaymentInfoStepModel {
  const _$PaymentInfoStepModelImpl({
    @JsonKey(name: 'PaymentUrl', includeIfNull: false) this.paymentUrl,
    @JsonKey(name: 'SystemName', includeIfNull: false) this.systemName,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$PaymentInfoStepModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentInfoStepModelImplFromJson(json);

  @override
  @JsonKey(name: 'PaymentUrl', includeIfNull: false)
  final String? paymentUrl;
  @override
  @JsonKey(name: 'SystemName', includeIfNull: false)
  final String? systemName;
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
    return 'PaymentInfoStepModel(paymentUrl: $paymentUrl, systemName: $systemName, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentInfoStepModelImpl &&
            (identical(other.paymentUrl, paymentUrl) ||
                other.paymentUrl == paymentUrl) &&
            (identical(other.systemName, systemName) ||
                other.systemName == systemName) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    paymentUrl,
    systemName,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of PaymentInfoStepModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentInfoStepModelImplCopyWith<_$PaymentInfoStepModelImpl>
  get copyWith =>
      __$$PaymentInfoStepModelImplCopyWithImpl<_$PaymentInfoStepModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentInfoStepModelImplToJson(this);
  }
}

abstract class _PaymentInfoStepModel implements PaymentInfoStepModel {
  const factory _PaymentInfoStepModel({
    @JsonKey(name: 'PaymentUrl', includeIfNull: false) final String? paymentUrl,
    @JsonKey(name: 'SystemName', includeIfNull: false) final String? systemName,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$PaymentInfoStepModelImpl;

  factory _PaymentInfoStepModel.fromJson(Map<String, dynamic> json) =
      _$PaymentInfoStepModelImpl.fromJson;

  @override
  @JsonKey(name: 'PaymentUrl', includeIfNull: false)
  String? get paymentUrl;
  @override
  @JsonKey(name: 'SystemName', includeIfNull: false)
  String? get systemName;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of PaymentInfoStepModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentInfoStepModelImplCopyWith<_$PaymentInfoStepModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
