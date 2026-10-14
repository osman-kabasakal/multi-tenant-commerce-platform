// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stale_cache_query_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StaleCacheQueryModel _$StaleCacheQueryModelFromJson(Map<String, dynamic> json) {
  return _StaleCacheQueryModel.fromJson(json);
}

/// @nodoc
mixin _$StaleCacheQueryModel {
  @JsonKey(name: 'StaleCacheItems')
  List<StaleCacheItem> get staleCacheItems =>
      throw _privateConstructorUsedError;

  /// Serializes this StaleCacheQueryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaleCacheQueryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaleCacheQueryModelCopyWith<StaleCacheQueryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaleCacheQueryModelCopyWith<$Res> {
  factory $StaleCacheQueryModelCopyWith(
    StaleCacheQueryModel value,
    $Res Function(StaleCacheQueryModel) then,
  ) = _$StaleCacheQueryModelCopyWithImpl<$Res, StaleCacheQueryModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'StaleCacheItems') List<StaleCacheItem> staleCacheItems,
  });
}

/// @nodoc
class _$StaleCacheQueryModelCopyWithImpl<
  $Res,
  $Val extends StaleCacheQueryModel
>
    implements $StaleCacheQueryModelCopyWith<$Res> {
  _$StaleCacheQueryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaleCacheQueryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? staleCacheItems = null}) {
    return _then(
      _value.copyWith(
            staleCacheItems:
                null == staleCacheItems
                    ? _value.staleCacheItems
                    : staleCacheItems // ignore: cast_nullable_to_non_nullable
                        as List<StaleCacheItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StaleCacheQueryModelImplCopyWith<$Res>
    implements $StaleCacheQueryModelCopyWith<$Res> {
  factory _$$StaleCacheQueryModelImplCopyWith(
    _$StaleCacheQueryModelImpl value,
    $Res Function(_$StaleCacheQueryModelImpl) then,
  ) = __$$StaleCacheQueryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'StaleCacheItems') List<StaleCacheItem> staleCacheItems,
  });
}

/// @nodoc
class __$$StaleCacheQueryModelImplCopyWithImpl<$Res>
    extends _$StaleCacheQueryModelCopyWithImpl<$Res, _$StaleCacheQueryModelImpl>
    implements _$$StaleCacheQueryModelImplCopyWith<$Res> {
  __$$StaleCacheQueryModelImplCopyWithImpl(
    _$StaleCacheQueryModelImpl _value,
    $Res Function(_$StaleCacheQueryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StaleCacheQueryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? staleCacheItems = null}) {
    return _then(
      _$StaleCacheQueryModelImpl(
        staleCacheItems:
            null == staleCacheItems
                ? _value._staleCacheItems
                : staleCacheItems // ignore: cast_nullable_to_non_nullable
                    as List<StaleCacheItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StaleCacheQueryModelImpl implements _StaleCacheQueryModel {
  const _$StaleCacheQueryModelImpl({
    @JsonKey(name: 'StaleCacheItems')
    final List<StaleCacheItem> staleCacheItems = const [],
  }) : _staleCacheItems = staleCacheItems;

  factory _$StaleCacheQueryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaleCacheQueryModelImplFromJson(json);

  final List<StaleCacheItem> _staleCacheItems;
  @override
  @JsonKey(name: 'StaleCacheItems')
  List<StaleCacheItem> get staleCacheItems {
    if (_staleCacheItems is EqualUnmodifiableListView) return _staleCacheItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_staleCacheItems);
  }

  @override
  String toString() {
    return 'StaleCacheQueryModel(staleCacheItems: $staleCacheItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaleCacheQueryModelImpl &&
            const DeepCollectionEquality().equals(
              other._staleCacheItems,
              _staleCacheItems,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_staleCacheItems),
  );

  /// Create a copy of StaleCacheQueryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaleCacheQueryModelImplCopyWith<_$StaleCacheQueryModelImpl>
  get copyWith =>
      __$$StaleCacheQueryModelImplCopyWithImpl<_$StaleCacheQueryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StaleCacheQueryModelImplToJson(this);
  }
}

abstract class _StaleCacheQueryModel implements StaleCacheQueryModel {
  const factory _StaleCacheQueryModel({
    @JsonKey(name: 'StaleCacheItems')
    final List<StaleCacheItem> staleCacheItems,
  }) = _$StaleCacheQueryModelImpl;

  factory _StaleCacheQueryModel.fromJson(Map<String, dynamic> json) =
      _$StaleCacheQueryModelImpl.fromJson;

  @override
  @JsonKey(name: 'StaleCacheItems')
  List<StaleCacheItem> get staleCacheItems;

  /// Create a copy of StaleCacheQueryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaleCacheQueryModelImplCopyWith<_$StaleCacheQueryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
