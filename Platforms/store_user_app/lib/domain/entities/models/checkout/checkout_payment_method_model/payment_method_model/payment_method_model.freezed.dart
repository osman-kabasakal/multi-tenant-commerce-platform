// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) {
  return _PaymentMethodModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethodModel {
  @JsonKey(name: 'PaymentMethodSystemName', includeIfNull: false)
  String? get paymentMethodSystemName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'Fee', includeIfNull: false)
  String? get fee => throw _privateConstructorUsedError;
  @JsonKey(name: 'Selected', includeIfNull: false)
  bool? get selected => throw _privateConstructorUsedError;
  @JsonKey(name: 'LogoUrl', includeIfNull: false)
  String? get logoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this PaymentMethodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentMethodModelCopyWith<PaymentMethodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodModelCopyWith<$Res> {
  factory $PaymentMethodModelCopyWith(
    PaymentMethodModel value,
    $Res Function(PaymentMethodModel) then,
  ) = _$PaymentMethodModelCopyWithImpl<$Res, PaymentMethodModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'PaymentMethodSystemName', includeIfNull: false)
    String? paymentMethodSystemName,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'Fee', includeIfNull: false) String? fee,
    @JsonKey(name: 'Selected', includeIfNull: false) bool? selected,
    @JsonKey(name: 'LogoUrl', includeIfNull: false) String? logoUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$PaymentMethodModelCopyWithImpl<$Res, $Val extends PaymentMethodModel>
    implements $PaymentMethodModelCopyWith<$Res> {
  _$PaymentMethodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethodSystemName = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? fee = freezed,
    Object? selected = freezed,
    Object? logoUrl = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            paymentMethodSystemName:
                freezed == paymentMethodSystemName
                    ? _value.paymentMethodSystemName
                    : paymentMethodSystemName // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            fee:
                freezed == fee
                    ? _value.fee
                    : fee // ignore: cast_nullable_to_non_nullable
                        as String?,
            selected:
                freezed == selected
                    ? _value.selected
                    : selected // ignore: cast_nullable_to_non_nullable
                        as bool?,
            logoUrl:
                freezed == logoUrl
                    ? _value.logoUrl
                    : logoUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PaymentMethodModelImplCopyWith<$Res>
    implements $PaymentMethodModelCopyWith<$Res> {
  factory _$$PaymentMethodModelImplCopyWith(
    _$PaymentMethodModelImpl value,
    $Res Function(_$PaymentMethodModelImpl) then,
  ) = __$$PaymentMethodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PaymentMethodSystemName', includeIfNull: false)
    String? paymentMethodSystemName,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'Fee', includeIfNull: false) String? fee,
    @JsonKey(name: 'Selected', includeIfNull: false) bool? selected,
    @JsonKey(name: 'LogoUrl', includeIfNull: false) String? logoUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$PaymentMethodModelImplCopyWithImpl<$Res>
    extends _$PaymentMethodModelCopyWithImpl<$Res, _$PaymentMethodModelImpl>
    implements _$$PaymentMethodModelImplCopyWith<$Res> {
  __$$PaymentMethodModelImplCopyWithImpl(
    _$PaymentMethodModelImpl _value,
    $Res Function(_$PaymentMethodModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethodSystemName = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? fee = freezed,
    Object? selected = freezed,
    Object? logoUrl = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$PaymentMethodModelImpl(
        paymentMethodSystemName:
            freezed == paymentMethodSystemName
                ? _value.paymentMethodSystemName
                : paymentMethodSystemName // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        fee:
            freezed == fee
                ? _value.fee
                : fee // ignore: cast_nullable_to_non_nullable
                    as String?,
        selected:
            freezed == selected
                ? _value.selected
                : selected // ignore: cast_nullable_to_non_nullable
                    as bool?,
        logoUrl:
            freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
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
class _$PaymentMethodModelImpl implements _PaymentMethodModel {
  _$PaymentMethodModelImpl({
    @JsonKey(name: 'PaymentMethodSystemName', includeIfNull: false)
    this.paymentMethodSystemName,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'Fee', includeIfNull: false) this.fee,
    @JsonKey(name: 'Selected', includeIfNull: false) this.selected = false,
    @JsonKey(name: 'LogoUrl', includeIfNull: false) this.logoUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$PaymentMethodModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodModelImplFromJson(json);

  @override
  @JsonKey(name: 'PaymentMethodSystemName', includeIfNull: false)
  final String? paymentMethodSystemName;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'Fee', includeIfNull: false)
  final String? fee;
  @override
  @JsonKey(name: 'Selected', includeIfNull: false)
  final bool? selected;
  @override
  @JsonKey(name: 'LogoUrl', includeIfNull: false)
  final String? logoUrl;
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
    return 'PaymentMethodModel(paymentMethodSystemName: $paymentMethodSystemName, name: $name, description: $description, fee: $fee, selected: $selected, logoUrl: $logoUrl, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodModelImpl &&
            (identical(
                  other.paymentMethodSystemName,
                  paymentMethodSystemName,
                ) ||
                other.paymentMethodSystemName == paymentMethodSystemName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.fee, fee) || other.fee == fee) &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    paymentMethodSystemName,
    name,
    description,
    fee,
    selected,
    logoUrl,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of PaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodModelImplCopyWith<_$PaymentMethodModelImpl> get copyWith =>
      __$$PaymentMethodModelImplCopyWithImpl<_$PaymentMethodModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodModelImplToJson(this);
  }
}

abstract class _PaymentMethodModel implements PaymentMethodModel {
  factory _PaymentMethodModel({
    @JsonKey(name: 'PaymentMethodSystemName', includeIfNull: false)
    final String? paymentMethodSystemName,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'Fee', includeIfNull: false) final String? fee,
    @JsonKey(name: 'Selected', includeIfNull: false) final bool? selected,
    @JsonKey(name: 'LogoUrl', includeIfNull: false) final String? logoUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$PaymentMethodModelImpl;

  factory _PaymentMethodModel.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodModelImpl.fromJson;

  @override
  @JsonKey(name: 'PaymentMethodSystemName', includeIfNull: false)
  String? get paymentMethodSystemName;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'Fee', includeIfNull: false)
  String? get fee;
  @override
  @JsonKey(name: 'Selected', includeIfNull: false)
  bool? get selected;
  @override
  @JsonKey(name: 'LogoUrl', includeIfNull: false)
  String? get logoUrl;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of PaymentMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentMethodModelImplCopyWith<_$PaymentMethodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
