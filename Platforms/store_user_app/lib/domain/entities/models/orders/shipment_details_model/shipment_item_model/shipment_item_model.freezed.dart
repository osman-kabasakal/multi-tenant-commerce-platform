// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipment_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShipmentItemModel _$ShipmentItemModelFromJson(Map<String, dynamic> json) {
  return _ShipmentItemModel.fromJson(json);
}

/// @nodoc
mixin _$ShipmentItemModel {
  @JsonKey(name: 'Sku', includeIfNull: false)
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  String? get attributeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'RentalInfo', includeIfNull: false)
  String? get rentalInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'QuantityOrdered', includeIfNull: false)
  int? get quantityOrdered => throw _privateConstructorUsedError;
  @JsonKey(name: 'QuantityShipped', includeIfNull: false)
  int? get quantityShipped => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ShipmentItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentItemModelCopyWith<ShipmentItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentItemModelCopyWith<$Res> {
  factory $ShipmentItemModelCopyWith(
    ShipmentItemModel value,
    $Res Function(ShipmentItemModel) then,
  ) = _$ShipmentItemModelCopyWithImpl<$Res, ShipmentItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) String? attributeInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) String? rentalInfo,
    @JsonKey(name: 'QuantityOrdered', includeIfNull: false)
    int? quantityOrdered,
    @JsonKey(name: 'QuantityShipped', includeIfNull: false)
    int? quantityShipped,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ShipmentItemModelCopyWithImpl<$Res, $Val extends ShipmentItemModel>
    implements $ShipmentItemModelCopyWith<$Res> {
  _$ShipmentItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sku = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? attributeInfo = freezed,
    Object? rentalInfo = freezed,
    Object? quantityOrdered = freezed,
    Object? quantityShipped = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            sku:
                freezed == sku
                    ? _value.sku
                    : sku // ignore: cast_nullable_to_non_nullable
                        as String?,
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            productName:
                freezed == productName
                    ? _value.productName
                    : productName // ignore: cast_nullable_to_non_nullable
                        as String?,
            productSeName:
                freezed == productSeName
                    ? _value.productSeName
                    : productSeName // ignore: cast_nullable_to_non_nullable
                        as String?,
            attributeInfo:
                freezed == attributeInfo
                    ? _value.attributeInfo
                    : attributeInfo // ignore: cast_nullable_to_non_nullable
                        as String?,
            rentalInfo:
                freezed == rentalInfo
                    ? _value.rentalInfo
                    : rentalInfo // ignore: cast_nullable_to_non_nullable
                        as String?,
            quantityOrdered:
                freezed == quantityOrdered
                    ? _value.quantityOrdered
                    : quantityOrdered // ignore: cast_nullable_to_non_nullable
                        as int?,
            quantityShipped:
                freezed == quantityShipped
                    ? _value.quantityShipped
                    : quantityShipped // ignore: cast_nullable_to_non_nullable
                        as int?,
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
abstract class _$$ShipmentItemModelImplCopyWith<$Res>
    implements $ShipmentItemModelCopyWith<$Res> {
  factory _$$ShipmentItemModelImplCopyWith(
    _$ShipmentItemModelImpl value,
    $Res Function(_$ShipmentItemModelImpl) then,
  ) = __$$ShipmentItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) String? attributeInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) String? rentalInfo,
    @JsonKey(name: 'QuantityOrdered', includeIfNull: false)
    int? quantityOrdered,
    @JsonKey(name: 'QuantityShipped', includeIfNull: false)
    int? quantityShipped,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ShipmentItemModelImplCopyWithImpl<$Res>
    extends _$ShipmentItemModelCopyWithImpl<$Res, _$ShipmentItemModelImpl>
    implements _$$ShipmentItemModelImplCopyWith<$Res> {
  __$$ShipmentItemModelImplCopyWithImpl(
    _$ShipmentItemModelImpl _value,
    $Res Function(_$ShipmentItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShipmentItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sku = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? attributeInfo = freezed,
    Object? rentalInfo = freezed,
    Object? quantityOrdered = freezed,
    Object? quantityShipped = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ShipmentItemModelImpl(
        sku:
            freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                    as String?,
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        productName:
            freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                    as String?,
        productSeName:
            freezed == productSeName
                ? _value.productSeName
                : productSeName // ignore: cast_nullable_to_non_nullable
                    as String?,
        attributeInfo:
            freezed == attributeInfo
                ? _value.attributeInfo
                : attributeInfo // ignore: cast_nullable_to_non_nullable
                    as String?,
        rentalInfo:
            freezed == rentalInfo
                ? _value.rentalInfo
                : rentalInfo // ignore: cast_nullable_to_non_nullable
                    as String?,
        quantityOrdered:
            freezed == quantityOrdered
                ? _value.quantityOrdered
                : quantityOrdered // ignore: cast_nullable_to_non_nullable
                    as int?,
        quantityShipped:
            freezed == quantityShipped
                ? _value.quantityShipped
                : quantityShipped // ignore: cast_nullable_to_non_nullable
                    as int?,
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
class _$ShipmentItemModelImpl implements _ShipmentItemModel {
  _$ShipmentItemModelImpl({
    @JsonKey(name: 'Sku', includeIfNull: false) this.sku,
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) this.attributeInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) this.rentalInfo,
    @JsonKey(name: 'QuantityOrdered', includeIfNull: false)
    this.quantityOrdered,
    @JsonKey(name: 'QuantityShipped', includeIfNull: false)
    this.quantityShipped,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ShipmentItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'Sku', includeIfNull: false)
  final String? sku;
  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  final String? productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  final String? productSeName;
  @override
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  final String? attributeInfo;
  @override
  @JsonKey(name: 'RentalInfo', includeIfNull: false)
  final String? rentalInfo;
  @override
  @JsonKey(name: 'QuantityOrdered', includeIfNull: false)
  final int? quantityOrdered;
  @override
  @JsonKey(name: 'QuantityShipped', includeIfNull: false)
  final int? quantityShipped;
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
    return 'ShipmentItemModel(sku: $sku, productId: $productId, productName: $productName, productSeName: $productSeName, attributeInfo: $attributeInfo, rentalInfo: $rentalInfo, quantityOrdered: $quantityOrdered, quantityShipped: $quantityShipped, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentItemModelImpl &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            (identical(other.attributeInfo, attributeInfo) ||
                other.attributeInfo == attributeInfo) &&
            (identical(other.rentalInfo, rentalInfo) ||
                other.rentalInfo == rentalInfo) &&
            (identical(other.quantityOrdered, quantityOrdered) ||
                other.quantityOrdered == quantityOrdered) &&
            (identical(other.quantityShipped, quantityShipped) ||
                other.quantityShipped == quantityShipped) &&
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
    sku,
    productId,
    productName,
    productSeName,
    attributeInfo,
    rentalInfo,
    quantityOrdered,
    quantityShipped,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ShipmentItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentItemModelImplCopyWith<_$ShipmentItemModelImpl> get copyWith =>
      __$$ShipmentItemModelImplCopyWithImpl<_$ShipmentItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentItemModelImplToJson(this);
  }
}

abstract class _ShipmentItemModel implements ShipmentItemModel {
  factory _ShipmentItemModel({
    @JsonKey(name: 'Sku', includeIfNull: false) final String? sku,
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false)
    final String? attributeInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) final String? rentalInfo,
    @JsonKey(name: 'QuantityOrdered', includeIfNull: false)
    final int? quantityOrdered,
    @JsonKey(name: 'QuantityShipped', includeIfNull: false)
    final int? quantityShipped,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ShipmentItemModelImpl;

  factory _ShipmentItemModel.fromJson(Map<String, dynamic> json) =
      _$ShipmentItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'Sku', includeIfNull: false)
  String? get sku;
  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName;
  @override
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  String? get attributeInfo;
  @override
  @JsonKey(name: 'RentalInfo', includeIfNull: false)
  String? get rentalInfo;
  @override
  @JsonKey(name: 'QuantityOrdered', includeIfNull: false)
  int? get quantityOrdered;
  @override
  @JsonKey(name: 'QuantityShipped', includeIfNull: false)
  int? get quantityShipped;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ShipmentItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentItemModelImplCopyWith<_$ShipmentItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
