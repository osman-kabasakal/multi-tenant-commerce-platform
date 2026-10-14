// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'footer_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FooterPageModel _$FooterPageModelFromJson(Map<String, dynamic> json) {
  return _FooterPageModel.fromJson(json);
}

/// @nodoc
mixin _$FooterPageModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'IncludeInFooterRow1', includeIfNull: false)
  bool? get includeInFooterRow1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'IncludeInFooterRow2', includeIfNull: false)
  bool? get includeInFooterRow2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'IncludeInFooterRow3', includeIfNull: false)
  bool? get includeInFooterRow3 => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this FooterPageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FooterPageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FooterPageModelCopyWith<FooterPageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FooterPageModelCopyWith<$Res> {
  factory $FooterPageModelCopyWith(
    FooterPageModel value,
    $Res Function(FooterPageModel) then,
  ) = _$FooterPageModelCopyWithImpl<$Res, FooterPageModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'IncludeInFooterRow1', includeIfNull: false)
    bool? includeInFooterRow1,
    @JsonKey(name: 'IncludeInFooterRow2', includeIfNull: false)
    bool? includeInFooterRow2,
    @JsonKey(name: 'IncludeInFooterRow3', includeIfNull: false)
    bool? includeInFooterRow3,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$FooterPageModelCopyWithImpl<$Res, $Val extends FooterPageModel>
    implements $FooterPageModelCopyWith<$Res> {
  _$FooterPageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FooterPageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? includeInFooterRow1 = freezed,
    Object? includeInFooterRow2 = freezed,
    Object? includeInFooterRow3 = freezed,
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
            includeInFooterRow1:
                freezed == includeInFooterRow1
                    ? _value.includeInFooterRow1
                    : includeInFooterRow1 // ignore: cast_nullable_to_non_nullable
                        as bool?,
            includeInFooterRow2:
                freezed == includeInFooterRow2
                    ? _value.includeInFooterRow2
                    : includeInFooterRow2 // ignore: cast_nullable_to_non_nullable
                        as bool?,
            includeInFooterRow3:
                freezed == includeInFooterRow3
                    ? _value.includeInFooterRow3
                    : includeInFooterRow3 // ignore: cast_nullable_to_non_nullable
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
abstract class _$$FooterPageModelImplCopyWith<$Res>
    implements $FooterPageModelCopyWith<$Res> {
  factory _$$FooterPageModelImplCopyWith(
    _$FooterPageModelImpl value,
    $Res Function(_$FooterPageModelImpl) then,
  ) = __$$FooterPageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'IncludeInFooterRow1', includeIfNull: false)
    bool? includeInFooterRow1,
    @JsonKey(name: 'IncludeInFooterRow2', includeIfNull: false)
    bool? includeInFooterRow2,
    @JsonKey(name: 'IncludeInFooterRow3', includeIfNull: false)
    bool? includeInFooterRow3,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$FooterPageModelImplCopyWithImpl<$Res>
    extends _$FooterPageModelCopyWithImpl<$Res, _$FooterPageModelImpl>
    implements _$$FooterPageModelImplCopyWith<$Res> {
  __$$FooterPageModelImplCopyWithImpl(
    _$FooterPageModelImpl _value,
    $Res Function(_$FooterPageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FooterPageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? includeInFooterRow1 = freezed,
    Object? includeInFooterRow2 = freezed,
    Object? includeInFooterRow3 = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$FooterPageModelImpl(
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
        includeInFooterRow1:
            freezed == includeInFooterRow1
                ? _value.includeInFooterRow1
                : includeInFooterRow1 // ignore: cast_nullable_to_non_nullable
                    as bool?,
        includeInFooterRow2:
            freezed == includeInFooterRow2
                ? _value.includeInFooterRow2
                : includeInFooterRow2 // ignore: cast_nullable_to_non_nullable
                    as bool?,
        includeInFooterRow3:
            freezed == includeInFooterRow3
                ? _value.includeInFooterRow3
                : includeInFooterRow3 // ignore: cast_nullable_to_non_nullable
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
class _$FooterPageModelImpl implements _FooterPageModel {
  _$FooterPageModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'IncludeInFooterRow1', includeIfNull: false)
    this.includeInFooterRow1 = false,
    @JsonKey(name: 'IncludeInFooterRow2', includeIfNull: false)
    this.includeInFooterRow2 = false,
    @JsonKey(name: 'IncludeInFooterRow3', includeIfNull: false)
    this.includeInFooterRow3 = false,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$FooterPageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FooterPageModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
  @override
  @JsonKey(name: 'IncludeInFooterRow1', includeIfNull: false)
  final bool? includeInFooterRow1;
  @override
  @JsonKey(name: 'IncludeInFooterRow2', includeIfNull: false)
  final bool? includeInFooterRow2;
  @override
  @JsonKey(name: 'IncludeInFooterRow3', includeIfNull: false)
  final bool? includeInFooterRow3;
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
    return 'FooterPageModel(name: $name, seName: $seName, includeInFooterRow1: $includeInFooterRow1, includeInFooterRow2: $includeInFooterRow2, includeInFooterRow3: $includeInFooterRow3, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FooterPageModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.includeInFooterRow1, includeInFooterRow1) ||
                other.includeInFooterRow1 == includeInFooterRow1) &&
            (identical(other.includeInFooterRow2, includeInFooterRow2) ||
                other.includeInFooterRow2 == includeInFooterRow2) &&
            (identical(other.includeInFooterRow3, includeInFooterRow3) ||
                other.includeInFooterRow3 == includeInFooterRow3) &&
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
    includeInFooterRow1,
    includeInFooterRow2,
    includeInFooterRow3,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of FooterPageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FooterPageModelImplCopyWith<_$FooterPageModelImpl> get copyWith =>
      __$$FooterPageModelImplCopyWithImpl<_$FooterPageModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FooterPageModelImplToJson(this);
  }
}

abstract class _FooterPageModel implements FooterPageModel {
  factory _FooterPageModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'IncludeInFooterRow1', includeIfNull: false)
    final bool? includeInFooterRow1,
    @JsonKey(name: 'IncludeInFooterRow2', includeIfNull: false)
    final bool? includeInFooterRow2,
    @JsonKey(name: 'IncludeInFooterRow3', includeIfNull: false)
    final bool? includeInFooterRow3,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$FooterPageModelImpl;

  factory _FooterPageModel.fromJson(Map<String, dynamic> json) =
      _$FooterPageModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'IncludeInFooterRow1', includeIfNull: false)
  bool? get includeInFooterRow1;
  @override
  @JsonKey(name: 'IncludeInFooterRow2', includeIfNull: false)
  bool? get includeInFooterRow2;
  @override
  @JsonKey(name: 'IncludeInFooterRow3', includeIfNull: false)
  bool? get includeInFooterRow3;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of FooterPageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FooterPageModelImplCopyWith<_$FooterPageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
