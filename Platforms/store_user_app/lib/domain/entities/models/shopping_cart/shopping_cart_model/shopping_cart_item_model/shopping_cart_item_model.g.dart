// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingCartItemModelImpl _$$ShoppingCartItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShoppingCartItemModelImpl(
  sku: json['Sku'] as String?,
  isCart: json['IsCart'] as bool? ?? false,
  picture:
      json['Picture'] == null
          ? null
          : PictureModel.fromJson(json['Picture'] as Map<String, dynamic>),
  productId: json['ProductId'] as String?,
  productName: json['ProductName'] as String?,
  productSeName: json['ProductSeName'] as String?,
  productUrl: json['ProductUrl'] as String?,
  warehouseId: json['WarehouseId'] as String?,
  warehouseName: json['WarehouseName'] as String?,
  warehouseCode: json['WarehouseCode'] as String?,
  vendorId: json['VendorId'] as String?,
  vendorName: json['VendorName'] as String?,
  vendorSeName: json['VendorSeName'] as String?,
  unitPriceWithoutDiscount: json['UnitPriceWithoutDiscount'] as String?,
  unitPriceWithoutDiscountValue:
      (json['UnitPriceWithoutDiscountValue'] as num?)?.toDouble(),
  unitPrice: json['UnitPrice'] as String?,
  unitPriceValue: (json['UnitPriceValue'] as num?)?.toDouble(),
  subTotal: json['SubTotal'] as String?,
  subTotalValue: (json['SubTotalValue'] as num?)?.toDouble(),
  discount: json['Discount'] as String?,
  discountedQty: (json['DiscountedQty'] as num?)?.toInt(),
  discounts:
      (json['Discounts'] as List<dynamic>?)?.map((e) => e as String).toSet() ??
      const <String>{},
  quantity: (json['Quantity'] as num?)?.toInt(),
  allowedQuantities:
      (json['AllowedQuantities'] as List<dynamic>?)
          ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  attributeInfo: json['AttributeInfo'] as String?,
  recurringInfo: json['RecurringInfo'] as String?,
  allowItemEditing: json['AllowItemEditing'] as bool? ?? false,
  disableRemoval: json['DisableRemoval'] as bool? ?? false,
  reservationInfo: json['ReservationInfo'] as String?,
  auctionInfo: json['AuctionInfo'] as String?,
  parameter: json['Parameter'] as String?,
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ShoppingCartItemModelImplToJson(
  _$ShoppingCartItemModelImpl instance,
) => <String, dynamic>{
  if (instance.sku case final value?) 'Sku': value,
  if (instance.isCart case final value?) 'IsCart': value,
  if (instance.picture case final value?) 'Picture': value,
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.productUrl case final value?) 'ProductUrl': value,
  if (instance.warehouseId case final value?) 'WarehouseId': value,
  if (instance.warehouseName case final value?) 'WarehouseName': value,
  if (instance.warehouseCode case final value?) 'WarehouseCode': value,
  if (instance.vendorId case final value?) 'VendorId': value,
  if (instance.vendorName case final value?) 'VendorName': value,
  if (instance.vendorSeName case final value?) 'VendorSeName': value,
  if (instance.unitPriceWithoutDiscount case final value?)
    'UnitPriceWithoutDiscount': value,
  if (instance.unitPriceWithoutDiscountValue case final value?)
    'UnitPriceWithoutDiscountValue': value,
  if (instance.unitPrice case final value?) 'UnitPrice': value,
  if (instance.unitPriceValue case final value?) 'UnitPriceValue': value,
  if (instance.subTotal case final value?) 'SubTotal': value,
  if (instance.subTotalValue case final value?) 'SubTotalValue': value,
  if (instance.discount case final value?) 'Discount': value,
  if (instance.discountedQty case final value?) 'DiscountedQty': value,
  if (instance.discounts?.toList() case final value?) 'Discounts': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (instance.allowedQuantities case final value?) 'AllowedQuantities': value,
  if (instance.attributeInfo case final value?) 'AttributeInfo': value,
  if (instance.recurringInfo case final value?) 'RecurringInfo': value,
  if (instance.allowItemEditing case final value?) 'AllowItemEditing': value,
  if (instance.disableRemoval case final value?) 'DisableRemoval': value,
  if (instance.reservationInfo case final value?) 'ReservationInfo': value,
  if (instance.auctionInfo case final value?) 'AuctionInfo': value,
  if (instance.parameter case final value?) 'Parameter': value,
  if (instance.warnings case final value?) 'Warnings': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
