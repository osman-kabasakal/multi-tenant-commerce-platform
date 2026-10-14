import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/product_collection_widget_sceleton.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

class CategoryFeaturedProductsSkeleton extends StatelessWidget {
  const CategoryFeaturedProductsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      isLoading: true,
      skeleton: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          return Column(
            children: [
              SizedBox(
                height: isSmallScreen ? 40 : 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                        right: index == 8 - 1 ? 0 : 16,
                      ),
                      child: Row(
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              width: isSmallScreen ? 22 : 32,
                              height: isSmallScreen ? 22 : 32,
                              borderRadius:
                                  BorderRadius.all(radiusCircular(22)),
                            ),
                          ),
                          5.width,
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              width: 100,
                              height: 20,
                              borderRadius:
                                  BorderRadius.all(radiusCircular(10)),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              10.height,
              ProductCollectionWidgetSceleton(
                scrollDirection: Axis.vertical,
              ),
            ],
          );
        },
      ),
      child: const SizedBox.shrink(),
    );
  }
}
