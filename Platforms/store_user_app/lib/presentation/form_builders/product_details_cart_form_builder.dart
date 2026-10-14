import 'dart:io';

import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/domain/entities/catalog/attribute_control_type/attribute_control_type.dart';
import 'package:store_user_app/domain/entities/catalog/gift_voucher_type/gift_voucher_type.dart';
import 'package:store_user_app/domain/entities/catalog/interval_unit/interval_unit.dart';
import 'package:store_user_app/domain/entities/microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_attribute_model/product_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_attribute_value_model/product_attribute_value_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_warehouse_model/product_warehouse_model.dart';
import 'package:store_user_app/domain/entities/models/custom_attribute_model/custom_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import 'package:store_user_app/domain/entities/orders/shopping_cart_type/shopping_cart_type.dart';
import 'package:store_user_app/domain/repositories/product/product_repository.dart';

class ProductDetailsCartFormModel {
  late final ProductDetailsCart model;
  late final ProductDetailsModel product;

  ProductDetailsCartFormModel({
    ShoppingCartType? carttype = ShoppingCartType.shoppingCart,
    required this.product,
  }) {
    model = ProductDetailsCart(
      productId: product.id,
      shoppingCartTypeId:
          product.addToCart?.updateShoppingCartItemType ?? carttype,
      shoppingCartItemId: product.addToCart?.updatedShoppingCartItemId,
      enteredQuantity: product.addToCart?.enteredQuantity ?? 1,
      warehouseId:
          product.productWarehouses
              ?.where((x) => x.selected ?? false)
              .firstOrNull
              ?.warehouseId,
      reservationDatepickerFrom:
          product.intervalUnit == IntervalUnit.day
              ? DateTimeFormat.onlyDate(product.startDate ?? DateTime.now())
              : null,
      reservationDatepickerTo:
          product.intervalUnit == IntervalUnit.day
              ? DateTimeFormat.onlyDate(
                product.startDate?.add(
                      DateTime(
                        product.startDate!.year,
                        12,
                        31,
                      ).difference(product.startDate!),
                    ) ??
                    DateTime.now(),
              )
              : null,
      recipientName: product.giftVoucher?.recipientName,
      recipientEmail: product.giftVoucher?.recipientEmail,
      senderName: product.giftVoucher?.senderName,
      senderEmail: product.giftVoucher?.senderEmail,
      message: product.giftVoucher?.message,
      attributes:
          product.productAttributes
              ?.where(
                (a) =>
                    !a.defaultValue.isEmptyOrNull ||
                    (a.values != null &&
                        a.values!.any((av) => av.isPreSelected ?? false)),
              )
              .map(
                (a) => CustomAttributeModel(
                  key: a.id!,
                  value:
                      a.values
                          ?.where((av) => av.isPreSelected ?? false)
                          .firstOrNull
                          ?.id ??
                      a.defaultValue,
                ),
              )
              .toList(),
      reservation: product.rentalReservationId,
      customerEnteredPrice: product.addToCart?.customerEnteredPrice
          ?.toStringAsFixed(2),
    );
  }
}

