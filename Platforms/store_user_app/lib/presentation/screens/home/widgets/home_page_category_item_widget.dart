import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/presentation/screens/home/view_models/home_page_category_item_view_model.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_async_waiter_button.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class HomePageCategoryItemWidget extends HookConsumerWidget {
  final HomePageCategoryItemViewModel category;
  final VoidCallback onTap;

  const HomePageCategoryItemWidget({
    super.key,
    required this.category,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeController = getIt<ThemeController>();
    var theme =
        themeController.isDarkMode
            ? AppTheme.foodDarkTheme
            : AppTheme.foodLightTheme;
    return AppAsyncWaiterButton(
      onPressed: () async => onTap(),
      child: Column(
        children: [
          SizedBox(
            height: 64,
            width: 64,
            // decoration: BoxDecoration(
            //   color: themeController.isDarkMode ? cardDark : colorGrey50,
            //   borderRadius: BorderRadius.circular(textFieldRadius),
            //   border: Border.all(
            //     color: themeController.isDarkMode ? borderDark : borderColor,
            //   ),
            // ),
            child: Center(
              child: OptimizedCacheImage(
                fit: BoxFit.cover,
                imageUrl: category.imageUrl,
                sizeConfig: ImageSizeConfig(width: 64, height: 64),
                placeholder: Container(
                  padding: const EdgeInsets.all(8),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
