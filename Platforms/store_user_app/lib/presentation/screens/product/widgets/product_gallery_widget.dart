import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';
import 'package:store_user_app/domain/entities/models/media/picture_model/picture_model.dart';
import 'package:store_user_app/presentation/screens/product/widgets/gallery_photo_view_wrapper.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

class ProductGallery extends StatefulWidget {
  final ProductDetailsModel model;

  const ProductGallery({
    super.key,
    required this.model,
  });

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  int _currentIndex = 0;
  bool _isGalleryOpen = false;
  final double aspectRatio = 1.5;

  @override
  Widget build(BuildContext context) {
    if (widget.model.defaultPictureModel == null) {
      return const SizedBox.shrink();
    }

    if (widget.model.pictureModels!.isEmpty ||
        widget.model.pictureModels!.length == 1) {
      return _buildMainImage();
    }

    return Column(
      children: [
        CarouselSlider(
          items: widget.model.pictureModels!.indexed.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (widget.model.defaultPictureZoomEnabled ?? false)
                      ? _buildZoomableImage(item.$2, item.$1)
                      : _buildSingleImage(
                          item.$2,
                        ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 8 / 8.5,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.model.pictureModels!.asMap().entries.map((entry) {
            int index = entry.key;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == index ? 24.0 : 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 2.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                border: _currentIndex == index
                    ? null
                    : Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.0,
                      ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMainImage() {
    if (widget.model.pictureModels?.isEmpty ?? true) {
      // No images case
      return _buildSingleImage(widget.model.defaultPictureModel!);
    } else if (widget.model.pictureModels!.length == 1) {
      // Single image case
      return (widget.model.defaultPictureZoomEnabled ?? false)
          ? _buildZoomableImage(widget.model.pictureModels!.first, 0)
          : _buildSingleImage(widget.model.pictureModels!.first);
    } else {
      // Multiple images case
      return (widget.model.defaultPictureZoomEnabled ?? false)
          ? _buildZoomableImage(
              widget.model.pictureModels![_currentIndex], _currentIndex)
          : _buildSingleImage(widget.model.pictureModels![_currentIndex]);
    }
  }

  Widget _buildSingleImage(PictureModel picture) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: LayoutBuilder(builder: (context, boxConstrait) {
        return OptimizedCacheImage(
          imageUrl: picture.imageUrl!,
          sizeConfig: ImageSizeConfig(
            width: boxConstrait.hasBoundedWidth ? boxConstrait.maxWidth : 500,
            height:
                boxConstrait.hasBoundedHeight ? boxConstrait.maxHeight : 500,
          ),
          fit: BoxFit.fitHeight,
        );
      }),
    );
  }

  Widget _buildZoomableImage(PictureModel picture, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isGalleryOpen = true;
        });
        _openGallery(index);
      },
      child: Hero(
        tag: 'product-image-${widget.model.id}-$index',
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: LayoutBuilder(builder: (context, boxConstrait) {
            return OptimizedCacheImage(
              imageUrl: picture.imageUrl!,
              fit: BoxFit.fitHeight,
              sizeConfig: ImageSizeConfig(
                width:
                    boxConstrait.hasBoundedWidth ? boxConstrait.maxWidth : 500,
                height: boxConstrait.hasBoundedHeight
                    ? boxConstrait.maxHeight
                    : 500,
              ),
              // isAbsolute: true,
            );
          }),
        ),
      ),
    );
  }

  void _openGallery(int initialIndex) {
    context.router.pushWidget(
      GalleryPhotoViewWrapper(
        galleryItems: widget.model.pictureModels ?? [],
        initialIndex: initialIndex,
        productId: widget.model.id!,
        onClose: () {
          setState(() {
            _isGalleryOpen = false;
          });
        },
      ),
    );
  }
}
