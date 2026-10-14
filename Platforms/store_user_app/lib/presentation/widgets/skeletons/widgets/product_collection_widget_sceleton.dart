import 'package:flutter/material.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/product_catalog_grid_skeleton.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/product_catalog_list_item_skeleton.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

class ProductCollectionWidgetSceleton extends StatelessWidget {
  final Axis scrollDirection;
  const ProductCollectionWidgetSceleton({
    super.key,
    this.scrollDirection = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Skeleton(
      isLoading: true,
      skeleton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 24,
                    width: screenWidth * 0.3,
                  ),
                ),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 24,
                    width: screenWidth * 0.1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          scrollDirection == Axis.horizontal
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                      height: screenWidth *
                          .95, // Adjust height based on screen size
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return ProductCatalogGridSkeleton(
                              last: index == 19 ? true : false);
                        },
                      )),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 20,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return ProductCatalogListItemSkeleton();
                    },
                  ),
                ),
        ],
      ),
      child: SizedBox.shrink(),
    );
  }
}
