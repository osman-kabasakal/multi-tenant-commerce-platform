import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class ProfileAppBar extends HookConsumerWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 20, top: 10),
        child: Row(
          children: [
            // OptimizedCacheImage(
            //   imageUrl: AppConfig.instance.storeLogo,
            //   sizeConfig: ImageSizeConfig(width: 37, height: 37),
            // ),
            // 15.width,
            Expanded(
              child: Text(
                'Hesabım',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
