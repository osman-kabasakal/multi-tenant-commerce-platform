// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
      orderItemGuid: json['OrderItemGuid'] as String?,
      sku: json['Sku'] as String?,
      productId: json['ProductId'] as String?,
      productName: json['ProductName'] as String?,
      productSeName: json['ProductSeName'] as String?,
      picture:
          json['Picture'] == null
              ? null
              : PictureModel.fromJson(json['Picture'] as Map<String, dynamic>),
      unitPrice: json['UnitPrice'] as String?,
      unitPriceIncludingTax: json['UnitPriceIncludingTax'] as bool? ?? false,
      unitPriceValue: (json['UnitPriceValue'] as num?)?.toDouble(),
      unitPriceWithoutDiscount: json['UnitPriceWithoutDiscount'] as String?,
      unitPriceWithoutDiscountValue:
          (json['UnitPriceWithoutDiscountValue'] as num?)?.toDouble(),
      subTotal: json['SubTotal'] as String?,
      discount: json['Discount'] as String?,
      quantity: (json['Quantity'] as num?)?.toInt(),
      attributeInfo: json['AttributeInfo'] as String?,
      rentalInfo: json['RentalInfo'] as String?,
      downloadId: json['DownloadId'] as String?,
      licenseId: json['LicenseId'] as String?,
      id: json['Id'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OrderItemModelImplToJson(
  _$OrderItemModelImpl instance,
) => <String, dynamic>{
  if (instance.orderItemGuid case final value?) 'OrderItemGuid': value,
  if (instance.sku case final value?) 'Sku': value,
  if (instance.productId case final value?) 'ProductId': value,
  if (instance.productName case final value?) 'ProductName': value,
  if (instance.productSeName case final value?) 'ProductSeName': value,
  if (instance.picture case final value?) 'Picture': value,
  if (instance.unitPrice case final value?) 'UnitPrice': value,
  if (instance.unitPriceIncludingTax case final value?)
    'UnitPriceIncludingTax': value,
  if (instance.unitPriceValue case final value?) 'UnitPriceValue': value,
  if (instance.unitPriceWithoutDiscount case final value?)
    'UnitPriceWithoutDiscount': value,
  if (instance.unitPriceWithoutDiscountValue case final value?)
    'UnitPriceWithoutDiscountValue': value,
  if (instance.subTotal case final value?) 'SubTotal': value,
  if (instance.discount case final value?) 'Discount': value,
  if (instance.quantity case final value?) 'Quantity': value,
  if (instance.attributeInfo case final value?) 'AttributeInfo': value,
  if (instance.rentalInfo case final value?) 'RentalInfo': value,
  if (instance.downloadId case final value?) 'DownloadId': value,
  if (instance.licenseId case final value?) 'LicenseId': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
