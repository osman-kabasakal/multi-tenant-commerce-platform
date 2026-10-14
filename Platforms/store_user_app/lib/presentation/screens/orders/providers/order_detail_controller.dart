import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/data/events/entity_updated_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/cache/cache_invalidate_type.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/cache/cache_freshness_service.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/repositories/order/order_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/screens/orders/view_model/order_detail_view_model.dart';
import 'package:open_file/open_file.dart';
import 'package:store_user_app/presentation/screens/orders/widgets/add_order_note_buttom_sheet_widget.dart';

part 'order_detail_controller.g.dart';

@riverpod
class OrderDetailController extends _$OrderDetailController
    with
        CacheInvalidationBase,
        CacheAwareAsyncFamilyProvider<OrderDetailViewModel> {
  late OrderRepository _orderRepository;
  late StreamSubscription<EntityEvent> _eventSubscription;
  late EventBus _eventBus;

  @override
  FutureOr<OrderDetailViewModel> build(String orderId) async {
    await registerCorrelation();
    _orderRepository = await getIt.getAsync<OrderRepository>();

    _eventBus = getIt.get<EventBus>();
    _eventSubscription = _eventBus.stream.listen(handleEvent);

    ref.onDispose(() {
      _eventSubscription.cancel();
    });
    return _initModel(orderId);
  }

  Future<OrderDetailViewModel> _initModel(String orderId) async {
    try {
      var apiResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _orderRepository.getOrderDetails(orderId),
          );

      if (apiResponse != null && apiResponse.data != null) {
        return OrderDetailViewModel(
          isLoading: false,
          orderDetailsModel: apiResponse.data,
        );
      }

      await getIt<AppRouter>().replacePath(AppPaths.notFound());

      return OrderDetailViewModel(isLoading: false);
    } catch (e) {
      return OrderDetailViewModel(isLoading: false);
    }
  }

  Future<void> loadModel(String orderId, [bool publishEvent = false]) async {
    state = AsyncValue.data(state.requireValue.copyWith(isLoading: true));
    try {
      var apiResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _orderRepository.getOrderDetails(orderId),
          );

      if (apiResponse != null && apiResponse.data != null) {
        if (publishEvent) {
          getIt<EventBus>().publish(
            EntityUpdatedEvent(
              oldEntity: state.requireValue.orderDetailsModel,
              entity: apiResponse.data!,
            ),
          );
        }
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            orderDetailsModel: apiResponse.data,
          ),
        );
        return;
      }

      state = AsyncValue.data(state.requireValue.copyWith(isLoading: false));
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(isLoading: false));
    }
  }

  Future<void> downloadOrderPdfInvoice() async {
    try {
      var componentRepository = await getIt.getAsync<ComponentRepository>();
      var footerModel = await componentRepository.getFooter();
      List<int> pdf = await _orderRepository.getOrderGetPdfInvoice(
        state.requireValue.orderDetailsModel!.id!,
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
          '${downloadDirectoryPath.path}/${footerModel?.storeName}/sipraiş_${state.requireValue.orderDetailsModel!.orderCode}_fatura.pdf';

      File file = File(filePath);
      await file.writeAsBytes(pdf);
      await OpenFile.open(filePath, type: 'application/pdf');
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

  Future<void> rePostProcessPayment() async {
    try {
      var apiResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _orderRepository.postOrderRePostPayment(
              state.requireValue.orderDetailsModel!.id!,
            ),
          );
      if (apiResponse != null &&
          apiResponse.isRedirectResponse &&
          (apiResponse.redirect!.redirectUri?.queryParameters.containsKey(
                state.requireValue.orderDetailsModel!.paymentMethod,
              ) ??
              false)) {
        var appRouter = getIt.get<AppRouter>();
        // appRouter.push(RedirectPaymentRoute());
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addOrderNote(BuildContext context) async {
    var model = await showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: AddOrderNoteButtomSheetWidget(
            orderId: state.requireValue.orderDetailsModel!.id!,
          ),
        );
      },
    );

    var apiResponse = await _orderRepository.postOrderAddOrderNote(model);
    if (apiResponse != null &&
        apiResponse.isRedirectResponse &&
        (((apiResponse.redirect!.redirectUri?.queryParameters.containsKey(
                      'routeName',
                    ) ??
                    false) &&
                apiResponse
                        .redirect!
                        .redirectUri
                        ?.queryParameters['routeName'] ==
                    'OrderDetails') ||
            apiResponse.redirect!.redirectUri!.path.contains('orderdetails'))) {
      await cacheFreshness(
        _orderRepository.generateCachePrefixForRemoval('/Order'),
        CacheInvalidateType.prefix,
      );

      await loadModel(state.requireValue.orderDetailsModel!.id!, true);

      return;
    }
    toast(
      'Notunuzu eklerken beklenmedik bir hata aldık lütfen tekrar deneyiniz!',
    );
  }

  Future<void> reOrder() async {
    try {
      var apiResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _orderRepository.getOrderReOrder(
              state.requireValue.orderDetailsModel!.id!,
            ),
          );

      if (apiResponse != null &&
          apiResponse.isRedirectResponse &&
          (apiResponse.redirect!.redirectUri?.queryParameters.containsKey(
                'routeName',
              ) ??
              false) &&
          apiResponse.redirect!.redirectUri?.queryParameters['routeName'] ==
              'ShoppingCart') {
        await cacheFreshness(
          _orderRepository.generateCachePrefixForRemoval('/ShoppingCart'),
          CacheInvalidateType.prefix,
        );

        var appRouter = getIt.get<AppRouter>();
        appRouter.push((CartRoute()));
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> cancelOrder() async {
    try {
      var apiResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _orderRepository.getOrderCancelOrder(
              state.requireValue.orderDetailsModel!.id!,
            ),
          );

      if (apiResponse != null &&
          apiResponse.isRedirectResponse &&
          (((apiResponse.redirect!.redirectUri?.queryParameters.containsKey(
                        'Route',
                      ) ??
                      false) &&
                  apiResponse.redirect!.redirectUri?.queryParameters['Route'] ==
                      'OrderDetails') ||
              apiResponse.redirect!.redirectUri!.path.contains(
                'orderdetails',
              ))) {
        await cacheFreshness(
          _orderRepository.generateCachePrefixForRemoval('/Order'),
          CacheInvalidateType.prefix,
        );

        await loadModel(state.requireValue.orderDetailsModel!.id!, true);
        return;
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> shipmentDetails(String shipmentId) async {
    var appRoter = getIt.get<AppRouter>();
    appRoter.push(ShipmentDetailsRoute(shipmentId: shipmentId));
  }

  void handleEvent(EntityEvent event) async {
    try {
      if (event is EntityCreatedEvent<CheckoutStepResponse>) {
        if (event.entity.success == 1 || event.entity.error == 1) {
          // var cacheManager = getIt.get<CacheManager>();
          // await cacheManager.removeByPrefix(
          //     _orderRepository.generateCachePrefixForRemoval('/Order'));

          // await loadModel(state.requireValue.orderDetailsModel!.id!);
          await cacheFreshness(
            _orderRepository.generateCachePrefixForRemoval('/Order'),
            CacheInvalidateType.prefix,
          );
        }
      }
    } catch (e) {
      LoggerService.error(e.toString());
    }
  }
}
