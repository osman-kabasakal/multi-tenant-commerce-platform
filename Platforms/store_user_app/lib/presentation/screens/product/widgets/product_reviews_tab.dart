import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_review_model/product_review_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_review_overview_model/product_review_overview_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_reviews_model/product_reviews_model.dart';

import 'product_review_overview_widget.dart';

class ProductReviewsTab extends ConsumerWidget {
  final ProductReviewsModel model;
  final ProductReviewOverviewModel? productReviewOverviewModel;
  final VoidCallback? onAddReview;
  final Function(String reviewId, bool isHelpful)? onUpdateHelpfulness;

  const ProductReviewsTab({
    super.key,
    required this.model,
    this.productReviewOverviewModel,
    this.onAddReview,
    this.onUpdateHelpfulness,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Review summary box
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.theme.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: productReviewOverviewModel != null
                      ? ProductReviewOverviewWidget(
                          model: productReviewOverviewModel!,
                          onAddReviewPressed: onAddReview ?? () {},
                          canReviewCustomer: model.addProductReview
                                  ?.canCurrentCustomerLeaveReview ??
                              false,
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),

        Divider(
          color: getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
          height: 1,
          thickness: 1,
        ).paddingSymmetric(vertical: 20),

        // Review list
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: model.items!.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return _buildReviewItem(context, model.items![index]);
          },
        ),
      ],
    );
  }

  Widget _buildReviewItem(BuildContext context, ProductReviewModel review) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.customerName ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        review.writtenOnStr ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      RatingBar(rating: (review.rating ?? 0).toDouble()),
                      const SizedBox(width: 5),
                      Text(
                        review.title ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    review.reviewText ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (review.replyText != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review.replyText!),
                          if (review.signature != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              review.signature!,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Review actions (report, helpful)
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      if (onUpdateHelpfulness != null) {
                        onUpdateHelpfulness!(review.id!, true);
                      }
                    },
                    icon: Icon(Icons.thumb_up,
                        size: Theme.of(context).textTheme.bodySmall!.fontSize),
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () async {
                      if (onUpdateHelpfulness != null) {
                        onUpdateHelpfulness!(review.id!, false);
                      }
                    },
                    icon: Icon(Icons.thumb_down,
                        size: Theme.of(context).textTheme.bodySmall!.fontSize),
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${review.helpfulness?.helpfulYesTotal}/${review.helpfulness?.helpfulNoTotal})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

// Rating Bar Widget
class RatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final Color activeColor;

  const RatingBar({
    super.key,
    required this.rating,
    this.size = 12,
    this.activeColor = const Color(0xffE85C31),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: activeColor,
          size: size,
        );
      }),
    );
  }
}

// SVG Icon wrapper
class SvgIcon extends StatelessWidget {
  final String path;
  final Color? color;
  final double size;

  const SvgIcon({
    super.key,
    required this.path,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: SvgPicture.asset(
        path,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );
  }
}
