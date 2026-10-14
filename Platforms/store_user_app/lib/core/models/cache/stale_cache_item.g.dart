// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stale_cache_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaleCacheItemImpl _$$StaleCacheItemImplFromJson(Map<String, dynamic> json) =>
    _$StaleCacheItemImpl(
      correlationId: json['CorrelationId'] as String,
      asOf: DateTime.parse(json['AsOf'] as String),
    );

Map<String, dynamic> _$$StaleCacheItemImplToJson(
  _$StaleCacheItemImpl instance,
) => <String, dynamic>{
  'CorrelationId': instance.correlationId,
  'AsOf': instance.asOf.toIso8601String(),
};
