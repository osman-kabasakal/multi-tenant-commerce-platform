import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';

class ScrollableTableHtmlExtension extends TableHtmlExtension {
  @override
  InlineSpan build(ExtensionContext context) {
    return WidgetSpan(
      child: context.elementName == 'table'
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context.buildContext!).size.height,
                  maxWidth: MediaQuery.of(context.buildContext!).size.width,
                ),
                child: Text.rich(super.build(context), softWrap: true),
              ),
            )
          : Text.rich(
              super.build(context),
              softWrap: true,
            ),
    );
  }
}
