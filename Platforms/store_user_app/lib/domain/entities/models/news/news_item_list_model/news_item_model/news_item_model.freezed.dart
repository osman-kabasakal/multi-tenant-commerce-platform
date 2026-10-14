// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NewsItemModel _$NewsItemModelFromJson(Map<String, dynamic> json) {
  return _NewsItemModel.fromJson(json);
}

/// @nodoc
mixin _$NewsItemModel {
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'Short', includeIfNull: false)
  String? get short => throw _privateConstructorUsedError;
  @JsonKey(name: 'Full', includeIfNull: false)
  String? get full => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this NewsItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsItemModelCopyWith<NewsItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsItemModelCopyWith<$Res> {
  factory $NewsItemModelCopyWith(
    NewsItemModel value,
    $Res Function(NewsItemModel) then,
  ) = _$NewsItemModelCopyWithImpl<$Res, NewsItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'Short', includeIfNull: false) String? short,
    @JsonKey(name: 'Full', includeIfNull: false) String? full,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $PictureModelCopyWith<$Res>? get pictureModel;
}

/// @nodoc
class _$NewsItemModelCopyWithImpl<$Res, $Val extends NewsItemModel>
    implements $NewsItemModelCopyWith<$Res> {
  _$NewsItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? seName = freezed,
    Object? title = freezed,
    Object? pictureModel = freezed,
    Object? short = freezed,
    Object? full = freezed,
    Object? createdOn = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            seName:
                freezed == seName
                    ? _value.seName
                    : seName // ignore: cast_nullable_to_non_nullable
                        as String?,
            title:
                freezed == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String?,
            pictureModel:
                freezed == pictureModel
                    ? _value.pictureModel
                    : pictureModel // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            short:
                freezed == short
                    ? _value.short
                    : short // ignore: cast_nullable_to_non_nullable
                        as String?,
            full:
                freezed == full
                    ? _value.full
                    : full // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdOn:
                freezed == createdOn
                    ? _value.createdOn
                    : createdOn // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of NewsItemModel
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
abstract class _$$NewsItemModelImplCopyWith<$Res>
    implements $NewsItemModelCopyWith<$Res> {
  factory _$$NewsItemModelImplCopyWith(
    _$NewsItemModelImpl value,
    $Res Function(_$NewsItemModelImpl) then,
  ) = __$$NewsItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Title', includeIfNull: false) String? title,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    PictureModel? pictureModel,
    @JsonKey(name: 'Short', includeIfNull: false) String? short,
    @JsonKey(name: 'Full', includeIfNull: false) String? full,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $PictureModelCopyWith<$Res>? get pictureModel;
}

/// @nodoc
class __$$NewsItemModelImplCopyWithImpl<$Res>
    extends _$NewsItemModelCopyWithImpl<$Res, _$NewsItemModelImpl>
    implements _$$NewsItemModelImplCopyWith<$Res> {
  __$$NewsItemModelImplCopyWithImpl(
    _$NewsItemModelImpl _value,
    $Res Function(_$NewsItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? seName = freezed,
    Object? title = freezed,
    Object? pictureModel = freezed,
    Object? short = freezed,
    Object? full = freezed,
    Object? createdOn = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$NewsItemModelImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        seName:
            freezed == seName
                ? _value.seName
                : seName // ignore: cast_nullable_to_non_nullable
                    as String?,
        title:
            freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String?,
        pictureModel:
            freezed == pictureModel
                ? _value.pictureModel
                : pictureModel // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
        short:
            freezed == short
                ? _value.short
                : short // ignore: cast_nullable_to_non_nullable
                    as String?,
        full:
            freezed == full
                ? _value.full
                : full // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdOn:
            freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
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
class _$NewsItemModelImpl implements _NewsItemModel {
  _$NewsItemModelImpl({
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'Title', includeIfNull: false) this.title,
    @JsonKey(name: 'PictureModel', includeIfNull: false) this.pictureModel,
    @JsonKey(name: 'Short', includeIfNull: false) this.short,
    @JsonKey(name: 'Full', includeIfNull: false) this.full,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$NewsItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  final String? title;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  final PictureModel? pictureModel;
  @override
  @JsonKey(name: 'Short', includeIfNull: false)
  final String? short;
  @override
  @JsonKey(name: 'Full', includeIfNull: false)
  final String? full;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
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
    return 'NewsItemModel(id: $id, seName: $seName, title: $title, pictureModel: $pictureModel, short: $short, full: $full, createdOn: $createdOn, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.pictureModel, pictureModel) ||
                other.pictureModel == pictureModel) &&
            (identical(other.short, short) || other.short == short) &&
            (identical(other.full, full) || other.full == full) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    seName,
    title,
    pictureModel,
    short,
    full,
    createdOn,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsItemModelImplCopyWith<_$NewsItemModelImpl> get copyWith =>
      __$$NewsItemModelImplCopyWithImpl<_$NewsItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsItemModelImplToJson(this);
  }
}

abstract class _NewsItemModel implements NewsItemModel {
  factory _NewsItemModel({
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'Title', includeIfNull: false) final String? title,
    @JsonKey(name: 'PictureModel', includeIfNull: false)
    final PictureModel? pictureModel,
    @JsonKey(name: 'Short', includeIfNull: false) final String? short,
    @JsonKey(name: 'Full', includeIfNull: false) final String? full,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$NewsItemModelImpl;

  factory _NewsItemModel.fromJson(Map<String, dynamic> json) =
      _$NewsItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'Title', includeIfNull: false)
  String? get title;
  @override
  @JsonKey(name: 'PictureModel', includeIfNull: false)
  PictureModel? get pictureModel;
  @override
  @JsonKey(name: 'Short', includeIfNull: false)
  String? get short;
  @override
  @JsonKey(name: 'Full', includeIfNull: false)
  String? get full;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of NewsItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsItemModelImplCopyWith<_$NewsItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
