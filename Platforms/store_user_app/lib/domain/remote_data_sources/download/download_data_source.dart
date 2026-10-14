import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'download_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class DownloadDataSource {
  @factoryMethod
  factory DownloadDataSource(Dio dio) {
    return _DownloadDataSource(dio);
  }

  @GET('/Download/Sample')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getDownloadSample(@Query('productId') String productId);

  @GET('/Download/GetDownload')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getDownloadGetDownload(
      @Query('orderItemId') String orderItemId, @Query('agree') bool? agree);

  @GET('/Download/GetLicense')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getDownloadGetLicense(
      @Query('orderItemId') String orderItemId);

  @GET('/Download/GetFileUpload')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getDownloadGetFileUpload(
      @Query('downloadId') String downloadId);

  @GET('/Download/GetOrderNoteFile')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getDownloadGetOrderNoteFile(
      @Query('orderNoteId') String orderNoteId);

  @GET('/Download/GetShipmentNoteFile')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getDownloadGetShipmentNoteFile(
      @Query('shipmentNoteId') String shipmentNoteId);

  @GET('/Download/GetCustomerNoteFile')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getDownloadGetCustomerNoteFile(
      @Query('customerNoteId') String customerNoteId);

  @GET('/Download/GetMerchandiseReturnNoteFile')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getDownloadGetMerchandiseReturnNoteFile(
      @Query('merchandiseReturnNoteId') String merchandiseReturnNoteId);

  @GET('/Download/GetDocumentFile')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getDownloadGetDocumentFile(
      @Query('documentId') String documentId);
}
