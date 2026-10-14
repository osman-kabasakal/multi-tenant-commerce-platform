// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MerchandiseReturnModelImpl _$$MerchandiseReturnModelImplFromJson(
  Map<String, dynamic> json,
) => _$MerchandiseReturnModelImpl(
  returnNumber: (json['ReturnNumber'] as num?)?.toInt(),
  merchandiseReturnStatus: json['MerchandiseReturnStatus'] as String?,
  createdOn:
      json['CreatedOn'] == null
          ? null
          : DateTime.parse(json['CreatedOn'] as String),
  productsCount: (json['ProductsCount'] as num?)?.toInt(),
  returnTotal: json['ReturnTotal'] as String?,
  id: json['Id'] as String?,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MerchandiseReturnModelImplToJson(
  _$MerchandiseReturnModelImpl instance,
) => <String, dynamic>{
  if (instance.returnNumber case final value?) 'ReturnNumber': value,
  if (instance.merchandiseReturnStatus case final value?)
    'MerchandiseReturnStatus': value,
  if (instance.createdOn?.toIso8601String() case final value?)
    'CreatedOn': value,
  if (instance.productsCount case final value?) 'ProductsCount': value,
  if (instance.returnTotal case final value?) 'ReturnTotal': value,
  if (instance.id case final value?) 'Id': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
