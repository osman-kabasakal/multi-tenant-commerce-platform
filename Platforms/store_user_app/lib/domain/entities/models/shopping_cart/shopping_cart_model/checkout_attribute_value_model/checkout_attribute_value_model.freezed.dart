// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_attribute_value_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutAttributeValueModel _$CheckoutAttributeValueModelFromJson(
  Map<String, dynamic> json,
) {
  return _CheckoutAttributeValueModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutAttributeValueModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  String? get colorSquaresRgb => throw _privateConstructorUsedError;
  @JsonKey(name: 'PriceAdjustment', includeIfNull: false)
  String? get priceAdjustment => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsPreSelected', includeIfNull: false)
  bool? get isPreSelected => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CheckoutAttributeValueModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutAttributeValueModelCopyWith<CheckoutAttributeValueModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutAttributeValueModelCopyWith<$Res> {
  factory $CheckoutAttributeValueModelCopyWith(
    CheckoutAttributeValueModel value,
    $Res Function(CheckoutAttributeValueModel) then,
  ) =
      _$CheckoutAttributeValueModelCopyWithImpl<
        $Res,
        CheckoutAttributeValueModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    String? colorSquaresRgb,
    @JsonKey(name: 'PriceAdjustment', includeIfNull: false)
    String? priceAdjustment,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false) bool? isPreSelected,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CheckoutAttributeValueModelCopyWithImpl<
  $Res,
  $Val extends CheckoutAttributeValueModel
>
    implements $CheckoutAttributeValueModelCopyWith<$Res> {
  _$CheckoutAttributeValueModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? colorSquaresRgb = freezed,
    Object? priceAdjustment = freezed,
    Object? isPreSelected = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            colorSquaresRgb:
                freezed == colorSquaresRgb
                    ? _value.colorSquaresRgb
                    : colorSquaresRgb // ignore: cast_nullable_to_non_nullable
                        as String?,
            priceAdjustment:
                freezed == priceAdjustment
                    ? _value.priceAdjustment
                    : priceAdjustment // ignore: cast_nullable_to_non_nullable
                        as String?,
            isPreSelected:
                freezed == isPreSelected
                    ? _value.isPreSelected
                    : isPreSelected // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
abstract class _$$CheckoutAttributeValueModelImplCopyWith<$Res>
    implements $CheckoutAttributeValueModelCopyWith<$Res> {
  factory _$$CheckoutAttributeValueModelImplCopyWith(
    _$CheckoutAttributeValueModelImpl value,
    $Res Function(_$CheckoutAttributeValueModelImpl) then,
  ) = __$$CheckoutAttributeValueModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    String? colorSquaresRgb,
    @JsonKey(name: 'PriceAdjustment', includeIfNull: false)
    String? priceAdjustment,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false) bool? isPreSelected,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CheckoutAttributeValueModelImplCopyWithImpl<$Res>
    extends
        _$CheckoutAttributeValueModelCopyWithImpl<
          $Res,
          _$CheckoutAttributeValueModelImpl
        >
    implements _$$CheckoutAttributeValueModelImplCopyWith<$Res> {
  __$$CheckoutAttributeValueModelImplCopyWithImpl(
    _$CheckoutAttributeValueModelImpl _value,
    $Res Function(_$CheckoutAttributeValueModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? colorSquaresRgb = freezed,
    Object? priceAdjustment = freezed,
    Object? isPreSelected = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CheckoutAttributeValueModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        colorSquaresRgb:
            freezed == colorSquaresRgb
                ? _value.colorSquaresRgb
                : colorSquaresRgb // ignore: cast_nullable_to_non_nullable
                    as String?,
        priceAdjustment:
            freezed == priceAdjustment
                ? _value.priceAdjustment
                : priceAdjustment // ignore: cast_nullable_to_non_nullable
                    as String?,
        isPreSelected:
            freezed == isPreSelected
                ? _value.isPreSelected
                : isPreSelected // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$CheckoutAttributeValueModelImpl
    implements _CheckoutAttributeValueModel {
  _$CheckoutAttributeValueModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    this.colorSquaresRgb,
    @JsonKey(name: 'PriceAdjustment', includeIfNull: false)
    this.priceAdjustment,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false)
    this.isPreSelected = false,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$CheckoutAttributeValueModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CheckoutAttributeValueModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  final String? colorSquaresRgb;
  @override
  @JsonKey(name: 'PriceAdjustment', includeIfNull: false)
  final String? priceAdjustment;
  @override
  @JsonKey(name: 'IsPreSelected', includeIfNull: false)
  final bool? isPreSelected;
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
    return 'CheckoutAttributeValueModel(name: $name, colorSquaresRgb: $colorSquaresRgb, priceAdjustment: $priceAdjustment, isPreSelected: $isPreSelected, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutAttributeValueModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.colorSquaresRgb, colorSquaresRgb) ||
                other.colorSquaresRgb == colorSquaresRgb) &&
            (identical(other.priceAdjustment, priceAdjustment) ||
                other.priceAdjustment == priceAdjustment) &&
            (identical(other.isPreSelected, isPreSelected) ||
                other.isPreSelected == isPreSelected) &&
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
    name,
    colorSquaresRgb,
    priceAdjustment,
    isPreSelected,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CheckoutAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutAttributeValueModelImplCopyWith<_$CheckoutAttributeValueModelImpl>
  get copyWith => __$$CheckoutAttributeValueModelImplCopyWithImpl<
    _$CheckoutAttributeValueModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutAttributeValueModelImplToJson(this);
  }
}

abstract class _CheckoutAttributeValueModel
    implements CheckoutAttributeValueModel {
  factory _CheckoutAttributeValueModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    final String? colorSquaresRgb,
    @JsonKey(name: 'PriceAdjustment', includeIfNull: false)
    final String? priceAdjustment,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false)
    final bool? isPreSelected,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CheckoutAttributeValueModelImpl;

  factory _CheckoutAttributeValueModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutAttributeValueModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  String? get colorSquaresRgb;
  @override
  @JsonKey(name: 'PriceAdjustment', includeIfNull: false)
  String? get priceAdjustment;
  @override
  @JsonKey(name: 'IsPreSelected', includeIfNull: false)
  bool? get isPreSelected;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CheckoutAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutAttributeValueModelImplCopyWith<_$CheckoutAttributeValueModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
