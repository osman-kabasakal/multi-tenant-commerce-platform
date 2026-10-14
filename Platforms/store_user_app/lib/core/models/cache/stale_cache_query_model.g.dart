// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stale_cache_query_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaleCacheQueryModelImpl _$$StaleCacheQueryModelImplFromJson(
  Map<String, dynamic> json,
) => _$StaleCacheQueryModelImpl(
  staleCacheItems:
      (json['StaleCacheItems'] as List<dynamic>?)
          ?.map((e) => StaleCacheItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$StaleCacheQueryModelImplToJson(
  _$StaleCacheQueryModelImpl instance,
) => <String, dynamic>{'StaleCacheItems': instance.staleCacheItems};
