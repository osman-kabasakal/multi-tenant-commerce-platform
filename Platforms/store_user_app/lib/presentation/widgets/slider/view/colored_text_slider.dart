import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:store_user_app/presentation/widgets/slider/view_models/app_slide_direction.dart';
import 'package:store_user_app/presentation/widgets/slider/view_models/colored_text_item_model.dart';

class ColoredTextSlider extends StatefulWidget {
  /// Gösterilecek metinler listesi
  final List<ColoredTextItemModel> items;

  /// Her metin için arka plan rengi listesi
  // final List<Color> backgroundColors;

  /// Geçiş yönü (dikey veya yatay)
  final AppSlideDirection direction;

  /// Metin bileşenini özelleştirmek için builder fonksiyonu
  final Widget Function(
          BuildContext context, String text, Color backgroundColor, int index)?
      builder;

  /// Metin stili
  final TextStyle? textStyle;

  /// Geçiş animasyon süresi
  final Duration animationDuration;

  /// Metin animasyon süresi
  final Duration textAnimationDuration;

  /// Otomatik geçiş süresi (null ise otomatik geçiş olmaz)
  final Duration? autoSlideDuration;

  /// Köşe yuvarlatma değeri
  final double borderRadius;

  const ColoredTextSlider({
    super.key,
    required this.items,
    // required this.backgroundColors,
    this.direction = AppSlideDirection.vertical,
    this.builder,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 500),
    this.textAnimationDuration = const Duration(milliseconds: 800),
    this.autoSlideDuration,
    this.borderRadius = 8.0,
  });

  @override
  State<ColoredTextSlider> createState() => _ColoredTextSliderState();
}

