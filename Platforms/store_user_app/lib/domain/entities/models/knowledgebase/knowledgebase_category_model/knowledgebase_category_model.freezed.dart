// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knowledgebase_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KnowledgebaseCategoryModel _$KnowledgebaseCategoryModelFromJson(
  Map<String, dynamic> json,
) {
  return _KnowledgebaseCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$KnowledgebaseCategoryModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsCurrent', includeIfNull: false)
  bool? get isCurrent => throw _privateConstructorUsedError;
  @JsonKey(name: 'Children', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get children =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Parent', includeIfNull: false)
  KnowledgebaseCategoryModel? get parent => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this KnowledgebaseCategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KnowledgebaseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KnowledgebaseCategoryModelCopyWith<KnowledgebaseCategoryModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KnowledgebaseCategoryModelCopyWith<$Res> {
  factory $KnowledgebaseCategoryModelCopyWith(
    KnowledgebaseCategoryModel value,
    $Res Function(KnowledgebaseCategoryModel) then,
  ) =
      _$KnowledgebaseCategoryModelCopyWithImpl<
        $Res,
        KnowledgebaseCategoryModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'IsCurrent', includeIfNull: false) bool? isCurrent,
    @JsonKey(name: 'Children', includeIfNull: false)
    List<KnowledgebaseCategoryModel>? children,
    @JsonKey(name: 'Parent', includeIfNull: false)
    KnowledgebaseCategoryModel? parent,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $KnowledgebaseCategoryModelCopyWith<$Res>? get parent;
}

/// @nodoc
class _$KnowledgebaseCategoryModelCopyWithImpl<
  $Res,
  $Val extends KnowledgebaseCategoryModel
>
    implements $KnowledgebaseCategoryModelCopyWith<$Res> {
  _$KnowledgebaseCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KnowledgebaseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? isCurrent = freezed,
    Object? children = freezed,
    Object? parent = freezed,
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
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            isCurrent:
                freezed == isCurrent
                    ? _value.isCurrent
                    : isCurrent // ignore: cast_nullable_to_non_nullable
                        as bool?,
            children:
                freezed == children
                    ? _value.children
                    : children // ignore: cast_nullable_to_non_nullable
                        as List<KnowledgebaseCategoryModel>?,
            parent:
                freezed == parent
                    ? _value.parent
                    : parent // ignore: cast_nullable_to_non_nullable
                        as KnowledgebaseCategoryModel?,
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

  /// Create a copy of KnowledgebaseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $KnowledgebaseCategoryModelCopyWith<$Res>? get parent {
    if (_value.parent == null) {
      return null;
    }

    return $KnowledgebaseCategoryModelCopyWith<$Res>(_value.parent!, (value) {
      return _then(_value.copyWith(parent: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$KnowledgebaseCategoryModelImplCopyWith<$Res>
    implements $KnowledgebaseCategoryModelCopyWith<$Res> {
  factory _$$KnowledgebaseCategoryModelImplCopyWith(
    _$KnowledgebaseCategoryModelImpl value,
    $Res Function(_$KnowledgebaseCategoryModelImpl) then,
  ) = __$$KnowledgebaseCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'Description', includeIfNull: false) String? description,
    @JsonKey(name: 'IsCurrent', includeIfNull: false) bool? isCurrent,
    @JsonKey(name: 'Children', includeIfNull: false)
    List<KnowledgebaseCategoryModel>? children,
    @JsonKey(name: 'Parent', includeIfNull: false)
    KnowledgebaseCategoryModel? parent,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $KnowledgebaseCategoryModelCopyWith<$Res>? get parent;
}

/// @nodoc
class __$$KnowledgebaseCategoryModelImplCopyWithImpl<$Res>
    extends
        _$KnowledgebaseCategoryModelCopyWithImpl<
          $Res,
          _$KnowledgebaseCategoryModelImpl
        >
    implements _$$KnowledgebaseCategoryModelImplCopyWith<$Res> {
  __$$KnowledgebaseCategoryModelImplCopyWithImpl(
    _$KnowledgebaseCategoryModelImpl _value,
    $Res Function(_$KnowledgebaseCategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KnowledgebaseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? isCurrent = freezed,
    Object? children = freezed,
    Object? parent = freezed,
    Object? seName = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$KnowledgebaseCategoryModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        isCurrent:
            freezed == isCurrent
                ? _value.isCurrent
                : isCurrent // ignore: cast_nullable_to_non_nullable
                    as bool?,
        children:
            freezed == children
                ? _value._children
                : children // ignore: cast_nullable_to_non_nullable
                    as List<KnowledgebaseCategoryModel>?,
        parent:
            freezed == parent
                ? _value.parent
                : parent // ignore: cast_nullable_to_non_nullable
                    as KnowledgebaseCategoryModel?,
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
class _$KnowledgebaseCategoryModelImpl implements _KnowledgebaseCategoryModel {
  _$KnowledgebaseCategoryModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'Description', includeIfNull: false) this.description,
    @JsonKey(name: 'IsCurrent', includeIfNull: false) this.isCurrent = false,
    @JsonKey(name: 'Children', includeIfNull: false)
    final List<KnowledgebaseCategoryModel>? children = const [],
    @JsonKey(name: 'Parent', includeIfNull: false) this.parent,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _children = children,
       _userFields = userFields;

  factory _$KnowledgebaseCategoryModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$KnowledgebaseCategoryModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  final String? description;
  @override
  @JsonKey(name: 'IsCurrent', includeIfNull: false)
  final bool? isCurrent;
  final List<KnowledgebaseCategoryModel>? _children;
  @override
  @JsonKey(name: 'Children', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get children {
    final value = _children;
    if (value == null) return null;
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'Parent', includeIfNull: false)
  final KnowledgebaseCategoryModel? parent;
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
    return 'KnowledgebaseCategoryModel(name: $name, description: $description, isCurrent: $isCurrent, children: $children, parent: $parent, seName: $seName, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KnowledgebaseCategoryModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            (identical(other.parent, parent) || other.parent == parent) &&
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
    description,
    isCurrent,
    const DeepCollectionEquality().hash(_children),
    parent,
    seName,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of KnowledgebaseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KnowledgebaseCategoryModelImplCopyWith<_$KnowledgebaseCategoryModelImpl>
  get copyWith => __$$KnowledgebaseCategoryModelImplCopyWithImpl<
    _$KnowledgebaseCategoryModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KnowledgebaseCategoryModelImplToJson(this);
  }
}

abstract class _KnowledgebaseCategoryModel
    implements KnowledgebaseCategoryModel {
  factory _KnowledgebaseCategoryModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'Description', includeIfNull: false)
    final String? description,
    @JsonKey(name: 'IsCurrent', includeIfNull: false) final bool? isCurrent,
    @JsonKey(name: 'Children', includeIfNull: false)
    final List<KnowledgebaseCategoryModel>? children,
    @JsonKey(name: 'Parent', includeIfNull: false)
    final KnowledgebaseCategoryModel? parent,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$KnowledgebaseCategoryModelImpl;

  factory _KnowledgebaseCategoryModel.fromJson(Map<String, dynamic> json) =
      _$KnowledgebaseCategoryModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'Description', includeIfNull: false)
  String? get description;
  @override
  @JsonKey(name: 'IsCurrent', includeIfNull: false)
  bool? get isCurrent;
  @override
  @JsonKey(name: 'Children', includeIfNull: false)
  List<KnowledgebaseCategoryModel>? get children;
  @override
  @JsonKey(name: 'Parent', includeIfNull: false)
  KnowledgebaseCategoryModel? get parent;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of KnowledgebaseCategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KnowledgebaseCategoryModelImplCopyWith<_$KnowledgebaseCategoryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
