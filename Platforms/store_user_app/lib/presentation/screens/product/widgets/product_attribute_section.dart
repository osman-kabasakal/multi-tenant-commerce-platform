import 'package:flutter/material.dart';

class ProductAttributeSection extends StatelessWidget {
  final String title;
  final Widget child;

  const ProductAttributeSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
            ),
            Container(height: 2, width: 24, color: const Color(0xffF19D83)),
          ],
        ),
        const SizedBox(height: 20),
        child,
      ],
    );
  }
}
