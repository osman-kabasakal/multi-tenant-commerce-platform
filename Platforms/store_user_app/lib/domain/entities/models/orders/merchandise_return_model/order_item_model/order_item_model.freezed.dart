// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return _OrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrderItemModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'VendorId', includeIfNull: false)
  String? get vendorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'VendorName', includeIfNull: false)
  String? get vendorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  String? get attributeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  String? get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'IncludingTax', includeIfNull: false)
  bool? get includingTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'MerchandiseReturnReasonId', includeIfNull: false)
  String? get merchandiseReturnReasonId => throw _privateConstructorUsedError;
  @JsonKey(name: 'MerchandiseReturnActionId', includeIfNull: false)
  String? get merchandiseReturnActionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
    OrderItemModel value,
    $Res Function(OrderItemModel) then,
  ) = _$OrderItemModelCopyWithImpl<$Res, OrderItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) String? vendorName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) String? attributeInfo,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
    @JsonKey(name: 'IncludingTax', includeIfNull: false) bool? includingTax,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'MerchandiseReturnReasonId', includeIfNull: false)
    String? merchandiseReturnReasonId,
    @JsonKey(name: 'MerchandiseReturnActionId', includeIfNull: false)
    String? merchandiseReturnActionId,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res, $Val extends OrderItemModel>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? productName = freezed,
    Object? vendorId = freezed,
    Object? vendorName = freezed,
    Object? productSeName = freezed,
    Object? attributeInfo = freezed,
    Object? unitPrice = freezed,
    Object? includingTax = freezed,
    Object? quantity = freezed,
    Object? merchandiseReturnReasonId = freezed,
    Object? merchandiseReturnActionId = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            vendorId:
                freezed == vendorId
                    ? _value.vendorId
                    : vendorId // ignore: cast_nullable_to_non_nullable
                        as String?,
            vendorName:
                freezed == vendorName
                    ? _value.vendorName
                    : vendorName // ignore: cast_nullable_to_non_nullable
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
            unitPrice:
                freezed == unitPrice
                    ? _value.unitPrice
                    : unitPrice // ignore: cast_nullable_to_non_nullable
                        as String?,
            includingTax:
                freezed == includingTax
                    ? _value.includingTax
                    : includingTax // ignore: cast_nullable_to_non_nullable
                        as bool?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            merchandiseReturnReasonId:
                freezed == merchandiseReturnReasonId
                    ? _value.merchandiseReturnReasonId
                    : merchandiseReturnReasonId // ignore: cast_nullable_to_non_nullable
                        as String?,
            merchandiseReturnActionId:
                freezed == merchandiseReturnActionId
                    ? _value.merchandiseReturnActionId
                    : merchandiseReturnActionId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$OrderItemModelImplCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$$OrderItemModelImplCopyWith(
    _$OrderItemModelImpl value,
    $Res Function(_$OrderItemModelImpl) then,
  ) = __$$OrderItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'VendorId', includeIfNull: false) String? vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) String? vendorName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) String? attributeInfo,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
    @JsonKey(name: 'IncludingTax', includeIfNull: false) bool? includingTax,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'MerchandiseReturnReasonId', includeIfNull: false)
    String? merchandiseReturnReasonId,
    @JsonKey(name: 'MerchandiseReturnActionId', includeIfNull: false)
    String? merchandiseReturnActionId,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$OrderItemModelImplCopyWithImpl<$Res>
    extends _$OrderItemModelCopyWithImpl<$Res, _$OrderItemModelImpl>
    implements _$$OrderItemModelImplCopyWith<$Res> {
  __$$OrderItemModelImplCopyWithImpl(
    _$OrderItemModelImpl _value,
    $Res Function(_$OrderItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? productName = freezed,
    Object? vendorId = freezed,
    Object? vendorName = freezed,
    Object? productSeName = freezed,
    Object? attributeInfo = freezed,
    Object? unitPrice = freezed,
    Object? includingTax = freezed,
    Object? quantity = freezed,
    Object? merchandiseReturnReasonId = freezed,
    Object? merchandiseReturnActionId = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$OrderItemModelImpl(
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
        vendorId:
            freezed == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                    as String?,
        vendorName:
            freezed == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
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
        unitPrice:
            freezed == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                    as String?,
        includingTax:
            freezed == includingTax
                ? _value.includingTax
                : includingTax // ignore: cast_nullable_to_non_nullable
                    as bool?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        merchandiseReturnReasonId:
            freezed == merchandiseReturnReasonId
                ? _value.merchandiseReturnReasonId
                : merchandiseReturnReasonId // ignore: cast_nullable_to_non_nullable
                    as String?,
        merchandiseReturnActionId:
            freezed == merchandiseReturnActionId
                ? _value.merchandiseReturnActionId
                : merchandiseReturnActionId // ignore: cast_nullable_to_non_nullable
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
class _$OrderItemModelImpl implements _OrderItemModel {
  _$OrderItemModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'VendorId', includeIfNull: false) this.vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) this.vendorName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) this.attributeInfo,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) this.unitPrice,
    @JsonKey(name: 'IncludingTax', includeIfNull: false)
    this.includingTax = false,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'MerchandiseReturnReasonId', includeIfNull: false)
    this.merchandiseReturnReasonId,
    @JsonKey(name: 'MerchandiseReturnActionId', includeIfNull: false)
    this.merchandiseReturnActionId,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  final String? productName;
  @override
  @JsonKey(name: 'VendorId', includeIfNull: false)
  final String? vendorId;
  @override
  @JsonKey(name: 'VendorName', includeIfNull: false)
  final String? vendorName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  final String? productSeName;
  @override
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  final String? attributeInfo;
  @override
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  final String? unitPrice;
  @override
  @JsonKey(name: 'IncludingTax', includeIfNull: false)
  final bool? includingTax;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
  @override
  @JsonKey(name: 'MerchandiseReturnReasonId', includeIfNull: false)
  final String? merchandiseReturnReasonId;
  @override
  @JsonKey(name: 'MerchandiseReturnActionId', includeIfNull: false)
  final String? merchandiseReturnActionId;
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
    return 'OrderItemModel(productId: $productId, productName: $productName, vendorId: $vendorId, vendorName: $vendorName, productSeName: $productSeName, attributeInfo: $attributeInfo, unitPrice: $unitPrice, includingTax: $includingTax, quantity: $quantity, merchandiseReturnReasonId: $merchandiseReturnReasonId, merchandiseReturnActionId: $merchandiseReturnActionId, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            (identical(other.attributeInfo, attributeInfo) ||
                other.attributeInfo == attributeInfo) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.includingTax, includingTax) ||
                other.includingTax == includingTax) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(
                  other.merchandiseReturnReasonId,
                  merchandiseReturnReasonId,
                ) ||
                other.merchandiseReturnReasonId == merchandiseReturnReasonId) &&
            (identical(
                  other.merchandiseReturnActionId,
                  merchandiseReturnActionId,
                ) ||
                other.merchandiseReturnActionId == merchandiseReturnActionId) &&
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
    productId,
    productName,
    vendorId,
    vendorName,
    productSeName,
    attributeInfo,
    unitPrice,
    includingTax,
    quantity,
    merchandiseReturnReasonId,
    merchandiseReturnActionId,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      __$$OrderItemModelImplCopyWithImpl<_$OrderItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemModelImplToJson(this);
  }
}