class ProductDetailsCartFormBuilder
    extends FormBuilder<ProductDetailsCartFormModel> {
  ProductDetailsCartFormBuilder(super.model) {
    addField(
      'ProductId',
      (model) => model.product.id,
      type: FormFieldType.hidden,
    );

    addField<int>(
      'ShoppingCartTypeId',
      (model) => model.model.shoppingCartTypeId!.value,
      type: FormFieldType.hidden,
      isRequired: model.model.shoppingCartTypeId != null,
    );

    addField(
      'ShoppingCartItemId',
      (model) => model.model.shoppingCartItemId,
      type: FormFieldType.hidden,
      isRequired: model.model.shoppingCartItemId != null,
    );

    if (model.product.addToCart?.allowedQuantities?.isNotEmpty ?? false) {
      var initialValue =
          model.product.addToCart?.allowedQuantities
              ?.where((v) => v.selected ?? false)
              .map((v) => int.parse(v.value ?? '0'))
              .toList() ??
          (((model.product.addToCart?.allowedQuantities?.isNotEmpty ?? false)
                  ? [
                    int.parse(
                      model
                              .product
                              .addToCart
                              ?.allowedQuantities
                              ?.firstOrNull
                              ?.value ??
                          '',
                    ),
                  ]
                  : null) ??
              []);

      if (initialValue.isEmpty &&
          (model.product.addToCart?.allowedQuantities?.isNotEmpty ?? false)) {
        initialValue = [
          int.parse(
            model.product.addToCart?.allowedQuantities?.first.value ?? '0',
          ),
        ];
      }
      addDropDownField<int, SelectListItem, int>(
        'EnteredQuantity',
        (model) => model.model.enteredQuantity!,
        (model) => model.product.addToCart?.allowedQuantities ?? [],
        (o) => o.text ?? '',
        (o) => int.tryParse(o.value ?? '0') ?? 0,
        validation: (v) => v > 0 ? null : 'Lütfen miktar seçiniz',
        initalSelectedValues: initialValue,

        isRequired: true,
        label: 'Miktar',
      );
    } else {
      addField<int>(
        'EnteredQuantity',
        (model) => model.model.enteredQuantity!,
        type: FormFieldType.number,
        label: 'Miktar',
        isRequired: true,
        validation: (v) => (v ?? 0) > 0 ? null : 'Lütfen miktar seçiniz',
      ).setHintText('Lütfen miktar seçiniz');
    }

    if (model.product.giftVoucher?.isGiftVoucher ?? false) {
      addField(
        'RecipientName',
        label: 'Alıcı Adı',
        (model) => model.model.recipientName,
        isRequired: true,
      );

      if (model.product.giftVoucher?.giftVoucherType ==
          GiftVoucherType.virtual) {
        addField(
          'RecipientEmail',
          (model) => model.model.recipientEmail,
          label: 'Alıcı E-Posta',
          isRequired: true,
        );
      }

      addField(
        'SenderName',
        (model) => model.model.senderName,
        label: 'Gönderen Adı',
        isRequired: true,
      );

      if (model.product.giftVoucher?.giftVoucherType ==
          GiftVoucherType.virtual) {
        addField(
          'SenderEmail',
          (model) => model.model.senderEmail,
          label: 'Gönderen E-Posta',
          isRequired: true,
        );
      }

      addField(
        'Message',
        (model) => model.model.message,
        isRequired: true,
        label: 'Mesaj',
      );
    }

    if (model.product.intervalUnit == IntervalUnit.day) {
      addField(
        'ReservationDatepickerFrom',
        (model) => model.model.reservationDatepickerFrom,
        type: FormFieldType.date,
        label: 'Rezervasyon başlangıç tarihi',
        isRequired: true,
      );
      addField(
        'ReservationDatepickerTo',
        (model) => model.model.reservationDatepickerTo,
        label: 'Rezervasyon bitiş tarihi',
        type: FormFieldType.date,
        isRequired: true,
      );
    }

    if (model.product.allowToSelectWarehouse ?? false) {
      addDropDownField<String?, ProductWarehouseModel, String>(
        'WarehouseId',
        (model) => model.model.warehouseId,
        (model) => model.product.productWarehouses ?? [],
        (o) => o.name ?? '',
        (o) => o.warehouseId!,
        isRequired: true,
        label: 'Depo',
      );
    }

    if (model.product.addToCart?.enteredPrice ?? false) {
      addField(
        'CustomerEnteredPrice',
        (model) => model.model.customerEnteredPrice,
        label: 'Fiyat veriniz',
        type: FormFieldType.price,
        isRequired: true,
      ).setHintText(model.product.addToCart?.customerEnteredPriceRange ?? '');
    }

    if (model.product.productAttributes?.isNotEmpty ?? false) {
      _addCustomAttributeFields(model.product.productAttributes!);
    }
  }

  void _addCustomAttributeFields(List<ProductAttributeModel> list) {
    for (var element in list) {
      switch (element.attributeControlType) {
        case null:
          // TODO: Handle this case.
          throw UnimplementedError();
        case AttributeControlType.dropdownList:
          addDropDownField<String, ProductAttributeValueModel, String>(
            getAttributeKey(element),
            (model) => "",
            (v) => element.values ?? [],
            (v) =>
                '${v.name ?? ''} ${(v.priceAdjustment.isEmptyOrNull ? '' : '[${v.priceAdjustment ?? ''}]')}',
            (v) => v.id!,
            initalSelectedValues:
                element.values
                    ?.where((v) => v.isPreSelected ?? false)
                    .map((x) => x.id!)
                    .toList() ??
                [],
            label: element.name,
            isRequired: element.isRequired ?? false,
          );

        case AttributeControlType.radioList:
          addRadioGroupField<String, ProductAttributeValueModel, String>(
            getAttributeKey(element),
            (model) => "",
            (v) => element.values ?? [],
            (v) =>
                '${v.name ?? ''} ${(v.priceAdjustment.isEmptyOrNull ? '' : '[${v.priceAdjustment ?? ''}]')}',
            (v) => v.id!,
            initalSelectedValues:
                element.values
                    ?.where((v) => v.isPreSelected ?? false)
                    .map((x) => x.id!)
                    .toList() ??
                [],
            label: element.name,
            isRequired: element.isRequired ?? false,
          );

        case AttributeControlType.checkboxes:
          addCheckboxGroupField<String, ProductAttributeValueModel, String>(
            getAttributeKey(element),
            (model) => "",
            (v) => element.values ?? [],
            (v) =>
                '${v.name ?? ''} ${(v.priceAdjustment.isEmptyOrNull ? '' : '[${v.priceAdjustment ?? ''}]')}',
            (v) => v.id!,
            initalSelectedValues:
                element.values
                    ?.where((v) => v.isPreSelected ?? false)
                    .map((x) => x.id!)
                    .toList() ??
                [],
            label: element.name,
            isRequired: element.isRequired ?? false,
          );
        case AttributeControlType.textBox:
          addField(
            getAttributeKey(element),
            (model) => element.defaultValue,
            label: element.name ?? '',
            isRequired: element.isRequired ?? false,
          ).setHintText(element.textPrompt ?? '');
          break;
        case AttributeControlType.hidden:
          addField(
            getAttributeKey(element),
            (model) => element.defaultValue,
            type: FormFieldType.hidden,
          );
        case AttributeControlType.multilineTextbox:
          addMultilineTextField(
            getAttributeKey(element),
            (model) => element.defaultValue,
            label: element.name,
            isRequired: element.isRequired ?? false,
          ).setHintText(element.textPrompt ?? '');
        case AttributeControlType.datepicker:
          addField(
            getAttributeKey(element),
            (model) =>
                element.defaultValue != null
                    ? DateTime.parse(element.defaultValue!)
                    : DateTime.now(),
            label: element.name,
            isRequired: element.isRequired ?? false,
            type: FormFieldType.date,
          );
        case AttributeControlType.fileUpload:
          addField(
            getAttributeKey(element),
            (model) => element.defaultValue,
            label:
                (element.textPrompt ?? (element.name ?? '')) +
                (element.values?.firstOrNull?.priceAdjustment.isEmptyOrNull ??
                        true
                    ? ''
                    : ' (${element.values?.firstOrNull?.priceAdjustment})'),
            isRequired: element.isRequired ?? false,
            type: FormFieldType.file,
            configurations: {
              'allowedExtensions': element.allowedFileExtensions ?? [],
              'onFileSelected': _handleFileUpload,
            },
          );
          break;
        case AttributeControlType.colorSquares:
          addRadioGroupField<String, ProductAttributeValueModel, String>(
            getAttributeKey(element),
            (model) => "",
            (v) => element.values ?? [],
            (v) => v.colorSquaresRgb ?? '#000000',
            (v) => v.id!,
            initalSelectedValues:
                element.values
                    ?.where((v) => v.isPreSelected ?? false)
                    .map((x) => x.id!)
                    .toList() ??
                [],
            label: element.name,
            type: FormFieldType.radioColor,
            isRequired: element.isRequired ?? false,
          );
        case AttributeControlType.imageSquares:
          // TODO: Handle this case.
          throw UnimplementedError();
        case AttributeControlType.readonlyCheckboxes:
          addCheckboxGroupField<String, ProductAttributeValueModel, String>(
            getAttributeKey(element),
            (model) => "",
            (v) => element.values ?? [],
            (v) =>
                '${v.name ?? ''} ${(v.priceAdjustment.isEmptyOrNull ? '' : '[${v.priceAdjustment ?? ''}]')}',
            (v) => v.id!,
            initalSelectedValues:
                element.values
                    ?.where((v) => v.isPreSelected ?? false)
                    .map((x) => x.id!)
                    .toList() ??
                [],
            label: element.name,
            isRequired: element.isRequired ?? false,
            readonly: true,
          );
      }
    }
  }

  String getAttributeKey(ProductAttributeModel attribute) {
    return 'attribute_${attribute.id}';
  }

  Future<String> _handleFileUpload(String fieldName, File? file) async {
    if (file != null && file.existsSync()) {
      var response = await (await getIt.getAsync<ProductRepository>())
          .postProductUploadFileProductAttribute(
            fieldName.split('_')[1],
            model.model.productId!,
            file,
          );
      if (response?.data?.success ?? false) {
        return response!.data!.downloadGuid!;
      } else if (response?.data?.message?.isNotEmpty ?? false) {
        toast(response!.data!.message!);
      }
    }

    return "";
  }
}
