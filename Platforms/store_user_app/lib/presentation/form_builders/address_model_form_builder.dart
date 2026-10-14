import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/domain/entities/catalog/attribute_control_type/attribute_control_type.dart';
import 'package:store_user_app/domain/entities/common/address_type/address_type.dart';
import 'package:store_user_app/domain/entities/models/common/address_attribute_model/address_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';

class AddressModelFormBuilder extends FormBuilder<AddressModel> {
  AddressModelFormBuilder(super.model) {
    var customAttrbuteMap = Map<String?, String?>.fromEntries(
      model.customAddressAttributes
          ?.where(
            (a) =>
        a.attributeControlType !=
            AttributeControlType.readonlyCheckboxes,
      )
          .map<MapEntry<String?, String?>>(
            (a) => MapEntry(a.name, _getDevaultValue(a)),
      ) ??
          {},
    );

    addField<String?>(
      'Email',
          (m) => m.email,
      label: 'Email',
      isRequired: true,
      readonly: model.disallowUsersToChangeEmail ?? false,
      validation: (v) {
        if (!((v?.toString())?.validateEmail() ?? false)) {
          return 'Mail beklenen formatta değil';
        }
        return null;
      },
      type: FormFieldType.email,
    ).setHintText('postam@sunucu.com');

    if (model.nameEnabled ?? false) {
      addField<String?>(
        'Name',
            (m) => m.name,
        label: 'Adres Adı',
        isRequired: true,
        validation: (v) {
          if (v != null && v is String) {
            if (v.isEmpty) {
              return 'Adres adı boş olamaz';
            }
          } else {
            return 'Adres adı gereklidir';
          }

          return null;
        },
      ).setHintText('Evim, İş, Diğer');
    }

    if ((model.addressTypeEnabled ?? false) &&
        (model.hideAddressType ?? false)) {
      addDropDownField(
        'AddressTypeId',
            (m) => m.addressTypeId,
            (m) => AddressType.values,
            (l) => l.name,
            (l) => l.value,
        initalSelectedValues: [model.addressTypeId],
        label: 'Adres Tipi',
        isRequired: true,
        readonly: false,
        validation: (v) {
          if (v != null && v is int) {
            if (v == 0) {
              return 'Adres tipi seçiniz';
            }
          } else {
            return 'Adres tipi seçiniz';
          }
          return null;
        },
      );
    }

    addField(
      'FirstName',
          (m) => m.firstName,
      label: 'Ad',
      isRequired: true,
      validation: (v) {
        if (v != null && v is String) {
          if (v.isEmpty) {
            return 'Ad boş olamaz';
          }
        } else {
          return 'Ad bilgisi boş olamaz';
        }
        return null;
      },
    ).setHintText('Adınızı girin');

    addField(
      'LastName',
          (m) => m.lastName,
      label: 'Soyad',
      isRequired: true,
      validation: (v) {
        if (v != null && v is String) {
          if (v.isEmpty) {
            return 'Soyad boş olamaz';
          }
        } else {
          return 'Soyad bilgisi boş olamaz';
        }

        return null;
      },
    ).setHintText('Soyadınızı girin');

    if (model.companyEnabled ?? false) {
      addField(
        'Company',
            (m) => m.company,
        label: 'Şirket',
        isRequired: model.companyRequired ?? false,
        validation: (v) {
          if (v != null && v is String) {
            if (v.isEmpty) {
              if (model.companyRequired!) {
                return 'Şirket boş olamaz';
              } else {
                return null;
              }
            }
            if (v.length < 3) {
              return 'Şirket adı en az 3 karakter olmalıdır';
            }

            if (v.length > 50) {
              return 'Şirket adı en fazla 50 karakter olmalıdır';
            }
          } else if (model.companyRequired!) {
            return 'Şirket bilgisi boş olamaz';
          }
          return null;
        },
      ).setHintText('Şirket adınızı girin');
    }

    if (model.vatNumberEnabled ?? false) {
      addField(
        'VatNumber',
            (m) => m.vatNumber,
        label: 'Vergi Numarası',
        isRequired: model.vatNumberRequired ?? false,
        validation: (v) {
          if (v != null && v is String) {
            if (v.isEmpty) {
              if (model.vatNumberRequired!) {
                return 'Vergi numarası boş olamaz';
              } else {
                return null;
              }
            }
            if (v.length < 3) {
              return 'Vergi numarası en az 3 karakter olmalıdır';
            }

            if (v.length > 50) {
              return 'Vergi numarası en fazla 50 karakter olmalıdır';
            }
          } else if (model.vatNumberRequired!) {
            return 'Vergi numarası bilgisi boş olamaz';
          }
          return null;
        },
      ).setHintText('Vergi numaranızı girin');
    }

    addField<String?>(
      'bno',
          (m) => customAttrbuteMap['bno'],
      label: 'Bina No',
      isRequired: true,
      validation: (v) {
        if (v != null && v is String) {
          if (v.isEmpty) {
            return 'Bina numarası boş olamaz';
          }
        } else if (v != null && v is int) {
          if (v == 0) {
            return 'Bina numarası boş olamaz';
          }
        } else {
          return 'Bina numarası bilgisi boş olamaz';
        }
        return null;
      },
      type: FormFieldType.number,
    ).setHintText('Bina No');

    addField<String?>(
      'dno',
          (m) => customAttrbuteMap['dno'],
      label: 'Daire No',
      isRequired: true,
      validation: (v) {
        if (v != null && v is String) {
          if (v.isEmpty) {
            return 'Daire numarası boş olamaz';
          }
        } else if (v != null && v is int) {
          if (v == 0) {
            return 'Daire numarası boş olamaz';
          }
        } else {
          return 'Daire numarası bilgisi boş olamaz';
        }
        return null;
      },
      type: FormFieldType.number,
    ).setHintText('Daire No');

    addField<String?>(
      'kno',
          (m) => customAttrbuteMap['kno'],
      label: 'Kat No',
      isRequired: true,
      validation: (v) {
        if (v != null && v is String) {
          if (v.isEmpty) {
            return 'Kat numarası boş olamaz';
          }
        } else if (v != null && v is int) {
          if (v == 0) {
            return 'Kat numarası boş olamaz';
          }
        } else {
          return 'Kat numarası bilgisi boş olamaz';
        }
        return null;
      },
      type: FormFieldType.number,
    ).setHintText('Kat No');

    addField(
      'Address1',
          (m) => m.address1,
      label: 'Sokak Adresi',
      isRequired: true,
      readonly: true,
      validation: (v) {
        if (v != null && v is String) {
          if (v.isEmpty) {
            return 'Adres boş olamaz';
          }
        } else {
          return 'Adres bilgisi boş olamaz';
        }
        return null;
      },
      type: FormFieldType.hidden,
    ).setHintText('Daire, Kat, Bina...');

    addMultilineTextField(
      'Address2',
          (m) => m.address2,
      label: 'Sokak Adresi',
      isRequired: true,
      readonly: true,
      validation: (v) {
        if (v != null && v is String) {
          if (v.isEmpty) {
            return 'Adres 2 boş olamaz';
          }
        }
        return null;
      },
    ).setHintText('Sokak, Mahalle, ilçe...');

    if (model.zipPostalCodeEnabled ?? false) {
      addField(
        'ZipPostalCode',
            (m) => m.zipPostalCode,
        label: 'Posta Kodu',
        isRequired: model.zipPostalCodeRequired!,
        readonly: true,
        validation: (v) {
          if (v != null && v is String) {
            if (v.isEmpty && model.zipPostalCodeRequired!) {
              return 'Posta kodu boş olamaz';
            }
          } else if (model.zipPostalCodeRequired!) {
            return 'Posta kodu bilgisi boş olamaz';
          }
          return null;
        },
      ).setHintText('Posta Kodunuz...');
    }

    if (model.cityEnabled ?? false) {
      addField(
        'City',
            (m) => m.city,
        label: 'Şehir',
        isRequired: model.cityRequired ?? false,
        readonly: true,
        validation: (v) {
          if (v != null && v is String) {
            if (v.isEmpty && model.cityRequired!) {
              return 'Şehir boş olamaz';
            }
          } else if (model.cityRequired!) {
            return 'Şehir bilgisi boş olamaz';
          }
          return null;
        },
      ).setHintText('Şehriniz...');
    }

    if (model.stateProvinceEnabled ?? false) {
      addField(
        'StateProvinceName',
            (m) => m.stateProvinceName,
        label: 'İlçe',
        isRequired: model.stateProvinceEnabled ?? false,
        readonly: true,
        validation: (v) {
          if (v != null && v is String) {
            if (v.isEmpty) {
              return 'İlçe boş olamaz';
            }
          } else if (model.stateProvinceEnabled!) {
            return 'İlçe bilgisi boş olamaz';
          }
          return null;
        },
      );

      addField(
        'StateProvinceId',
            (m) => m.stateProvinceId,
        type: FormFieldType.hidden,
      );
    }

    if (model.countryEnabled ?? false) {
      addField(
        'CountryName',
            (m) => m.countryName,
        label: 'Ülke',
        isRequired: true,
        readonly: true,
        validation: (v) {
          if (v != null && v is String) {
            if (v.isEmpty) {
              return 'Ülke boş olamaz';
            }
          } else {
            return 'Ülke bilgisi boş olamaz';
          }
          return null;
        },
      );

      addField('CountryId', (m) => m.countryId, type: FormFieldType.hidden);
    }

    if (model.phoneEnabled ?? false) {
      addField(
        'PhoneNumber',
            (m) => m.phoneNumber,
        label: 'Telefon',
        isRequired: model.phoneRequired ?? false,
        readonly: false,
        type: FormFieldType.phone,
        validation: (v) {
          if (v != null && v is String) {
            if (v.isEmpty && model.faxRequired!) {
              return 'Telefon boş olamaz';
            }
          } else if (model.phoneRequired!) {
            return 'Telefon bilgisi boş olamaz';
          }
          return null;
        },
      ).setHintText('Telefon numaranız...');
    }

    if (model.faxEnabled ?? false) {
      addField(
        'FaxNumber',
            (m) => m.faxNumber,
        label: 'Faks',
        isRequired: model.faxRequired ?? false,
        readonly: false,
        type: FormFieldType.phone,
        validation: (v) {
          if (v != null && v is String) {
            if (v.isEmpty && model.faxRequired!) {
              return 'Faks boş olamaz';
            }
          } else if (model.faxRequired!) {
            return 'Faks bilgisi boş olamaz';
          }
          return null;
        },
      ).setHintText('Faks numaranız...');
    }

    addMultilineTextField(
      'adres_tarifi',
          (m) => customAttrbuteMap['adres_tarifi'],
      label: 'Adres Tarifi',
      isRequired: true,
      validation: (v) {
        if (v != null && v is String) {
          if (v.isEmpty) {
            return 'Adres tarifi boş olamaz';
          }
        } else {
          return 'Adres tarifi bilgisi boş olamaz';
        }
        return null;
      },
    ).setHintText('Örnek: Merkez caminin karşısı...');

    if (model.noteEnabled ?? false) {
      addMultilineTextField(
        'Note',
            (m) => m.note,
        label: 'Not',
        isRequired: false,
        readonly: false,
      ).setHintText('Siparişiniz ile ilgili eklemk istediğiniz notlar...');
    }

    addField(
      'lat',
          (m) => customAttrbuteMap['lat'],
      type: FormFieldType.hidden,
    );
    addField(
      'long',
          (m) => customAttrbuteMap['long'],
      type: FormFieldType.hidden,
    );
    var fields = build();
    for (var attr
    in (model.customAddressAttributes ?? <AddressAttributeModel>[])) {
      if (fields.any(
            (element) => element.name == attr.name || element.name == attr.id,
      )) {
        continue;
      }

      var selectedAttribute =
          model.selectedAttributes!.where((a) => a.key == attr.id).firstOrNull;
      if (selectedAttribute != null) {
        attr = attr.copyWith(defaultValue: selectedAttribute.value);
      }
      switch (attr.attributeControlType) {
        case null:
          throw UnimplementedError();
        case AttributeControlType.dropdownList:
          if (attr.values?.isNotEmpty ?? false) {
            addDropDownField(
              attr.id!,
                  (model) => attr,
                  (model) => attr.values!,
                  (item) => item.name ?? '',
                  (item) => item.id!,
              label: attr.name ?? '',
              isRequired: attr.isRequired ?? false,
              initalSelectedValues:
              attr.defaultValue?.split(',') ??
                  attr.values!
                      .where((v) => v.isPreSelected ?? false)
                      .map((e) => e.id)
                      .toList(),
            );
          }
          break;
        case AttributeControlType.radioList:
          if (attr.values?.isNotEmpty ?? false) {
            addRadioGroupField(
              attr.id!,
                  (model) => attr,
                  (model) => attr.values!,
                  (item) => item.name ?? '',
                  (item) => item.id!,
              label: attr.name ?? '',
              isRequired: attr.isRequired ?? false,
              initalSelectedValues:
              attr.defaultValue?.split(',') ??
                  attr.values!
                      .where((v) => v.isPreSelected ?? false)
                      .map((e) => e.id)
                      .toList(),
            );
          }
          break;
        case AttributeControlType.readonlyCheckboxes:
        case AttributeControlType.checkboxes:
          if (attr.values?.isNotEmpty ?? false) {
            addCheckboxGroupField(
              attr.id!,
                  (model) => attr,
                  (model) => attr.values!,
                  (item) => item.name ?? '',
                  (item) => item.id!,
              label: attr.name ?? '',
              isRequired: attr.isRequired ?? false,
              readonly:
              attr.attributeControlType ==
                  AttributeControlType.readonlyCheckboxes,
              initalSelectedValues:
              attr.defaultValue?.split(',') ??
                  attr.values!
                      .where((v) => v.isPreSelected ?? false)
                      .map((e) => e.id)
                      .toList(),
            );
          }
          break;
        case AttributeControlType.textBox:
          addField(
            attr.id!,
                (model) => attr.defaultValue,
            label: model.name ?? '',
            isRequired: attr.isRequired ?? false,
          );
          break;

        case AttributeControlType.multilineTextbox:
          addMultilineTextField(
            attr.id!,
                (model) => attr.defaultValue,
            label: attr.name ?? '',
            isRequired: attr.isRequired ?? false,
          );
          break;
        case AttributeControlType.datepicker:
          throw UnimplementedError();
        case AttributeControlType.fileUpload:
          throw UnimplementedError();
        case AttributeControlType.colorSquares:
          throw UnimplementedError();
        case AttributeControlType.imageSquares:
          throw UnimplementedError();
        case AttributeControlType.hidden:
          throw UnimplementedError();
      }
    }
  }

  dynamic _getDevaultValue(AddressAttributeModel attributeModel) {
    var selectedAttribute =
        model.selectedAttributes!
            .where((a) => a.key == attributeModel.id)
            .firstOrNull;
    if (selectedAttribute != null) {
      return selectedAttribute.value;
    }

    return attributeModel.defaultValue;
  }
}
