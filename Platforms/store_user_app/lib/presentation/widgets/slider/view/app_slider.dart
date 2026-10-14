import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_async_waiter_button.dart';
import 'package:store_user_app/presentation/widgets/slider/widgets/app_slide_widget.dart';

import '../view_models/slider_item.dart';

class AppSlider extends StatefulHookConsumerWidget {
  final List<SliderItem> items;
  final double height;
  final Duration autoPlayInterval;
  final Duration animationDuration;
  final Function(SliderItem)? onItemTap;

  final Widget Function(BuildContext, SliderItem)? itemBuilder;

  const AppSlider({
    super.key,
    required this.items,
    this.height = 200.0,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.animationDuration = const Duration(milliseconds: 500),
    this.onItemTap,
    this.itemBuilder,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppSliderState();
}

class _AppSliderState extends ConsumerState<AppSlider> {
  // late PageController _pageController;
  // late Timer _timer;
  // int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // _pageController = PageController(initialPage: 0);
    // _startAutoPlay();
  }

  @override
  void dispose() {
    // _pageController.dispose();
    // _timer.cancel();
    super.dispose();
  }

  // void _startAutoPlay() {
  //   _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
  //     if (_currentPage < widget.items.length - 1) {
  //       _currentPage++;
  //     } else {
  //       _currentPage = 0;
  //     }

  //     _pageController.animateToPage(
  //       _currentPage,
  //       duration: widget.animationDuration,
  //       curve: Curves.easeInOut,
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        aspectRatio: 16 / 8,
        autoPlay: true,
        viewportFraction: 1.0,

        autoPlayInterval: widget.autoPlayInterval,
        autoPlayAnimationDuration: widget.animationDuration,
        // onPageChanged: (index, reason) {
        //   setState(() => _currentPage = index);
        // },
      ),
      itemCount: widget.items.length,
      itemBuilder: (context, index, realIndex) {
        return AppAsyncWaiterButton(
          onPressed: () async => widget.onItemTap?.call(widget.items[index]),
          child:
              widget.itemBuilder != null
                  ? widget.itemBuilder!(context, widget.items[index])
                  : AppSlideWidget(item: widget.items[index]),
        );
      },
    );

    // return SizedBox(
    //   height: widget.height,
    //   child: Stack(
    //     children: [
    //       // Slider
    //       PageView.builder(
    //         controller: _pageController,
    //         onPageChanged: (index) {
    //           setState(() => _currentPage = index);
    //         },
    //         itemCount: widget.items.length,
    //         itemBuilder: (context, index) {
    //           return AppAsyncWaiterButton(
    //             onPressed:
    //                 () async => widget.onItemTap?.call(widget.items[index]),
    //             child:
    //                 widget.itemBuilder != null
    //                     ? widget.itemBuilder!(context, widget.items[index])
    //                     : AppSlideWidget(item: widget.items[index]),
    //           );
    //         },
    //       ),
    //       // İndikatörler
    //       Positioned(
    //         left: 0,
    //         right: 0,
    //         bottom: 16,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: List.generate(
    //             widget.items.length,
    //             (index) => Container(
    //               width: 8,
    //               height: 8,
    //               margin: EdgeInsets.symmetric(horizontal: 4),
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color:
    //                     _currentPage == index
    //                         ? Color(0xFF2381AA)
    //                         : Colors.white.withValues(alpha: 0.5),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
