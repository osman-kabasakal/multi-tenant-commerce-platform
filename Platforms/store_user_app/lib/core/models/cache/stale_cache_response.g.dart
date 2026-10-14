// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stale_cache_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaleCacheResponseImpl _$$StaleCacheResponseImplFromJson(
  Map<String, dynamic> json,
) => _$StaleCacheResponseImpl(
  staleCorrelationIds:
      (json['StaleCorrelationIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  asOf: DateTime.parse(json['AsOf'] as String),
);

Map<String, dynamic> _$$StaleCacheResponseImplToJson(
  _$StaleCacheResponseImpl instance,
) => <String, dynamic>{
  'StaleCorrelationIds': instance.staleCorrelationIds,
  'AsOf': instance.asOf.toIso8601String(),
};
