import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_01_fa76_b1.freezed.dart';
part 'anonymous_type_01_fa76_b1.g.dart';

@freezed
class AnonymousType_01FA76B1
    extends StoreJsonSerializable<AnonymousType_01FA76B1>
    with _$AnonymousType_01FA76B1 {
  factory AnonymousType_01FA76B1(
          {@JsonKey(name: 'success', includeIfNull: false)
          @Default(false)
          bool? success,
          @JsonKey(name: 'message', includeIfNull: false) Object? message}) =
      _AnonymousType_01FA76B1;

  factory AnonymousType_01FA76B1.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_01FA76B1FromJson(json);
}
