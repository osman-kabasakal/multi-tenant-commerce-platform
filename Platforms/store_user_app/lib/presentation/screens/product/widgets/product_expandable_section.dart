import 'package:flutter/material.dart';

class ProductExpandableSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProductExpandableSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: const Color(0xffE85C31),
        collapsedIconColor: const Color(0xffE85C31),
        title: Column(
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
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(left: 15),
            itemCount: children.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: children[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
