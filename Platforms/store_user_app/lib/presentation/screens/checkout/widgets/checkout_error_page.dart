import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_bottom_navigation.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';

class CheckoutErrorPage extends StatelessWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final FutureOr<void> Function() onPrimaryButtonPressed;
  final FutureOr<void> Function()? onSecondaryButtonPressed;
  final String? errorCode;
  final bool showAnimation;

  const CheckoutErrorPage({
    Key? key,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    this.secondaryButtonText,
    required this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
    this.errorCode,
    this.showAnimation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: fdCommonAppBarWidget(context, titleText: 'Ödeme Durumu'),
        body: SingleChildScrollView(
          child: Container(
            width: context.width(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Error icon or animation
                if (showAnimation) ...[
                  SizedBox(height: 120, child: _buildErrorAnimation(context)),
                  16.height,
                ],

                // Error card
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Error title
                      Text(
                        title,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorPrimary,
                        ),
                      ),
                      8.height,
                      const Divider(),
                      12.height,

                      // Error message
                      Text(message, style: context.textTheme.bodyMedium),

                      if (errorCode != null) ...[
                        16.height,
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                              8.width,
                              Text(
                                'Hata Kodu: $errorCode',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      24.height,

                      // Additional help text
                      Text(
                        'Öneriler:',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.height,

                      _buildSuggestionItem(
                        context,
                        'Ödeme bilgilerinizi kontrol edin.',
                        Icons.credit_card,
                      ),
                      _buildSuggestionItem(
                        context,
                        'İnternet bağlantınızı kontrol edin.',
                        Icons.wifi,
                      ),
                      _buildSuggestionItem(
                        context,
                        'Daha sonra tekrar deneyin.',
                        Icons.update,
                      ),
                      _buildSuggestionItem(
                        context,
                        'Sorun devam ederse müşteri hizmetleri ile iletişime geçin.',
                        Icons.support_agent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppCommonButton(
                onPressed: onPrimaryButtonPressed,
                text: primaryButtonText,
              ),
              if (secondaryButtonText != null) ...[
                8.height,
                AppCommonButton(
                  onPressed: onSecondaryButtonPressed ?? () {},
                  text: secondaryButtonText!,
                  bgColor: Colors.white,
                  textColor: colorPrimary,
                  borderColor: colorPrimary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(
    BuildContext context,
    String text,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colorPrimary),
          8.width,
          Expanded(child: Text(text, style: context.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildErrorAnimation(BuildContext context) {
    // For simplicity, using a static error icon
    // In a real implementation, you might want to use a Lottie animation
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.error_outline, size: 50, color: Colors.red.shade500),
      ),
    );
  }
}
