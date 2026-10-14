import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/services/painters/background_bubble_painters.dart';

class AppAnimatedLoadingWidget extends StatefulWidget {
  const AppAnimatedLoadingWidget({super.key});

  @override
  State<AppAnimatedLoadingWidget> createState() =>
      _AppAnimatedLoadingWidgetState();
}

class _AppAnimatedLoadingWidgetState extends State<AppAnimatedLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<double> _sizeAnimation1;
  late Animation<double> _sizeAnimation2;
  late Animation<double> _sizeAnimation3;

  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;
  late Animation<Color?> _colorAnimation3;

  @override
  void initState() {
    super.initState();

    // İlk daire animasyon kontrolcüsü
    _controller1 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // İkinci daire animasyon kontrolcüsü (biraz daha yavaş)
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    // Üçüncü daire animasyon kontrolcüsü (daha farklı bir hızda)
    _controller3 = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    // Boyut animasyonları
    _sizeAnimation1 = Tween<double>(begin: 50.0, end: 100.0).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );

    _sizeAnimation2 = Tween<double>(begin: 40.0, end: 80.0).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    _sizeAnimation3 = Tween<double>(begin: 30.0, end: 60.0).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeInOut),
    );

    // Renk animasyonları
    _colorAnimation1 = ColorTween(
      begin: Colors.purple,
      end: Colors.blue,
    ).animate(_controller1);

    _colorAnimation2 = ColorTween(
      begin: Colors.pink,
      end: Colors.green,
    ).animate(_controller2);

    _colorAnimation3 = ColorTween(
      begin: Colors.amber,
      end: Colors.cyan,
    ).animate(_controller3);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.2),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey.shade900.withValues(alpha: 0.3),
              Colors.black.withValues(alpha: 0.3)
            ],
          ),
        ),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Arka plan efekti
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(math.max(
                        math.max(_sizeAnimation2.value, _sizeAnimation1.value),
                        _sizeAnimation3.value)),
                  ),
                  child: CustomPaint(
                    painter: BackgroundBubblePainter(),
                  ),
                ),
              ),

              // Üçüncü daire
              AnimatedBuilder(
                animation: _controller3,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller3.value * 2 * math.pi,
                    child: Container(
                      width: _sizeAnimation3.value,
                      height: _sizeAnimation3.value,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(_sizeAnimation3.value),
                        color: _colorAnimation3.value!.withValues(alpha: 0.7),
                        boxShadow: [
                          BoxShadow(
                            color:
                                _colorAnimation3.value!.withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // İkinci daire
              AnimatedBuilder(
                animation: _controller2,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: -_controller2.value * 2 * math.pi,
                    child: Container(
                      width: _sizeAnimation2.value,
                      height: _sizeAnimation2.value,
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        color: _colorAnimation2.value!.withOpacity(0.7),
                        borderRadius:
                            BorderRadius.circular(_sizeAnimation2.value),
                        boxShadow: [
                          BoxShadow(
                            color: _colorAnimation2.value!.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Birinci daire
              AnimatedBuilder(
                animation: _controller1,
                builder: (context, child) {
                  return Container(
                    width: _sizeAnimation1.value,
                    height: _sizeAnimation1.value,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(_sizeAnimation1.value),
                      color: _colorAnimation1.value!.withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                          color: _colorAnimation1.value!.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  );
                },
              ),

              // İsteğe bağlı metin
              // Positioned(
              //   bottom: 50,
              //   child: AnimatedOpacity(
              //     opacity: 0.8,
              //     duration: const Duration(seconds: 1),
              //     child: const Text(
              //       "Yükleniyor...",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 18,
              //         fontWeight: FontWeight.w300,
              //         letterSpacing: 3,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
