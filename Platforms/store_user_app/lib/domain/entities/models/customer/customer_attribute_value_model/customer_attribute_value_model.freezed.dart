// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_attribute_value_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerAttributeValueModel _$CustomerAttributeValueModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerAttributeValueModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerAttributeValueModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsPreSelected', includeIfNull: false)
  bool? get isPreSelected => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerAttributeValueModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerAttributeValueModelCopyWith<CustomerAttributeValueModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerAttributeValueModelCopyWith<$Res> {
  factory $CustomerAttributeValueModelCopyWith(
    CustomerAttributeValueModel value,
    $Res Function(CustomerAttributeValueModel) then,
  ) =
      _$CustomerAttributeValueModelCopyWithImpl<
        $Res,
        CustomerAttributeValueModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false) bool? isPreSelected,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CustomerAttributeValueModelCopyWithImpl<
  $Res,
  $Val extends CustomerAttributeValueModel
>
    implements $CustomerAttributeValueModelCopyWith<$Res> {
  _$CustomerAttributeValueModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
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
abstract class _$$CustomerAttributeValueModelImplCopyWith<$Res>
    implements $CustomerAttributeValueModelCopyWith<$Res> {
  factory _$$CustomerAttributeValueModelImplCopyWith(
    _$CustomerAttributeValueModelImpl value,
    $Res Function(_$CustomerAttributeValueModelImpl) then,
  ) = __$$CustomerAttributeValueModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false) bool? isPreSelected,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CustomerAttributeValueModelImplCopyWithImpl<$Res>
    extends
        _$CustomerAttributeValueModelCopyWithImpl<
          $Res,
          _$CustomerAttributeValueModelImpl
        >
    implements _$$CustomerAttributeValueModelImplCopyWith<$Res> {
  __$$CustomerAttributeValueModelImplCopyWithImpl(
    _$CustomerAttributeValueModelImpl _value,
    $Res Function(_$CustomerAttributeValueModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? isPreSelected = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CustomerAttributeValueModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
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
class _$CustomerAttributeValueModelImpl
    implements _CustomerAttributeValueModel {
  _$CustomerAttributeValueModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false)
    this.isPreSelected = false,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$CustomerAttributeValueModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CustomerAttributeValueModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
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
    return 'CustomerAttributeValueModel(name: $name, isPreSelected: $isPreSelected, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerAttributeValueModelImpl &&
            (identical(other.name, name) || other.name == name) &&
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
    isPreSelected,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CustomerAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerAttributeValueModelImplCopyWith<_$CustomerAttributeValueModelImpl>
  get copyWith => __$$CustomerAttributeValueModelImplCopyWithImpl<
    _$CustomerAttributeValueModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerAttributeValueModelImplToJson(this);
  }
}

abstract class _CustomerAttributeValueModel
    implements CustomerAttributeValueModel {
  factory _CustomerAttributeValueModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false)
    final bool? isPreSelected,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerAttributeValueModelImpl;

  factory _CustomerAttributeValueModel.fromJson(Map<String, dynamic> json) =
      _$CustomerAttributeValueModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'IsPreSelected', includeIfNull: false)
  bool? get isPreSelected;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerAttributeValueModelImplCopyWith<_$CustomerAttributeValueModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
