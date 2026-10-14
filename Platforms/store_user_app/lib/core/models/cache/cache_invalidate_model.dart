import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/cache/cache_invalidate_type.dart';

part 'cache_invalidate_model.freezed.dart';

@freezed
class CacheInvalidateModel with _$CacheInvalidateModel {
  const factory CacheInvalidateModel({
    String? key,
    required CacheInvalidateType type,
  }) = _CacheInvalidateModel;
}
