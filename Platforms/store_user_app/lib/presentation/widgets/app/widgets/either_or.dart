import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';

class EitherOr extends StatelessWidget {
  final String orText;
  final bool isDarkMode;
  const EitherOr({
    super.key,
    required this.orText,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
              child: Container(
                  height: 0.2,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.black26)),
          10.width,
          Text(orText,
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: colorGrey600, fontWeight: FontWeight.w600)),
          10.width,
          Expanded(
              child: Container(
                  height: 0.2,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.black26)),
        ],
      ),
    );
  }
}
