// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SubCategoryModel _$SubCategoryModelFromJson(Map<String, dynamic> json) {
  return _SubCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$SubCategoryModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'Flag', includeIfNull: false)
  String? get flag => throw _privateConstructorUsedError;
  @JsonKey(name: 'FlagStyle', includeIfNull: false)
  String? get flagStyle => throw _privateConstructorUsedError;
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this SubCategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubCategoryModelCopyWith<SubCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubCategoryModelCopyWith<$Res> {
  factory $SubCategoryModelCopyWith(
    SubCategoryModel value,
    $Res Function(SubCategoryModel) then,
  ) = _$SubCategoryModelCopyWithImpl<$Res, SubCategoryModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) String? flagStyle,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $PictureModelCopyWith<$Res>? get pictureModel;
}

/// @nodoc
class _$SubCategoryModelCopyWithImpl<$Res, $Val extends SubCategoryModel>
    implements $SubCategoryModelCopyWith<$Res> {
  _$SubCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? description = freezed,
    Object? flag = freezed,
    Object? flagStyle = freezed,
    Object? pictureModel = freezed,
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
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            flag:
                freezed == flag
                    ? _value.flag
                    : flag // ignore: cast_nullable_to_non_nullable
                        as String?,
            flagStyle:
                freezed == flagStyle
                    ? _value.flagStyle
                    : flagStyle // ignore: cast_nullable_to_non_nullable
                        as String?,
            pictureModel:
                freezed == pictureModel
                    ? _value.pictureModel
                    : pictureModel // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
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

  /// Create a copy of SubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PictureModelCopyWith<$Res>? get pictureModel {
    if (_value.pictureModel == null) {
      return null;
    }

    return $PictureModelCopyWith<$Res>(_value.pictureModel!, (value) {
      return _then(_value.copyWith(pictureModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubCategoryModelImplCopyWith<$Res>
    implements $SubCategoryModelCopyWith<$Res> {
  factory _$$SubCategoryModelImplCopyWith(
    _$SubCategoryModelImpl value,
    $Res Function(_$SubCategoryModelImpl) then,
  ) = __$$SubCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) String? flagStyle,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $PictureModelCopyWith<$Res>? get pictureModel;
}

/// @nodoc
class __$$SubCategoryModelImplCopyWithImpl<$Res>
    extends _$SubCategoryModelCopyWithImpl<$Res, _$SubCategoryModelImpl>
    implements _$$SubCategoryModelImplCopyWith<$Res> {
  __$$SubCategoryModelImplCopyWithImpl(
    _$SubCategoryModelImpl _value,
    $Res Function(_$SubCategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? description = freezed,
    Object? flag = freezed,
    Object? flagStyle = freezed,
    Object? pictureModel = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$SubCategoryModelImpl(
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
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        flag:
            freezed == flag
                ? _value.flag
                : flag // ignore: cast_nullable_to_non_nullable
                    as String?,
        flagStyle:
            freezed == flagStyle
                ? _value.flagStyle
                : flagStyle // ignore: cast_nullable_to_non_nullable
                    as String?,
        pictureModel:
            freezed == pictureModel
                ? _value.pictureModel
                : pictureModel // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
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
class _$SubCategoryModelImpl implements _SubCategoryModel {
  _$SubCategoryModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'Flag', includeIfNull: false) this.flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) this.flagStyle,
    @JsonKey(name: 'PictureModel', includeIfNull: false) this.pictureModel,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$SubCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubCategoryModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'Flag', includeIfNull: false)
  final String? flag;
  @override
  @JsonKey(name: 'FlagStyle', includeIfNull: false)
  final String? flagStyle;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  final PictureModel? pictureModel;
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
    return 'SubCategoryModel(name: $name, seName: $seName, description: $description, flag: $flag, flagStyle: $flagStyle, pictureModel: $pictureModel, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubCategoryModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.flag, flag) || other.flag == flag) &&
            (identical(other.flagStyle, flagStyle) ||
                other.flagStyle == flagStyle) &&
            (identical(other.pictureModel, pictureModel) ||
                other.pictureModel == pictureModel) &&
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
    description,
    flag,
    flagStyle,
    pictureModel,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of SubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubCategoryModelImplCopyWith<_$SubCategoryModelImpl> get copyWith =>
      __$$SubCategoryModelImplCopyWithImpl<_$SubCategoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubCategoryModelImplToJson(this);
  }
}

abstract class _SubCategoryModel implements SubCategoryModel {
  factory _SubCategoryModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'Flag', includeIfNull: false) final String? flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) final String? flagStyle,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    final PictureModel? pictureModel,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$SubCategoryModelImpl;

  factory _SubCategoryModel.fromJson(Map<String, dynamic> json) =
      _$SubCategoryModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'Flag', includeIfNull: false)
  String? get flag;
  @override
  @JsonKey(name: 'FlagStyle', includeIfNull: false)
  String? get flagStyle;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of SubCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubCategoryModelImplCopyWith<_$SubCategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
