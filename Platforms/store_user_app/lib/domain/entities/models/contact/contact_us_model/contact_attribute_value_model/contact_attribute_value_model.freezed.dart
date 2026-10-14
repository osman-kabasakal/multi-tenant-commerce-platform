// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_attribute_value_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ContactAttributeValueModel _$ContactAttributeValueModelFromJson(
  Map<String, dynamic> json,
) {
  return _ContactAttributeValueModel.fromJson(json);
}

/// @nodoc
mixin _$ContactAttributeValueModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayOrder', includeIfNull: false)
  int? get displayOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  String? get colorSquaresRgb => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsPreSelected', includeIfNull: false)
  bool? get isPreSelected => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ContactAttributeValueModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactAttributeValueModelCopyWith<ContactAttributeValueModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactAttributeValueModelCopyWith<$Res> {
  factory $ContactAttributeValueModelCopyWith(
    ContactAttributeValueModel value,
    $Res Function(ContactAttributeValueModel) then,
  ) =
      _$ContactAttributeValueModelCopyWithImpl<
        $Res,
        ContactAttributeValueModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'DisplayOrder', includeIfNull: false) int? displayOrder,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    String? colorSquaresRgb,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false) bool? isPreSelected,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ContactAttributeValueModelCopyWithImpl<
  $Res,
  $Val extends ContactAttributeValueModel
>
    implements $ContactAttributeValueModelCopyWith<$Res> {
  _$ContactAttributeValueModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? displayOrder = freezed,
    Object? colorSquaresRgb = freezed,
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
            displayOrder:
                freezed == displayOrder
                    ? _value.displayOrder
                    : displayOrder // ignore: cast_nullable_to_non_nullable
                        as int?,
            colorSquaresRgb:
                freezed == colorSquaresRgb
                    ? _value.colorSquaresRgb
                    : colorSquaresRgb // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ContactAttributeValueModelImplCopyWith<$Res>
    implements $ContactAttributeValueModelCopyWith<$Res> {
  factory _$$ContactAttributeValueModelImplCopyWith(
    _$ContactAttributeValueModelImpl value,
    $Res Function(_$ContactAttributeValueModelImpl) then,
  ) = __$$ContactAttributeValueModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'DisplayOrder', includeIfNull: false) int? displayOrder,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    String? colorSquaresRgb,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false) bool? isPreSelected,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ContactAttributeValueModelImplCopyWithImpl<$Res>
    extends
        _$ContactAttributeValueModelCopyWithImpl<
          $Res,
          _$ContactAttributeValueModelImpl
        >
    implements _$$ContactAttributeValueModelImplCopyWith<$Res> {
  __$$ContactAttributeValueModelImplCopyWithImpl(
    _$ContactAttributeValueModelImpl _value,
    $Res Function(_$ContactAttributeValueModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContactAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? displayOrder = freezed,
    Object? colorSquaresRgb = freezed,
    Object? isPreSelected = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ContactAttributeValueModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        displayOrder:
            freezed == displayOrder
                ? _value.displayOrder
                : displayOrder // ignore: cast_nullable_to_non_nullable
                    as int?,
        colorSquaresRgb:
            freezed == colorSquaresRgb
                ? _value.colorSquaresRgb
                : colorSquaresRgb // ignore: cast_nullable_to_non_nullable
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
class _$ContactAttributeValueModelImpl implements _ContactAttributeValueModel {
  _$ContactAttributeValueModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'DisplayOrder', includeIfNull: false) this.displayOrder,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    this.colorSquaresRgb,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false)
    this.isPreSelected = false,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ContactAttributeValueModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ContactAttributeValueModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'DisplayOrder', includeIfNull: false)
  final int? displayOrder;
  @override
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  final String? colorSquaresRgb;
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
    return 'ContactAttributeValueModel(name: $name, displayOrder: $displayOrder, colorSquaresRgb: $colorSquaresRgb, isPreSelected: $isPreSelected, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactAttributeValueModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.colorSquaresRgb, colorSquaresRgb) ||
                other.colorSquaresRgb == colorSquaresRgb) &&
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
    displayOrder,
    colorSquaresRgb,
    isPreSelected,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ContactAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactAttributeValueModelImplCopyWith<_$ContactAttributeValueModelImpl>
  get copyWith => __$$ContactAttributeValueModelImplCopyWithImpl<
    _$ContactAttributeValueModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactAttributeValueModelImplToJson(this);
  }
}

abstract class _ContactAttributeValueModel
    implements ContactAttributeValueModel {
  factory _ContactAttributeValueModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'DisplayOrder', includeIfNull: false)
    final int? displayOrder,
    @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
    final String? colorSquaresRgb,
    @JsonKey(name: 'IsPreSelected', includeIfNull: false)
    final bool? isPreSelected,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ContactAttributeValueModelImpl;

  factory _ContactAttributeValueModel.fromJson(Map<String, dynamic> json) =
      _$ContactAttributeValueModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'DisplayOrder', includeIfNull: false)
  int? get displayOrder;
  @override
  @JsonKey(name: 'ColorSquaresRgb', includeIfNull: false)
  String? get colorSquaresRgb;
  @override
  @JsonKey(name: 'IsPreSelected', includeIfNull: false)
  bool? get isPreSelected;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ContactAttributeValueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactAttributeValueModelImplCopyWith<_$ContactAttributeValueModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
