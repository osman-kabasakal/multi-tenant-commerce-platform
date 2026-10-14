import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/domain/entities/models/custom_attribute_model/custom_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import 'package:store_user_app/domain/entities/orders/shopping_cart_type/shopping_cart_type.dart';
import 'package:store_user_app/presentation/form_builders/product_details_cart_form_builder.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/layout/view/base_bottom_sheet.dart';
import 'package:store_user_app/core/constants/colors.dart' as app_colors;
import 'package:store_user_app/presentation/widgets/products/widgets/catalog_product_list_item_view.dart';

import '../../buttons/view/app_common_button.dart';

class QuickAddToCartBottomSheet extends HookConsumerWidget {
  final ProductDetailsModel product;
  const QuickAddToCartBottomSheet({super.key, required this.product});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var formBuilder = ProductDetailsCartFormBuilder(
      ProductDetailsCartFormModel(
        product: product,
        carttype: ShoppingCartType.shoppingCart,
      ),
    );
    var formController = AppFormController<ProductDetailsCartFormModel>(
      formBuilder.build(),
    );
    return BaseBottomSheet(
      title: 'Pratik Ürün Kartı',
      maxWidthPercentage: 1,
      maxHeightPercentage: 1,
      contentBuilder: (contentContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              // fit: FlexFit.loose,
              child: CatalogProductListItemView(
                product: ProductOverviewModel.fromJson(
                  jsonDecode(
                    jsonEncode(
                      product
                          .copyWith(
                            productPrice: product.productPrice?.copyWith(
                              price:
                                  product.productPrice?.priceWithDiscount ??
                                  product.productPrice?.price,
                            ),
                          )
                          .toJson(),
                    ),
                  ),
                ),
                readOnly: true,
                onPressed: () {},
              ),
            ),
            20.height,
            Flexible(
              child: GenericForm(
                formBuilder: formBuilder,
                formController: formController,
              ),
            ),
          ],
        );
      },
      footerBuilder: (footerContent) {
        var themeController = getIt<ThemeController>();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppCommonButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: cancel,
                height: 58,
                bgColor:
                    themeController.isDarkMode
                        ? app_colors.borderDark
                        : app_colors.primaryColor100,
                textColor:
                    themeController.isDarkMode
                        ? app_colors.colorWhite1
                        : app_colors.colorPrimary,
              ),
            ),
            15.width,
            Expanded(
              child: AppCommonButton(
                onPressed: () async {
                  if (formController.validate()) {
                    var formValues = formController.getValues();

                    var responseModel = ProductDetailsCart.fromJson(formValues);
                    responseModel = responseModel.copyWith(
                      attributes:
                          formValues.keys
                              .where(
                                (element) =>
                                    element.startsWith('attribute_') &&
                                    formValues[element] != null,
                              )
                              .map(
                                (e) => CustomAttributeModel(
                                  key: e.split('_')[1],
                                  value:
                                      formValues[e] is List
                                          ? (formValues[e] as List)
                                              .map((v) => v.toString())
                                              .join(',')
                                          : formValues[e].toString(),
                                ),
                              )
                              .toList(),
                    );
                    await footerContent.router.maybePop(responseModel);
                  }
                },
                text: add,
                height: 58,
              ),
            ),
          ],
        );
      },
    );
  }
}
