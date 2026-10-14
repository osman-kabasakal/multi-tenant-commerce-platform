// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_simple_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategorySimpleModel _$CategorySimpleModelFromJson(Map<String, dynamic> json) {
  return _CategorySimpleModel.fromJson(json);
}

/// @nodoc
mixin _$CategorySimpleModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Flag', includeIfNull: false)
  String? get flag => throw _privateConstructorUsedError;
  @JsonKey(name: 'FlagStyle', includeIfNull: false)
  String? get flagStyle => throw _privateConstructorUsedError;
  @JsonKey(name: 'Icon', includeIfNull: false)
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'ImageUrl', includeIfNull: false)
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'NumberOfProducts', includeIfNull: false)
  int? get numberOfProducts => throw _privateConstructorUsedError;
  @JsonKey(name: 'IncludeInMenu', includeIfNull: false)
  bool? get includeInMenu => throw _privateConstructorUsedError;
  @JsonKey(name: 'SubCategories', includeIfNull: false)
  List<CategorySimpleModel>? get subCategories =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CategorySimpleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategorySimpleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategorySimpleModelCopyWith<CategorySimpleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySimpleModelCopyWith<$Res> {
  factory $CategorySimpleModelCopyWith(
    CategorySimpleModel value,
    $Res Function(CategorySimpleModel) then,
  ) = _$CategorySimpleModelCopyWithImpl<$Res, CategorySimpleModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) String? flagStyle,
    @JsonKey(name: 'Icon', includeIfNull: false) String? icon,
    @JsonKey(name: 'ImageUrl', includeIfNull: false) String? imageUrl,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'NumberOfProducts', includeIfNull: false)
    int? numberOfProducts,
    @JsonKey(name: 'IncludeInMenu', includeIfNull: false) bool? includeInMenu,
    @JsonKey(name: 'SubCategories', includeIfNull: false)
    List<CategorySimpleModel>? subCategories,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CategorySimpleModelCopyWithImpl<$Res, $Val extends CategorySimpleModel>
    implements $CategorySimpleModelCopyWith<$Res> {
  _$CategorySimpleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategorySimpleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? flag = freezed,
    Object? flagStyle = freezed,
    Object? icon = freezed,
    Object? imageUrl = freezed,
    Object? seName = freezed,
    Object? numberOfProducts = freezed,
    Object? includeInMenu = freezed,
    Object? subCategories = freezed,
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
            icon:
                freezed == icon
                    ? _value.icon
                    : icon // ignore: cast_nullable_to_non_nullable
                        as String?,
            imageUrl:
                freezed == imageUrl
                    ? _value.imageUrl
                    : imageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            seName:
                freezed == seName
                    ? _value.seName
                    : seName // ignore: cast_nullable_to_non_nullable
                        as String?,
            numberOfProducts:
                freezed == numberOfProducts
                    ? _value.numberOfProducts
                    : numberOfProducts // ignore: cast_nullable_to_non_nullable
                        as int?,
            includeInMenu:
                freezed == includeInMenu
                    ? _value.includeInMenu
                    : includeInMenu // ignore: cast_nullable_to_non_nullable
                        as bool?,
            subCategories:
                freezed == subCategories
                    ? _value.subCategories
                    : subCategories // ignore: cast_nullable_to_non_nullable
                        as List<CategorySimpleModel>?,
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
abstract class _$$CategorySimpleModelImplCopyWith<$Res>
    implements $CategorySimpleModelCopyWith<$Res> {
  factory _$$CategorySimpleModelImplCopyWith(
    _$CategorySimpleModelImpl value,
    $Res Function(_$CategorySimpleModelImpl) then,
  ) = __$$CategorySimpleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) String? flagStyle,
    @JsonKey(name: 'Icon', includeIfNull: false) String? icon,
    @JsonKey(name: 'ImageUrl', includeIfNull: false) String? imageUrl,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'NumberOfProducts', includeIfNull: false)
    int? numberOfProducts,
    @JsonKey(name: 'IncludeInMenu', includeIfNull: false) bool? includeInMenu,
    @JsonKey(name: 'SubCategories', includeIfNull: false)
    List<CategorySimpleModel>? subCategories,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CategorySimpleModelImplCopyWithImpl<$Res>
    extends _$CategorySimpleModelCopyWithImpl<$Res, _$CategorySimpleModelImpl>
    implements _$$CategorySimpleModelImplCopyWith<$Res> {
  __$$CategorySimpleModelImplCopyWithImpl(
    _$CategorySimpleModelImpl _value,
    $Res Function(_$CategorySimpleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategorySimpleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? flag = freezed,
    Object? flagStyle = freezed,
    Object? icon = freezed,
    Object? imageUrl = freezed,
    Object? seName = freezed,
    Object? numberOfProducts = freezed,
    Object? includeInMenu = freezed,
    Object? subCategories = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CategorySimpleModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
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
        icon:
            freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                    as String?,
        imageUrl:
            freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        seName:
            freezed == seName
                ? _value.seName
                : seName // ignore: cast_nullable_to_non_nullable
                    as String?,
        numberOfProducts:
            freezed == numberOfProducts
                ? _value.numberOfProducts
                : numberOfProducts // ignore: cast_nullable_to_non_nullable
                    as int?,
        includeInMenu:
            freezed == includeInMenu
                ? _value.includeInMenu
                : includeInMenu // ignore: cast_nullable_to_non_nullable
                    as bool?,
        subCategories:
            freezed == subCategories
                ? _value._subCategories
                : subCategories // ignore: cast_nullable_to_non_nullable
                    as List<CategorySimpleModel>?,
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
class _$CategorySimpleModelImpl implements _CategorySimpleModel {
  _$CategorySimpleModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Flag', includeIfNull: false) this.flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) this.flagStyle,
    @JsonKey(name: 'Icon', includeIfNull: false) this.icon,
    @JsonKey(name: 'ImageUrl', includeIfNull: false) this.imageUrl,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'NumberOfProducts', includeIfNull: false)
    this.numberOfProducts = null,
    @JsonKey(name: 'IncludeInMenu', includeIfNull: false)
    this.includeInMenu = false,
    @JsonKey(name: 'SubCategories', includeIfNull: false)
    final List<CategorySimpleModel>? subCategories = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _subCategories = subCategories,
       _userFields = userFields;

  factory _$CategorySimpleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategorySimpleModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Flag', includeIfNull: false)
  final String? flag;
  @override
  @JsonKey(name: 'FlagStyle', includeIfNull: false)
  final String? flagStyle;
  @override
  @JsonKey(name: 'Icon', includeIfNull: false)
  final String? icon;
  @override
  @JsonKey(name: 'ImageUrl', includeIfNull: false)
  final String? imageUrl;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
  @override
  @JsonKey(name: 'NumberOfProducts', includeIfNull: false)
  final int? numberOfProducts;
  @override
  @JsonKey(name: 'IncludeInMenu', includeIfNull: false)
  final bool? includeInMenu;
  final List<CategorySimpleModel>? _subCategories;
  @override
  @JsonKey(name: 'SubCategories', includeIfNull: false)
  List<CategorySimpleModel>? get subCategories {
    final value = _subCategories;
    if (value == null) return null;
    if (_subCategories is EqualUnmodifiableListView) return _subCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'CategorySimpleModel(name: $name, flag: $flag, flagStyle: $flagStyle, icon: $icon, imageUrl: $imageUrl, seName: $seName, numberOfProducts: $numberOfProducts, includeInMenu: $includeInMenu, subCategories: $subCategories, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySimpleModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.flag, flag) || other.flag == flag) &&
            (identical(other.flagStyle, flagStyle) ||
                other.flagStyle == flagStyle) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.numberOfProducts, numberOfProducts) ||
                other.numberOfProducts == numberOfProducts) &&
            (identical(other.includeInMenu, includeInMenu) ||
                other.includeInMenu == includeInMenu) &&
            const DeepCollectionEquality().equals(
              other._subCategories,
              _subCategories,
            ) &&
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
    flag,
    flagStyle,
    icon,
    imageUrl,
    seName,
    numberOfProducts,
    includeInMenu,
    const DeepCollectionEquality().hash(_subCategories),
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CategorySimpleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySimpleModelImplCopyWith<_$CategorySimpleModelImpl> get copyWith =>
      __$$CategorySimpleModelImplCopyWithImpl<_$CategorySimpleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategorySimpleModelImplToJson(this);
  }
}

