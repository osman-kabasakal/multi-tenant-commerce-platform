import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/domain/entities/catalog/attribute_control_type/attribute_control_type.dart';
import 'package:store_user_app/domain/entities/microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';
import 'package:store_user_app/domain/entities/models/custom_attribute_model/custom_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/customer/register_model/register_model.dart';

import '../../domain/entities/models/customer/customer_attribute_model/customer_attribute_model.dart';

class RegisterModelFormBuilder extends FormBuilder<RegisterModel> {
  var specialCharacters = RegExp(r'[!@#<>\.\|?":_|=+)(*&^%0-9-]');
  var badCharacters = RegExp(r'[~`]');
  RegisterModelFormBuilder(RegisterModel model) : super(model) {
    addField(
      'Email',
      (model) => model.email,
      label: 'E-Posta',
      isRequired: true,
      type: FormFieldType.email,
      validation: (value) {
        if (!((value?.toString())?.validateEmail() ?? false)) {
          return 'Posta Adresiniz Geçerli Değil';
        }
        return null;
      },
    ).setHintText('postam@hotmail.com');

    if (model.usernamesEnabled ?? false) {
      addField(
        'Username',
        (model) => model.username,
        label: 'Kullanıcı Adı',
      ).setHintText(
        'Giriş yaparken kullanabileceğiniz benzersiz kullanıcı adı',
      );
    }

    addField(
      'Password',
      (model) => model.password,
      label: 'Şifre',
      isRequired: true,
      type: FormFieldType.password,
      validation:
          (value) =>
              value == null ||
                      value.toString().length < 6 ||
                      !value.toString().contains(specialCharacters) ||
                      value.toString().contains(badCharacters)
                  ? 'Şifreniz en az 6 karakter uzunluğunda olmalı ve en az bir özel karakter içermelidir.'
                  : null,
    );

    addField(
      'ConfirmPassword',
      (model) => model.confirmPassword,
      label: 'Şifre Tekrarı',
      isRequired: true,
      type: FormFieldType.password,
    ).setHintText('Şifrenizi tekrar girin');

    addField(
      'FirstName',
      (model) => model.firstName,
      label: 'Ad',
      isRequired: model.firstLastNameRequired ?? false,
    ).setHintText('Adınız..');

    addField(
      'LastName',
      (model) => model.lastName,
      label: 'Soyad',
      isRequired: model.firstLastNameRequired ?? false,
    ).setHintText('Soyadınız..');

    if (model.genderEnabled ?? false) {
      addField(
        'Gender',
        (model) => model.gender,
        label: 'Cinsiyet',
      ).setHintText('Cinsiyetiniz..');
    }

    if (model.dateOfBirthEnabled ?? false) {
      addField(
        'DateOfBirth',
        (model) => DateTime.now().add(Duration(days: -(12 * 30 * 18))),
        type: FormFieldType.date,
        label: 'Doğum Tarihi',
        isRequired: model.dateOfBirthRequired ?? false,
      );
    }

    if (model.companyEnabled ?? false) {
      addField(
        'Company',
        (model) => model.company,
        isRequired: model.companyRequired ?? false,
        label: 'Şirket Adı',
      ).setHintText('Şirketinizin adı...');
    }

    if (model.streetAddressEnabled ?? false) {
      addField(
        'StreetAddress',
        (model) => model.streetAddress,
        isRequired: model.streetAddressRequired ?? false,
        label: 'Sokak Adresi',
      ).setHintText('Daire, Kat, Bina...');
    }

    if (model.streetAddress2Enabled ?? false) {
      addField(
        'StreetAddress2',
        (model) => model.streetAddress2,
        isRequired: model.streetAddress2Required ?? false,
        label: 'Sokak Adresi 2',
      ).setHintText('Sokak, Mahalle, ilçe...');
    }

    if (model.cityEnabled ?? false) {
      addField(
        'City',
        (model) => model.city,
        isRequired: model.cityRequired ?? false,
        label: 'Şehir',
      ).setHintText('Şehriniz...');
    }

    if (model.zipPostalCodeEnabled ?? false) {
      addField(
        'ZipPostalCode',
        (model) => model.zipPostalCode,
        isRequired: model.zipPostalCodeRequired ?? false,
        label: 'Posta Kodu',
      ).setHintText('Posta Kodunuz...');
    }

    if (model.countryEnabled ?? false) {
      addDropDownField(
        'CountryId',
        (model) => model.countryId,
        (model) => model.availableCountries ?? <SelectListItem>[],
        (item) => item.text ?? '',
        (item) => item.value ?? '',
        isRequired: model.countryRequired ?? false,
        label: 'Ülke',
      );
    }

    if (model.stateProvinceEnabled ?? false) {
      addDropDownField(
        'StateProvinceId',
        (model) => model.stateProvinceId,
        (model) => <SelectListItem>[],
        (item) => item.text ?? '',
        (item) => item.value ?? '',
        isRequired: model.stateProvinceRequired ?? false,
        label: 'İl',
      );
    }

    if (model.phoneEnabled ?? false) {
      addField(
        'Phone',
        (model) => model.phone,
        isRequired: model.phoneRequired ?? false,
        type: FormFieldType.phone,
        label: 'Telefon',
      ).setHintText('Telefon numaranız...');
    }

    if (model.faxEnabled ?? false) {
      addField(
        'Fax',
        (model) => model.fax,
        isRequired: model.faxRequired ?? false,
        type: FormFieldType.phone,
        label: 'Faks',
      ).setHintText('Faks numaranız...');
    }

    if (model.newsletterEnabled ?? false) {
      addField(
        'Newsletter',
        (model) => model.newsletter,
        type: FormFieldType.checkbox,
        label: 'Kampanya, Haber ve Duyurulardan haberdar olmak istiyorum',
        readonly: false,
      );
    }

    if (model.newsletterCategories?.isNotEmpty ?? false) {
      addCheckboxGroupField(
        'NewsletterCategories',
        (model) => model.selectedNewsletterCategory,
        (model) => model.newsletterCategories!,
        (item) => item.name ?? '',
        (item) => item.id!,
        initalSelectedValues: model.selectedNewsletterCategory,
        label:
            'Kampanya, Haber ve Duyurulardan hangi kategorilerde haberdar olmak istersiniz?',
      );
    }

    if (model.customerAttributes?.isNotEmpty ?? false) {
      addCustomAttributeFields(model.customerAttributes!);
    }
  }

