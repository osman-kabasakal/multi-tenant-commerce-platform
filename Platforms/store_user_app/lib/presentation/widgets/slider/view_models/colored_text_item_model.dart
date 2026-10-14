import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'colored_text_item_model.freezed.dart';

@freezed
class ColoredTextItemModel with _$ColoredTextItemModel {
  const factory ColoredTextItemModel({
    required String text,
    required Color color,
  }) = _ColoredTextItemModel;
}
