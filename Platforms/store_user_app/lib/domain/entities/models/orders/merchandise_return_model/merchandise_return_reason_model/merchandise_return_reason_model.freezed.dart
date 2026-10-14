// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchandise_return_reason_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MerchandiseReturnReasonModel _$MerchandiseReturnReasonModelFromJson(
  Map<String, dynamic> json,
) {
  return _MerchandiseReturnReasonModel.fromJson(json);
}

/// @nodoc
mixin _$MerchandiseReturnReasonModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this MerchandiseReturnReasonModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MerchandiseReturnReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchandiseReturnReasonModelCopyWith<MerchandiseReturnReasonModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchandiseReturnReasonModelCopyWith<$Res> {
  factory $MerchandiseReturnReasonModelCopyWith(
    MerchandiseReturnReasonModel value,
    $Res Function(MerchandiseReturnReasonModel) then,
  ) =
      _$MerchandiseReturnReasonModelCopyWithImpl<
        $Res,
        MerchandiseReturnReasonModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$MerchandiseReturnReasonModelCopyWithImpl<
  $Res,
  $Val extends MerchandiseReturnReasonModel
>
    implements $MerchandiseReturnReasonModelCopyWith<$Res> {
  _$MerchandiseReturnReasonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchandiseReturnReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
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
abstract class _$$MerchandiseReturnReasonModelImplCopyWith<$Res>
    implements $MerchandiseReturnReasonModelCopyWith<$Res> {
  factory _$$MerchandiseReturnReasonModelImplCopyWith(
    _$MerchandiseReturnReasonModelImpl value,
    $Res Function(_$MerchandiseReturnReasonModelImpl) then,
  ) = __$$MerchandiseReturnReasonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$MerchandiseReturnReasonModelImplCopyWithImpl<$Res>
    extends
        _$MerchandiseReturnReasonModelCopyWithImpl<
          $Res,
          _$MerchandiseReturnReasonModelImpl
        >
    implements _$$MerchandiseReturnReasonModelImplCopyWith<$Res> {
  __$$MerchandiseReturnReasonModelImplCopyWithImpl(
    _$MerchandiseReturnReasonModelImpl _value,
    $Res Function(_$MerchandiseReturnReasonModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MerchandiseReturnReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$MerchandiseReturnReasonModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
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
class _$MerchandiseReturnReasonModelImpl
    implements _MerchandiseReturnReasonModel {
  _$MerchandiseReturnReasonModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$MerchandiseReturnReasonModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$MerchandiseReturnReasonModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
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
    return 'MerchandiseReturnReasonModel(name: $name, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchandiseReturnReasonModelImpl &&
            (identical(other.name, name) || other.name == name) &&
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
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of MerchandiseReturnReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchandiseReturnReasonModelImplCopyWith<
    _$MerchandiseReturnReasonModelImpl
  >
  get copyWith => __$$MerchandiseReturnReasonModelImplCopyWithImpl<
    _$MerchandiseReturnReasonModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchandiseReturnReasonModelImplToJson(this);
  }
}

abstract class _MerchandiseReturnReasonModel
    implements MerchandiseReturnReasonModel {
  factory _MerchandiseReturnReasonModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$MerchandiseReturnReasonModelImpl;

  factory _MerchandiseReturnReasonModel.fromJson(Map<String, dynamic> json) =
      _$MerchandiseReturnReasonModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of MerchandiseReturnReasonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchandiseReturnReasonModelImplCopyWith<
    _$MerchandiseReturnReasonModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