  void addCustomAttributeFields(List<CustomerAttributeModel> customAttributes) {
    for (var element in customAttributes) {
      if (element.attributeControlType == AttributeControlType.checkboxes ||
          element.attributeControlType ==
              AttributeControlType.readonlyCheckboxes) {
        if (element.values?.isNotEmpty ?? false) {
          var attIndex = model.customerAttributes!.indexWhere(
            (a) => a.id == element.id,
          );
          addCheckboxGroupField(
            element.id!,
            (model) => model.customerAttributes![attIndex],
            (model) =>
                model.customerAttributes!
                    .firstWhere((a) => a.id == element.id)
                    .values!,
            (item) => item.name ?? '',
            (item) => item.id!,
            label: element.name,
            isRequired: element.isRequired ?? false,
            readonly: element.isReadOnly ?? false,
            initalSelectedValues: model.selectedAttributes
                ?.firstWhere(
                  (sca) => sca.key == element.id,
                  orElse:
                      () => CustomAttributeModel(key: element.id, value: ''),
                )
                .value!
                .split(',')
                .fold(
                  model.customerAttributes![attIndex].defaultValue?.split(
                        ',',
                      ) ??
                      [],
                  (previousValue, element) {
                    previousValue.add(element);
                    return previousValue;
                  },
                ),
          );
        }
      } else if (element.attributeControlType ==
          AttributeControlType.dropdownList) {
        if (element.values?.isNotEmpty ?? false) {
          var attIndex = model.customerAttributes!.indexWhere(
            (a) => a.id == element.id,
          );
          addDropDownField(
            element.id!,
            (model) => model.customerAttributes![attIndex],
            (model) =>
                model.customerAttributes!
                    .firstWhere((a) => a.id == element.id)
                    .values!,
            (item) => item.name ?? '',
            (item) => item.id!,
            label: element.name,
            isRequired: element.isRequired ?? false,
            readonly: element.isReadOnly ?? false,
            initalSelectedValues: model.selectedAttributes
                ?.firstWhere(
                  (sca) => sca.key == element.id,
                  orElse:
                      () => CustomAttributeModel(key: element.id, value: ''),
                )
                .value!
                .split(',')
                .fold(
                  model.customerAttributes![attIndex].defaultValue?.split(
                        ',',
                      ) ??
                      [],
                  (previousValue, element) {
                    previousValue.add(element);
                    return previousValue;
                  },
                ),
          );
        }
      } else if (element.attributeControlType ==
          AttributeControlType.radioList) {
        if (element.values?.isNotEmpty ?? false) {
          var attIndex = model.customerAttributes!.indexWhere(
            (a) => a.id == element.id,
          );
          addRadioGroupField(
            element.id!,
            (model) => model.customerAttributes![attIndex],
            (model) =>
                model.customerAttributes!
                    .firstWhere((a) => a.id == element.id)
                    .values!,
            (item) => item.name ?? '',
            (item) => item.id!,
            label: element.name,
            isRequired: element.isRequired ?? false,
            readonly: element.isReadOnly ?? false,
            initalSelectedValues: model.selectedAttributes
                ?.firstWhere(
                  (sca) => sca.key == element.id,
                  orElse:
                      () => CustomAttributeModel(key: element.id, value: ''),
                )
                .value!
                .split(',')
                .fold(
                  model.customerAttributes![attIndex].defaultValue?.split(
                        ',',
                      ) ??
                      [],
                  (previousValue, element) {
                    previousValue.add(element);
                    return previousValue;
                  },
                ),
          );
        }
      } else if (element.attributeControlType == AttributeControlType.textBox) {
        var attIndex = model.customerAttributes!.indexWhere(
          (a) => a.id == element.id,
        );
        addField(
          element.id!,
          (model) => model.customerAttributes![attIndex].defaultValue ?? '',
          label: element.name,
          isRequired: element.isRequired ?? false,
          readonly: element.isReadOnly ?? false,
        ).setHintText(element.name ?? '');
      } else if (element.attributeControlType ==
          AttributeControlType.multilineTextbox) {
        var attIndex = model.customerAttributes!.indexWhere(
          (a) => a.id == element.id,
        );
        addMultilineTextField(
          element.id!,
          (model) => model.customerAttributes![attIndex].defaultValue ?? '',
          label: element.name,
          isRequired: element.isRequired ?? false,
          readonly: element.isReadOnly ?? false,
        ).setHintText(element.name ?? '');
      }
    }
  }
}
