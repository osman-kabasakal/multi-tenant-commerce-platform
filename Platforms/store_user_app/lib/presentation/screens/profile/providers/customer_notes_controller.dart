import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    hide CacheManager;
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/services/file_service/dio_file_service.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/core/state_management/riverpod/base_event_listener_provider.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_notes_model/customer_notes_model.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/repositories/download/download_repository.dart';

part 'customer_notes_controller.g.dart';

@riverpod
class CustomerNotesController extends _$CustomerNotesController
    with
        BaseEventListenerProvider<CustomerNotesModel>,
        CacheInvalidationBase,
        CacheAwareAsyncProvider<CustomerNotesModel> {
  late AccountRepository _accountRepository;
  late DownloadRepository _downloadRepository;
  late DioFileService _dioFileService;

  @override
  FutureOr<CustomerNotesModel> build() async {
    await registerCorrelation();
    _accountRepository = await getIt.getAsync<AccountRepository>();
    _downloadRepository = await getIt.getAsync<DownloadRepository>();
    _dioFileService = await getIt.getAsync<DioFileService>();
    initListenar();
    return await _getCustomerNotes();
  }

  Future<CustomerNotesModel> _getCustomerNotes() async {
    try {
      final response =
          await correlationService.runRepositoryMethodWithCorrelation(
        correlationId,
        () async => await _accountRepository.getAccountNotes(),
      );

      if (response != null && response.data != null) {
        return response.data!;
      }
      throw Exception('Notlar yüklenirken bir hata oluştu.');
    } catch (e) {
      throw Exception('Beklenmeyen bir hata oluştu: $e');
    }
  }

  Future<void> refreshNotes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_getCustomerNotes);
  }

  Future<void> downloadAttachment(String noteId) async {
    try {
      var componentRepository = await getIt.getAsync<ComponentRepository>();
      var footerModel = await componentRepository.getFooter();
      FileServiceResponse noteFile = await _dioFileService
          .get('/Download/GetCustomerNoteFile?customerNoteId=$noteId');
      var downloadDirectoryPath = await _getDownloadDirectory();
      if (downloadDirectoryPath == null) {
        toast(
            'Dosya indirme dizini bulunamadı. Doğru izinleri verdiğinizden emin olnuz!');
        return;
      }
      if (!Directory('${downloadDirectoryPath.path}/${footerModel?.storeName}')
          .existsSync()) {
        Directory('${downloadDirectoryPath.path}/${footerModel?.storeName}')
            .createSync();
      }
      var filePath =
          '${downloadDirectoryPath.path}/${footerModel?.storeName}/not_dosyasi_$noteId.${noteFile.fileExtension}';

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

  @override
  void handleEvent(EntityEvent event) async {
    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens != null &&
          (event.oldTokens?.email != event.entity.email ||
              event.oldTokens?.guestId != event.entity.guestId)) {
        await cacheFreshness();
        state = await AsyncValue.guard(() async => await _getCustomerNotes());
      }
    }
  }
}
