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
  @JsonKey(name: 'OrderItemGuid', includeIfNull: false)
  String? get orderItemGuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'Sku', includeIfNull: false)
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Picture', includeIfNull: false)
  PictureModel? get picture => throw _privateConstructorUsedError;
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  String? get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'UnitPriceIncludingTax', includeIfNull: false)
  bool? get unitPriceIncludingTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'UnitPriceValue', includeIfNull: false)
  double? get unitPriceValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'UnitPriceWithoutDiscount', includeIfNull: false)
  String? get unitPriceWithoutDiscount => throw _privateConstructorUsedError;
  @JsonKey(name: 'UnitPriceWithoutDiscountValue', includeIfNull: false)
  double? get unitPriceWithoutDiscountValue =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  String? get subTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'Discount', includeIfNull: false)
  String? get discount => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  String? get attributeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'RentalInfo', includeIfNull: false)
  String? get rentalInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  String? get downloadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'LicenseId', includeIfNull: false)
  String? get licenseId => throw _privateConstructorUsedError;
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
    @JsonKey(name: 'OrderItemGuid', includeIfNull: false) String? orderItemGuid,
    @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'Picture', includeIfNull: false) PictureModel? picture,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
    @JsonKey(name: 'UnitPriceIncludingTax', includeIfNull: false)
    bool? unitPriceIncludingTax,
    @JsonKey(name: 'UnitPriceValue', includeIfNull: false)
    double? unitPriceValue,
    @JsonKey(name: 'UnitPriceWithoutDiscount', includeIfNull: false)
    String? unitPriceWithoutDiscount,
    @JsonKey(name: 'UnitPriceWithoutDiscountValue', includeIfNull: false)
    double? unitPriceWithoutDiscountValue,
    @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
    @JsonKey(name: 'Discount', includeIfNull: false) String? discount,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) String? attributeInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) String? rentalInfo,
    @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
    @JsonKey(name: 'LicenseId', includeIfNull: false) String? licenseId,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $PictureModelCopyWith<$Res>? get picture;
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
    Object? orderItemGuid = freezed,
    Object? sku = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? picture = freezed,
    Object? unitPrice = freezed,
    Object? unitPriceIncludingTax = freezed,
    Object? unitPriceValue = freezed,
    Object? unitPriceWithoutDiscount = freezed,
    Object? unitPriceWithoutDiscountValue = freezed,
    Object? subTotal = freezed,
    Object? discount = freezed,
    Object? quantity = freezed,
    Object? attributeInfo = freezed,
    Object? rentalInfo = freezed,
    Object? downloadId = freezed,
    Object? licenseId = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            orderItemGuid:
                freezed == orderItemGuid
                    ? _value.orderItemGuid
                    : orderItemGuid // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            picture:
                freezed == picture
                    ? _value.picture
                    : picture // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            unitPrice:
                freezed == unitPrice
                    ? _value.unitPrice
                    : unitPrice // ignore: cast_nullable_to_non_nullable
                        as String?,
            unitPriceIncludingTax:
                freezed == unitPriceIncludingTax
                    ? _value.unitPriceIncludingTax
                    : unitPriceIncludingTax // ignore: cast_nullable_to_non_nullable
                        as bool?,
            unitPriceValue:
                freezed == unitPriceValue
                    ? _value.unitPriceValue
                    : unitPriceValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            unitPriceWithoutDiscount:
                freezed == unitPriceWithoutDiscount
                    ? _value.unitPriceWithoutDiscount
                    : unitPriceWithoutDiscount // ignore: cast_nullable_to_non_nullable
                        as String?,
            unitPriceWithoutDiscountValue:
                freezed == unitPriceWithoutDiscountValue
                    ? _value.unitPriceWithoutDiscountValue
                    : unitPriceWithoutDiscountValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            subTotal:
                freezed == subTotal
                    ? _value.subTotal
                    : subTotal // ignore: cast_nullable_to_non_nullable
                        as String?,
            discount:
                freezed == discount
                    ? _value.discount
                    : discount // ignore: cast_nullable_to_non_nullable
                        as String?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
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
            downloadId:
                freezed == downloadId
                    ? _value.downloadId
                    : downloadId // ignore: cast_nullable_to_non_nullable
                        as String?,
            licenseId:
                freezed == licenseId
                    ? _value.licenseId
                    : licenseId // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PictureModelCopyWith<$Res>? get picture {
    if (_value.picture == null) {
      return null;
    }

    return $PictureModelCopyWith<$Res>(_value.picture!, (value) {
      return _then(_value.copyWith(picture: value) as $Val);
    });
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
    @JsonKey(name: 'OrderItemGuid', includeIfNull: false) String? orderItemGuid,
    @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'Picture', includeIfNull: false) PictureModel? picture,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
    @JsonKey(name: 'UnitPriceIncludingTax', includeIfNull: false)
    bool? unitPriceIncludingTax,
    @JsonKey(name: 'UnitPriceValue', includeIfNull: false)
    double? unitPriceValue,
    @JsonKey(name: 'UnitPriceWithoutDiscount', includeIfNull: false)
    String? unitPriceWithoutDiscount,
    @JsonKey(name: 'UnitPriceWithoutDiscountValue', includeIfNull: false)
    double? unitPriceWithoutDiscountValue,
    @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
    @JsonKey(name: 'Discount', includeIfNull: false) String? discount,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) String? attributeInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) String? rentalInfo,
    @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
    @JsonKey(name: 'LicenseId', includeIfNull: false) String? licenseId,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $PictureModelCopyWith<$Res>? get picture;
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
    Object? orderItemGuid = freezed,
    Object? sku = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? picture = freezed,
    Object? unitPrice = freezed,
    Object? unitPriceIncludingTax = freezed,
    Object? unitPriceValue = freezed,
    Object? unitPriceWithoutDiscount = freezed,
    Object? unitPriceWithoutDiscountValue = freezed,
    Object? subTotal = freezed,
    Object? discount = freezed,
    Object? quantity = freezed,
    Object? attributeInfo = freezed,
    Object? rentalInfo = freezed,
    Object? downloadId = freezed,
    Object? licenseId = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$OrderItemModelImpl(
        orderItemGuid:
            freezed == orderItemGuid
                ? _value.orderItemGuid
                : orderItemGuid // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        picture:
            freezed == picture
                ? _value.picture
                : picture // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
        unitPrice:
            freezed == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                    as String?,
        unitPriceIncludingTax:
            freezed == unitPriceIncludingTax
                ? _value.unitPriceIncludingTax
                : unitPriceIncludingTax // ignore: cast_nullable_to_non_nullable
                    as bool?,
        unitPriceValue:
            freezed == unitPriceValue
                ? _value.unitPriceValue
                : unitPriceValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        unitPriceWithoutDiscount:
            freezed == unitPriceWithoutDiscount
                ? _value.unitPriceWithoutDiscount
                : unitPriceWithoutDiscount // ignore: cast_nullable_to_non_nullable
                    as String?,
        unitPriceWithoutDiscountValue:
            freezed == unitPriceWithoutDiscountValue
                ? _value.unitPriceWithoutDiscountValue
                : unitPriceWithoutDiscountValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        subTotal:
            freezed == subTotal
                ? _value.subTotal
                : subTotal // ignore: cast_nullable_to_non_nullable
                    as String?,
        discount:
            freezed == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                    as String?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
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
        downloadId:
            freezed == downloadId
                ? _value.downloadId
                : downloadId // ignore: cast_nullable_to_non_nullable
                    as String?,
        licenseId:
            freezed == licenseId
                ? _value.licenseId
                : licenseId // ignore: cast_nullable_to_non_nullable
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
    @JsonKey(name: 'OrderItemGuid', includeIfNull: false) this.orderItemGuid,
    @JsonKey(name: 'Sku', includeIfNull: false) this.sku,
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'Picture', includeIfNull: false) this.picture,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) this.unitPrice,
    @JsonKey(name: 'UnitPriceIncludingTax', includeIfNull: false)
    this.unitPriceIncludingTax = false,
    @JsonKey(name: 'UnitPriceValue', includeIfNull: false) this.unitPriceValue,
    @JsonKey(name: 'UnitPriceWithoutDiscount', includeIfNull: false)
    this.unitPriceWithoutDiscount,
    @JsonKey(name: 'UnitPriceWithoutDiscountValue', includeIfNull: false)
    this.unitPriceWithoutDiscountValue,
    @JsonKey(name: 'SubTotal', includeIfNull: false) this.subTotal,
    @JsonKey(name: 'Discount', includeIfNull: false) this.discount,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) this.attributeInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) this.rentalInfo,
    @JsonKey(name: 'DownloadId', includeIfNull: false) this.downloadId,
    @JsonKey(name: 'LicenseId', includeIfNull: false) this.licenseId,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'OrderItemGuid', includeIfNull: false)
  final String? orderItemGuid;
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
  @JsonKey(name: 'Picture', includeIfNull: false)
  final PictureModel? picture;
  @override
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  final String? unitPrice;
  @override
  @JsonKey(name: 'UnitPriceIncludingTax', includeIfNull: false)
  final bool? unitPriceIncludingTax;
  @override
  @JsonKey(name: 'UnitPriceValue', includeIfNull: false)
  final double? unitPriceValue;
  @override
  @JsonKey(name: 'UnitPriceWithoutDiscount', includeIfNull: false)
  final String? unitPriceWithoutDiscount;
  @override
  @JsonKey(name: 'UnitPriceWithoutDiscountValue', includeIfNull: false)
  final double? unitPriceWithoutDiscountValue;
  @override
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  final String? subTotal;
  @override
  @JsonKey(name: 'Discount', includeIfNull: false)
  final String? discount;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
  @override
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  final String? attributeInfo;
  @override
  @JsonKey(name: 'RentalInfo', includeIfNull: false)
  final String? rentalInfo;
  @override
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  final String? downloadId;
  @override
  @JsonKey(name: 'LicenseId', includeIfNull: false)
  final String? licenseId;
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
    return 'OrderItemModel(orderItemGuid: $orderItemGuid, sku: $sku, productId: $productId, productName: $productName, productSeName: $productSeName, picture: $picture, unitPrice: $unitPrice, unitPriceIncludingTax: $unitPriceIncludingTax, unitPriceValue: $unitPriceValue, unitPriceWithoutDiscount: $unitPriceWithoutDiscount, unitPriceWithoutDiscountValue: $unitPriceWithoutDiscountValue, subTotal: $subTotal, discount: $discount, quantity: $quantity, attributeInfo: $attributeInfo, rentalInfo: $rentalInfo, downloadId: $downloadId, licenseId: $licenseId, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.orderItemGuid, orderItemGuid) ||
                other.orderItemGuid == orderItemGuid) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.unitPriceIncludingTax, unitPriceIncludingTax) ||
                other.unitPriceIncludingTax == unitPriceIncludingTax) &&
            (identical(other.unitPriceValue, unitPriceValue) ||
                other.unitPriceValue == unitPriceValue) &&
            (identical(
                  other.unitPriceWithoutDiscount,
                  unitPriceWithoutDiscount,
                ) ||
                other.unitPriceWithoutDiscount == unitPriceWithoutDiscount) &&
            (identical(
                  other.unitPriceWithoutDiscountValue,
                  unitPriceWithoutDiscountValue,
                ) ||
                other.unitPriceWithoutDiscountValue ==
                    unitPriceWithoutDiscountValue) &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.attributeInfo, attributeInfo) ||
                other.attributeInfo == attributeInfo) &&
            (identical(other.rentalInfo, rentalInfo) ||
                other.rentalInfo == rentalInfo) &&
            (identical(other.downloadId, downloadId) ||
                other.downloadId == downloadId) &&
            (identical(other.licenseId, licenseId) ||
                other.licenseId == licenseId) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    orderItemGuid,
    sku,
    productId,
    productName,
    productSeName,
    picture,
    unitPrice,
    unitPriceIncludingTax,
    unitPriceValue,
    unitPriceWithoutDiscount,
    unitPriceWithoutDiscountValue,
    subTotal,
    discount,
    quantity,
    attributeInfo,
    rentalInfo,
    downloadId,
    licenseId,
    id,
    const DeepCollectionEquality().hash(_userFields),
  ]);

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
    @JsonKey(name: 'OrderItemGuid', includeIfNull: false)
    final String? orderItemGuid,
    @JsonKey(name: 'Sku', includeIfNull: false) final String? sku,
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'Picture', includeIfNull: false) final PictureModel? picture,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) final String? unitPrice,
    @JsonKey(name: 'UnitPriceIncludingTax', includeIfNull: false)
    final bool? unitPriceIncludingTax,
    @JsonKey(name: 'UnitPriceValue', includeIfNull: false)
    final double? unitPriceValue,
    @JsonKey(name: 'UnitPriceWithoutDiscount', includeIfNull: false)
    final String? unitPriceWithoutDiscount,
    @JsonKey(name: 'UnitPriceWithoutDiscountValue', includeIfNull: false)
    final double? unitPriceWithoutDiscountValue,
    @JsonKey(name: 'SubTotal', includeIfNull: false) final String? subTotal,
    @JsonKey(name: 'Discount', includeIfNull: false) final String? discount,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false)
    final String? attributeInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) final String? rentalInfo,
    @JsonKey(name: 'DownloadId', includeIfNull: false) final String? downloadId,
    @JsonKey(name: 'LicenseId', includeIfNull: false) final String? licenseId,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$OrderItemModelImpl;

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'OrderItemGuid', includeIfNull: false)
  String? get orderItemGuid;
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
  @JsonKey(name: 'Picture', includeIfNull: false)
  PictureModel? get picture;
  @override
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  String? get unitPrice;
  @override
  @JsonKey(name: 'UnitPriceIncludingTax', includeIfNull: false)
  bool? get unitPriceIncludingTax;
  @override
  @JsonKey(name: 'UnitPriceValue', includeIfNull: false)
  double? get unitPriceValue;
  @override
  @JsonKey(name: 'UnitPriceWithoutDiscount', includeIfNull: false)
  String? get unitPriceWithoutDiscount;
  @override
  @JsonKey(name: 'UnitPriceWithoutDiscountValue', includeIfNull: false)
  double? get unitPriceWithoutDiscountValue;
  @override
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  String? get subTotal;
  @override
  @JsonKey(name: 'Discount', includeIfNull: false)
  String? get discount;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  String? get attributeInfo;
  @override
  @JsonKey(name: 'RentalInfo', includeIfNull: false)
  String? get rentalInfo;
  @override
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  String? get downloadId;
  @override
  @JsonKey(name: 'LicenseId', includeIfNull: false)
  String? get licenseId;
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
