import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type__b6395690.freezed.dart';
part 'anonymous_type__b6395690.g.dart';

@freezed
class AnonymousType_B6395690
    extends StoreJsonSerializable<AnonymousType_B6395690>
    with _$AnonymousType_B6395690 {
  factory AnonymousType_B6395690(
      {@JsonKey(name: 'stored', includeIfNull: false)
      @Default(false)
      bool? stored}) = _AnonymousType_B6395690;

  factory AnonymousType_B6395690.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_B6395690FromJson(json);
}
