import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/config/image_size_config.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/images/view/optimized_cache_image.dart';

// Custom background pattern painter
class BackgroundPatternPainter extends CustomPainter {
  final Color color;

  BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Draw geometric patterns
    drawPattern(canvas, size, paint);
  }

  void drawPattern(Canvas canvas, Size size, Paint paint) {
    // Generate some random circles and rectangles as a pattern
    final random = math.Random(12345); // Fixed seed for consistent pattern

    // Draw circles
    for (int i = 0; i < 15; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double radius = 10 + random.nextDouble() * 40;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw rectangles
    for (int i = 0; i < 10; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double width = 20 + random.nextDouble() * 60;
      double height = 20 + random.nextDouble() * 60;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, width, height),
          const Radius.circular(8),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

@RoutePage()
class WelcomeScreen extends HookConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> goTo() async {
      await 4.seconds.delay;
      if (context.mounted) context.router.replace(WalkThroughRoute());
    }

    var asyncState = useAsyncTask();
    asyncState.pending.value = goTo();

    var getFooterModelFunc = useMemoized(() async {
      return await (await getIt.getAsync<ComponentRepository>()).getFooter();
    });

    var footerModelSnap = useFuture(getFooterModelFunc);

    // Create animation controller for logo
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    // Create animations
    final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    final scaleUp = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Start the animation
    useEffect(() {
      animationController.forward();
      return animationController.dispose;
    }, []);

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: <Widget>[
            // Modern layered background design
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.8),
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorDark,
                  ],
                ),
              ),
            ),
            // Decorative elements
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPatternPainter(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Gradient overlay for text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            // Content
            SafeArea(
              child: Column(
                children: [
                  // Animated logo at the top
                  Expanded(
                    flex: 4,
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: fadeIn,
                          child: ScaleTransition(
                            scale: scaleUp,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: OptimizedCacheImage(
                                  imageUrl: AppConfig.instance.storeLogo,
                                  sizeConfig: const ImageSizeConfig(
                                    width: 120,
                                    height: 120,
                                  ),
                                  fit: BoxFit.contain,
                                  placeholder: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  errorWidget: Image.asset(
                                    logoImg,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Bottom section with store information
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            welcomeMsg,
                            textAlign: TextAlign.center,
                            style: context.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              foreground: Paint()..shader = linearGradient,
                              letterSpacing: 0.5,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  footerModelSnap.hasData
                                      ? footerModelSnap.data!.storeName ?? ''
                                      : '...',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        foreground:
                                            Paint()..shader = linearGradient,
                                        letterSpacing: 0.5,
                                        height: 1.2,
                                      ),
                                ),
                                8.width,
                                Image.asset(waveIcon, width: 24, height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Footer information
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 32,
                      left: 24,
                      right: 24,
                    ),
                    child: Builder(
                      builder: (context) {
                        var snapshot = footerModelSnap;
                        if (!snapshot.hasData) {
                          return Text(
                            '...',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          );
                        }
                        final footerData = snapshot.data!;
                        final companyInfo = [
                          if (footerData.companyName != null &&
                              footerData.companyName!.isNotEmpty)
                            footerData.companyName,
                          if (footerData.companyAddress != null &&
                              footerData.companyAddress!.isNotEmpty)
                            footerData.companyAddress,
                          if (footerData.companyPhone != null &&
                              footerData.companyPhone!.isNotEmpty)
                            footerData.companyPhone,
                          if (footerData.companyEmail != null &&
                              footerData.companyEmail!.isNotEmpty)
                            footerData.companyEmail,
                        ].where((e) => e != null).join(' • ');
                        return Text(
                          companyInfo,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
