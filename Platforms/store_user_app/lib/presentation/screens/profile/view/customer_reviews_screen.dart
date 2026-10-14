import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/datetime_extensions.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_product_review_model/customer_product_review_model.dart';
import 'package:store_user_app/presentation/screens/profile/providers/customer_reviews_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';

@RoutePage()
class CustomerReviewsScreen extends HookConsumerWidget {
  const CustomerReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = getIt<ThemeController>();

    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        titleText: 'Yorum ve değerlendirmelerim',
      ),
      body: ref.watch(customerReviewsControllerProvider).when(
            data: (data) {
              final reviews = data.reviews ?? [];

              return reviews.isEmpty
                  ? _buildEmptyState(context)
                  : AppInifiniteScrollList(
                      key: const ValueKey('CustomerReviews_list'),
                      isLoading: false,
                      hasMore: false,
                      refresh: () => ref
                          .read(customerReviewsControllerProvider.notifier)
                          .refresh(),
                      onLoadMore: () => Future.value(),
                      itemCount: reviews.length,
                      itemBuilder: (listItemContext, index) {
                        final review = reviews[index];
                        return _buildReviewCard(
                            context, review, themeController);
                      },
                    );
            },
            error: (err, stack) => Center(
              child: AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.refresh(customerReviewsControllerProvider),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: context.theme.dividerColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Henüz hiç yorum yapmadınız',
              style: context.theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Satın aldığınız ürünler hakkında yorumlarınız burada görünecektir',
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: getIt<ThemeController>().isDarkMode
                    ? colorGrey300
                    : colorGrey700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context,
      CustomerProductReviewModel review, ThemeController themeController) {
    // final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final formattedDate =
        (review.createdOn ?? DateTime.now()).formattedDateTime;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: themeController.isDarkMode ? borderDark : borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header with date
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color:
                      themeController.isDarkMode ? colorGrey400 : colorGrey600,
                ),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    color: themeController.isDarkMode
                        ? colorGrey400
                        : colorGrey600,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: themeController.isDarkMode
                ? borderDark
                : borderColor.withValues(alpha: 0.5),
          ),

          // Review content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name and rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (review.id != null && review.id!.isNotEmpty) {
                            context.router.push(
                                ProductRoute(productId: review.productId!));
                          }
                        },
                        child: Text(
                          review.productName ?? 'Ürün',
                          style: context.theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildRatingStars(context, review.rating ?? 0),
                  ],
                ),

                const SizedBox(height: 12),

                // Review text
                Text(
                  review.reviewText ?? '',
                  style: context.theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // Admin reply if exists
          if (review.replyText != null && review.replyText!.isNotEmpty)
            Column(
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: themeController.isDarkMode
                      ? borderDark
                      : borderColor.withValues(alpha: 0.5),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Satıcı Yanıtı',
                        style: context.theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.replyText ?? '',
                              style:
                                  context.theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            if (review.signature != null &&
                                review.signature!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  review.signature!,
                                  style: context.theme.textTheme.labelMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(BuildContext context, int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? Colors.amber : colorGrey400,
          size: 18,
        );
      }),
    );
  }
}
