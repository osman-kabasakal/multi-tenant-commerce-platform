// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CollectionListModel _$CollectionListModelFromJson(Map<String, dynamic> json) {
  return _CollectionListModel.fromJson(json);
}

/// @nodoc
mixin _$CollectionListModel {
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  CollectionPagingModel? get pagingModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'CollectionModel', includeIfNull: false)
  List<CollectionModel>? get collectionModel =>
      throw _privateConstructorUsedError;

  /// Serializes this CollectionListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CollectionListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollectionListModelCopyWith<CollectionListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionListModelCopyWith<$Res> {
  factory $CollectionListModelCopyWith(
    CollectionListModel value,
    $Res Function(CollectionListModel) then,
  ) = _$CollectionListModelCopyWithImpl<$Res, CollectionListModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    CollectionPagingModel? pagingModel,
    @JsonKey(name: 'CollectionModel', includeIfNull: false)
    List<CollectionModel>? collectionModel,
  });

  $CollectionPagingModelCopyWith<$Res>? get pagingModel;
}

/// @nodoc
class _$CollectionListModelCopyWithImpl<$Res, $Val extends CollectionListModel>
    implements $CollectionListModelCopyWith<$Res> {
  _$CollectionListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CollectionListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagingModel = freezed,
    Object? collectionModel = freezed,
  }) {
    return _then(
      _value.copyWith(
            pagingModel:
                freezed == pagingModel
                    ? _value.pagingModel
                    : pagingModel // ignore: cast_nullable_to_non_nullable
                        as CollectionPagingModel?,
            collectionModel:
                freezed == collectionModel
                    ? _value.collectionModel
                    : collectionModel // ignore: cast_nullable_to_non_nullable
                        as List<CollectionModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of CollectionListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CollectionPagingModelCopyWith<$Res>? get pagingModel {
    if (_value.pagingModel == null) {
      return null;
    }

    return $CollectionPagingModelCopyWith<$Res>(_value.pagingModel!, (value) {
      return _then(_value.copyWith(pagingModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CollectionListModelImplCopyWith<$Res>
    implements $CollectionListModelCopyWith<$Res> {
  factory _$$CollectionListModelImplCopyWith(
    _$CollectionListModelImpl value,
    $Res Function(_$CollectionListModelImpl) then,
  ) = __$$CollectionListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    CollectionPagingModel? pagingModel,
    @JsonKey(name: 'CollectionModel', includeIfNull: false)
    List<CollectionModel>? collectionModel,
  });

  @override
  $CollectionPagingModelCopyWith<$Res>? get pagingModel;
}

/// @nodoc
class __$$CollectionListModelImplCopyWithImpl<$Res>
    extends _$CollectionListModelCopyWithImpl<$Res, _$CollectionListModelImpl>
    implements _$$CollectionListModelImplCopyWith<$Res> {
  __$$CollectionListModelImplCopyWithImpl(
    _$CollectionListModelImpl _value,
    $Res Function(_$CollectionListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CollectionListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagingModel = freezed,
    Object? collectionModel = freezed,
  }) {
    return _then(
      _$CollectionListModelImpl(
        pagingModel:
            freezed == pagingModel
                ? _value.pagingModel
                : pagingModel // ignore: cast_nullable_to_non_nullable
                    as CollectionPagingModel?,
        collectionModel:
            freezed == collectionModel
                ? _value._collectionModel
                : collectionModel // ignore: cast_nullable_to_non_nullable
                    as List<CollectionModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionListModelImpl implements _CollectionListModel {
  _$CollectionListModelImpl({
    @JsonKey(name: 'PagingModel', includeIfNull: false) this.pagingModel,
    @JsonKey(name: 'CollectionModel', includeIfNull: false)
    final List<CollectionModel>? collectionModel = const [],
  }) : _collectionModel = collectionModel;

  factory _$CollectionListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionListModelImplFromJson(json);

  @override
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  final CollectionPagingModel? pagingModel;
  final List<CollectionModel>? _collectionModel;
  @override
  @JsonKey(name: 'CollectionModel', includeIfNull: false)
  List<CollectionModel>? get collectionModel {
    final value = _collectionModel;
    if (value == null) return null;
    if (_collectionModel is EqualUnmodifiableListView) return _collectionModel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CollectionListModel(pagingModel: $pagingModel, collectionModel: $collectionModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionListModelImpl &&
            (identical(other.pagingModel, pagingModel) ||
                other.pagingModel == pagingModel) &&
            const DeepCollectionEquality().equals(
              other._collectionModel,
              _collectionModel,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pagingModel,
    const DeepCollectionEquality().hash(_collectionModel),
  );

  /// Create a copy of CollectionListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionListModelImplCopyWith<_$CollectionListModelImpl> get copyWith =>
      __$$CollectionListModelImplCopyWithImpl<_$CollectionListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionListModelImplToJson(this);
  }
}

abstract class _CollectionListModel implements CollectionListModel {
  factory _CollectionListModel({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    final CollectionPagingModel? pagingModel,
    @JsonKey(name: 'CollectionModel', includeIfNull: false)
    final List<CollectionModel>? collectionModel,
  }) = _$CollectionListModelImpl;

  factory _CollectionListModel.fromJson(Map<String, dynamic> json) =
      _$CollectionListModelImpl.fromJson;

  @override
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  CollectionPagingModel? get pagingModel;
  @override
  @JsonKey(name: 'CollectionModel', includeIfNull: false)
  List<CollectionModel>? get collectionModel;

  /// Create a copy of CollectionListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectionListModelImplCopyWith<_$CollectionListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
