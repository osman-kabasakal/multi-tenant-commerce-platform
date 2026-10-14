// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wish_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WishListState {
  String? get error => throw _privateConstructorUsedError;
  WishlistModel? get wishList => throw _privateConstructorUsedError;
  Map<String, ShoppingCartItemModel> get wishListItems =>
      throw _privateConstructorUsedError;
  bool get wisListEnabled => throw _privateConstructorUsedError;

  /// Create a copy of WishListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishListStateCopyWith<WishListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishListStateCopyWith<$Res> {
  factory $WishListStateCopyWith(
    WishListState value,
    $Res Function(WishListState) then,
  ) = _$WishListStateCopyWithImpl<$Res, WishListState>;
  @useResult
  $Res call({
    String? error,
    WishlistModel? wishList,
    Map<String, ShoppingCartItemModel> wishListItems,
    bool wisListEnabled,
  });

  $WishlistModelCopyWith<$Res>? get wishList;
}

/// @nodoc
class _$WishListStateCopyWithImpl<$Res, $Val extends WishListState>
    implements $WishListStateCopyWith<$Res> {
  _$WishListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? wishList = freezed,
    Object? wishListItems = null,
    Object? wisListEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            wishList:
                freezed == wishList
                    ? _value.wishList
                    : wishList // ignore: cast_nullable_to_non_nullable
                        as WishlistModel?,
            wishListItems:
                null == wishListItems
                    ? _value.wishListItems
                    : wishListItems // ignore: cast_nullable_to_non_nullable
                        as Map<String, ShoppingCartItemModel>,
            wisListEnabled:
                null == wisListEnabled
                    ? _value.wisListEnabled
                    : wisListEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of WishListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WishlistModelCopyWith<$Res>? get wishList {
    if (_value.wishList == null) {
      return null;
    }

    return $WishlistModelCopyWith<$Res>(_value.wishList!, (value) {
      return _then(_value.copyWith(wishList: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WishListStateImplCopyWith<$Res>
    implements $WishListStateCopyWith<$Res> {
  factory _$$WishListStateImplCopyWith(
    _$WishListStateImpl value,
    $Res Function(_$WishListStateImpl) then,
  ) = __$$WishListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? error,
    WishlistModel? wishList,
    Map<String, ShoppingCartItemModel> wishListItems,
    bool wisListEnabled,
  });

  @override
  $WishlistModelCopyWith<$Res>? get wishList;
}

/// @nodoc
class __$$WishListStateImplCopyWithImpl<$Res>
    extends _$WishListStateCopyWithImpl<$Res, _$WishListStateImpl>
    implements _$$WishListStateImplCopyWith<$Res> {
  __$$WishListStateImplCopyWithImpl(
    _$WishListStateImpl _value,
    $Res Function(_$WishListStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WishListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? wishList = freezed,
    Object? wishListItems = null,
    Object? wisListEnabled = null,
  }) {
    return _then(
      _$WishListStateImpl(
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        wishList:
            freezed == wishList
                ? _value.wishList
                : wishList // ignore: cast_nullable_to_non_nullable
                    as WishlistModel?,
        wishListItems:
            null == wishListItems
                ? _value._wishListItems
                : wishListItems // ignore: cast_nullable_to_non_nullable
                    as Map<String, ShoppingCartItemModel>,
        wisListEnabled:
            null == wisListEnabled
                ? _value.wisListEnabled
                : wisListEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$WishListStateImpl implements _WishListState {
  const _$WishListStateImpl({
    this.error = null,
    this.wishList,
    final Map<String, ShoppingCartItemModel> wishListItems = const {},
    this.wisListEnabled = false,
  }) : _wishListItems = wishListItems;

  @override
  @JsonKey()
  final String? error;
  @override
  final WishlistModel? wishList;
  final Map<String, ShoppingCartItemModel> _wishListItems;
  @override
  @JsonKey()
  Map<String, ShoppingCartItemModel> get wishListItems {
    if (_wishListItems is EqualUnmodifiableMapView) return _wishListItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_wishListItems);
  }

  @override
  @JsonKey()
  final bool wisListEnabled;

  @override
  String toString() {
    return 'WishListState(error: $error, wishList: $wishList, wishListItems: $wishListItems, wisListEnabled: $wisListEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishListStateImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.wishList, wishList) ||
                other.wishList == wishList) &&
            const DeepCollectionEquality().equals(
              other._wishListItems,
              _wishListItems,
            ) &&
            (identical(other.wisListEnabled, wisListEnabled) ||
                other.wisListEnabled == wisListEnabled));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    error,
    wishList,
    const DeepCollectionEquality().hash(_wishListItems),
    wisListEnabled,
  );

  /// Create a copy of WishListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishListStateImplCopyWith<_$WishListStateImpl> get copyWith =>
      __$$WishListStateImplCopyWithImpl<_$WishListStateImpl>(this, _$identity);
}

abstract class _WishListState implements WishListState {
  const factory _WishListState({
    final String? error,
    final WishlistModel? wishList,
    final Map<String, ShoppingCartItemModel> wishListItems,
    final bool wisListEnabled,
  }) = _$WishListStateImpl;

  @override
  String? get error;
  @override
  WishlistModel? get wishList;
  @override
  Map<String, ShoppingCartItemModel> get wishListItems;
  @override
  bool get wisListEnabled;

  /// Create a copy of WishListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishListStateImplCopyWith<_$WishListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
