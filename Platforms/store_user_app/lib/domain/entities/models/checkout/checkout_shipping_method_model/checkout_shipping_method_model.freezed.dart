// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_shipping_method_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutShippingMethodModel _$CheckoutShippingMethodModelFromJson(
  Map<String, dynamic> json,
) {
  return _CheckoutShippingMethodModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutShippingMethodModel {
  @JsonKey(name: 'ShippingMethods', includeIfNull: false)
  List<ShippingMethodModel>? get shippingMethods =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippingOption', includeIfNull: false)
  String? get shippingOption => throw _privateConstructorUsedError;
  @JsonKey(name: 'Data', includeIfNull: false)
  Map<String, String>? get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CheckoutShippingMethodModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutShippingMethodModelCopyWith<CheckoutShippingMethodModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutShippingMethodModelCopyWith<$Res> {
  factory $CheckoutShippingMethodModelCopyWith(
    CheckoutShippingMethodModel value,
    $Res Function(CheckoutShippingMethodModel) then,
  ) =
      _$CheckoutShippingMethodModelCopyWithImpl<
        $Res,
        CheckoutShippingMethodModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'ShippingMethods', includeIfNull: false)
    List<ShippingMethodModel>? shippingMethods,
    @JsonKey(name: 'ShippingOption', includeIfNull: false)
    String? shippingOption,
    @JsonKey(name: 'Data', includeIfNull: false) Map<String, String>? data,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CheckoutShippingMethodModelCopyWithImpl<
  $Res,
  $Val extends CheckoutShippingMethodModel
>
    implements $CheckoutShippingMethodModelCopyWith<$Res> {
  _$CheckoutShippingMethodModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shippingMethods = freezed,
    Object? shippingOption = freezed,
    Object? data = freezed,
    Object? warnings = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            shippingMethods:
                freezed == shippingMethods
                    ? _value.shippingMethods
                    : shippingMethods // ignore: cast_nullable_to_non_nullable
                        as List<ShippingMethodModel>?,
            shippingOption:
                freezed == shippingOption
                    ? _value.shippingOption
                    : shippingOption // ignore: cast_nullable_to_non_nullable
                        as String?,
            data:
                freezed == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as Map<String, String>?,
            warnings:
                freezed == warnings
                    ? _value.warnings
                    : warnings // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
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
abstract class _$$CheckoutShippingMethodModelImplCopyWith<$Res>
    implements $CheckoutShippingMethodModelCopyWith<$Res> {
  factory _$$CheckoutShippingMethodModelImplCopyWith(
    _$CheckoutShippingMethodModelImpl value,
    $Res Function(_$CheckoutShippingMethodModelImpl) then,
  ) = __$$CheckoutShippingMethodModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ShippingMethods', includeIfNull: false)
    List<ShippingMethodModel>? shippingMethods,
    @JsonKey(name: 'ShippingOption', includeIfNull: false)
    String? shippingOption,
    @JsonKey(name: 'Data', includeIfNull: false) Map<String, String>? data,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CheckoutShippingMethodModelImplCopyWithImpl<$Res>
    extends
        _$CheckoutShippingMethodModelCopyWithImpl<
          $Res,
          _$CheckoutShippingMethodModelImpl
        >
    implements _$$CheckoutShippingMethodModelImplCopyWith<$Res> {
  __$$CheckoutShippingMethodModelImplCopyWithImpl(
    _$CheckoutShippingMethodModelImpl _value,
    $Res Function(_$CheckoutShippingMethodModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shippingMethods = freezed,
    Object? shippingOption = freezed,
    Object? data = freezed,
    Object? warnings = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CheckoutShippingMethodModelImpl(
        shippingMethods:
            freezed == shippingMethods
                ? _value._shippingMethods
                : shippingMethods // ignore: cast_nullable_to_non_nullable
                    as List<ShippingMethodModel>?,
        shippingOption:
            freezed == shippingOption
                ? _value.shippingOption
                : shippingOption // ignore: cast_nullable_to_non_nullable
                    as String?,
        data:
            freezed == data
                ? _value._data
                : data // ignore: cast_nullable_to_non_nullable
                    as Map<String, String>?,
        warnings:
            freezed == warnings
                ? _value._warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
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
class _$CheckoutShippingMethodModelImpl
    implements _CheckoutShippingMethodModel {
  _$CheckoutShippingMethodModelImpl({
    @JsonKey(name: 'ShippingMethods', includeIfNull: false)
    final List<ShippingMethodModel>? shippingMethods = const [],
    @JsonKey(name: 'ShippingOption', includeIfNull: false) this.shippingOption,
    @JsonKey(name: 'Data', includeIfNull: false)
    final Map<String, String>? data = const {},
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _shippingMethods = shippingMethods,
       _data = data,
       _warnings = warnings,
       _userFields = userFields;

  factory _$CheckoutShippingMethodModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CheckoutShippingMethodModelImplFromJson(json);

  final List<ShippingMethodModel>? _shippingMethods;
  @override
  @JsonKey(name: 'ShippingMethods', includeIfNull: false)
  List<ShippingMethodModel>? get shippingMethods {
    final value = _shippingMethods;
    if (value == null) return null;
    if (_shippingMethods is EqualUnmodifiableListView) return _shippingMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'ShippingOption', includeIfNull: false)
  final String? shippingOption;
  final Map<String, String>? _data;
  @override
  @JsonKey(name: 'Data', includeIfNull: false)
  Map<String, String>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _warnings;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings {
    final value = _warnings;
    if (value == null) return null;
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'CheckoutShippingMethodModel(shippingMethods: $shippingMethods, shippingOption: $shippingOption, data: $data, warnings: $warnings, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutShippingMethodModelImpl &&
            const DeepCollectionEquality().equals(
              other._shippingMethods,
              _shippingMethods,
            ) &&
            (identical(other.shippingOption, shippingOption) ||
                other.shippingOption == shippingOption) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_shippingMethods),
    shippingOption,
    const DeepCollectionEquality().hash(_data),
    const DeepCollectionEquality().hash(_warnings),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CheckoutShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutShippingMethodModelImplCopyWith<_$CheckoutShippingMethodModelImpl>
  get copyWith => __$$CheckoutShippingMethodModelImplCopyWithImpl<
    _$CheckoutShippingMethodModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutShippingMethodModelImplToJson(this);
  }
}

abstract class _CheckoutShippingMethodModel
    implements CheckoutShippingMethodModel {
  factory _CheckoutShippingMethodModel({
    @JsonKey(name: 'ShippingMethods', includeIfNull: false)
    final List<ShippingMethodModel>? shippingMethods,
    @JsonKey(name: 'ShippingOption', includeIfNull: false)
    final String? shippingOption,
    @JsonKey(name: 'Data', includeIfNull: false)
    final Map<String, String>? data,
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CheckoutShippingMethodModelImpl;

  factory _CheckoutShippingMethodModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutShippingMethodModelImpl.fromJson;

  @override
  @JsonKey(name: 'ShippingMethods', includeIfNull: false)
  List<ShippingMethodModel>? get shippingMethods;
  @override
  @JsonKey(name: 'ShippingOption', includeIfNull: false)
  String? get shippingOption;
  @override
  @JsonKey(name: 'Data', includeIfNull: false)
  Map<String, String>? get data;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CheckoutShippingMethodModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutShippingMethodModelImplCopyWith<_$CheckoutShippingMethodModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
