import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/presentation/screens/onboarding/view_models/walk_through_state.dart';

part 'walk_through_controller.g.dart';

@riverpod
class WalkThroughController extends _$WalkThroughController {
  final PageController pageController = PageController();
  late final AppRouter _appRouter;

  @override
  WalkThroughState build() {
    _appRouter = getIt<AppRouter>();
    return WalkThroughState(walkthroughs: [
      Walkthrough(
        title: 'Siparişini Ver',
        description: 'Binlerce Ürün arasından ihtiyacına göre dileğini seç.',
        image: walkThrough_1,
      ),
      Walkthrough(
        title: 'Kolayca Öde',
        description: 'Güvenli ve kolay ödeme ile siparişini tamamla.',
        image: walkThrough_2,
      ),
      Walkthrough(
        title: 'Hemen Kapında',
        description: 'Kısa sürede kapında, hemen kullanmaya başla.',
        image: walkThrough_3,
      ),
    ]);
  }

  void onPageChanged(int index) {
    state = state.copyWith(currentIndex: index);
  }

  Future<void> nextPage() async {
    if (state.currentIndex < state.walkthroughs.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
      pageController.animateToPage(state.currentIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      await goToNextScreen();
    }
  }

  Future<void> goToNextScreen() async {
    _appRouter.push(WelcomeSiginRoute());
  }
}