abstract class _CategorySimpleModel implements CategorySimpleModel {
  factory _CategorySimpleModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Flag', includeIfNull: false) final String? flag,
    @JsonKey(name: 'FlagStyle', includeIfNull: false) final String? flagStyle,
    @JsonKey(name: 'Icon', includeIfNull: false) final String? icon,
    @JsonKey(name: 'ImageUrl', includeIfNull: false) final String? imageUrl,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'NumberOfProducts', includeIfNull: false)
    final int? numberOfProducts,
    @JsonKey(name: 'IncludeInMenu', includeIfNull: false)
    final bool? includeInMenu,
    @JsonKey(name: 'SubCategories', includeIfNull: false)
    final List<CategorySimpleModel>? subCategories,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CategorySimpleModelImpl;

  factory _CategorySimpleModel.fromJson(Map<String, dynamic> json) =
      _$CategorySimpleModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Flag', includeIfNull: false)
  String? get flag;
  @override
  @JsonKey(name: 'FlagStyle', includeIfNull: false)
  String? get flagStyle;
  @override
  @JsonKey(name: 'Icon', includeIfNull: false)
  String? get icon;
  @override
  @JsonKey(name: 'ImageUrl', includeIfNull: false)
  String? get imageUrl;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'NumberOfProducts', includeIfNull: false)
  int? get numberOfProducts;
  @override
  @JsonKey(name: 'IncludeInMenu', includeIfNull: false)
  bool? get includeInMenu;
  @override
  @JsonKey(name: 'SubCategories', includeIfNull: false)
  List<CategorySimpleModel>? get subCategories;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CategorySimpleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorySimpleModelImplCopyWith<_$CategorySimpleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
