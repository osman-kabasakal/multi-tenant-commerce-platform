import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:store_user_app/core/constants/strings.dart';

import '../providers/walk_through_controller.dart';
import '../widgets/walk_through/walkthrough_page.dart';

@RoutePage()
class WalkThroughScreen extends HookConsumerWidget {
  const WalkThroughScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.watch(walkThroughControllerProvider.notifier);
    var state = ref.watch(walkThroughControllerProvider);
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: controller.pageController, // Assign PageController
              itemCount: state.walkthroughs.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                final walkthrough = state.walkthroughs[index];
                return WalkthroughPage(
                  title: walkthrough.title,
                  description: walkthrough.description,
                  image: walkthrough.image,
                  theme: context.theme,
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: context.theme.scaffoldBackgroundColor,
                child: Column(
                  children: [
                    DotsIndicator(
                      dotsCount: state.walkthroughs.length,
                      position: state.currentIndex.toDouble(),
                      decorator: DotsDecorator(
                        activeColor: colorPrimary,
                        size: const Size.square(9.0),
                        activeSize: const Size(18.0, 9.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),
                    20.height,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary),
                          onPressed: () async {
                            // Handle the action when the next button is pressed
                            await controller.nextPage();
                          },
                          child: Text(
                            (state.currentIndex < state.walkthroughs.length - 1)
                                ? next
                                : getStarted,
                            style: context.theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    20.height,
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
