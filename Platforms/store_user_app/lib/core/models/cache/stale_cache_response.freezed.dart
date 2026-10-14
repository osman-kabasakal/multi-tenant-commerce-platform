// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stale_cache_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StaleCacheResponse _$StaleCacheResponseFromJson(Map<String, dynamic> json) {
  return _StaleCacheResponse.fromJson(json);
}

/// @nodoc
mixin _$StaleCacheResponse {
  @JsonKey(name: 'StaleCorrelationIds')
  List<String> get staleCorrelationIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'AsOf')
  DateTime get asOf => throw _privateConstructorUsedError;

  /// Serializes this StaleCacheResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaleCacheResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaleCacheResponseCopyWith<StaleCacheResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaleCacheResponseCopyWith<$Res> {
  factory $StaleCacheResponseCopyWith(
    StaleCacheResponse value,
    $Res Function(StaleCacheResponse) then,
  ) = _$StaleCacheResponseCopyWithImpl<$Res, StaleCacheResponse>;
  @useResult
  $Res call({
    @JsonKey(name: 'StaleCorrelationIds') List<String> staleCorrelationIds,
    @JsonKey(name: 'AsOf') DateTime asOf,
  });
}

/// @nodoc
class _$StaleCacheResponseCopyWithImpl<$Res, $Val extends StaleCacheResponse>
    implements $StaleCacheResponseCopyWith<$Res> {
  _$StaleCacheResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaleCacheResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? staleCorrelationIds = null, Object? asOf = null}) {
    return _then(
      _value.copyWith(
            staleCorrelationIds:
                null == staleCorrelationIds
                    ? _value.staleCorrelationIds
                    : staleCorrelationIds // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            asOf:
                null == asOf
                    ? _value.asOf
                    : asOf // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StaleCacheResponseImplCopyWith<$Res>
    implements $StaleCacheResponseCopyWith<$Res> {
  factory _$$StaleCacheResponseImplCopyWith(
    _$StaleCacheResponseImpl value,
    $Res Function(_$StaleCacheResponseImpl) then,
  ) = __$$StaleCacheResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'StaleCorrelationIds') List<String> staleCorrelationIds,
    @JsonKey(name: 'AsOf') DateTime asOf,
  });
}

/// @nodoc
class __$$StaleCacheResponseImplCopyWithImpl<$Res>
    extends _$StaleCacheResponseCopyWithImpl<$Res, _$StaleCacheResponseImpl>
    implements _$$StaleCacheResponseImplCopyWith<$Res> {
  __$$StaleCacheResponseImplCopyWithImpl(
    _$StaleCacheResponseImpl _value,
    $Res Function(_$StaleCacheResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StaleCacheResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? staleCorrelationIds = null, Object? asOf = null}) {
    return _then(
      _$StaleCacheResponseImpl(
        staleCorrelationIds:
            null == staleCorrelationIds
                ? _value._staleCorrelationIds
                : staleCorrelationIds // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        asOf:
            null == asOf
                ? _value.asOf
                : asOf // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StaleCacheResponseImpl implements _StaleCacheResponse {
  const _$StaleCacheResponseImpl({
    @JsonKey(name: 'StaleCorrelationIds')
    final List<String> staleCorrelationIds = const [],
    @JsonKey(name: 'AsOf') required this.asOf,
  }) : _staleCorrelationIds = staleCorrelationIds;

  factory _$StaleCacheResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaleCacheResponseImplFromJson(json);

  final List<String> _staleCorrelationIds;
  @override
  @JsonKey(name: 'StaleCorrelationIds')
  List<String> get staleCorrelationIds {
    if (_staleCorrelationIds is EqualUnmodifiableListView)
      return _staleCorrelationIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_staleCorrelationIds);
  }

  @override
  @JsonKey(name: 'AsOf')
  final DateTime asOf;

  @override
  String toString() {
    return 'StaleCacheResponse(staleCorrelationIds: $staleCorrelationIds, asOf: $asOf)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaleCacheResponseImpl &&
            const DeepCollectionEquality().equals(
              other._staleCorrelationIds,
              _staleCorrelationIds,
            ) &&
            (identical(other.asOf, asOf) || other.asOf == asOf));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_staleCorrelationIds),
    asOf,
  );

  /// Create a copy of StaleCacheResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaleCacheResponseImplCopyWith<_$StaleCacheResponseImpl> get copyWith =>
      __$$StaleCacheResponseImplCopyWithImpl<_$StaleCacheResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StaleCacheResponseImplToJson(this);
  }
}

abstract class _StaleCacheResponse implements StaleCacheResponse {
  const factory _StaleCacheResponse({
    @JsonKey(name: 'StaleCorrelationIds')
    final List<String> staleCorrelationIds,
    @JsonKey(name: 'AsOf') required final DateTime asOf,
  }) = _$StaleCacheResponseImpl;

  factory _StaleCacheResponse.fromJson(Map<String, dynamic> json) =
      _$StaleCacheResponseImpl.fromJson;

  @override
  @JsonKey(name: 'StaleCorrelationIds')
  List<String> get staleCorrelationIds;
  @override
  @JsonKey(name: 'AsOf')
  DateTime get asOf;

  /// Create a copy of StaleCacheResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaleCacheResponseImplCopyWith<_$StaleCacheResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
