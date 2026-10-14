// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipping_method_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShippingMethodModel _$ShippingMethodModelFromJson(Map<String, dynamic> json) {
  return _ShippingMethodModel.fromJson(json);
}

/// @nodoc
mixin _$ShippingMethodModel {
  @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
  String? get shippingRateProviderSystemName =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'Fee', includeIfNull: false)
  String? get fee => throw _privateConstructorUsedError;
  @JsonKey(name: 'Selected', includeIfNull: false)
  bool? get selected => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingOption', includeIfNull: false)
  ShippingOption? get shippingOption => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ShippingMethodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShippingMethodModelCopyWith<ShippingMethodModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShippingMethodModelCopyWith<$Res> {
  factory $ShippingMethodModelCopyWith(
    ShippingMethodModel value,
    $Res Function(ShippingMethodModel) then,
  ) = _$ShippingMethodModelCopyWithImpl<$Res, ShippingMethodModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
    String? shippingRateProviderSystemName,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'Fee', includeIfNull: false) String? fee,
    @JsonKey(name: 'Selected', includeIfNull: false) bool? selected,
    @JsonKey(name: 'ShippingOption', includeIfNull: false)
    ShippingOption? shippingOption,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $ShippingOptionCopyWith<$Res>? get shippingOption;
}

/// @nodoc
class _$ShippingMethodModelCopyWithImpl<$Res, $Val extends ShippingMethodModel>
    implements $ShippingMethodModelCopyWith<$Res> {
  _$ShippingMethodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shippingRateProviderSystemName = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? fee = freezed,
    Object? selected = freezed,
    Object? shippingOption = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            shippingRateProviderSystemName:
                freezed == shippingRateProviderSystemName
                    ? _value.shippingRateProviderSystemName
                    : shippingRateProviderSystemName // ignore: cast_nullable_to_non_nullable
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
            shippingOption:
                freezed == shippingOption
                    ? _value.shippingOption
                    : shippingOption // ignore: cast_nullable_to_non_nullable
                        as ShippingOption?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShippingOptionCopyWith<$Res>? get shippingOption {
    if (_value.shippingOption == null) {
      return null;
    }

    return $ShippingOptionCopyWith<$Res>(_value.shippingOption!, (value) {
      return _then(_value.copyWith(shippingOption: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShippingMethodModelImplCopyWith<$Res>
    implements $ShippingMethodModelCopyWith<$Res> {
  factory _$$ShippingMethodModelImplCopyWith(
    _$ShippingMethodModelImpl value,
    $Res Function(_$ShippingMethodModelImpl) then,
  ) = __$$ShippingMethodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
    String? shippingRateProviderSystemName,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'Fee', includeIfNull: false) String? fee,
    @JsonKey(name: 'Selected', includeIfNull: false) bool? selected,
    @JsonKey(name: 'ShippingOption', includeIfNull: false)
    ShippingOption? shippingOption,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $ShippingOptionCopyWith<$Res>? get shippingOption;
}

/// @nodoc
class __$$ShippingMethodModelImplCopyWithImpl<$Res>
    extends _$ShippingMethodModelCopyWithImpl<$Res, _$ShippingMethodModelImpl>
    implements _$$ShippingMethodModelImplCopyWith<$Res> {
  __$$ShippingMethodModelImplCopyWithImpl(
    _$ShippingMethodModelImpl _value,
    $Res Function(_$ShippingMethodModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shippingRateProviderSystemName = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? fee = freezed,
    Object? selected = freezed,
    Object? shippingOption = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ShippingMethodModelImpl(
        shippingRateProviderSystemName:
            freezed == shippingRateProviderSystemName
                ? _value.shippingRateProviderSystemName
                : shippingRateProviderSystemName // ignore: cast_nullable_to_non_nullable
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
        shippingOption:
            freezed == shippingOption
                ? _value.shippingOption
                : shippingOption // ignore: cast_nullable_to_non_nullable
                    as ShippingOption?,
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
class _$ShippingMethodModelImpl implements _ShippingMethodModel {
  _$ShippingMethodModelImpl({
    @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
    this.shippingRateProviderSystemName,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'Fee', includeIfNull: false) this.fee,
    @JsonKey(name: 'Selected', includeIfNull: false) this.selected = false,
    @JsonKey(name: 'ShippingOption', includeIfNull: false) this.shippingOption,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ShippingMethodModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShippingMethodModelImplFromJson(json);

  @override
  @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
  final String? shippingRateProviderSystemName;
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
  @JsonKey(name: 'ShippingOption', includeIfNull: false)
  final ShippingOption? shippingOption;
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
    return 'ShippingMethodModel(shippingRateProviderSystemName: $shippingRateProviderSystemName, name: $name, description: $description, fee: $fee, selected: $selected, shippingOption: $shippingOption, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShippingMethodModelImpl &&
            (identical(
                  other.shippingRateProviderSystemName,
                  shippingRateProviderSystemName,
                ) ||
                other.shippingRateProviderSystemName ==
                    shippingRateProviderSystemName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.fee, fee) || other.fee == fee) &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.shippingOption, shippingOption) ||
                other.shippingOption == shippingOption) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    shippingRateProviderSystemName,
    name,
    description,
    fee,
    selected,
    shippingOption,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShippingMethodModelImplCopyWith<_$ShippingMethodModelImpl> get copyWith =>
      __$$ShippingMethodModelImplCopyWithImpl<_$ShippingMethodModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShippingMethodModelImplToJson(this);
  }
}

abstract class _ShippingMethodModel implements ShippingMethodModel {
  factory _ShippingMethodModel({
    @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
    final String? shippingRateProviderSystemName,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'Fee', includeIfNull: false) final String? fee,
    @JsonKey(name: 'Selected', includeIfNull: false) final bool? selected,
    @JsonKey(name: 'ShippingOption', includeIfNull: false)
    final ShippingOption? shippingOption,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ShippingMethodModelImpl;

  factory _ShippingMethodModel.fromJson(Map<String, dynamic> json) =
      _$ShippingMethodModelImpl.fromJson;

  @override
  @JsonKey(name: 'ShippingRateProviderSystemName', includeIfNull: false)
  String? get shippingRateProviderSystemName;
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
  @JsonKey(name: 'ShippingOption', includeIfNull: false)
  ShippingOption? get shippingOption;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShippingMethodModelImplCopyWith<_$ShippingMethodModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
