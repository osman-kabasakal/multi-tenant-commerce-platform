import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/shimmer.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

class ProductCatalogGridSkeleton extends StatelessWidget {
  const ProductCatalogGridSkeleton({
    super.key,
    required this.last,
  });

  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: last ? 0 : 15,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: SizedBox(
          width: context.width() * 0.6, // Adjust width based on screen size
          height: double.infinity,
          // padding:
          //     const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            spacing: 16,
            children: [
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: context.width() * 0.7,
                  height: context.width() * 0.6,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
              ),
              Column(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 16,
                      width: context.width() * 0.3,
                    ),
                  ),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 8,
                      width: context.width() * 0.2,
                    ),
                  ),
                  5.height,
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
            ],
          ),
        ),
      ),
    );
  }
}
