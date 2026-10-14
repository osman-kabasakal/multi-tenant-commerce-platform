import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/presentation/screens/home/view_models/special_offer_item_view_model.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class AppSpecialOfferItemWidget extends HookConsumerWidget {
  final SpecialOfferItemViewModel offer;
  const AppSpecialOfferItemWidget({super.key, required this.offer});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          _buildBackgroundImage(),

          // _buildOfferContent(context)
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: LayoutBuilder(
        builder: (context, lboxConstraints) {
          return OptimizedCacheImage(
            imageUrl: offer.imageUrl,
            sizeConfig: ImageSizeConfig(
              width: lboxConstraints.maxWidth,
              height: lboxConstraints.maxHeight,
            ),
            fit: BoxFit.fitWidth,
            errorWidget: Container(
              height: 181,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                gradient: const LinearGradient(colors: [gradient1, gradient2]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOfferContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            offer.title,
            style: context.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 60,
              height: 1.1,
              fontFamily: GoogleFonts.luckiestGuy().fontFamily,
              color: Colors.white,
            ),
          ),
          Text(
            offer.description,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              fontFamily: GoogleFonts.luckiestGuy().fontFamily,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
