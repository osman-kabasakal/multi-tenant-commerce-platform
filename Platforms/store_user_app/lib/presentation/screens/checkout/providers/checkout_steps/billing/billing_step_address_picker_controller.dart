import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_billing_address_model/checkout_billing_address_model.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_address_edit_model/customer_address_edit_model.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/widgets/location/providers/adress_picker_controller_interface.dart';
import 'package:store_user_app/presentation/widgets/location/view_models/address_picker_view_model.dart';
import 'package:store_user_app/core/utils/extensions/address_model_extensions.dart';
part 'billing_step_address_picker_controller.g.dart';

@riverpod
class BillingStepAddressPickerController
    extends _$BillingStepAddressPickerController
    with
        CacheInvalidationBase,
        CacheAwareAsyncFamilyProvider<AddressPickerViewModel>,
        FamilyAsyncNotiferAddressPickerControllerBase {
  late CheckoutBillingAddressModel _billingAddressModel;
  late AuthService _authService;

  late AccountRepository _accountRepository;
  late CacheManager _cacheManager;
  @override
  FutureOr<AddressPickerViewModel> build(
    CheckOutRouteData routeData,
  ) async {
    await registerCorrelation();
    _billingAddressModel = (await ref.read(checkoutControllerProvider(routeData)
            .selectAsync((a) => a.checkoutModel)))!
        .billingAddress!;

    _authService = await getIt.getAsync<AuthService>();

    _accountRepository = await getIt.getAsync<AccountRepository>();
    _cacheManager = await getIt.getAsync<CacheManager>();
    return AddressPickerViewModel(
        addresses: _billingAddressModel.existingAddresses ?? []);
  }

  Future<void> selectAddress([String? addressId]) async {
    if (addressId == null) {
      await ref
          .read(checkoutControllerProvider(routeData).notifier)
          .execute(_billingAddressModel.copyWith(
            billingAddressId: null,
            existingAddresses: [],
          ).toJson());
    } else {
      await ref
          .read(checkoutControllerProvider(routeData).notifier)
          .execute(_billingAddressModel.copyWith(
            billingNewAddress: (await _billingAddressModel.billingNewAddress!
                .fillRequiredAddressFields()),
            billingAddressId: addressId,
            existingAddresses: [],
          ).toJson());
    }
  }

  @override
  Future<void> addAddress(AddressModel address) async {
    var tokens = await _authService.getAccessToken();
    if (tokens?.isGuest ?? true) {
      _billingAddressModel = _billingAddressModel.copyWith(
        billingAddressId: null,
        billingNewAddress: address.copyWith(availableStates: []),
        existingAddresses: [],
      );
      await selectAddress();
    } else {
      state = AsyncValue.loading();
      var addAddressResponse = await _accountRepository
          .postAccountAddressAdd(CustomerAddressEditModel(address: address));
      if ((addAddressResponse?.isRedirectResponse ?? false) &&
          addAddressResponse!
                  .redirect?.redirectUri?.queryParameters['routeName'] !=
              null &&
          addAddressResponse
                  .redirect?.redirectUri?.queryParameters['routeName'] ==
              'CustomerAddresses') {
        await cacheFreshness();
        await refresh();
        return;
      }
      toast(
          'Adresiniz güncellenirken bilinmeyen bir hata meydana geldi! Lütfen daha sonra tekrar deneyiniz!');
    }
  }

  @override
  Future<AddressModel?> getAddressModel([String? addressId]) async {
    if (addressId == null) {
      return _billingAddressModel.billingNewAddress;
    }
    var editAddressResponse =
        await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async => await _accountRepository.getAccountAddressEdit(addressId),
    );

    if (editAddressResponse?.data != null) {
      return editAddressResponse!.data!.address;
    }
    return _billingAddressModel.billingNewAddress!;
  }

  @override
  Future<void> refresh() async {
    var tokens = await _authService.getAccessToken();
    if (tokens?.isGuest ?? true) {
      return;
    }
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      var address = await correlationService.runRepositoryMethodWithCorrelation(
        correlationId,
        () async => await _accountRepository.getAccountAddresses(),
      );

      if (address?.data != null && address!.data!.addresses!.isNotEmpty) {
        return AddressPickerViewModel(addresses: address.data!.addresses!);
      }

      return AddressPickerViewModel(
          error:
              'Adresleriniz alınırken bilinmeyen bir hata oluştu lütfen tekrar deneyiniz!');
    });
  }

  @override
  Future<void> removeAddress(String addressId) async {
    var tokens = await _authService.getAccessToken();
    if (tokens?.isGuest ?? true) {
      return;
    }

    state = AsyncValue.loading();

    var removeAddressResponse =
        await _accountRepository.postAccountAddressDelete(addressId);
    if ((removeAddressResponse?.data! != null) &&
        removeAddressResponse!.data!.redirect != null &&
        removeAddressResponse.data!.redirect!
            .toString()
            .contains('addresses')) {
      await cacheFreshness();
      await refresh();
      return;
    }
    toast(
        'Adresiniz silinirken bilinmeyen bir hata meydana geldi! Lütfen daha sonra tekrar deneyiniz!');

    return;
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    var tokens = await _authService.getAccessToken();
    if (tokens?.isGuest ?? true) {
      return;
    }
    state = AsyncValue.loading();
    var updateAddressResponse = await _accountRepository
        .postAccountAddressEdit(CustomerAddressEditModel(address: address));
    if ((updateAddressResponse?.isRedirectResponse ?? false) &&
        updateAddressResponse!
                .redirect?.redirectUri?.queryParameters['routeName'] !=
            null &&
        updateAddressResponse
                .redirect?.redirectUri?.queryParameters['routeName'] ==
            'CustomerAddresses') {
      await cacheFreshness();
      await refresh();
      return;
    }
    toast(
        'Adresiniz güncellenirken bilinmeyen bir hata meydana geldi! Lütfen daha sonra tekrar deneyiniz!');
  }
}
