import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../models/checkout/update_section_json_model/update_section_json_model.dart';

part 'anonymous_type__f238_a175.freezed.dart';
part 'anonymous_type__f238_a175.g.dart';

@freezed
class AnonymousType_F238A175
    extends StoreJsonSerializable<AnonymousType_F238A175>
    with _$AnonymousType_F238A175 {
  factory AnonymousType_F238A175({
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
  }) = _AnonymousType_F238A175;

  factory AnonymousType_F238A175.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_F238A175FromJson(json);
}