abstract class _OrderItemModel implements OrderItemModel {
  factory _OrderItemModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'VendorId', includeIfNull: false) final String? vendorId,
    @JsonKey(name: 'VendorName', includeIfNull: false) final String? vendorName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false)
    final String? attributeInfo,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) final String? unitPrice,
    @JsonKey(name: 'IncludingTax', includeIfNull: false)
    final bool? includingTax,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'MerchandiseReturnReasonId', includeIfNull: false)
    final String? merchandiseReturnReasonId,
    @JsonKey(name: 'MerchandiseReturnActionId', includeIfNull: false)
    final String? merchandiseReturnActionId,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$OrderItemModelImpl;

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName;
  @override
  @JsonKey(name: 'VendorId', includeIfNull: false)
  String? get vendorId;
  @override
  @JsonKey(name: 'VendorName', includeIfNull: false)
  String? get vendorName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName;
  @override
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  String? get attributeInfo;
  @override
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  String? get unitPrice;
  @override
  @JsonKey(name: 'IncludingTax', includeIfNull: false)
  bool? get includingTax;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'MerchandiseReturnReasonId', includeIfNull: false)
  String? get merchandiseReturnReasonId;
  @override
  @JsonKey(name: 'MerchandiseReturnActionId', includeIfNull: false)
  String? get merchandiseReturnActionId;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
