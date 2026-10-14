// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knowledgebase_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KnowledgebaseItemModel _$KnowledgebaseItemModelFromJson(
  Map<String, dynamic> json,
) {
  return _KnowledgebaseItemModel.fromJson(json);
}

/// @nodoc
mixin _$KnowledgebaseItemModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsArticle', includeIfNull: false)
  bool? get isArticle => throw _privateConstructorUsedError;
  @JsonKey(name: 'FormattedBreadcrumbs', includeIfNull: false)
  String? get formattedBreadcrumbs => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this KnowledgebaseItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KnowledgebaseItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KnowledgebaseItemModelCopyWith<KnowledgebaseItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KnowledgebaseItemModelCopyWith<$Res> {
  factory $KnowledgebaseItemModelCopyWith(
    KnowledgebaseItemModel value,
    $Res Function(KnowledgebaseItemModel) then,
  ) = _$KnowledgebaseItemModelCopyWithImpl<$Res, KnowledgebaseItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'IsArticle', includeIfNull: false) bool? isArticle,
    @JsonKey(name: 'FormattedBreadcrumbs', includeIfNull: false)
    String? formattedBreadcrumbs,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$KnowledgebaseItemModelCopyWithImpl<
  $Res,
  $Val extends KnowledgebaseItemModel
>
    implements $KnowledgebaseItemModelCopyWith<$Res> {
  _$KnowledgebaseItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KnowledgebaseItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? isArticle = freezed,
    Object? formattedBreadcrumbs = freezed,
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
            isArticle:
                freezed == isArticle
                    ? _value.isArticle
                    : isArticle // ignore: cast_nullable_to_non_nullable
                        as bool?,
            formattedBreadcrumbs:
                freezed == formattedBreadcrumbs
                    ? _value.formattedBreadcrumbs
                    : formattedBreadcrumbs // ignore: cast_nullable_to_non_nullable
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
abstract class _$$KnowledgebaseItemModelImplCopyWith<$Res>
    implements $KnowledgebaseItemModelCopyWith<$Res> {
  factory _$$KnowledgebaseItemModelImplCopyWith(
    _$KnowledgebaseItemModelImpl value,
    $Res Function(_$KnowledgebaseItemModelImpl) then,
  ) = __$$KnowledgebaseItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'IsArticle', includeIfNull: false) bool? isArticle,
    @JsonKey(name: 'FormattedBreadcrumbs', includeIfNull: false)
    String? formattedBreadcrumbs,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$KnowledgebaseItemModelImplCopyWithImpl<$Res>
    extends
        _$KnowledgebaseItemModelCopyWithImpl<$Res, _$KnowledgebaseItemModelImpl>
    implements _$$KnowledgebaseItemModelImplCopyWith<$Res> {
  __$$KnowledgebaseItemModelImplCopyWithImpl(
    _$KnowledgebaseItemModelImpl _value,
    $Res Function(_$KnowledgebaseItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KnowledgebaseItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? seName = freezed,
    Object? isArticle = freezed,
    Object? formattedBreadcrumbs = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$KnowledgebaseItemModelImpl(
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
        isArticle:
            freezed == isArticle
                ? _value.isArticle
                : isArticle // ignore: cast_nullable_to_non_nullable
                    as bool?,
        formattedBreadcrumbs:
            freezed == formattedBreadcrumbs
                ? _value.formattedBreadcrumbs
                : formattedBreadcrumbs // ignore: cast_nullable_to_non_nullable
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
class _$KnowledgebaseItemModelImpl implements _KnowledgebaseItemModel {
  _$KnowledgebaseItemModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'IsArticle', includeIfNull: false) this.isArticle = false,
    @JsonKey(name: 'FormattedBreadcrumbs', includeIfNull: false)
    this.formattedBreadcrumbs,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$KnowledgebaseItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$KnowledgebaseItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
  @override
  @JsonKey(name: 'IsArticle', includeIfNull: false)
  final bool? isArticle;
  @override
  @JsonKey(name: 'FormattedBreadcrumbs', includeIfNull: false)
  final String? formattedBreadcrumbs;
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
    return 'KnowledgebaseItemModel(name: $name, seName: $seName, isArticle: $isArticle, formattedBreadcrumbs: $formattedBreadcrumbs, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KnowledgebaseItemModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.isArticle, isArticle) ||
                other.isArticle == isArticle) &&
            (identical(other.formattedBreadcrumbs, formattedBreadcrumbs) ||
                other.formattedBreadcrumbs == formattedBreadcrumbs) &&
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
    isArticle,
    formattedBreadcrumbs,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of KnowledgebaseItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KnowledgebaseItemModelImplCopyWith<_$KnowledgebaseItemModelImpl>
  get copyWith =>
      __$$KnowledgebaseItemModelImplCopyWithImpl<_$KnowledgebaseItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KnowledgebaseItemModelImplToJson(this);
  }
}

abstract class _KnowledgebaseItemModel implements KnowledgebaseItemModel {
  factory _KnowledgebaseItemModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'IsArticle', includeIfNull: false) final bool? isArticle,
    @JsonKey(name: 'FormattedBreadcrumbs', includeIfNull: false)
    final String? formattedBreadcrumbs,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$KnowledgebaseItemModelImpl;

  factory _KnowledgebaseItemModel.fromJson(Map<String, dynamic> json) =
      _$KnowledgebaseItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'IsArticle', includeIfNull: false)
  bool? get isArticle;
  @override
  @JsonKey(name: 'FormattedBreadcrumbs', includeIfNull: false)
  String? get formattedBreadcrumbs;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of KnowledgebaseItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KnowledgebaseItemModelImplCopyWith<_$KnowledgebaseItemModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
