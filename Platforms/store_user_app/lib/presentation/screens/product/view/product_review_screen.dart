import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/services/dialog/dialog_helper.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/domain/entities/models/catalog/add_product_review_model/add_product_review_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_review_overview_model/product_review_overview_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_reviews_model/product_reviews_model.dart';
import 'package:store_user_app/presentation/form_builders/add_review_model_form_builder.dart';
import 'package:store_user_app/presentation/screens/product/providers/product_reviews_controller.dart';
import 'package:store_user_app/presentation/screens/product/widgets/add_review_widget.dart';
import 'package:store_user_app/presentation/screens/product/widgets/product_reviews_tab.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';

class ProductReviewScreen extends ConsumerStatefulWidget {
  final ProductReviewsModel model;
  final ProductReviewOverviewModel? productReviewOverviewModel;
  const ProductReviewScreen(
      {super.key, required this.model, this.productReviewOverviewModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductReviewScreenState();
}

class _ProductReviewScreenState extends ConsumerState<ProductReviewScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref
      //     .read(productReviewsControllerProvider(widget.model).notifier)
      //     .getProductReviews(widget.model.productId!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: fdCommonAppBarWidget(context, titleText: ratingReviews),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ref.watch(productReviewsControllerProvider(widget.model)).when(
                skipLoadingOnRefresh: true,
                skipLoadingOnReload: true,
                data: (value) {
                  return ProductReviewsTab(
                    model: value.reviewsModel!,
                    productReviewOverviewModel:
                        widget.productReviewOverviewModel,
                    onAddReview: _showReviewForm,
                    onUpdateHelpfulness: _updateReviewHelpfulness,
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Center(child: AppErrorWidget(message: error.toString())),
              ),
        ),
      ),
    );
  }

  Future<void> _showReviewForm() async {
    context.router.pushWidget(
      AddReviewWidget(
        model: ref
            .read(productReviewsControllerProvider(widget.model)
                .select((s) => s.requireValue))
            .reviewsModel!
            .addProductReview!,
        onSubmit: (formResult) async {
          // Use the provider to submit the review
          final success = await ref
              .read(productReviewsControllerProvider(widget.model).notifier)
              .submitReview(formResult);

          if (success) {
            toast('Değerlendirme başarıyla eklendi');
            context.router.maybePop();
          } else {
            toast('Değerlendirme eklenirken bir hata oluştu');
          }
        },
      ),
    );
  }

  Future<void> _updateReviewHelpfulness(String reviewId, bool isHelpful) async {
    // Use the provider to update helpfulness
    final success = await ref
        .read(productReviewsControllerProvider(widget.model).notifier)
        .updateReviewHelpfulness(reviewId, widget.model.productId!, isHelpful);

    if (!success) {
      toast('Değerlendirme güncellenirken bir hata oluştu');
    }
  }
}
