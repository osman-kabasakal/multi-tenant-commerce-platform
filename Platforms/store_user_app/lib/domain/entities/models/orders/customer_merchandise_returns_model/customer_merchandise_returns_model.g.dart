// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_merchandise_returns_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerMerchandiseReturnsModelImpl
_$$CustomerMerchandiseReturnsModelImplFromJson(Map<String, dynamic> json) =>
    _$CustomerMerchandiseReturnsModelImpl(
      items:
          (json['Items'] as List<dynamic>?)
              ?.map(
                (e) =>
                    MerchandiseReturnModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CustomerMerchandiseReturnsModelImplToJson(
  _$CustomerMerchandiseReturnsModelImpl instance,
) => <String, dynamic>{
  if (instance.items case final value?) 'Items': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
