// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_bid_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddBidModel _$AddBidModelFromJson(Map<String, dynamic> json) {
  return _AddBidModel.fromJson(json);
}

/// @nodoc
mixin _$AddBidModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'HighestBidValue', includeIfNull: false)
  String? get highestBidValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  String? get warehouseId => throw _privateConstructorUsedError;

  /// Serializes this AddBidModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddBidModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddBidModelCopyWith<AddBidModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddBidModelCopyWith<$Res> {
  factory $AddBidModelCopyWith(
    AddBidModel value,
    $Res Function(AddBidModel) then,
  ) = _$AddBidModelCopyWithImpl<$Res, AddBidModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    String? highestBidValue,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
  });
}

/// @nodoc
class _$AddBidModelCopyWithImpl<$Res, $Val extends AddBidModel>
    implements $AddBidModelCopyWith<$Res> {
  _$AddBidModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddBidModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? highestBidValue = freezed,
    Object? warehouseId = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            highestBidValue:
                freezed == highestBidValue
                    ? _value.highestBidValue
                    : highestBidValue // ignore: cast_nullable_to_non_nullable
                        as String?,
            warehouseId:
                freezed == warehouseId
                    ? _value.warehouseId
                    : warehouseId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddBidModelImplCopyWith<$Res>
    implements $AddBidModelCopyWith<$Res> {
  factory _$$AddBidModelImplCopyWith(
    _$AddBidModelImpl value,
    $Res Function(_$AddBidModelImpl) then,
  ) = __$$AddBidModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    String? highestBidValue,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
  });
}

/// @nodoc
class __$$AddBidModelImplCopyWithImpl<$Res>
    extends _$AddBidModelCopyWithImpl<$Res, _$AddBidModelImpl>
    implements _$$AddBidModelImplCopyWith<$Res> {
  __$$AddBidModelImplCopyWithImpl(
    _$AddBidModelImpl _value,
    $Res Function(_$AddBidModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddBidModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? highestBidValue = freezed,
    Object? warehouseId = freezed,
  }) {
    return _then(
      _$AddBidModelImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        highestBidValue:
            freezed == highestBidValue
                ? _value.highestBidValue
                : highestBidValue // ignore: cast_nullable_to_non_nullable
                    as String?,
        warehouseId:
            freezed == warehouseId
                ? _value.warehouseId
                : warehouseId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddBidModelImpl implements _AddBidModel {
  _$AddBidModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    this.highestBidValue,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) this.warehouseId,
  });

  factory _$AddBidModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddBidModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'HighestBidValue', includeIfNull: false)
  final String? highestBidValue;
  @override
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  final String? warehouseId;

  @override
  String toString() {
    return 'AddBidModel(productId: $productId, highestBidValue: $highestBidValue, warehouseId: $warehouseId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddBidModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.highestBidValue, highestBidValue) ||
                other.highestBidValue == highestBidValue) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, highestBidValue, warehouseId);

  /// Create a copy of AddBidModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddBidModelImplCopyWith<_$AddBidModelImpl> get copyWith =>
      __$$AddBidModelImplCopyWithImpl<_$AddBidModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddBidModelImplToJson(this);
  }
}

abstract class _AddBidModel implements AddBidModel {
  factory _AddBidModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'HighestBidValue', includeIfNull: false)
    final String? highestBidValue,
    @JsonKey(name: 'WarehouseId', includeIfNull: false)
    final String? warehouseId,
  }) = _$AddBidModelImpl;

  factory _AddBidModel.fromJson(Map<String, dynamic> json) =
      _$AddBidModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'HighestBidValue', includeIfNull: false)
  String? get highestBidValue;
  @override
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  String? get warehouseId;

  /// Create a copy of AddBidModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddBidModelImplCopyWith<_$AddBidModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
