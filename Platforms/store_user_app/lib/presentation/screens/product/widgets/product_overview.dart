import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_attribute_model/product_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/app_add_to_wishlist_button.dart';

class ProductOverview extends ConsumerWidget {
  final ProductDetailsModel product;

  const ProductOverview({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((product.breadcrumb?.enabled ?? false) &&
                  (product.breadcrumb?.categoryBreadcrumb?.isNotEmpty ?? false))
                Text.rich(
                  TextSpan(
                    children: product.breadcrumb!.categoryBreadcrumb!
                        .map(
                          (s) => TextSpan(
                            text: s.name ?? '',
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    context.router.navigatePath(
                                      '/home/category/${s.id}',
                                    );
                                  },
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color:
                                  theme.brightness == Brightness.dark
                                      ? Colors.grey[400]
                                      : Colors.blue[700],
                            ),
                          ),
                        )
                        .fold([], (newList, element) {
                          if (newList!.isNotEmpty) {
                            newList.addAll([
                              const TextSpan(text: ' / '),
                              element,
                            ]);
                          } else {
                            newList.add(element);
                          }
                          return newList;
                        }),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color:
                        theme.brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[700],
                  ),
                ),
              Text(
                product.name ?? '',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        AppAddToWishlistButton(
          product: ProductOverviewModel(
            name: product.name,
            shortDescription: product.shortDescription,
            fullDescription: product.fullDescription,
            url: product.seName,
            productType: product.productType,
            isFreeShipping: product.isFreeShipping,
            showQty: null,
            id: product.id,
            specificationAttributeModels: product.productSpecifications,
            productAttributeModels:
                product.productAttributes!
                    .map(
                      (x) => ProductAttributeModel.fromJson(
                        jsonDecode(jsonEncode(x.toJson())),
                      ),
                    )
                    .toList(),
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     ref
        //         .read(productFavoriteProvider(product.id.toString()).notifier)
        //         .state = !isFavorite;
        //     onFavoriteToggle();
        //   },
        //   child: isFavorite
        //       ? SvgPicture.asset(
        //           'assets/icons/product_favourite.svg',
        //           height: 23,
        //           width: 23,
        //         )
        //       : SizedBox(
        //           height: 22,
        //           width: 22,
        //           child: SvgPicture.asset(
        //             'assets/icons/fashion_like.svg',
        //             colorFilter: ColorFilter.mode(
        //               theme.brightness == Brightness.dark
        //                   ? Colors.white
        //                   : theme.primaryColor,
        //               BlendMode.srcIn,
        //             ),
        //           ),
        //         ),
        // ),
      ],
    );
  }
}

// class ProductRatingBar extends StatelessWidget {
//   final ProductReviewOverviewModel product;

//   const ProductRatingBar({
//     super.key,
//     required this.product,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return IntrinsicHeight(
//       child: Row(
//         children: [
//           const Icon(
//             Icons.star,
//             color: Color(0xffE85C31),
//             size: 12,
//           ),
//           const SizedBox(width: 7),
//           Text(
//             product.revi??'0',
//             style: theme.textTheme.bodySmall?.copyWith(
//               fontWeight: FontWeight.w500,
//               color: const Color(0xffE85C31),
//             ),
//           ),
//           const SizedBox(width: 5),
//           _buildVerticalDivider(),
//           const SizedBox(width: 5),
//           Text(
//             "206 Reviews",
//             style: theme.textTheme.bodySmall?.copyWith(
//               fontWeight: FontWeight.w500,
//               color: const Color(0xffE85C31),
//             ),
//           ),
//           const SizedBox(width: 5),
//           _buildVerticalDivider(),
//           const SizedBox(width: 5),
//           Text(
//             "537 Sold",
//             style: theme.textTheme.bodySmall?.copyWith(
//               fontWeight: FontWeight.w500,
//               color: const Color(0xffE85C31),
//             ),
//           ),
//           const SizedBox(width: 5),
//           _buildVerticalDivider(),
//           const SizedBox(width: 5),
//           Text(
//             product.leftNumber,
//             style: theme.textTheme.bodySmall?.copyWith(
//               fontWeight: FontWeight.w500,
//               color: const Color(0xffE85C31),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVerticalDivider() {
//     return const VerticalDivider(
//       color: Color(0xffF19D83),
//       thickness: 1.2,
//       indent: 2,
//     );
//   }
// }
