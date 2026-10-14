// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_attribute_selected_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutAttributeSelectedModel _$CheckoutAttributeSelectedModelFromJson(
  Map<String, dynamic> json,
) {
  return _CheckoutAttributeSelectedModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutAttributeSelectedModel {
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes =>
      throw _privateConstructorUsedError;

  /// Serializes this CheckoutAttributeSelectedModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutAttributeSelectedModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutAttributeSelectedModelCopyWith<CheckoutAttributeSelectedModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutAttributeSelectedModelCopyWith<$Res> {
  factory $CheckoutAttributeSelectedModelCopyWith(
    CheckoutAttributeSelectedModel value,
    $Res Function(CheckoutAttributeSelectedModel) then,
  ) =
      _$CheckoutAttributeSelectedModelCopyWithImpl<
        $Res,
        CheckoutAttributeSelectedModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttributeModel>? attributes,
  });
}

/// @nodoc
class _$CheckoutAttributeSelectedModelCopyWithImpl<
  $Res,
  $Val extends CheckoutAttributeSelectedModel
>
    implements $CheckoutAttributeSelectedModelCopyWith<$Res> {
  _$CheckoutAttributeSelectedModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutAttributeSelectedModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? attributes = freezed}) {
    return _then(
      _value.copyWith(
            attributes:
                freezed == attributes
                    ? _value.attributes
                    : attributes // ignore: cast_nullable_to_non_nullable
                        as List<CustomAttributeModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CheckoutAttributeSelectedModelImplCopyWith<$Res>
    implements $CheckoutAttributeSelectedModelCopyWith<$Res> {
  factory _$$CheckoutAttributeSelectedModelImplCopyWith(
    _$CheckoutAttributeSelectedModelImpl value,
    $Res Function(_$CheckoutAttributeSelectedModelImpl) then,
  ) = __$$CheckoutAttributeSelectedModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttributeModel>? attributes,
  });
}

/// @nodoc
class __$$CheckoutAttributeSelectedModelImplCopyWithImpl<$Res>
    extends
        _$CheckoutAttributeSelectedModelCopyWithImpl<
          $Res,
          _$CheckoutAttributeSelectedModelImpl
        >
    implements _$$CheckoutAttributeSelectedModelImplCopyWith<$Res> {
  __$$CheckoutAttributeSelectedModelImplCopyWithImpl(
    _$CheckoutAttributeSelectedModelImpl _value,
    $Res Function(_$CheckoutAttributeSelectedModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutAttributeSelectedModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? attributes = freezed}) {
    return _then(
      _$CheckoutAttributeSelectedModelImpl(
        attributes:
            freezed == attributes
                ? _value._attributes
                : attributes // ignore: cast_nullable_to_non_nullable
                    as List<CustomAttributeModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckoutAttributeSelectedModelImpl
    implements _CheckoutAttributeSelectedModel {
  _$CheckoutAttributeSelectedModelImpl({
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttributeModel>? attributes = const [],
  }) : _attributes = attributes;

  factory _$CheckoutAttributeSelectedModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CheckoutAttributeSelectedModelImplFromJson(json);

  final List<CustomAttributeModel>? _attributes;
  @override
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes {
    final value = _attributes;
    if (value == null) return null;
    if (_attributes is EqualUnmodifiableListView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CheckoutAttributeSelectedModel(attributes: $attributes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutAttributeSelectedModelImpl &&
            const DeepCollectionEquality().equals(
              other._attributes,
              _attributes,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_attributes),
  );

  /// Create a copy of CheckoutAttributeSelectedModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutAttributeSelectedModelImplCopyWith<
    _$CheckoutAttributeSelectedModelImpl
  >
  get copyWith => __$$CheckoutAttributeSelectedModelImplCopyWithImpl<
    _$CheckoutAttributeSelectedModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutAttributeSelectedModelImplToJson(this);
  }
}

abstract class _CheckoutAttributeSelectedModel
    implements CheckoutAttributeSelectedModel {
  factory _CheckoutAttributeSelectedModel({
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttributeModel>? attributes,
  }) = _$CheckoutAttributeSelectedModelImpl;

  factory _CheckoutAttributeSelectedModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutAttributeSelectedModelImpl.fromJson;

  @override
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes;

  /// Create a copy of CheckoutAttributeSelectedModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutAttributeSelectedModelImplCopyWith<
    _$CheckoutAttributeSelectedModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
