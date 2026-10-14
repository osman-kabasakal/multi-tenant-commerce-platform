import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';

class AppSummaryRowWidget extends StatelessWidget {
  final String label;
  final String amount;
  final bool isHighlight;
  final bool isSmall;
  final bool isPrice;
  const AppSummaryRowWidget(
    this.label,
    this.amount, {
    super.key,
    this.isHighlight = false,
    this.isSmall = false,
    this.isPrice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!label.isEmptyOrNull)
          Flexible(
            flex: 1,
            child: Text(
              label,
              style: (isHighlight
                  ? context.textTheme.titleSmall!
                      .copyWith(fontWeight: FontWeight.bold)
                  : isSmall
                      ? context.textTheme.bodySmall
                      : context.textTheme.labelSmall),
              textAlign: TextAlign.start,
            ),
          ),
        Flexible(
          flex: 2,
          child: Text(
            amount,
            style: (isHighlight
                ? context.textTheme.titleSmall!.copyWith(
                    fontFamily: isPrice ? '' : null,
                    fontWeight: FontWeight.bold,
                    color: colorPrimary,
                    overflow: TextOverflow.ellipsis,
                  )
                : isSmall
                    ? context.textTheme.bodySmall!.copyWith(
                        fontFamily: isPrice ? '' : null,
                        overflow: TextOverflow.ellipsis,
                      )
                    : context.textTheme.labelSmall!.copyWith(
                        fontFamily: isPrice ? '' : null,
                        overflow: TextOverflow.ellipsis,
                      )),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
