// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MerchandiseReturnModelImpl _$$MerchandiseReturnModelImplFromJson(
  Map<String, dynamic> json,
) => _$MerchandiseReturnModelImpl(
  orderId: json['OrderId'] as String?,
  orderNumber: (json['OrderNumber'] as num?)?.toInt(),
  orderCode: json['OrderCode'] as String?,
  items:
      (json['Items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  availableReturnReasons:
      (json['AvailableReturnReasons'] as List<dynamic>?)
          ?.map(
            (e) => MerchandiseReturnReasonModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  availableReturnActions:
      (json['AvailableReturnActions'] as List<dynamic>?)
          ?.map(
            (e) => MerchandiseReturnActionModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  comments: json['Comments'] as String?,
  pickupDate:
      json['PickupDate'] == null
          ? null
          : DateTime.parse(json['PickupDate'] as String),
  result: json['Result'] as String?,
  error: json['Error'] as String?,
  existingAddresses:
      (json['ExistingAddresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  newAddressPreselected: json['NewAddressPreselected'] as bool? ?? false,
  merchandiseReturnNewAddress:
      json['MerchandiseReturnNewAddress'] == null
          ? null
          : AddressModel.fromJson(
            json['MerchandiseReturnNewAddress'] as Map<String, dynamic>,
          ),
  pickupAddressId: json['PickupAddressId'] as String?,
  showPickupAddress: json['ShowPickupAddress'] as bool? ?? false,
  showPickupDate: json['ShowPickupDate'] as bool? ?? false,
  pickupDateRequired: json['PickupDateRequired'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MerchandiseReturnModelImplToJson(
  _$MerchandiseReturnModelImpl instance,
) => <String, dynamic>{
  if (instance.orderId case final value?) 'OrderId': value,
  if (instance.orderNumber case final value?) 'OrderNumber': value,
  if (instance.orderCode case final value?) 'OrderCode': value,
  if (instance.items case final value?) 'Items': value,
  if (instance.availableReturnReasons case final value?)
    'AvailableReturnReasons': value,
  if (instance.availableReturnActions case final value?)
    'AvailableReturnActions': value,
  if (instance.comments case final value?) 'Comments': value,
  if (instance.pickupDate?.toIso8601String() case final value?)
    'PickupDate': value,
  if (instance.result case final value?) 'Result': value,
  if (instance.error case final value?) 'Error': value,
  if (instance.existingAddresses case final value?) 'ExistingAddresses': value,
  if (instance.newAddressPreselected case final value?)
    'NewAddressPreselected': value,
  if (instance.merchandiseReturnNewAddress case final value?)
    'MerchandiseReturnNewAddress': value,
  if (instance.pickupAddressId case final value?) 'PickupAddressId': value,
  if (instance.showPickupAddress case final value?) 'ShowPickupAddress': value,
  if (instance.showPickupDate case final value?) 'ShowPickupDate': value,
  if (instance.pickupDateRequired case final value?)
    'PickupDateRequired': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
