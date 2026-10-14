// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stale_cache_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StaleCacheItem _$StaleCacheItemFromJson(Map<String, dynamic> json) {
  return _StaleCacheItem.fromJson(json);
}

/// @nodoc
mixin _$StaleCacheItem {
  @JsonKey(name: 'CorrelationId')
  String get correlationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'AsOf')
  DateTime get asOf => throw _privateConstructorUsedError;

  /// Serializes this StaleCacheItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaleCacheItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaleCacheItemCopyWith<StaleCacheItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaleCacheItemCopyWith<$Res> {
  factory $StaleCacheItemCopyWith(
    StaleCacheItem value,
    $Res Function(StaleCacheItem) then,
  ) = _$StaleCacheItemCopyWithImpl<$Res, StaleCacheItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'CorrelationId') String correlationId,
    @JsonKey(name: 'AsOf') DateTime asOf,
  });
}

/// @nodoc
class _$StaleCacheItemCopyWithImpl<$Res, $Val extends StaleCacheItem>
    implements $StaleCacheItemCopyWith<$Res> {
  _$StaleCacheItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaleCacheItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? correlationId = null, Object? asOf = null}) {
    return _then(
      _value.copyWith(
            correlationId:
                null == correlationId
                    ? _value.correlationId
                    : correlationId // ignore: cast_nullable_to_non_nullable
                        as String,
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
abstract class _$$StaleCacheItemImplCopyWith<$Res>
    implements $StaleCacheItemCopyWith<$Res> {
  factory _$$StaleCacheItemImplCopyWith(
    _$StaleCacheItemImpl value,
    $Res Function(_$StaleCacheItemImpl) then,
  ) = __$$StaleCacheItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CorrelationId') String correlationId,
    @JsonKey(name: 'AsOf') DateTime asOf,
  });
}

/// @nodoc
class __$$StaleCacheItemImplCopyWithImpl<$Res>
    extends _$StaleCacheItemCopyWithImpl<$Res, _$StaleCacheItemImpl>
    implements _$$StaleCacheItemImplCopyWith<$Res> {
  __$$StaleCacheItemImplCopyWithImpl(
    _$StaleCacheItemImpl _value,
    $Res Function(_$StaleCacheItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StaleCacheItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? correlationId = null, Object? asOf = null}) {
    return _then(
      _$StaleCacheItemImpl(
        correlationId:
            null == correlationId
                ? _value.correlationId
                : correlationId // ignore: cast_nullable_to_non_nullable
                    as String,
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
class _$StaleCacheItemImpl implements _StaleCacheItem {
  const _$StaleCacheItemImpl({
    @JsonKey(name: 'CorrelationId') required this.correlationId,
    @JsonKey(name: 'AsOf') required this.asOf,
  });

  factory _$StaleCacheItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaleCacheItemImplFromJson(json);

  @override
  @JsonKey(name: 'CorrelationId')
  final String correlationId;
  @override
  @JsonKey(name: 'AsOf')
  final DateTime asOf;

  @override
  String toString() {
    return 'StaleCacheItem(correlationId: $correlationId, asOf: $asOf)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaleCacheItemImpl &&
            (identical(other.correlationId, correlationId) ||
                other.correlationId == correlationId) &&
            (identical(other.asOf, asOf) || other.asOf == asOf));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, correlationId, asOf);

  /// Create a copy of StaleCacheItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaleCacheItemImplCopyWith<_$StaleCacheItemImpl> get copyWith =>
      __$$StaleCacheItemImplCopyWithImpl<_$StaleCacheItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StaleCacheItemImplToJson(this);
  }
}

abstract class _StaleCacheItem implements StaleCacheItem {
  const factory _StaleCacheItem({
    @JsonKey(name: 'CorrelationId') required final String correlationId,
    @JsonKey(name: 'AsOf') required final DateTime asOf,
  }) = _$StaleCacheItemImpl;

  factory _StaleCacheItem.fromJson(Map<String, dynamic> json) =
      _$StaleCacheItemImpl.fromJson;

  @override
  @JsonKey(name: 'CorrelationId')
  String get correlationId;
  @override
  @JsonKey(name: 'AsOf')
  DateTime get asOf;

  /// Create a copy of StaleCacheItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaleCacheItemImplCopyWith<_$StaleCacheItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
