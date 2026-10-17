import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/domain/cache/custom_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'optimized_cache_image.g.dart';

@riverpod
Future<AuthTokens?> getTokens(Ref ref) async {
  if (!getIt.isReadySync<CustomCacheManager>()) {
    await getIt.getAsync<CustomCacheManager>();
  }
  var authService = getIt<AuthService>();
  return await authService.getAccessToken();
}

class OptimizedCacheImage extends ConsumerWidget {
  final String imageUrl;
  final ImageSizeConfig sizeConfig;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool isAbsolute;
  final Alignment alignment;

  const OptimizedCacheImage({
    super.key,
    required this.imageUrl,
    required this.sizeConfig,
    this.fit = BoxFit.fitWidth,
    this.isAbsolute = false,
    this.placeholder,
    this.errorWidget,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallback = errorWidget ?? const Icon(Icons.broken_image_outlined);
    if (imageUrl.trim().isEmpty || Uri.tryParse(imageUrl) == null) {
      return SizedBox(
        width: sizeConfig.width,
        height: sizeConfig.height,
        child: fallback,
      );
    }
    var optimizedUrl = imageUrl;
    if (path.extension(Uri.parse(optimizedUrl).path).toLowerCase() == '.svg') {
      if (optimizedUrl.startsWith("assets")) {
        return SvgPicture.asset(
          optimizedUrl,
          width: sizeConfig.width,
          height: sizeConfig.height,
          fit: fit,
          alignment: alignment,
        );
      }
      return FutureBuilder<File>(
        future: (getIt.getAsync<CustomCacheManager>()).then(
          (cacheManager) => cacheManager.getSingleFile(optimizedUrl),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SizedBox(
              width: sizeConfig.width,
              height: sizeConfig.height,
              child: fallback,
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return placeholder ??
                Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
          }

          return SvgPicture.file(
            snapshot.data!,
            width: sizeConfig.width,
            height: sizeConfig.height,
            fit: fit,
            alignment: alignment,
          );
        },
      );
    }

    if (imageUrl.startsWith("assets")) {
      return Image.asset(
        optimizedUrl,
        width: sizeConfig.width,
        height: sizeConfig.height,
        fit: fit,
        alignment: alignment,
        errorBuilder:
            (context, url, error) =>
                errorWidget ??
                Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
      );
    }
    if (!isAbsolute && !imageUrl.contains('no-image')) {
      optimizedUrl = sizeConfig.getOptimizedUrl(imageUrl);
    }
    return switch (ref.watch(getTokensProvider)) {
      AsyncData<AuthTokens?>() => CachedNetworkImage(
        imageUrl: optimizedUrl,
        width: sizeConfig.width,
        height: sizeConfig.height,
        cacheManager: getIt<CustomCacheManager>(),
        memCacheWidth:
            sizeConfig.width.isFinite && sizeConfig.width > 0
                ? sizeConfig.width.round() * 5
                : null,
        filterQuality: FilterQuality.high,
        alignment: alignment,
        fit: fit,
        placeholder:
            (context, url) =>
                placeholder ??
                Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
        errorWidget:
            (context, url, error) =>
                errorWidget ??
                Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
      ),
      _ => Container(
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}
