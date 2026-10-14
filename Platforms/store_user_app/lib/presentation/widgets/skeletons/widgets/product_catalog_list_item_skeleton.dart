import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/shimmer.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

class ProductCatalogListItemSkeleton extends StatelessWidget {
  const ProductCatalogListItemSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
                width: context.width() * 0.3,
                height: context.width() * 0.3,
                borderRadius: BorderRadius.circular(20.0)),
          ),
          10.width,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: context.textTheme.bodyLarge!.fontSize,
                  ),
                ),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: context.textTheme.bodySmall!.fontSize,
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  direction: Axis.horizontal,
                  children: List.filled(
                      5,
                      ShimmerWidget(
                        child: Icon(
                          Icons.star,
                          size: 16,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
