import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart' as app_colors;
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';

class BaseBottomSheet extends StatelessWidget {
  final String? title;
  final Widget Function(BuildContext context) contentBuilder;
  final Widget Function(BuildContext context)? footerBuilder;
  // final DraggableScrollableController sheetController =
  //     DraggableScrollableController();
  final double? width;
  final double? height;
  final double maxWidthPercentage;
  final double maxHeightPercentage;
  final bool isHorizontalScrollable;
  const BaseBottomSheet({
    super.key,
    this.title,
    required this.contentBuilder,
    this.footerBuilder,
    this.width,
    this.height,
    this.maxWidthPercentage = 0.8,
    this.maxHeightPercentage = 0.7,
    this.isHorizontalScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    var themeController = getIt<ThemeController>();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth:
            width ?? MediaQuery.of(context).size.width * maxWidthPercentage,
        maxHeight:
            height ?? MediaQuery.of(context).size.height * maxHeightPercentage,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Column(
              children: [
                5.height,
                Text(title!,
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: app_colors.appRedColor)),
                15.height,
                Divider(
                  color: themeController.isDarkMode
                      ? app_colors.borderDark
                      : app_colors.borderColor,
                  height: 1,
                  thickness: 1,
                ),
              ],
            ),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              primary: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Builder(builder: contentBuilder),
              ),
            ),
          ),
          if (footerBuilder != null)
            Builder(builder: footerBuilder!)
                .paddingSymmetric(horizontal: 16, vertical: 10)
        ],
      ),
    );
  }
}
