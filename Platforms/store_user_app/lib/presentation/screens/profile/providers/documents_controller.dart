import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/file_service/dio_file_service.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/customer/document/document.dart';
import 'package:store_user_app/domain/entities/models/customer/document_paging_model/document_paging_model.dart';
import 'package:store_user_app/domain/entities/models/customer/documents_model/documents_model.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';

part 'documents_controller.g.dart';

@riverpod
class DocumentsController extends _$DocumentsController
    with CacheInvalidationBase, CacheAwareAsyncProvider<DocumentsModel> {
  DocumentsModel? _documentsModel;
  bool _isLoading = false;
  int _currentPage = 1;
  late DioFileService _dioFileService;

  @override
  FutureOr<DocumentsModel> build() async {
    await registerCorrelation();
    _dioFileService = await getIt.getAsync<DioFileService>();
    return _fetchDocuments(_currentPage);
  }

  Future<DocumentsModel> _fetchDocuments(int pageNumber) async {
    final accountRepository = await getIt.getAsync<AccountRepository>();

    final documentPagingModel = DocumentPagingModel(
      pageNumber: pageNumber,
      pageSize: 10,
    );

    final response =
        await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async =>
          await accountRepository.getAccountDocuments(documentPagingModel),
    );

    if (response != null && response.data != null) {
      _documentsModel = response.data!;
      return _documentsModel!;
    }

    throw Exception('Dokümanlar yüklenemedi');
  }

  Future<void> loadMore() async {
    if (_isLoading ||
        _documentsModel?.pagingContext == null ||
        !(_documentsModel!.pagingContext!.hasNextPage ?? false)) {
      return;
    }

    _isLoading = true;

    try {
      var oldDocs = _documentsModel!.documentList?.toList() ?? [];
      final nextPage = (_documentsModel!.pagingContext!.pageNumber ?? 0) + 1;
      final newDocs = await _fetchDocuments(nextPage);

      // Combine the lists
      final allDocs = <Document>[...oldDocs, ...(newDocs.documentList ?? [])];

      _documentsModel = newDocs.copyWith(
        documentList: allDocs,
      );

      state = AsyncValue.data(_documentsModel!);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refresh() async {
    _currentPage = 1;
    ref.invalidateSelf();
  }

  Future<void> downloadDocument(BuildContext context, String documentId) async {
    try {
      var componentRepository = await getIt.getAsync<ComponentRepository>();
      var footerModel = await componentRepository.getFooter();
      FileServiceResponse noteFile = await _dioFileService
          .get('/Download/GetDocumentFile?documentId=$documentId');
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
          '${downloadDirectoryPath.path}/${footerModel?.storeName}/belge_$documentId.${noteFile.fileExtension}';

      File file = File(filePath);
      await file.writeAsBytes(await noteFile.content.single);
      await OpenFile.open(filePath);
    } catch (e) {
      LoggerService.error('Error downloading document', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download document')),
      );
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
}
