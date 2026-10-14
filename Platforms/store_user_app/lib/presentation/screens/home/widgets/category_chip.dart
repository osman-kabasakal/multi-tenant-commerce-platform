import 'package:flutter/material.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? colorPrimary
              : isDarkMode
                  ? cardDark
                  : colorGrey50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorPrimary
                : isDarkMode
                    ? borderDark
                    : borderColor,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.pictureModel?.imageUrl != null) ...[
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(22)),
                child: OptimizedCacheImage(
                  imageUrl: category.pictureModel?.imageUrl ?? '',
                  sizeConfig: ImageSizeConfig(
                    width: isSmallScreen ? 22 : 32,
                    height: isSmallScreen ? 22 : 32,
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                category.name ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isDarkMode
                          ? Colors.white
                          : textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
