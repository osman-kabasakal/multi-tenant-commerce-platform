// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_review_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderReviewDataModelImpl _$$OrderReviewDataModelImplFromJson(
  Map<String, dynamic> json,
) => _$OrderReviewDataModelImpl(
  billingAddress:
      json['BillingAddress'] == null
          ? null
          : AddressModel.fromJson(
            json['BillingAddress'] as Map<String, dynamic>,
          ),
  isShippable: json['IsShippable'] as bool? ?? false,
  shippingAddress:
      json['ShippingAddress'] == null
          ? null
          : AddressModel.fromJson(
            json['ShippingAddress'] as Map<String, dynamic>,
          ),
  selectedPickUpInStore: json['SelectedPickUpInStore'] as bool? ?? false,
  pickupAddress:
      json['PickupAddress'] == null
          ? null
          : AddressModel.fromJson(
            json['PickupAddress'] as Map<String, dynamic>,
          ),
  shippingMethod: json['ShippingMethod'] as String?,
  shippingAdditionDescription: json['ShippingAdditionDescription'] as String?,
  paymentMethod: json['PaymentMethod'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OrderReviewDataModelImplToJson(
  _$OrderReviewDataModelImpl instance,
) => <String, dynamic>{
  if (instance.billingAddress case final value?) 'BillingAddress': value,
  if (instance.isShippable case final value?) 'IsShippable': value,
  if (instance.shippingAddress case final value?) 'ShippingAddress': value,
  if (instance.selectedPickUpInStore case final value?)
    'SelectedPickUpInStore': value,
  if (instance.pickupAddress case final value?) 'PickupAddress': value,
  if (instance.shippingMethod case final value?) 'ShippingMethod': value,
  if (instance.shippingAdditionDescription case final value?)
    'ShippingAdditionDescription': value,
  if (instance.paymentMethod case final value?) 'PaymentMethod': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
