import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/deeplink/deeplink_service.dart';
import 'package:store_user_app/presentation/widgets/slider/view_models/slider_item.dart';

import '../../images/view/optimized_cache_image.dart';

class AppSlideWidget extends HookConsumerWidget {
  final SliderItem item;
  const AppSlideWidget({super.key, required this.item});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        if (item.url == null) return;
        var deeplinkService = await getIt.getAsync<DeeplinkService>();
        var path = await deeplinkService.handleIncomingLink(
          Uri.dataFromString(item.url!),
        );
        if (path == null) return;
        if (context.mounted) context.router.pushPath(path);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (lContext, lBox) {
            // Platform'a göre BoxFit ayarını değiştir
            final BoxFit imageFit =
                Platform.isIOS
                    ? BoxFit
                        .fitWidth // iOS için
                    : BoxFit.fitWidth; // Android için (mevcut çalışan davranış)

            return SizedBox(
              width: lBox.maxWidth,
              height: lBox.maxWidth,
              child: OptimizedCacheImage(
                imageUrl: item.imageUrl,
                sizeConfig: ImageSizeConfig(
                  width: lBox.maxWidth,
                  height: lBox.maxWidth,
                ),
                fit: imageFit,
                errorWidget: Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
