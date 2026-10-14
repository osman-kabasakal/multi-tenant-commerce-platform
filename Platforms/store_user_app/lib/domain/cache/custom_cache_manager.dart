import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../core/services/file_service/dio_file_service.dart';

class OptimizedImageConfig {
  static const int maxCacheSize = 100000; // MB
  static const Duration cacheDuration = Duration(days: 7);
  static const int maxMemoryCacheSize = 100000; // Items
}

class CustomCacheManager extends CacheManager {
  static const key = 'storeCacheKey';

  static CustomCacheManager? _instance;
  final DioFileService _fileService;

  factory CustomCacheManager(DioFileService fileService) {
    _instance ??= CustomCacheManager._(fileService);
    return _instance!;
  }

  CustomCacheManager._(this._fileService)
    : super(
        Config(
          key,
          stalePeriod: OptimizedImageConfig.cacheDuration,
          maxNrOfCacheObjects: OptimizedImageConfig.maxCacheSize,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: _fileService,
        ),
      );
}
