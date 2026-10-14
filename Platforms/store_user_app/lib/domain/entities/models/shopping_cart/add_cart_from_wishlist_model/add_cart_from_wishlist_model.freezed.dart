// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_cart_from_wishlist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddCartFromWishlistModel _$AddCartFromWishlistModelFromJson(
  Map<String, dynamic> json,
) {
  return _AddCartFromWishlistModel.fromJson(json);
}

/// @nodoc
mixin _$AddCartFromWishlistModel {
  @JsonKey(name: 'CustomerGuid', includeIfNull: false)
  String? get customerGuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
  String? get shoppingCartId => throw _privateConstructorUsedError;

  /// Serializes this AddCartFromWishlistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddCartFromWishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddCartFromWishlistModelCopyWith<AddCartFromWishlistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddCartFromWishlistModelCopyWith<$Res> {
  factory $AddCartFromWishlistModelCopyWith(
    AddCartFromWishlistModel value,
    $Res Function(AddCartFromWishlistModel) then,
  ) = _$AddCartFromWishlistModelCopyWithImpl<$Res, AddCartFromWishlistModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerGuid', includeIfNull: false) String? customerGuid,
    @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
    String? shoppingCartId,
  });
}

/// @nodoc
class _$AddCartFromWishlistModelCopyWithImpl<
  $Res,
  $Val extends AddCartFromWishlistModel
>
    implements $AddCartFromWishlistModelCopyWith<$Res> {
  _$AddCartFromWishlistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddCartFromWishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerGuid = freezed,
    Object? shoppingCartId = freezed,
  }) {
    return _then(
      _value.copyWith(
            customerGuid:
                freezed == customerGuid
                    ? _value.customerGuid
                    : customerGuid // ignore: cast_nullable_to_non_nullable
                        as String?,
            shoppingCartId:
                freezed == shoppingCartId
                    ? _value.shoppingCartId
                    : shoppingCartId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddCartFromWishlistModelImplCopyWith<$Res>
    implements $AddCartFromWishlistModelCopyWith<$Res> {
  factory _$$AddCartFromWishlistModelImplCopyWith(
    _$AddCartFromWishlistModelImpl value,
    $Res Function(_$AddCartFromWishlistModelImpl) then,
  ) = __$$AddCartFromWishlistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerGuid', includeIfNull: false) String? customerGuid,
    @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
    String? shoppingCartId,
  });
}

/// @nodoc
class __$$AddCartFromWishlistModelImplCopyWithImpl<$Res>
    extends
        _$AddCartFromWishlistModelCopyWithImpl<
          $Res,
          _$AddCartFromWishlistModelImpl
        >
    implements _$$AddCartFromWishlistModelImplCopyWith<$Res> {
  __$$AddCartFromWishlistModelImplCopyWithImpl(
    _$AddCartFromWishlistModelImpl _value,
    $Res Function(_$AddCartFromWishlistModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddCartFromWishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerGuid = freezed,
    Object? shoppingCartId = freezed,
  }) {
    return _then(
      _$AddCartFromWishlistModelImpl(
        customerGuid:
            freezed == customerGuid
                ? _value.customerGuid
                : customerGuid // ignore: cast_nullable_to_non_nullable
                    as String?,
        shoppingCartId:
            freezed == shoppingCartId
                ? _value.shoppingCartId
                : shoppingCartId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddCartFromWishlistModelImpl implements _AddCartFromWishlistModel {
  _$AddCartFromWishlistModelImpl({
    @JsonKey(name: 'CustomerGuid', includeIfNull: false)
    this.customerGuid = null,
    @JsonKey(name: 'ShoppingCartId', includeIfNull: false) this.shoppingCartId,
  });

  factory _$AddCartFromWishlistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddCartFromWishlistModelImplFromJson(json);

  @override
  @JsonKey(name: 'CustomerGuid', includeIfNull: false)
  final String? customerGuid;
  @override
  @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
  final String? shoppingCartId;

  @override
  String toString() {
    return 'AddCartFromWishlistModel(customerGuid: $customerGuid, shoppingCartId: $shoppingCartId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddCartFromWishlistModelImpl &&
            (identical(other.customerGuid, customerGuid) ||
                other.customerGuid == customerGuid) &&
            (identical(other.shoppingCartId, shoppingCartId) ||
                other.shoppingCartId == shoppingCartId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, customerGuid, shoppingCartId);

  /// Create a copy of AddCartFromWishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddCartFromWishlistModelImplCopyWith<_$AddCartFromWishlistModelImpl>
  get copyWith => __$$AddCartFromWishlistModelImplCopyWithImpl<
    _$AddCartFromWishlistModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddCartFromWishlistModelImplToJson(this);
  }
}

abstract class _AddCartFromWishlistModel implements AddCartFromWishlistModel {
  factory _AddCartFromWishlistModel({
    @JsonKey(name: 'CustomerGuid', includeIfNull: false)
    final String? customerGuid,
    @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
    final String? shoppingCartId,
  }) = _$AddCartFromWishlistModelImpl;

  factory _AddCartFromWishlistModel.fromJson(Map<String, dynamic> json) =
      _$AddCartFromWishlistModelImpl.fromJson;

  @override
  @JsonKey(name: 'CustomerGuid', includeIfNull: false)
  String? get customerGuid;
  @override
  @JsonKey(name: 'ShoppingCartId', includeIfNull: false)
  String? get shoppingCartId;

  /// Create a copy of AddCartFromWishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddCartFromWishlistModelImplCopyWith<_$AddCartFromWishlistModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
