import 'package:freezed_annotation/freezed_annotation.dart';

import 'stale_cache_item.dart';

part 'stale_cache_query_model.freezed.dart';
part 'stale_cache_query_model.g.dart';

@freezed
class StaleCacheQueryModel with _$StaleCacheQueryModel {
  const factory StaleCacheQueryModel({
    @JsonKey(name: 'StaleCacheItems')
    @Default([])
    List<StaleCacheItem> staleCacheItems,
  }) = _StaleCacheQueryModel;

  factory StaleCacheQueryModel.fromJson(Map<String, dynamic> json) =>
      _$StaleCacheQueryModelFromJson(json);
}
