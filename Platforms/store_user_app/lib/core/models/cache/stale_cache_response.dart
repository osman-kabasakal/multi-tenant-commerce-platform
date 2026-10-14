import 'package:freezed_annotation/freezed_annotation.dart';

part 'stale_cache_response.freezed.dart';
part 'stale_cache_response.g.dart';

@freezed
class StaleCacheResponse with _$StaleCacheResponse {
  const factory StaleCacheResponse({
    @JsonKey(name: 'StaleCorrelationIds')
    @Default([])
    List<String> staleCorrelationIds,
    @JsonKey(name: 'AsOf') required DateTime asOf,
  }) = _StaleCacheResponse;

  factory StaleCacheResponse.fromJson(Map<String, dynamic> json) =>
      _$StaleCacheResponseFromJson(json);
}
