// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BrandListModel _$BrandListModelFromJson(Map<String, dynamic> json) {
  return _BrandListModel.fromJson(json);
}

/// @nodoc
mixin _$BrandListModel {
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  BrandPagingModel? get pagingModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'BrandsModel', includeIfNull: false)
  List<BrandModel>? get brandsModel => throw _privateConstructorUsedError;

  /// Serializes this BrandListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BrandListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrandListModelCopyWith<BrandListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrandListModelCopyWith<$Res> {
  factory $BrandListModelCopyWith(
    BrandListModel value,
    $Res Function(BrandListModel) then,
  ) = _$BrandListModelCopyWithImpl<$Res, BrandListModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    BrandPagingModel? pagingModel,
    @JsonKey(name: 'BrandsModel', includeIfNull: false)
    List<BrandModel>? brandsModel,
  });

  $BrandPagingModelCopyWith<$Res>? get pagingModel;
}

/// @nodoc
class _$BrandListModelCopyWithImpl<$Res, $Val extends BrandListModel>
    implements $BrandListModelCopyWith<$Res> {
  _$BrandListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrandListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pagingModel = freezed, Object? brandsModel = freezed}) {
    return _then(
      _value.copyWith(
            pagingModel:
                freezed == pagingModel
                    ? _value.pagingModel
                    : pagingModel // ignore: cast_nullable_to_non_nullable
                        as BrandPagingModel?,
            brandsModel:
                freezed == brandsModel
                    ? _value.brandsModel
                    : brandsModel // ignore: cast_nullable_to_non_nullable
                        as List<BrandModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of BrandListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BrandPagingModelCopyWith<$Res>? get pagingModel {
    if (_value.pagingModel == null) {
      return null;
    }

    return $BrandPagingModelCopyWith<$Res>(_value.pagingModel!, (value) {
      return _then(_value.copyWith(pagingModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BrandListModelImplCopyWith<$Res>
    implements $BrandListModelCopyWith<$Res> {
  factory _$$BrandListModelImplCopyWith(
    _$BrandListModelImpl value,
    $Res Function(_$BrandListModelImpl) then,
  ) = __$$BrandListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    BrandPagingModel? pagingModel,
    @JsonKey(name: 'BrandsModel', includeIfNull: false)
    List<BrandModel>? brandsModel,
  });

  @override
  $BrandPagingModelCopyWith<$Res>? get pagingModel;
}

/// @nodoc
class __$$BrandListModelImplCopyWithImpl<$Res>
    extends _$BrandListModelCopyWithImpl<$Res, _$BrandListModelImpl>
    implements _$$BrandListModelImplCopyWith<$Res> {
  __$$BrandListModelImplCopyWithImpl(
    _$BrandListModelImpl _value,
    $Res Function(_$BrandListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BrandListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pagingModel = freezed, Object? brandsModel = freezed}) {
    return _then(
      _$BrandListModelImpl(
        pagingModel:
            freezed == pagingModel
                ? _value.pagingModel
                : pagingModel // ignore: cast_nullable_to_non_nullable
                    as BrandPagingModel?,
        brandsModel:
            freezed == brandsModel
                ? _value._brandsModel
                : brandsModel // ignore: cast_nullable_to_non_nullable
                    as List<BrandModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BrandListModelImpl implements _BrandListModel {
  _$BrandListModelImpl({
    @JsonKey(name: 'PagingModel', includeIfNull: false) this.pagingModel,
    @JsonKey(name: 'BrandsModel', includeIfNull: false)
    final List<BrandModel>? brandsModel = const [],
  }) : _brandsModel = brandsModel;

  factory _$BrandListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrandListModelImplFromJson(json);

  @override
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  final BrandPagingModel? pagingModel;
  final List<BrandModel>? _brandsModel;
  @override
  @JsonKey(name: 'BrandsModel', includeIfNull: false)
  List<BrandModel>? get brandsModel {
    final value = _brandsModel;
    if (value == null) return null;
    if (_brandsModel is EqualUnmodifiableListView) return _brandsModel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BrandListModel(pagingModel: $pagingModel, brandsModel: $brandsModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrandListModelImpl &&
            (identical(other.pagingModel, pagingModel) ||
                other.pagingModel == pagingModel) &&
            const DeepCollectionEquality().equals(
              other._brandsModel,
              _brandsModel,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pagingModel,
    const DeepCollectionEquality().hash(_brandsModel),
  );

  /// Create a copy of BrandListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrandListModelImplCopyWith<_$BrandListModelImpl> get copyWith =>
      __$$BrandListModelImplCopyWithImpl<_$BrandListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BrandListModelImplToJson(this);
  }
}

abstract class _BrandListModel implements BrandListModel {
  factory _BrandListModel({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    final BrandPagingModel? pagingModel,
    @JsonKey(name: 'BrandsModel', includeIfNull: false)
    final List<BrandModel>? brandsModel,
  }) = _$BrandListModelImpl;

  factory _BrandListModel.fromJson(Map<String, dynamic> json) =
      _$BrandListModelImpl.fromJson;

  @override
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  BrandPagingModel? get pagingModel;
  @override
  @JsonKey(name: 'BrandsModel', includeIfNull: false)
  List<BrandModel>? get brandsModel;

  /// Create a copy of BrandListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrandListModelImplCopyWith<_$BrandListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
