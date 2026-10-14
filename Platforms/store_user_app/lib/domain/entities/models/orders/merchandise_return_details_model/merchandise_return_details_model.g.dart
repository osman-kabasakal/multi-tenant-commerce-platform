// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MerchandiseReturnDetailsModelImpl
_$$MerchandiseReturnDetailsModelImplFromJson(
  Map<String, dynamic> json,
) => _$MerchandiseReturnDetailsModelImpl(
  merchandiseReturnItems:
      (json['MerchandiseReturnItems'] as List<dynamic>?)
          ?.map(
            (e) =>
                MerchandiseReturnItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  comments: json['Comments'] as String?,
  returnNumber: (json['ReturnNumber'] as num?)?.toInt(),
  externalId: json['ExternalId'] as String?,
  merchandiseReturnStatus:
      $enumDecodeNullable(
        _$MerchandiseReturnStatusEnumMap,
        json['MerchandiseReturnStatus'],
      ) ??
      MerchandiseReturnStatus.pending,
  createdOnUtc:
      json['CreatedOnUtc'] == null
          ? null
          : DateTime.parse(json['CreatedOnUtc'] as String),
  showPickupDate: json['ShowPickupDate'] as bool? ?? false,
  showPickupAddress: json['ShowPickupAddress'] as bool? ?? false,
  pickupAddress:
      json['PickupAddress'] == null
          ? null
          : AddressModel.fromJson(
            json['PickupAddress'] as Map<String, dynamic>,
          ),
  pickupDate:
      json['PickupDate'] == null
          ? null
          : DateTime.parse(json['PickupDate'] as String),
  merchandiseReturnNotes:
      (json['MerchandiseReturnNotes'] as List<dynamic>?)
          ?.map(
            (e) => MerchandiseReturnNote.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  showAddMerchandiseReturnNote:
      json['ShowAddMerchandiseReturnNote'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MerchandiseReturnDetailsModelImplToJson(
  _$MerchandiseReturnDetailsModelImpl instance,
) => <String, dynamic>{
  if (instance.merchandiseReturnItems case final value?)
    'MerchandiseReturnItems': value,
  if (instance.comments case final value?) 'Comments': value,
  if (instance.returnNumber case final value?) 'ReturnNumber': value,
  if (instance.externalId case final value?) 'ExternalId': value,
  if (_$MerchandiseReturnStatusEnumMap[instance.merchandiseReturnStatus]
      case final value?)
    'MerchandiseReturnStatus': value,
  if (instance.createdOnUtc?.toIso8601String() case final value?)
    'CreatedOnUtc': value,
  if (instance.showPickupDate case final value?) 'ShowPickupDate': value,
  if (instance.showPickupAddress case final value?) 'ShowPickupAddress': value,
  if (instance.pickupAddress case final value?) 'PickupAddress': value,
  if (instance.pickupDate?.toIso8601String() case final value?)
    'PickupDate': value,
  if (instance.merchandiseReturnNotes case final value?)
    'MerchandiseReturnNotes': value,
  if (instance.showAddMerchandiseReturnNote case final value?)
    'ShowAddMerchandiseReturnNote': value,
  if (instance.userFields case final value?) 'UserFields': value,
};

const _$MerchandiseReturnStatusEnumMap = {
  MerchandiseReturnStatus.pending: 0,
  MerchandiseReturnStatus.accepted: 10,
  MerchandiseReturnStatus.rejected: 20,
  MerchandiseReturnStatus.cancelled: 30,
  MerchandiseReturnStatus.completed: 40,
};
