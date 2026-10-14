import 'package:flutter/material.dart';

extension ListExtensions on List<Widget> {
  List<Widget> addPaddingBetweenWidgets(double padding) {
    List<Widget> widgets = [];
    for (int i = 0; i < length; i++) {
      widgets.add(this[i]);
      if (i != length - 1) {
        widgets.add(SizedBox(height: padding));
      }
    }
    return widgets;
  }

  List<Widget> addPaddingBetweenWidgetsHorizontal(double padding) {
    List<Widget> widgets = [];
    for (int i = 0; i < length; i++) {
      widgets.add(this[i]);
      if (i != length - 1) {
        widgets.add(SizedBox(width: padding));
      }
    }
    return widgets;
  }

  List<Widget> joinBySperatedWidget(Widget seperator) {
    List<Widget> widgets = [];
    for (int i = 0; i < length; i++) {
      widgets.add(this[i]);
      if (i != length - 1) {
        widgets.add(seperator);
      }
    }
    return widgets;
  }
}
