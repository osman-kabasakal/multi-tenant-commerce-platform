import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../models/checkout/update_section_json_model/update_section_json_model.dart';

part 'anonymous_type__da179_d76.freezed.dart';
part 'anonymous_type__da179_d76.g.dart';

@freezed
class AnonymousType_DA179D76
    extends StoreJsonSerializable<AnonymousType_DA179D76>
    with _$AnonymousType_DA179D76 {
  factory AnonymousType_DA179D76({
    @JsonKey(name: 'update_section', includeIfNull: false)
    UpdateSectionJsonModel? update_section,
    @JsonKey(name: 'goto_section') String? goToSection,
    @JsonKey(name: 'wrong_shipping_address', includeIfNull: false)
    @Default(false)
    bool? wrong_shipping_address,
    @JsonKey(name: 'model_state', includeIfNull: false)
    @Default([])
    List<String> model_state,
    @JsonKey(name: 'error') int? error,
    @JsonKey(name: 'message') String? message,
  }) = _AnonymousType_DA179D76;

  factory AnonymousType_DA179D76.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_DA179D76FromJson(json);
}
