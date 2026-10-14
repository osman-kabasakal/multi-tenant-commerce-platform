import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/domain/entities/models/media/picture_model/picture_model.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  final List<PictureModel> galleryItems;
  final int initialIndex;
  final String productId;
  final Function onClose;

  const GalleryPhotoViewWrapper({
    super.key,
    required this.galleryItems,
    required this.initialIndex,
    required this.productId,
    required this.onClose,
  });

  @override
  State<GalleryPhotoViewWrapper> createState() =>
      _GalleryPhotoViewWrapperState();
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions.customChild(
                child: OptimizedCacheImage(
                  imageUrl: widget.galleryItems[index].fullSizeImageUrl!,
                  sizeConfig: ImageSizeConfig(width: 500, height: 500),
                  isAbsolute: true,
                  fit: BoxFit.fitWidth,
                ),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: 'product-image-${widget.productId}-$index',
                ),
              );
            },
            itemCount: widget.galleryItems.length,
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null
                    ? null
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            pageController: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onClose();
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: _buildIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.galleryItems.asMap().entries.map((entry) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == entry.key
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
          ),
        );
      }).toList(),
    );
  }
}
