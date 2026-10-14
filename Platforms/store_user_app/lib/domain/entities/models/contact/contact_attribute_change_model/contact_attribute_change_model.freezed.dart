// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_attribute_change_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContactAttributeChangeModel _$ContactAttributeChangeModelFromJson(
  Map<String, dynamic> json,
) {
  return _ContactAttributeChangeModel.fromJson(json);
}

/// @nodoc
mixin _$ContactAttributeChangeModel {
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes =>
      throw _privateConstructorUsedError;

  /// Serializes this ContactAttributeChangeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactAttributeChangeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactAttributeChangeModelCopyWith<ContactAttributeChangeModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactAttributeChangeModelCopyWith<$Res> {
  factory $ContactAttributeChangeModelCopyWith(
    ContactAttributeChangeModel value,
    $Res Function(ContactAttributeChangeModel) then,
  ) =
      _$ContactAttributeChangeModelCopyWithImpl<
        $Res,
        ContactAttributeChangeModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttributeModel>? attributes,
  });
}

/// @nodoc
class _$ContactAttributeChangeModelCopyWithImpl<
  $Res,
  $Val extends ContactAttributeChangeModel
>
    implements $ContactAttributeChangeModelCopyWith<$Res> {
  _$ContactAttributeChangeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactAttributeChangeModel
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
abstract class _$$ContactAttributeChangeModelImplCopyWith<$Res>
    implements $ContactAttributeChangeModelCopyWith<$Res> {
  factory _$$ContactAttributeChangeModelImplCopyWith(
    _$ContactAttributeChangeModelImpl value,
    $Res Function(_$ContactAttributeChangeModelImpl) then,
  ) = __$$ContactAttributeChangeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttributeModel>? attributes,
  });
}

/// @nodoc
class __$$ContactAttributeChangeModelImplCopyWithImpl<$Res>
    extends
        _$ContactAttributeChangeModelCopyWithImpl<
          $Res,
          _$ContactAttributeChangeModelImpl
        >
    implements _$$ContactAttributeChangeModelImplCopyWith<$Res> {
  __$$ContactAttributeChangeModelImplCopyWithImpl(
    _$ContactAttributeChangeModelImpl _value,
    $Res Function(_$ContactAttributeChangeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactAttributeChangeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? attributes = freezed}) {
    return _then(
      _$ContactAttributeChangeModelImpl(
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
class _$ContactAttributeChangeModelImpl
    implements _ContactAttributeChangeModel {
  _$ContactAttributeChangeModelImpl({
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttributeModel>? attributes = const [],
  }) : _attributes = attributes;

  factory _$ContactAttributeChangeModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ContactAttributeChangeModelImplFromJson(json);

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
    return 'ContactAttributeChangeModel(attributes: $attributes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactAttributeChangeModelImpl &&
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

  /// Create a copy of ContactAttributeChangeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactAttributeChangeModelImplCopyWith<_$ContactAttributeChangeModelImpl>
  get copyWith => __$$ContactAttributeChangeModelImplCopyWithImpl<
    _$ContactAttributeChangeModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactAttributeChangeModelImplToJson(this);
  }
}

abstract class _ContactAttributeChangeModel
    implements ContactAttributeChangeModel {
  factory _ContactAttributeChangeModel({
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttributeModel>? attributes,
  }) = _$ContactAttributeChangeModelImpl;

  factory _ContactAttributeChangeModel.fromJson(Map<String, dynamic> json) =
      _$ContactAttributeChangeModelImpl.fromJson;

  @override
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes;

  /// Create a copy of ContactAttributeChangeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactAttributeChangeModelImplCopyWith<_$ContactAttributeChangeModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
