import 'package:flutter/material.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

class OrderCardSkeleton extends StatelessWidget {
  const OrderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SkeletonLine(
                  style: SkeletonLineStyle(
                    width: 100,
                    height: 24,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                const SkeletonLine(
                  style: SkeletonLineStyle(
                    width: 80,
                    height: 24,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            SkeletonListView(
              itemCount: 4,
              spacing: 8,
              item: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const SkeletonLine(
                        style: SkeletonLineStyle(
                          width: 100,
                          height: 20,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const SkeletonLine(
                        style: SkeletonLineStyle(
                          width: 120,
                          height: 20,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
