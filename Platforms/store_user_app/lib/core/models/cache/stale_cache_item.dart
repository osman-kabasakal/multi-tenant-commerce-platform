import 'package:freezed_annotation/freezed_annotation.dart';

part 'stale_cache_item.freezed.dart';
part 'stale_cache_item.g.dart';

@freezed
class StaleCacheItem with _$StaleCacheItem {
  const factory StaleCacheItem({
    @JsonKey(name: 'CorrelationId') required String correlationId,
    @JsonKey(name: 'AsOf') required DateTime asOf,
  }) = _StaleCacheItem;

  factory StaleCacheItem.fromJson(Map<String, dynamic> json) =>
      _$StaleCacheItemFromJson(json);
}
