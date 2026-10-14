// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'redirect_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RedirectResponse _$RedirectResponseFromJson(Map<String, dynamic> json) {
  return _RedirectResponse.fromJson(json);
}

/// @nodoc
mixin _$RedirectResponse {
  Uri? get redirectUri => throw _privateConstructorUsedError;
  int? get responseStatus => throw _privateConstructorUsedError;

  /// Serializes this RedirectResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RedirectResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RedirectResponseCopyWith<RedirectResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RedirectResponseCopyWith<$Res> {
  factory $RedirectResponseCopyWith(
    RedirectResponse value,
    $Res Function(RedirectResponse) then,
  ) = _$RedirectResponseCopyWithImpl<$Res, RedirectResponse>;
  @useResult
  $Res call({Uri? redirectUri, int? responseStatus});
}

/// @nodoc
class _$RedirectResponseCopyWithImpl<$Res, $Val extends RedirectResponse>
    implements $RedirectResponseCopyWith<$Res> {
  _$RedirectResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RedirectResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? redirectUri = freezed, Object? responseStatus = freezed}) {
    return _then(
      _value.copyWith(
            redirectUri:
                freezed == redirectUri
                    ? _value.redirectUri
                    : redirectUri // ignore: cast_nullable_to_non_nullable
                        as Uri?,
            responseStatus:
                freezed == responseStatus
                    ? _value.responseStatus
                    : responseStatus // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RedirectResponseImplCopyWith<$Res>
    implements $RedirectResponseCopyWith<$Res> {
  factory _$$RedirectResponseImplCopyWith(
    _$RedirectResponseImpl value,
    $Res Function(_$RedirectResponseImpl) then,
  ) = __$$RedirectResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Uri? redirectUri, int? responseStatus});
}

/// @nodoc
class __$$RedirectResponseImplCopyWithImpl<$Res>
    extends _$RedirectResponseCopyWithImpl<$Res, _$RedirectResponseImpl>
    implements _$$RedirectResponseImplCopyWith<$Res> {
  __$$RedirectResponseImplCopyWithImpl(
    _$RedirectResponseImpl _value,
    $Res Function(_$RedirectResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RedirectResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? redirectUri = freezed, Object? responseStatus = freezed}) {
    return _then(
      _$RedirectResponseImpl(
        redirectUri:
            freezed == redirectUri
                ? _value.redirectUri
                : redirectUri // ignore: cast_nullable_to_non_nullable
                    as Uri?,
        responseStatus:
            freezed == responseStatus
                ? _value.responseStatus
                : responseStatus // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _$RedirectResponseImpl implements _RedirectResponse {
  const _$RedirectResponseImpl({
    this.redirectUri = null,
    this.responseStatus = null,
  });

  factory _$RedirectResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RedirectResponseImplFromJson(json);

  @override
  @JsonKey()
  final Uri? redirectUri;
  @override
  @JsonKey()
  final int? responseStatus;

  @override
  String toString() {
    return 'RedirectResponse(redirectUri: $redirectUri, responseStatus: $responseStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RedirectResponseImpl &&
            (identical(other.redirectUri, redirectUri) ||
                other.redirectUri == redirectUri) &&
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, redirectUri, responseStatus);

  /// Create a copy of RedirectResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RedirectResponseImplCopyWith<_$RedirectResponseImpl> get copyWith =>
      __$$RedirectResponseImplCopyWithImpl<_$RedirectResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RedirectResponseImplToJson(this);
  }
}

abstract class _RedirectResponse implements RedirectResponse {
  const factory _RedirectResponse({
    final Uri? redirectUri,
    final int? responseStatus,
  }) = _$RedirectResponseImpl;

  factory _RedirectResponse.fromJson(Map<String, dynamic> json) =
      _$RedirectResponseImpl.fromJson;

  @override
  Uri? get redirectUri;
  @override
  int? get responseStatus;

  /// Create a copy of RedirectResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RedirectResponseImplCopyWith<_$RedirectResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
