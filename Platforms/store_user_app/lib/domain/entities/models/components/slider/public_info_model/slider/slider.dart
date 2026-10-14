import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'slider.freezed.dart';
part 'slider.g.dart';

@freezed
class Slider extends StoreJsonSerializable<Slider> with _$Slider {
  const factory Slider({
    @JsonKey(name: 'PictureUrl') String? pictureUrl,
    @JsonKey(name: 'Name') String? name,
    @JsonKey(name: 'Description') String? description,
    @JsonKey(name: 'Link') String? link,
    @JsonKey(name: 'FullWidth') @Default(false) bool? fullWidth,
    @JsonKey(name: 'CssClass') String? cssClass,
  }) = _Slider;

  factory Slider.fromJson(Map<String, dynamic> json) => _$SliderFromJson(json);
}
