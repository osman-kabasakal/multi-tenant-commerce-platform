import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/di/modules/dio_module.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/core/services/file_service/dio_file_service.dart';
import 'package:store_user_app/domain/repositories/notification/notification_repository.dart';
import 'package:store_user_app/domain/usecases/notification/notification_checker_service.dart';

import '../../../domain/cache/custom_cache_manager.dart';

@module
abstract class ServiceModule {
  @lazySingleton
  DioFileService provideDioFileService(FileServiceDio dio) {
    return DioFileService(dio: dio);
  }

  @lazySingleton
  CustomCacheManager provideCustomCacheManager(DioFileService fileService) {
    return CustomCacheManager(fileService);
  }
  
  // Notification checker servis kaldırıldı, doğrudan inject edilecek
}
