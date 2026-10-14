import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show FileServiceResponse;
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/services/file_service/dio_file_service.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_details_model/merchandise_return_details_model.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/repositories/merchandise_return/merchandise_return_repository.dart';

part 'merchandise_return_details_controller.g.dart';

@riverpod
class MerchandiseReturnDetailsController
    extends _$MerchandiseReturnDetailsController
    with
        CacheInvalidationBase,
        CacheAwareAsyncFamilyProvider<MerchandiseReturnDetailsModel> {
  late MerchandiseReturnRepository _merchandiseReturnRepository;
  late DioFileService _dioFileService;
  late StreamSubscription<EntityEvent>? _eventSubscription;

  @override
  FutureOr<MerchandiseReturnDetailsModel> build(
    String merchandiseReturnId,
  ) async {
    await registerCorrelation();

    _merchandiseReturnRepository =
        await getIt.getAsync<MerchandiseReturnRepository>();

    _dioFileService = await getIt.getAsync<DioFileService>();

    _eventSubscription = getIt<EventBus>().stream.listen((event) {
      handleEvent(event);
    });

    ref.onDispose(dispose);

    return await _getMerchandiseReturnDetails(merchandiseReturnId);
  }

  Future<MerchandiseReturnDetailsModel> _getMerchandiseReturnDetails(
    String merchandiseReturnId,
  ) async {
    try {
      final response = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _merchandiseReturnRepository
                .getMerchandiseReturnMerchandiseReturnDetails(
                  merchandiseReturnId,
                ),
          );
      if (response != null && response.data != null) {
        return response.data!;
      } else {
        await getIt<AppRouter>().replacePath(AppPaths.notFound());
        return MerchandiseReturnDetailsModel();
      }
    } catch (e) {
      LoggerService.error('İade detayları yüklenirken hata oluştu', e);
      throw Exception('İade detayları yüklenirken bir hata oluştu: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final details = await _getMerchandiseReturnDetails(merchandiseReturnId);
      state = AsyncValue.data(details);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // İade notu indirme işlemi için yardımcı metod
  Future<void> downloadMerchandiseReturnNote(
    String merchandiseReturnNoteId,
  ) async {
    toast('Not indiriliyor...');
    try {
      var componentRepository = await getIt.getAsync<ComponentRepository>();
      var footerModel = await componentRepository.getFooter();
      FileServiceResponse noteFile = await _dioFileService.get(
        'download/merchandisereturnnotefile/$merchandiseReturnNoteId',
      );
      var downloadDirectoryPath = await _getDownloadDirectory();
      if (downloadDirectoryPath == null) {
        toast(
          'Dosya indirme dizini bulunamadı. Doğru izinleri verdiğinizden emin olnuz!',
        );
        return;
      }
      if (!Directory(
        '${downloadDirectoryPath.path}/${footerModel?.storeName}',
      ).existsSync()) {
        Directory(
          '${downloadDirectoryPath.path}/${footerModel?.storeName}',
        ).createSync();
      }
      var filePath =
          '${downloadDirectoryPath.path}/${footerModel?.storeName}/not_dosyasi_$merchandiseReturnNoteId.${noteFile.fileExtension}';

      File file = File(filePath);
      await file.writeAsBytes(await noteFile.content.single);
      await OpenFile.open(filePath);
    } catch (e) {
      // Handle error
      LoggerService.error('Download attachment error', e);
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // Android'de indirme dizini için izin gerekebilir (Android 10+ için storage izni gerekli değil)
      if (await _checkStoragePermission()) {
        return await getExternalStorageDirectory();
      } else {
        return null;
      }
    } else if (Platform.isIOS) {
      // iOS'ta Documents klasörü izin gerektirmez
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  Future<bool> _checkStoragePermission() async {
    // Android 10 (API 29) ve üzeri için dosya sistemi izni gerekmez
    if (Platform.isAndroid) {
      var (release, sdk) = await _getAndroidVersion();
      if (release >= 10 || sdk >= 29) {
        return true;
      }
      if (await Permission.storage.status != PermissionStatus.granted) {
        // İzin yok, izin iste
        if (await Permission.storage.request() != PermissionStatus.granted) {
          return false;
        }
      }
    }
    return true;
  }

  Future<(int release, int sdk)> _getAndroidVersion() async {
    if (!Platform.isAndroid) return (0, 0);
    var deviceInfo = await DeviceInfoPlugin().androidInfo;
    var release = deviceInfo.version.release;
    var sdkInt = deviceInfo.version.sdkInt;
    return (int.parse(release), sdkInt);
  }

  void dispose() {
    _eventSubscription?.cancel();
  }

  void handleEvent(EntityEvent event) {
    // TODO: implement handleEvent
  }
}
