// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  String? get warehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
  String? get reservationDatepickerFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
  String? get reservationDatepickerTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'LoadPicture', includeIfNull: false)
  bool? get loadPicture => throw _privateConstructorUsedError;
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes =>
      throw _privateConstructorUsedError;

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
    ProductModel value,
    $Res Function(ProductModel) then,
  ) = _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
    @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
    String? reservationDatepickerFrom,
    @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
    String? reservationDatepickerTo,
    @JsonKey(name: 'LoadPicture', includeIfNull: false) bool? loadPicture,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttributeModel>? attributes,
  });
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? warehouseId = freezed,
    Object? reservationDatepickerFrom = freezed,
    Object? reservationDatepickerTo = freezed,
    Object? loadPicture = freezed,
    Object? attributes = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            warehouseId:
                freezed == warehouseId
                    ? _value.warehouseId
                    : warehouseId // ignore: cast_nullable_to_non_nullable
                        as String?,
            reservationDatepickerFrom:
                freezed == reservationDatepickerFrom
                    ? _value.reservationDatepickerFrom
                    : reservationDatepickerFrom // ignore: cast_nullable_to_non_nullable
                        as String?,
            reservationDatepickerTo:
                freezed == reservationDatepickerTo
                    ? _value.reservationDatepickerTo
                    : reservationDatepickerTo // ignore: cast_nullable_to_non_nullable
                        as String?,
            loadPicture:
                freezed == loadPicture
                    ? _value.loadPicture
                    : loadPicture // ignore: cast_nullable_to_non_nullable
                        as bool?,
            attributes:
                freezed == attributes
                    ? _value.attributes
                    : attributes // ignore: cast_nullable_to_non_nullable
                        as List<CustomAttributeModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
    _$ProductModelImpl value,
    $Res Function(_$ProductModelImpl) then,
  ) = __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
    @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
    String? reservationDatepickerFrom,
    @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
    String? reservationDatepickerTo,
    @JsonKey(name: 'LoadPicture', includeIfNull: false) bool? loadPicture,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    List<CustomAttributeModel>? attributes,
  });
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
    _$ProductModelImpl _value,
    $Res Function(_$ProductModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? warehouseId = freezed,
    Object? reservationDatepickerFrom = freezed,
    Object? reservationDatepickerTo = freezed,
    Object? loadPicture = freezed,
    Object? attributes = freezed,
  }) {
    return _then(
      _$ProductModelImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        warehouseId:
            freezed == warehouseId
                ? _value.warehouseId
                : warehouseId // ignore: cast_nullable_to_non_nullable
                    as String?,
        reservationDatepickerFrom:
            freezed == reservationDatepickerFrom
                ? _value.reservationDatepickerFrom
                : reservationDatepickerFrom // ignore: cast_nullable_to_non_nullable
                    as String?,
        reservationDatepickerTo:
            freezed == reservationDatepickerTo
                ? _value.reservationDatepickerTo
                : reservationDatepickerTo // ignore: cast_nullable_to_non_nullable
                    as String?,
        loadPicture:
            freezed == loadPicture
                ? _value.loadPicture
                : loadPicture // ignore: cast_nullable_to_non_nullable
                    as bool?,
        attributes:
            freezed == attributes
                ? _value._attributes
                : attributes // ignore: cast_nullable_to_non_nullable
                    as List<CustomAttributeModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl implements _ProductModel {
  _$ProductModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) this.warehouseId,
    @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
    this.reservationDatepickerFrom,
    @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
    this.reservationDatepickerTo,
    @JsonKey(name: 'LoadPicture', includeIfNull: false)
    this.loadPicture = false,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttributeModel>? attributes = const [],
  }) : _attributes = attributes;

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  final String? warehouseId;
  @override
  @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
  final String? reservationDatepickerFrom;
  @override
  @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
  final String? reservationDatepickerTo;
  @override
  @JsonKey(name: 'LoadPicture', includeIfNull: false)
  final bool? loadPicture;
  final List<CustomAttributeModel>? _attributes;
  @override
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes {
    final value = _attributes;
    if (value == null) return null;
    if (_attributes is EqualUnmodifiableListView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProductModel(productId: $productId, warehouseId: $warehouseId, reservationDatepickerFrom: $reservationDatepickerFrom, reservationDatepickerTo: $reservationDatepickerTo, loadPicture: $loadPicture, attributes: $attributes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(
                  other.reservationDatepickerFrom,
                  reservationDatepickerFrom,
                ) ||
                other.reservationDatepickerFrom == reservationDatepickerFrom) &&
            (identical(
                  other.reservationDatepickerTo,
                  reservationDatepickerTo,
                ) ||
                other.reservationDatepickerTo == reservationDatepickerTo) &&
            (identical(other.loadPicture, loadPicture) ||
                other.loadPicture == loadPicture) &&
            const DeepCollectionEquality().equals(
              other._attributes,
              _attributes,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    warehouseId,
    reservationDatepickerFrom,
    reservationDatepickerTo,
    loadPicture,
    const DeepCollectionEquality().hash(_attributes),
  );

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(this);
  }
}

abstract class _ProductModel implements ProductModel {
  factory _ProductModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'WarehouseId', includeIfNull: false)
    final String? warehouseId,
    @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
    final String? reservationDatepickerFrom,
    @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
    final String? reservationDatepickerTo,
    @JsonKey(name: 'LoadPicture', includeIfNull: false) final bool? loadPicture,
    @JsonKey(name: 'Attributes', includeIfNull: false)
    final List<CustomAttributeModel>? attributes,
  }) = _$ProductModelImpl;

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  String? get warehouseId;
  @override
  @JsonKey(name: 'ReservationDatepickerFrom', includeIfNull: false)
  String? get reservationDatepickerFrom;
  @override
  @JsonKey(name: 'ReservationDatepickerTo', includeIfNull: false)
  String? get reservationDatepickerTo;
  @override
  @JsonKey(name: 'LoadPicture', includeIfNull: false)
  bool? get loadPicture;
  @override
  @JsonKey(name: 'Attributes', includeIfNull: false)
  List<CustomAttributeModel>? get attributes;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
