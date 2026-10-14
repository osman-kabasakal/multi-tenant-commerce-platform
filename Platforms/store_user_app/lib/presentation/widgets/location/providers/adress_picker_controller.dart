import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_address_edit_model/customer_address_edit_model.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';

import '../view_models/address_picker_view_model.dart';
import 'adress_picker_controller_interface.dart';

part 'adress_picker_controller.g.dart';

@riverpod
class AdressPickerController extends _$AdressPickerController
    with
        CacheInvalidationBase,
        CacheAwareAsyncProvider<AddressPickerViewModel>,
        AsyncNotiferAddressPickerControllerBase {
  late AccountRepository _accountRepository;
  late CacheManager _cacheManager;

  @override
  FutureOr<AddressPickerViewModel> build() async {
    await registerCorrelation();
    _accountRepository = await getIt.getAsync<AccountRepository>();
    _cacheManager = await getIt.getAsync<CacheManager>();

    return await _loadState();
  }

  Future<AddressPickerViewModel> _loadState() async {
    var address = await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async => await _accountRepository.getAccountAddresses(),
    );
    if (address?.data != null) {
      return AddressPickerViewModel(
        addresses: address?.data?.addresses ?? [],
      );
    }

    return AddressPickerViewModel(
        error:
            'Adresleriniz alınırken bilinmeyen bir hata oluştu lütfen tekrar deneyiniz!');
  }

  @override
  Future<void> addAddress(AddressModel address) async {
    await _updateState(() async {
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
        return _loadState();
      }
      toast(
          'Adresiniz ekenirken bilinmeyen bir hata meydana geldi! Lütfen daha sonra tekrar deneyiniz!');

      return state.requireValue;
    });
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    await _updateState(() async {
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
        return _loadState();
      }
      toast(
          'Adresiniz güncellenirken bilinmeyen bir hata meydana geldi! Lütfen daha sonra tekrar deneyiniz!');

      return state.requireValue;
    });
  }

  @override
  Future<void> removeAddress(String addressId) async {
    await _updateState(() async {
      var removeAddressResponse =
          await _accountRepository.postAccountAddressDelete(addressId);
      if ((removeAddressResponse?.data! != null) &&
          removeAddressResponse!.data!.redirect != null &&
          removeAddressResponse.data!.redirect!
              .toString()
              .contains('addresses')) {
        return _loadState();
      }
      toast(
          'Adresiniz silinirken bilinmeyen bir hata meydana geldi! Lütfen daha sonra tekrar deneyiniz!');

      return state.requireValue;
    });
  }

  @override
  Future<void> refresh() async {
    await _updateState(_loadState);
  }

  Future<void> _updateState(
      Future<AddressPickerViewModel> Function() action) async {
    if (state.isLoading) return;
    state = AsyncValue.loading();
    try {
      state = await AsyncValue.guard(action);
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(error: e.toString()));
    }
  }

  @override
  Future<AddressModel?> getAddressModel([String? addressId]) async {
    if (addressId != null) {
      var response =
          await correlationService.runRepositoryMethodWithCorrelation(
        correlationId,
        () async => await _accountRepository.getAccountAddressEdit(addressId),
      );
      if (!(response?.isRedirectResponse ?? false)) {
        return response?.data?.address;
      }
    }

    var inserAddressResponse =
        await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async => await _accountRepository.getAccountAddressAdd(),
    );

    if (!(inserAddressResponse?.isRedirectResponse ?? false)) {
      return inserAddressResponse?.data?.address;
    }

    return null;
  }
}
