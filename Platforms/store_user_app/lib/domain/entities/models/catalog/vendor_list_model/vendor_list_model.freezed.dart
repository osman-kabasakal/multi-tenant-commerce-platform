// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VendorListModel _$VendorListModelFromJson(Map<String, dynamic> json) {
  return _VendorListModel.fromJson(json);
}

/// @nodoc
mixin _$VendorListModel {
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  VendorPagingModel? get pagingModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'VendorsModel', includeIfNull: false)
  List<VendorModel>? get vendorsModel => throw _privateConstructorUsedError;

  /// Serializes this VendorListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorListModelCopyWith<VendorListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorListModelCopyWith<$Res> {
  factory $VendorListModelCopyWith(
    VendorListModel value,
    $Res Function(VendorListModel) then,
  ) = _$VendorListModelCopyWithImpl<$Res, VendorListModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    VendorPagingModel? pagingModel,
    @JsonKey(name: 'VendorsModel', includeIfNull: false)
    List<VendorModel>? vendorsModel,
  });

  $VendorPagingModelCopyWith<$Res>? get pagingModel;
}

/// @nodoc
class _$VendorListModelCopyWithImpl<$Res, $Val extends VendorListModel>
    implements $VendorListModelCopyWith<$Res> {
  _$VendorListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pagingModel = freezed, Object? vendorsModel = freezed}) {
    return _then(
      _value.copyWith(
            pagingModel:
                freezed == pagingModel
                    ? _value.pagingModel
                    : pagingModel // ignore: cast_nullable_to_non_nullable
                        as VendorPagingModel?,
            vendorsModel:
                freezed == vendorsModel
                    ? _value.vendorsModel
                    : vendorsModel // ignore: cast_nullable_to_non_nullable
                        as List<VendorModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of VendorListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VendorPagingModelCopyWith<$Res>? get pagingModel {
    if (_value.pagingModel == null) {
      return null;
    }

    return $VendorPagingModelCopyWith<$Res>(_value.pagingModel!, (value) {
      return _then(_value.copyWith(pagingModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VendorListModelImplCopyWith<$Res>
    implements $VendorListModelCopyWith<$Res> {
  factory _$$VendorListModelImplCopyWith(
    _$VendorListModelImpl value,
    $Res Function(_$VendorListModelImpl) then,
  ) = __$$VendorListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    VendorPagingModel? pagingModel,
    @JsonKey(name: 'VendorsModel', includeIfNull: false)
    List<VendorModel>? vendorsModel,
  });

  @override
  $VendorPagingModelCopyWith<$Res>? get pagingModel;
}

/// @nodoc
class __$$VendorListModelImplCopyWithImpl<$Res>
    extends _$VendorListModelCopyWithImpl<$Res, _$VendorListModelImpl>
    implements _$$VendorListModelImplCopyWith<$Res> {
  __$$VendorListModelImplCopyWithImpl(
    _$VendorListModelImpl _value,
    $Res Function(_$VendorListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VendorListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pagingModel = freezed, Object? vendorsModel = freezed}) {
    return _then(
      _$VendorListModelImpl(
        pagingModel:
            freezed == pagingModel
                ? _value.pagingModel
                : pagingModel // ignore: cast_nullable_to_non_nullable
                    as VendorPagingModel?,
        vendorsModel:
            freezed == vendorsModel
                ? _value._vendorsModel
                : vendorsModel // ignore: cast_nullable_to_non_nullable
                    as List<VendorModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorListModelImpl implements _VendorListModel {
  _$VendorListModelImpl({
    @JsonKey(name: 'PagingModel', includeIfNull: false) this.pagingModel,
    @JsonKey(name: 'VendorsModel', includeIfNull: false)
    final List<VendorModel>? vendorsModel = const [],
  }) : _vendorsModel = vendorsModel;

  factory _$VendorListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorListModelImplFromJson(json);

  @override
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  final VendorPagingModel? pagingModel;
  final List<VendorModel>? _vendorsModel;
  @override
  @JsonKey(name: 'VendorsModel', includeIfNull: false)
  List<VendorModel>? get vendorsModel {
    final value = _vendorsModel;
    if (value == null) return null;
    if (_vendorsModel is EqualUnmodifiableListView) return _vendorsModel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'VendorListModel(pagingModel: $pagingModel, vendorsModel: $vendorsModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorListModelImpl &&
            (identical(other.pagingModel, pagingModel) ||
                other.pagingModel == pagingModel) &&
            const DeepCollectionEquality().equals(
              other._vendorsModel,
              _vendorsModel,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pagingModel,
    const DeepCollectionEquality().hash(_vendorsModel),
  );

  /// Create a copy of VendorListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorListModelImplCopyWith<_$VendorListModelImpl> get copyWith =>
      __$$VendorListModelImplCopyWithImpl<_$VendorListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorListModelImplToJson(this);
  }
}

abstract class _VendorListModel implements VendorListModel {
  factory _VendorListModel({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    final VendorPagingModel? pagingModel,
    @JsonKey(name: 'VendorsModel', includeIfNull: false)
    final List<VendorModel>? vendorsModel,
  }) = _$VendorListModelImpl;

  factory _VendorListModel.fromJson(Map<String, dynamic> json) =
      _$VendorListModelImpl.fromJson;

  @override
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  VendorPagingModel? get pagingModel;
  @override
  @JsonKey(name: 'VendorsModel', includeIfNull: false)
  List<VendorModel>? get vendorsModel;

  /// Create a copy of VendorListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorListModelImplCopyWith<_$VendorListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
