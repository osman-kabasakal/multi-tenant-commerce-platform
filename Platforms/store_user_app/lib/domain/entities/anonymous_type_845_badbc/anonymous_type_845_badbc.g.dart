// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_type_845_badbc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnonymousType_845BADBCImpl _$$AnonymousType_845BADBCImplFromJson(
  Map<String, dynamic> json,
) => _$AnonymousType_845BADBCImpl(
  totalproducts: json['totalproducts'] as String?,
  model:
      json['model'] == null
          ? null
          : ShoppingCartModel.fromJson(json['model'] as Map<String, dynamic>),
  sidebarshoppingcartmodel: json['sidebarshoppingcartmodel'],
);

Map<String, dynamic> _$$AnonymousType_845BADBCImplToJson(
  _$AnonymousType_845BADBCImpl instance,
) => <String, dynamic>{
  if (instance.totalproducts case final value?) 'totalproducts': value,
  if (instance.model case final value?) 'model': value,
  if (instance.sidebarshoppingcartmodel case final value?)
    'sidebarshoppingcartmodel': value,
};
