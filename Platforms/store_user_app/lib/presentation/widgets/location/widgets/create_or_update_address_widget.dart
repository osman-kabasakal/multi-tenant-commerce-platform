import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/domain/entities/catalog/attribute_control_type/attribute_control_type.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/domain/entities/models/custom_attribute_model/custom_attribute_model.dart';
import 'package:store_user_app/domain/repositories/country/country_repository.dart';
import 'package:store_user_app/presentation/form_builders/address_model_form_builder.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card_title.dart';
import 'package:store_user_app/presentation/widgets/location/widgets/location_picker_widget.dart';
import 'package:store_user_app/presentation/widgets/location/widgets/view_location_widget.dart';

import '../view_models/adress_detail.dart';

class CreateOrUpdateAddressWidget extends ConsumerStatefulWidget {
  final AddressModel model;
  final bool editable;
  final FutureOr<void> Function(AddressModel address)? onAddressUpdated;
  const CreateOrUpdateAddressWidget({
    super.key,
    required this.model,
    this.editable = true,
    this.onAddressUpdated,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateOrUpdateAddressWidgetState();
}

class _CreateOrUpdateAddressWidgetState
    extends ConsumerState<CreateOrUpdateAddressWidget> {
  late Map<String?, String?> customAttributeMap;

  late AddressModelFormBuilder formBuilder;
  late AppFormController<AddressModel> formController;

  @override
  void initState() {
    super.initState();
    customAttributeMap = Map<String?, String?>.fromEntries(widget
        .model.customAddressAttributes
        ?.where((a) =>
    a.attributeControlType !=
        AttributeControlType.readonlyCheckboxes)
        .map<MapEntry<String?, String?>>(
            (a) => MapEntry(a.name, a.defaultValue)) ??
        {});

    formBuilder = AddressModelFormBuilder(widget.model);
    formController = AppFormController<AddressModel>(
      formBuilder.build(),
      onFieldFocusChange: fieldFocusChange,
      onFieldChange: (fieldName, value) {
        if (widget.model.customAddressAttributes
            ?.any((x) => x.name == fieldName) ??
            false) {
          customAttributeMap[fieldName] = value;
          if (fieldName == 'lat' || fieldName == 'long') {
            setState(() {});
          }
        }
      },
    );
  }

  String? lastFocusedFieldName;
  void fieldFocusChange(String fieldName, bool hasFocus) {
    if (hasFocus) {
      lastFocusedFieldName = fieldName;
    } else if (!formController
        .getValues()
        .keys
        .any((fieldName) => formController.getFocusNode(fieldName).hasFocus)) {
      var values = formController.getValues();
      var fieldNames = values.keys.toList();
      var focusNodeIndex = fieldNames.indexOf(fieldName);
      while (focusNodeIndex < values.length - 1) {
        var field = fieldNames.elementAt(focusNodeIndex + 1);
        var fieldImpl =
        formController.fields.firstWhere((f) => f.name == field);
        if (fieldImpl.type == FormFieldType.hidden || fieldImpl.readonly) {
          focusNodeIndex++;
        } else {
          var focus = formController.getFocusNode(field);
          if (focus.canRequestFocus) {
            formController.setFocus(field);
            break;
          }
        }
        focusNodeIndex++;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // late final form = GenericForm(
  //   formBuilder: formBuilder,
  //   formController: formController,
  // );

  @override
  Widget build(BuildContext context) {
    var locationWidgetTitle = widget.model.id != null
        ? 'Konum Bilgisi Güncelle'
        : 'Konum Bilgisi Ekle';
    var locationWidgetDescription = widget.model.id != null
        ? '* Şehir, ilçe ve mahalle bilgilerinizi harita üzerinden güncelleyebilirsiniz'
        : '* Şehir, ilçe ve mahalle bilgilerinizi harita üzerinden ekleyebilirsiniz';

    return Scaffold(
      appBar: fdCommonAppBarWidget(context,
          titleText: widget.model.id != null ? updateAddress : addNewAddress),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 5,
                  children: [
                    AppCardTitle.primary(title: "Konumunuz *", hasDivider: true),
                    Text(locationWidgetDescription,style: context.theme.textTheme.labelMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: context.theme.textTheme.labelMedium?.color?.withValues(alpha:0.5),
                    ),),
                    InkWell(
                      onTap: () {
                        if (widget.editable) {
                          context.router.pushWidget(
                            LocationPickerWidget(
                                lat: customAttributeMap['lat'] != null
                                    ? double.parse(customAttributeMap['lat']!)
                                    : null,
                                long: customAttributeMap['long'] != null
                                    ? double.parse(customAttributeMap['long']!)
                                    : null,
                                onAddressSelected: (address) {
                                  _handleLocationSelection(address).then((v) {
                                    if (context.mounted) context.router.maybePop();
                                  });
                                }),
                          );
                        }
                      },
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          ViewLocationWidget(
                            lat: double.parse(customAttributeMap['lat'] ?? '41.0082'),
                            long: double.parse(
                              customAttributeMap['long'] ?? '28.9784',
                            ),
                          ),
                          SizedBox(
                            width: context.width(),
                            height: context.width() / 2.2,
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            8.height,
            AppCard(
              child: GenericForm(
                key: ValueKey('CreateOrUpdateAddressWidget_form'),
                formBuilder: formBuilder,
                formController: formController,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppCard(
          child: AppCommonButton(
              text: save,
              onPressed: () async {
                if (formController.submit()) {
                  var values = formController.getValues();
                  var adresmodel = AddressModel.fromJson(values);
                  var selectedAttributes = <CustomAttributeModel>[];
                  for (var vKey in values.entries) {
                    if (widget.model.customAddressAttributes
                        ?.any((x) => x.id == vKey.key) ??
                        false) {
                      selectedAttributes.add(CustomAttributeModel(
                          key: vKey.key, value: vKey.value.toString()));
                    }

                    if (widget.model.customAddressAttributes
                        ?.any((x) => x.name == vKey.key) ??
                        false) {
                      var attr = widget.model.customAddressAttributes!
                          .firstWhere((x) => x.name == vKey.key);
                      selectedAttributes.removeWhere((x) => x.key == attr.id);
                      selectedAttributes.add(CustomAttributeModel(
                          key: attr.id, value: vKey.value.toString()));
                    }
                  }
                  values.addAll(jsonDecode(jsonEncode({
                    'SelectedAttributes': selectedAttributes,
                    'customAddressAttributes':
                    widget.model.customAddressAttributes,
                    'Address1':
                    'Bina no: ${values['bno']} Daire No: ${values['dno']} Kat: ${values['kno']}'
                  })));
                  var mergeAddressModel =
                  (jsonDecode(jsonEncode(widget.model.toJson())) as Map);
                  mergeAddressModel.addAll(values);
                  if (adresmodel.id != null) {
                    await widget.onAddressUpdated?.call(AddressModel.fromJson(
                        mergeAddressModel as Map<String, dynamic>));
                  }
                  if (context.mounted) {
                    context.router.maybePop(AddressModel.fromJson(
                        mergeAddressModel as Map<String, dynamic>));
                  }
                }
              })),
    );
  }

  Future<void> _handleLocationSelection(AddressDetail address) async {
    final countryId = widget.model.countryEnabled!
        ? widget.model.availableCountries!
        .firstWhere((s) =>
    s.text!.trim().toLowerCase() ==
        address.country.trim().toLowerCase())
        .value!
        : null;

    address.countryId = countryId;

    if (widget.model.stateProvinceEnabled! && countryId != null) {
// Get state ID
      final states = await (await getIt.getAsync<CountryRepository>())
          .getCountryGetStatesByCountryId(countryId, false);

      final stateId = states?.data!
          .firstWhere((x) =>
      x.name!.trim().toLowerCase() == address.city.trim().toLowerCase())
          .id!;

      address.stateId = stateId;
    }

    formController.updateField(
        'Address1', 'Bina no:~bno~ Daire No:~dno~ Kat:~kat~', true);
    formController.updateField(
        'Address2', '${address.street} ${address.neighbourhood}', true);
    formController.updateField('ZipPostalCode', address.postcode, true);
    formController.updateField('City', address.district, true);
    formController.updateField('StateProvinceName', address.city, true);
    formController.updateField('StateProvinceId', address.stateId, true);
    formController.updateField('CountryName', address.country, true);
    formController.updateField('CountryId', address.countryId, true);
    formController.updateField('lat', address.latitude.toString(), true);
    formController.updateField('long', address.longitude.toString(), true);
  }
}
