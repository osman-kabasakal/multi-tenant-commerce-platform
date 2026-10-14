// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand_brief_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BrandBriefInfoModel _$BrandBriefInfoModelFromJson(Map<String, dynamic> json) {
  return _BrandBriefInfoModel.fromJson(json);
}

/// @nodoc
mixin _$BrandBriefInfoModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this BrandBriefInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BrandBriefInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrandBriefInfoModelCopyWith<BrandBriefInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrandBriefInfoModelCopyWith<$Res> {
  factory $BrandBriefInfoModelCopyWith(
    BrandBriefInfoModel value,
    $Res Function(BrandBriefInfoModel) then,
  ) = _$BrandBriefInfoModelCopyWithImpl<$Res, BrandBriefInfoModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$BrandBriefInfoModelCopyWithImpl<$Res, $Val extends BrandBriefInfoModel>
    implements $BrandBriefInfoModelCopyWith<$Res> {
  _$BrandBriefInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrandBriefInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
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
            seName:
                freezed == seName
                    ? _value.seName
                    : seName // ignore: cast_nullable_to_non_nullable
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
abstract class _$$BrandBriefInfoModelImplCopyWith<$Res>
    implements $BrandBriefInfoModelCopyWith<$Res> {
  factory _$$BrandBriefInfoModelImplCopyWith(
    _$BrandBriefInfoModelImpl value,
    $Res Function(_$BrandBriefInfoModelImpl) then,
  ) = __$$BrandBriefInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$BrandBriefInfoModelImplCopyWithImpl<$Res>
    extends _$BrandBriefInfoModelCopyWithImpl<$Res, _$BrandBriefInfoModelImpl>
    implements _$$BrandBriefInfoModelImplCopyWith<$Res> {
  __$$BrandBriefInfoModelImplCopyWithImpl(
    _$BrandBriefInfoModelImpl _value,
    $Res Function(_$BrandBriefInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BrandBriefInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$BrandBriefInfoModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        seName:
            freezed == seName
                ? _value.seName
                : seName // ignore: cast_nullable_to_non_nullable
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
class _$BrandBriefInfoModelImpl implements _BrandBriefInfoModel {
  _$BrandBriefInfoModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$BrandBriefInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrandBriefInfoModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
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
    return 'BrandBriefInfoModel(name: $name, seName: $seName, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrandBriefInfoModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.seName, seName) || other.seName == seName) &&
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
    seName,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of BrandBriefInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrandBriefInfoModelImplCopyWith<_$BrandBriefInfoModelImpl> get copyWith =>
      __$$BrandBriefInfoModelImplCopyWithImpl<_$BrandBriefInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BrandBriefInfoModelImplToJson(this);
  }
}

abstract class _BrandBriefInfoModel implements BrandBriefInfoModel {
  factory _BrandBriefInfoModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$BrandBriefInfoModelImpl;

  factory _BrandBriefInfoModel.fromJson(Map<String, dynamic> json) =
      _$BrandBriefInfoModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of BrandBriefInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrandBriefInfoModelImplCopyWith<_$BrandBriefInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
