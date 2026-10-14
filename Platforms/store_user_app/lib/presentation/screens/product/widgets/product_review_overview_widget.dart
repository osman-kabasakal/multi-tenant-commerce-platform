import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_review_overview_model/product_review_overview_model.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';

class ProductReviewOverviewWidget extends StatelessWidget {
  final ProductReviewOverviewModel model;
  final VoidCallback onAddReviewPressed;
  final bool canReviewCustomer;
  const ProductReviewOverviewWidget({
    super.key,
    required this.model,
    required this.onAddReviewPressed,
    required this.canReviewCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
              text: model.avgRating.toString(),
              style: context.textTheme.displaySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: ' (${model.totalReviews ?? 0} oylama)',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: getIt<ThemeController>().isDarkMode
                        ? colorGrey300
                        : colorGrey800,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ]),
          overflow: TextOverflow.ellipsis,
        ),
        8.height,
        RatingBarWidget(
          size: 24,
          onRatingChanged: (rating) {},
          rating: model.avgRating ?? 0,
          activeColor: yellowGradient2,
          disable: true,
          // allowHalfRating: true,
        ),
        8.height,
        if (canReviewCustomer)
          AppCommonButton(
            textStyle: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.035),
            onPressed: onAddReviewPressed,
            text: 'Değerlendir',
            height: MediaQuery.of(context).size.width * 0.12,
          ),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 20,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, size: size, color: color);
        } else if (index == rating.floor() && rating % 1 != 0) {
          return Icon(Icons.star_half, size: size, color: color);
        } else {
          return Icon(Icons.star_border, size: size, color: color);
        }
      }),
    );
  }
}
