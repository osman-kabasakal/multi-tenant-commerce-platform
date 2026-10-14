import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/dialog/dialog_helper.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_shipping_address_model/checkout_shipping_address_model.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/domain/entities/models/custom_attribute_model/custom_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_address_edit_model/customer_address_edit_model.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';
import 'package:store_user_app/domain/repositories/country/country_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/widgets/location/providers/adress_picker_controller_interface.dart';
import 'package:store_user_app/presentation/widgets/location/view_models/address_picker_view_model.dart';

part 'shipping_step_address_picker_controller.g.dart';

@riverpod
class ShippingStepAddressPickerController
    extends _$ShippingStepAddressPickerController
    with FamilyAsyncNotiferAddressPickerControllerBase {
  late CheckoutShippingAddressModel _shippingAddressModel;
  late AuthService _authService;

  late AccountRepository _accountRepository;
  late CacheManager _cacheManager;

  late AppRouter _appRouter;

  @override
  FutureOr<AddressPickerViewModel> build(
    CheckOutRouteData routeData,
  ) async {
    _shippingAddressModel = (await ref.read(
            checkoutControllerProvider(routeData)
                .selectAsync((a) => a.checkoutModel)))!
        .shippingAddress!;

    _authService = await getIt.getAsync<AuthService>();

    _accountRepository = await getIt.getAsync<AccountRepository>();
    _cacheManager = await getIt.getAsync<CacheManager>();

    _appRouter = getIt<AppRouter>();

    return AddressPickerViewModel(
        addresses: _shippingAddressModel.existingAddresses ?? []);
  }

  Future<void> selectAddress([String? addressId]) async {
    var billToSame = await DialogHelper.showAlertDialog(
      title: 'Fatura Adres seçimi',
      message: 'Fatura adresi ile aynı adresi kullanmak ister misiniz?',
      confirmText: 'Evet',
      cancelText: 'Hayır',
      useRootNavigator: true,
      type: AppDialogType.content,
    );

    if (addressId == null) {
      await ref
          .read(checkoutControllerProvider(routeData).notifier)
          .execute(_shippingAddressModel
              .copyWith(
                shippingAddressId: null,
                existingAddresses: [],
                billToTheSameAddress: billToSame ?? true,
                pickupPointId: null,
                pickUpInStore: false,
              )
              .toJson());
    } else {
      await ref.read(checkoutControllerProvider(routeData).notifier).execute(
          _shippingAddressModel
              .copyWith(
                  shippingNewAddress: (await fillRequiredAddressFields(
                      _shippingAddressModel.shippingNewAddress!)),
                  shippingAddressId: addressId,
                  existingAddresses: [],
                  billToTheSameAddress: billToSame ?? true,
                  pickupPointId: null,
                  pickUpInStore: false)
              .toJson());
    }
  }

  Future<void> selectPickPoint(String pickPointId) async {
    //Bad request hatasını önlemek için shippingnewaddress dolu ve gerekli alanların hepsi dolu olmalı
    await ref.read(checkoutControllerProvider(routeData).notifier).execute(
        _shippingAddressModel
            .copyWith(
                shippingNewAddress: (await fillRequiredAddressFields(
                    _shippingAddressModel.shippingNewAddress!)),
                existingAddresses: [],
                shippingAddressId: null,
                pickupPointId: pickPointId,
                billToTheSameAddress: false,
                pickUpInStore: true)
            .toJson());
  }

  @override
  Future<void> addAddress(AddressModel address) async {
    var tokens = await _authService.getAccessToken();
    if (tokens?.isGuest ?? true) {
      _shippingAddressModel = _shippingAddressModel.copyWith(
          shippingAddressId: null,
          shippingNewAddress: address.copyWith(availableStates: []),
          existingAddresses: [],
          pickUpInStore: false);
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
        await _cacheManager.removeByPrefix(
            _accountRepository.generateCachePrefixForRemoval('/Account'));
        await refresh();
        return;
      }
      toast(
          'Adresiniz güncellenirken bilinmeyen bir hata meydana geldi! Lütfen daha sonra tekrar deneyiniz!');
    }
  }

  @override
  Future<void> refresh() async {
    var tokens = await _authService.getAccessToken();
    if (tokens?.isGuest ?? true) {
      return;
    }
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      var address = await _accountRepository.getAccountAddresses();
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
      await _cacheManager.removeByPrefix(
          _accountRepository.generateCachePrefixForRemoval('/Account'));
      await refresh();
      return;
    }
    toast(
        'Adresiniz güncellenirken bilinmeyen bir hata meydana geldi! Lütfen daha sonra tekrar deneyiniz!');
  }

  @override
  Future<AddressModel?> getAddressModel([String? addressId]) async {
    if (addressId == null) {
      return _shippingAddressModel.shippingNewAddress;
    }
    var editAddressResponse =
        await _accountRepository.getAccountAddressEdit(addressId);
    if (editAddressResponse?.data != null) {
      return editAddressResponse!.data!.address;
    }
    return _shippingAddressModel.shippingNewAddress!;
  }

  Future<AddressModel> fillRequiredAddressFields(AddressModel baseModel) async {
    // Temel gerekli alanları doldur

    var model = baseModel.copyWith(
      email: baseModel.email ?? 'default@email.com',
      firstName: baseModel.firstName ?? 'Default FirstName',
      lastName: baseModel.lastName ?? 'Default LastName',
      address1: baseModel.address1 ?? 'Default Address 1',
      address2: baseModel.address2 ?? 'Default Address 2',
    );

    // Koşullu gerekli alanları kontrol et ve doldur
    if (model.nameEnabled ?? false) {
      model = model.copyWith(
        name: model.name ?? 'Default Address Name',
      );
    }

    if ((model.addressTypeEnabled ?? false) &&
        (model.hideAddressType ?? false)) {
      model = model.copyWith(
        addressTypeId: model.addressTypeId ?? 1,
      );
    }

    if ((model.companyEnabled ?? true) && (model.companyRequired ?? false)) {
      model = model.copyWith(
        company: model.company ?? 'Default Company',
      );
    }

    if ((model.vatNumberEnabled ?? true) &&
        (model.vatNumberRequired ?? false)) {
      model = model.copyWith(
        vatNumber: model.vatNumber ?? 'Default VAT Number',
      );
    }

    if (model.zipPostalCodeEnabled ?? false) {
      model = model.copyWith(
        zipPostalCode: model.zipPostalCode ?? 'Default Postal Code',
      );
    }

    if (model.cityEnabled ?? false) {
      model = model.copyWith(
        city: model.city ?? 'Default City',
      );
    }
    var countryRepository = await getIt.getAsync<CountryRepository>();
    var defaultCountry = model.availableCountries!
        .firstWhere((element) => !(element.value.isEmptyOrNull));

    if (model.countryEnabled ?? false) {
      model = model.copyWith(
        countryName: defaultCountry.text ?? 'Default Country',
        countryId: defaultCountry.value,
      );
    }
    var states = await countryRepository.getCountryGetStatesByCountryId(
        defaultCountry.value!, true);
    var defaultState =
        states?.data?.firstWhere((element) => !(element.id.isEmptyOrNull));
    if (model.stateProvinceEnabled ?? false) {
      model = model.copyWith(
        stateProvinceName: defaultState?.name ?? 'Default State/Province',
        stateProvinceId: defaultState?.id,
      );
    }

    if ((model.phoneEnabled ?? false) && (model.phoneRequired ?? false)) {
      model = model.copyWith(
        phoneNumber: model.phoneNumber ?? '+90 (555) 555 55 55',
      );
    }

    if ((model.faxEnabled ?? false) && (model.faxRequired ?? false)) {
      model = model.copyWith(
        faxNumber: model.faxNumber ?? '+90 (555) 555 55 56',
      );
    }

    // Custom address attributes için Map oluştur
    Map<String?, String?> customAttributes = {
      'bno': '1',
      'dno': '1',
      'kno': '1',
      'adres_tarifi': 'Default address description',
      'lat': '41.0082',
      'long': '28.9784',
    };

    // Varolan custom attributes'ları koru
    var selectedAttributes = <CustomAttributeModel>[];
    if (model.customAddressAttributes != null) {
      for (var attr in model.customAddressAttributes!) {
        if (customAttributes.containsKey(attr.name)) {
          selectedAttributes.add(CustomAttributeModel(
              key: attr.id, value: customAttributes[attr.name]));
        }
      }
    }

    // Custom attributes'ları modele ekle
    model = model
        .copyWith(selectedAttributes: selectedAttributes, availableStates: []);

    return model;
  }
}
