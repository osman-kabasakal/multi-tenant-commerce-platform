import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_bottom_navigation.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card_title.dart';

class FailStep extends StatelessWidget {
  final String title;
  final String messageTitle;
  final String message;
  final Color dialogColor;
  final String buttonText;
  final FutureOr<void> Function()? onPressed;
  final IconData? icon;
  const FailStep({
    super.key,
    required this.title,
    required this.messageTitle,
    required this.message,
    required this.dialogColor,
    required this.buttonText,
    this.onPressed,
    this.icon,
  });

  factory FailStep.withError({
    required String title,
    required String message,
    required String buttonText,
    Function()? onPressed,
  }) {
    return FailStep(
      title: title,
      messageTitle: 'Hata',
      message: message,
      dialogColor: Colors.red,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: Icons.error_outline,
    );
  }

  factory FailStep.withWarning({
    required String title,
    required String message,
    required String buttonText,
    Function()? onPressed,
  }) {
    return FailStep(
      title: title,
      messageTitle: 'Uyarı',
      message: message,
      dialogColor: Colors.orange,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: Icons.warning_amber,
    );
  }

  factory FailStep.withInfo({
    required String title,
    required String message,
    required String buttonText,
    Function()? onPressed,
  }) {
    return FailStep(
      title: title,
      messageTitle: 'Bilgi',
      message: message,
      dialogColor: Colors.blue,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: Icons.info_outline,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: fdCommonAppBarWidget(context, titleText: title),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.width() * 0.8,
              maxHeight: context.height() * 0.7,
            ),
            child: AppCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    // Başarılı işlem ikonu
                    SizedBox(
                      width: context.height() * 0.05,
                      height: context.height() * 0.020,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.loose,
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -context.height() * 0.07,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: dialogColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.theme.scaffoldBackgroundColor,
                                  width: 4.0,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  icon!,
                                  size: (context.height() * 0.05) -
                                      16, // Ekran genişliğine göre ikon boyutu
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16.0),
                  ],

                  // Başarılı sipariş mesajı
                  AppCardTitle.active(
                    title: messageTitle,
                    // style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    // textAlign: TextAlign.center,
                    hasDivider: true,
                  ),
                  8.height,
                  Text(
                    message,
                    style: context.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.normal),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(
          child: AppCommonButton(
            onPressed: () async {
              if (onPressed != null) {
                await onPressed!();
              } else {
                await context.router.maybePop();
              }
            },
            text: buttonText,
          ),
        ),
      ),
    );
  }
}
