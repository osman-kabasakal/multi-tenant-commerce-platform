import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';

import '../../remote_data_sources/download/download_data_source.dart';

@lazySingleton
class DownloadRepository extends BaseRepository {
  final DownloadDataSource _dataSource;

  DownloadRepository(this._dataSource, super.decorator, super.eventBus);

  Future<dynamic> getDownloadSample(String productId) async {
    return await decorator.execute<dynamic>(
      operationName: "/Download/Sample",
      cacheKey: generateCacheKey("/Download/Sample", [productId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getDownloadSample(productId);
      },
    );
  }

  Future<dynamic> getDownloadGetDownload(
      String orderItemId, bool? agree) async {
    return await decorator.execute<dynamic>(
      operationName: "/Download/GetDownload",
      cacheKey: generateCacheKey("/Download/GetDownload", [orderItemId, agree]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getDownloadGetDownload(orderItemId, agree);
      },
    );
  }

  Future<dynamic> getDownloadGetLicense(String orderItemId) async {
    return await decorator.execute<dynamic>(
      operationName: "/Download/GetLicense",
      cacheKey: generateCacheKey("/Download/GetLicense", [orderItemId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getDownloadGetLicense(orderItemId);
      },
    );
  }

  Future<List<int>?> getDownloadGetFileUpload(String downloadId) async {
    return await decorator.execute<List<int>>(
      operationName: "/Download/GetFileUpload",
      cacheKey: generateCacheKey("/Download/GetFileUpload", [downloadId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getDownloadGetFileUpload(downloadId);
      },
    );
  }

  Future<dynamic> getDownloadGetOrderNoteFile(String orderNoteId) async {
    return await decorator.execute<dynamic>(
      operationName: "/Download/GetOrderNoteFile",
      cacheKey: generateCacheKey("/Download/GetOrderNoteFile", [orderNoteId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getDownloadGetOrderNoteFile(orderNoteId);
      },
    );
  }

  Future<dynamic> getDownloadGetShipmentNoteFile(String shipmentNoteId) async {
    return await decorator.execute<dynamic>(
      operationName: "/Download/GetShipmentNoteFile",
      cacheKey:
          generateCacheKey("/Download/GetShipmentNoteFile", [shipmentNoteId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getDownloadGetShipmentNoteFile(shipmentNoteId);
      },
    );
  }

  Future<List<int>?> getDownloadGetCustomerNoteFile(
      String customerNoteId) async {
    return await decorator.execute<List<int>>(
      operationName: "/Download/GetCustomerNoteFile",
      cacheKey:
          generateCacheKey("/Download/GetCustomerNoteFile", [customerNoteId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getDownloadGetCustomerNoteFile(customerNoteId);
      },
    );
  }

  Future<dynamic> getDownloadGetMerchandiseReturnNoteFile(
      String merchandiseReturnNoteId) async {
    return await decorator.execute<dynamic>(
      operationName: "/Download/GetMerchandiseReturnNoteFile",
      cacheKey: generateCacheKey(
          "/Download/GetMerchandiseReturnNoteFile", [merchandiseReturnNoteId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .getDownloadGetMerchandiseReturnNoteFile(merchandiseReturnNoteId);
      },
    );
  }

  Future<dynamic> getDownloadGetDocumentFile(String documentId) async {
    return await decorator.execute<dynamic>(
      operationName: "/Download/GetDocumentFile",
      cacheKey: generateCacheKey("/Download/GetDocumentFile", [documentId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getDownloadGetDocumentFile(documentId);
      },
    );
  }
}
