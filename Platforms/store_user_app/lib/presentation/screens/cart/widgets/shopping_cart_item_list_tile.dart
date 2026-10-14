import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/domain/entities/microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/shopping_cart_model/shopping_cart_item_model/shopping_cart_item_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_icon_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class ShoppingCartItemListTile extends HookConsumerWidget {
  final ShoppingCartItemModel cartItem;
  final FutureOr<void> Function()? onRemove;
  final FutureOr<void> Function()? onIncrease;
  final FutureOr<void> Function()? onDecrease;
  final FutureOr<void> Function(int selectedQuantity)? onChanged;
  const ShoppingCartItemListTile({
    super.key,
    required this.cartItem,
    this.onRemove,
    this.onDecrease,
    this.onIncrease,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allowedQuantityBuilder = FormBuilder<ShoppingCartItemModel>(cartItem)
      ..addDropDownField(
        'Quantity',
        // label: 'Adet',
        (model) => (model.quantity ?? 0),
        (option) => (option.allowedQuantities ?? <SelectListItem>[]),
        (opt) => opt.text ?? '',
        (opt) => int.parse(opt.value ?? '0'),
        initalSelectedValues: [cartItem.quantity],
      );
    var formController = AppFormController(
      allowedQuantityBuilder.build(),
      onFieldChange: (field, value) {
        onChanged?.call(value);
      },
    );

    var numberFormat = NumberFormat.currency(
      locale: 'tr_TR',
      symbol: '₺',
      decimalDigits: 2,
    );

    var themeController = getIt<ThemeController>();
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [cardBoxShadow, cardBoxShadow2],
                      color: black,
                    ),
                    child: OptimizedCacheImage(
                      imageUrl: cartItem.picture?.imageUrl ?? '',
                      sizeConfig: ImageSizeConfig(width: 110, height: 110),
                    ),
                  ),
                ),
                10.width,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      6.height,
                      Text(
                        cartItem.productName.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      3.height,
                      if (!(cartItem.attributeInfo.isEmptyOrNull))
                        Html(
                          data: cartItem.attributeInfo.toString(),
                          style: {
                            "body": Style(
                              fontSize: FontSize(12),
                              color: grey,
                              fontWeight: FontWeight.normal,
                              fontFamily:
                                  context.textTheme.bodyMedium?.fontFamily,
                            ),
                          },
                          // overflow: TextOverflow.ellipsis,
                          // maxLines: 1,
                          // style: context.textTheme.bodyMedium?.copyWith(
                          //   fontWeight: FontWeight.normal,
                          // ),
                        ),
                      if (cartItem.unitPriceWithoutDiscountValue != null &&
                          cartItem.unitPriceWithoutDiscountValue! !=
                              cartItem.unitPriceValue!)
                        Text(
                          "Kazancınız: -${numberFormat.format((cartItem.unitPriceWithoutDiscountValue! - cartItem.unitPriceValue!) * cartItem.quantity!)}",
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontFamily: '',
                            fontWeight: FontWeight.w900,
                            color: const Color.fromARGB(255, 0, 179, 255),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      6.height,
                      Text(
                        "${cartItem.unitPrice}",
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontFamily: '',
                          fontWeight: FontWeight.w900,
                          color: colorPrimary,
                        ),
                      ),
                      6.height,
                      if ((cartItem.allowItemEditing ?? false))
                        if (cartItem.allowedQuantities?.isNotEmpty ?? false)
                          SizedBox(
                            width: double.infinity,
                            // height: MediaQuery.of(context).size.height * 0.12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AppIconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: appRedColor,
                                    size: 35,
                                  ),
                                  onPressed: () => onRemove?.call(),
                                ),
                                Expanded(
                                  child: GenericForm(
                                    formBuilder: allowedQuantityBuilder,
                                    formController: formController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      if (!(cartItem.allowedQuantities?.isNotEmpty ?? false))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppIconButton(
                              icon:
                                  (cartItem.quantity ?? 0) == 1
                                      ? Icon(
                                        Icons.delete_outline,
                                        color: appRedColor,
                                        size: 35,
                                      )
                                      : SvgPicture.asset(
                                        themeController.isDarkMode
                                            ? minusDarkIcon
                                            : minusIcon,
                                        width: 35,
                                        height: 35,
                                      ),
                              onPressed: () async {
                                if ((cartItem.quantity ?? 0) > 1) {
                                  await onDecrease?.call();
                                } else {
                                  await onRemove?.call();
                                }
                              },
                            ),
                            15.width,
                            Text(
                              '${cartItem.quantity}',
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            15.width,
                            AppIconButton(
                              onPressed: onIncrease,
                              icon: SvgPicture.asset(
                                themeController.isDarkMode
                                    ? addDarkIcon
                                    : addIcon,
                                width: 35,
                                height: 35,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
