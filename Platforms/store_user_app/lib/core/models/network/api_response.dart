import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/network/redirect_response.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final T? data;
  final Map<String, dynamic>? meta;
  final RedirectResponse? redirect;
  bool get isRedirectResponse => redirect != null;

  const ApiResponse({this.data, this.meta, this.redirect});
  factory ApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  Map<String, dynamic> tryToJson() => _$ApiResponseToJson(
      this,
      T is List
          ? (value) => (value as List)
              .map((e) => e is! StoreJsonSerializable ? e : e.toJson())
              .toList()
          : (value) =>
              value is! StoreJsonSerializable ? value : value.toJson());

  ApiResponse<T> copyWith({
    T? data,
    Map<String, dynamic>? meta,
    RedirectResponse? redirect,
  }) {
    return ApiResponse<T>(
      data: data ?? this.data,
      meta: meta ?? this.meta,
      redirect: redirect ?? this.redirect,
    );
  }
}
