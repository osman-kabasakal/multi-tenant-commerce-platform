import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/domain/entities/models/custom_attribute_model/custom_attribute_model.dart';
import 'package:store_user_app/domain/repositories/country/country_repository.dart';
import 'package:nb_utils/nb_utils.dart';

extension AddressModelExtensions on AddressModel {
  Future<AddressModel> fillRequiredAddressFields() async {
    // Temel gerekli alanları doldur
    var baseModel = this;
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

    if (model.countryEnabled ?? false) {
      var defaultCountry = model.availableCountries!
          .firstWhere((element) => !(element.value.isEmptyOrNull));
      model = model.copyWith(
        countryName: defaultCountry.text ?? 'Default Country',
        countryId: defaultCountry.value,
      );
    }

    if (model.stateProvinceEnabled ?? false) {
      var states = await countryRepository.getCountryGetStatesByCountryId(
          model.countryId!, true);
      var defaultState =
          states?.data?.firstWhere((element) => !(element.id.isEmptyOrNull));
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
    if (model.customAddressAttributes != null && customAttributes.isNotEmpty) {
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
