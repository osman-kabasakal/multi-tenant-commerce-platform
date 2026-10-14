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
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/services/file_service/dio_file_service.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/core/utils/extensions/api_response_extensions.dart';
import 'package:store_user_app/domain/entities/models/orders/shipment_details_model/shipment_details_model.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/repositories/order/order_repository.dart';

part 'shipment_details_controller.g.dart';

@riverpod
class ShipmentDetailsController extends _$ShipmentDetailsController
    with
        CacheInvalidationBase,
        CacheAwareAsyncFamilyProvider<ShipmentDetailsModel> {
  late OrderRepository _orderRepository;
  late DioFileService _dioFileService;

  late StreamSubscription<EntityEvent> _eventSubscription;
  late EventBus _eventBus;

  @override
  FutureOr<ShipmentDetailsModel> build(String shipmentDetailId) async {
    await registerCorrelation();

    _orderRepository = await getIt.getAsync<OrderRepository>();
    _dioFileService = await getIt.getAsync<DioFileService>();

    _eventBus = getIt.get<EventBus>();
    _eventSubscription = _eventBus.stream.listen(handleEvent);

    ref.onDispose(() {
      _eventSubscription.cancel();
    });

    return _getShipmentDetailModel();
  }

  Future<ShipmentDetailsModel> _getShipmentDetailModel() async {
    var shipmentdetail = await correlationService
        .runRepositoryMethodWithCorrelation(
          correlationId,
          () async =>
              await _orderRepository.getOrderShipmentDetails(shipmentDetailId),
        );

    if (shipmentdetail.success) {
      return shipmentdetail!.data!;
    }

    await getIt<AppRouter>().replacePath(AppPaths.notFound());

    return ShipmentDetailsModel();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_getShipmentDetailModel);
  }

  Future<void> shipmentNoteFileDownload(String shipmentNoteId) async {
    try {
      var componentRepository = await getIt.getAsync<ComponentRepository>();
      var footerModel = await componentRepository.getFooter();

      FileServiceResponse noteFile = await _dioFileService.get(
        'download/shipmentnotefile/$shipmentNoteId',
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
          '${downloadDirectoryPath.path}/${footerModel?.storeName}/gonderi_dokumnanı_$shipmentNoteId.${noteFile.fileExtension}';

      File file = File(filePath);
      await file.writeAsBytes(await noteFile.content.single);
      await OpenFile.open(filePath);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
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

  void handleEvent(EntityEvent event) async {
    if (event is EntityCreatedEvent<ShipmentDetailsModel>) {
      // await (await getIt.getAsync<CacheManager>()).removeByPrefix(
      //     _orderRepository
      //         .generateCachePrefixForRemoval('/Order/ShipmentDetails'));

      // state = await AsyncValue.guard(_getShipmentDetailModel);
    }
  }
}
