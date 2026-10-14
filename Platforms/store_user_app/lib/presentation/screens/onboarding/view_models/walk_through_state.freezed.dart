// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk_through_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WalkThroughState {
  List<Walkthrough> get walkthroughs => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;

  /// Create a copy of WalkThroughState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalkThroughStateCopyWith<WalkThroughState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalkThroughStateCopyWith<$Res> {
  factory $WalkThroughStateCopyWith(
    WalkThroughState value,
    $Res Function(WalkThroughState) then,
  ) = _$WalkThroughStateCopyWithImpl<$Res, WalkThroughState>;
  @useResult
  $Res call({List<Walkthrough> walkthroughs, int currentIndex});
}

/// @nodoc
class _$WalkThroughStateCopyWithImpl<$Res, $Val extends WalkThroughState>
    implements $WalkThroughStateCopyWith<$Res> {
  _$WalkThroughStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalkThroughState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? walkthroughs = null, Object? currentIndex = null}) {
    return _then(
      _value.copyWith(
            walkthroughs:
                null == walkthroughs
                    ? _value.walkthroughs
                    : walkthroughs // ignore: cast_nullable_to_non_nullable
                        as List<Walkthrough>,
            currentIndex:
                null == currentIndex
                    ? _value.currentIndex
                    : currentIndex // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WalkThroughStateImplCopyWith<$Res>
    implements $WalkThroughStateCopyWith<$Res> {
  factory _$$WalkThroughStateImplCopyWith(
    _$WalkThroughStateImpl value,
    $Res Function(_$WalkThroughStateImpl) then,
  ) = __$$WalkThroughStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Walkthrough> walkthroughs, int currentIndex});
}

/// @nodoc
class __$$WalkThroughStateImplCopyWithImpl<$Res>
    extends _$WalkThroughStateCopyWithImpl<$Res, _$WalkThroughStateImpl>
    implements _$$WalkThroughStateImplCopyWith<$Res> {
  __$$WalkThroughStateImplCopyWithImpl(
    _$WalkThroughStateImpl _value,
    $Res Function(_$WalkThroughStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WalkThroughState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? walkthroughs = null, Object? currentIndex = null}) {
    return _then(
      _$WalkThroughStateImpl(
        walkthroughs:
            null == walkthroughs
                ? _value._walkthroughs
                : walkthroughs // ignore: cast_nullable_to_non_nullable
                    as List<Walkthrough>,
        currentIndex:
            null == currentIndex
                ? _value.currentIndex
                : currentIndex // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc

class _$WalkThroughStateImpl implements _WalkThroughState {
  const _$WalkThroughStateImpl({
    final List<Walkthrough> walkthroughs = const [],
    this.currentIndex = 0,
  }) : _walkthroughs = walkthroughs;

  final List<Walkthrough> _walkthroughs;
  @override
  @JsonKey()
  List<Walkthrough> get walkthroughs {
    if (_walkthroughs is EqualUnmodifiableListView) return _walkthroughs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_walkthroughs);
  }

  @override
  @JsonKey()
  final int currentIndex;

  @override
  String toString() {
    return 'WalkThroughState(walkthroughs: $walkthroughs, currentIndex: $currentIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalkThroughStateImpl &&
            const DeepCollectionEquality().equals(
              other._walkthroughs,
              _walkthroughs,
            ) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_walkthroughs),
    currentIndex,
  );

  /// Create a copy of WalkThroughState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalkThroughStateImplCopyWith<_$WalkThroughStateImpl> get copyWith =>
      __$$WalkThroughStateImplCopyWithImpl<_$WalkThroughStateImpl>(
        this,
        _$identity,
      );
}

abstract class _WalkThroughState implements WalkThroughState {
  const factory _WalkThroughState({
    final List<Walkthrough> walkthroughs,
    final int currentIndex,
  }) = _$WalkThroughStateImpl;

  @override
  List<Walkthrough> get walkthroughs;
  @override
  int get currentIndex;

  /// Create a copy of WalkThroughState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalkThroughStateImplCopyWith<_$WalkThroughStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