class _ColoredTextSliderState extends State<ColoredTextSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _currentIndex;
  late int _nextIndex;

  // Genişlik ölçümleri için TextPainter kullanılacak
  final List<Size> _textSizes = [];

  // Metin animasyonu için controller
  // late AnimationController _textAnimController;
  // late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
    _nextIndex = widget.items.isEmpty?0:(1 % widget.items.length);

    // Ana animasyon controller'ı
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Otomatik geçiş ayarla
    if (widget.autoSlideDuration != null) {
      Future.delayed(widget.autoSlideDuration!, () {
        _startAutoSlide();
      });
    }

    // Animasyon dinleyicisi
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentIndex = _nextIndex;
          _nextIndex = (_currentIndex + 1) % widget.items.length;
        });
        _controller.reset();

        // Metin animasyonunu başlat
        // _textAnimController.forward(from: 0.0);

        // Otomatik geçiş için
        if (widget.autoSlideDuration != null && widget.items.length > 1) {
          Future.delayed(widget.autoSlideDuration!, () {
            if (mounted) {
              _nextSlide();
            }
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    _currentIndex = 0;
    if(widget.items.length==0) {
      _controller.stop();
      _controller.reset();
    }else{
      _nextIndex = 1 % widget.items.length;
      // Tüm metinlerin boyutlarını ölç
      _measureTextSizes();
      _startAutoSlide();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ColoredTextSlider oldWidget) {
    _currentIndex = 0;
    if(oldWidget.items.length != widget.items.length) {
      _textSizes.clear();
    }
    if(widget.items.length==0) {
      _controller.stop();
      _controller.reset();
    }else{
      _nextIndex = 1 % widget.items.length;
      // Tüm metinlerin boyutlarını ölç
      _measureTextSizes();
      _startAutoSlide();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _startAutoSlide() {
    if (mounted &&
        widget.autoSlideDuration != null &&
        widget.items.length > 1) {
      _nextSlide();
    } else if (mounted) {
      _controller.stop();
      _controller.reset();
    }
  }

  void _nextSlide() {
    if (!_controller.isAnimating) {
      _controller.forward();
    }
  }

  void _measureTextSizes() {
    final textStyle =
        widget.textStyle ?? Theme.of(context).textTheme.labelSmall!;

    for (String text in widget.items.map((e) => e.text)) {
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();

      _textSizes.add(textPainter.size);
    }
  }

  Color _getBackgroundColor(int index) {
    return widget.items[index].color;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Metin boyutları ölçülmediyse tekrar ölç
        if (_textSizes.isEmpty && widget.items.isNotEmpty) {
          _measureTextSizes();
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if(widget.items.isEmpty) {
              return SizedBox.shrink();
            }
            // Mevcut metin ve sonraki metinin genişlikleri
            final currentTextSize =
                _textSizes.isNotEmpty && _currentIndex < _textSizes.length
                    ? _textSizes[_currentIndex]
                    : Size(100, 50);

            final nextTextSize =
                _textSizes.isNotEmpty && _nextIndex < _textSizes.length
                    ? _textSizes[_nextIndex]
                    : Size(100, 50);

            // Animasyonlu genişlik hesaplama
            final width = currentTextSize.width +
                (_animation.value *
                    (nextTextSize.width - currentTextSize.width));
            final height = currentTextSize.height +
                (_animation.value *
                    (nextTextSize.height - currentTextSize.height));

            // Mevcut ve sonraki metinler
            final currentText = widget.items[_currentIndex].text;
            final nextText = widget.items[_nextIndex].text;

            // Mevcut ve sonraki renkler
            final currentColor = _getBackgroundColor(_currentIndex);
            final nextColor = _getBackgroundColor(_nextIndex);

            // Renk animasyonu
            final animatedColor =
                Color.lerp(currentColor, nextColor, _animation.value)!;

            // Konumlandırma için offset hesaplama
            double offset = _animation.value;

            return GestureDetector(
              onTap: _nextSlide,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: constraints.hasBoundedWidth
                    ? constraints.maxWidth
                    : width + 8, // Padding için ekstra alan
                height: height, // Padding için ekstra alan
                decoration: BoxDecoration(
                  color: animatedColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Stack(
                    children: [
                      // Mevcut metin
                      Positioned(
                        width: constraints.hasBoundedWidth
                            ? constraints.maxWidth
                            : width + 8,
                        left: widget.direction == AppSlideDirection.horizontal
                            ? -offset * width
                            : 0,
                        top: widget.direction == AppSlideDirection.vertical
                            ? (-offset * (height)) - (height / 2)
                            : 0,
                        child: _buildTextItem(
                            currentText, currentColor, _currentIndex),
                      ),
                      // Sonraki metin
                      Positioned(
                        width: constraints.hasBoundedWidth
                            ? constraints.maxWidth
                            : width + 8,
                        left: widget.direction == AppSlideDirection.horizontal
                            ? width * (1 - offset)
                            : 0,
                        top: widget.direction == AppSlideDirection.vertical
                            ? ((height) * (1 - offset)) - (height / 2)
                            : 0,
                        child: _buildTextItem(nextText, nextColor, _nextIndex),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextItem(String text, Color backgroundColor, int index) {
    // Varsayılan metin bileşeni
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: HookBuilder(builder: (context) {
        // Metin animasyonu için controller
        final textAnimController = useAnimationController(
          duration: Duration(
              microseconds:
                  ((widget.textAnimationDuration.inSeconds * 1000) / 1.5)
                      .floor()),
        );

        var textAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: textAnimController,
          curve: Curves.easeInOut,
        ));

        useEffect(() {
          textAnimController.forward(from: 0.0);
          var stop = true;
          _controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (!stop || _currentIndex != index) return;
              stop = false;

              textAnimController.forward(from: 0.0);
            }

            if (status == AnimationStatus.forward) {
              stop = false;
              if (!textAnimController.isDismissed)
                textAnimController.animateTo(1);
            }
          });
          // textAnimController.addStatusListener((status) {
          //   if (status == AnimationStatus.completed) {
          //     if (stop) return;
          //     textAnimController.forward(from: 0.0);
          //   }
          // });
          return null;
        }, []);

        return AnimatedBuilder(
          animation: textAnimController,
          builder: (context, child) {
            // Harfleri animasyonlu şekilde göstermek için
            final visibleLength = (text.length * textAnimation.value).round();
            final visibleText = text.substring(0, visibleLength);

            // Builder fonksiyonu varsa kullan
            if (widget.builder != null) {
              return widget.builder!(
                  context, visibleText, backgroundColor, index);
            }

            return Text(
              visibleText,
              textAlign: TextAlign.center,
              style: widget.textStyle?.copyWith(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ) ??
                  Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
              maxLines: 1,
            );
          },
        );
      }),
    );
  }
}
