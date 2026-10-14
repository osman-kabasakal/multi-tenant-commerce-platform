// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_catalog_cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductCatalogCart _$ProductCatalogCartFromJson(Map<String, dynamic> json) {
  return _ProductCatalogCart.fromJson(json);
}

/// @nodoc
mixin _$ProductCatalogCart {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
  ShoppingCartType? get shoppingCartTypeId =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'ForceRedirection', includeIfNull: false)
  bool? get forceRedirection => throw _privateConstructorUsedError;

  /// Serializes this ProductCatalogCart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductCatalogCart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCatalogCartCopyWith<ProductCatalogCart> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCatalogCartCopyWith<$Res> {
  factory $ProductCatalogCartCopyWith(
    ProductCatalogCart value,
    $Res Function(ProductCatalogCart) then,
  ) = _$ProductCatalogCartCopyWithImpl<$Res, ProductCatalogCart>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
    ShoppingCartType? shoppingCartTypeId,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'ForceRedirection', includeIfNull: false)
    bool? forceRedirection,
  });
}

/// @nodoc
class _$ProductCatalogCartCopyWithImpl<$Res, $Val extends ProductCatalogCart>
    implements $ProductCatalogCartCopyWith<$Res> {
  _$ProductCatalogCartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductCatalogCart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? shoppingCartTypeId = freezed,
    Object? quantity = freezed,
    Object? forceRedirection = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            shoppingCartTypeId:
                freezed == shoppingCartTypeId
                    ? _value.shoppingCartTypeId
                    : shoppingCartTypeId // ignore: cast_nullable_to_non_nullable
                        as ShoppingCartType?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            forceRedirection:
                freezed == forceRedirection
                    ? _value.forceRedirection
                    : forceRedirection // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductCatalogCartImplCopyWith<$Res>
    implements $ProductCatalogCartCopyWith<$Res> {
  factory _$$ProductCatalogCartImplCopyWith(
    _$ProductCatalogCartImpl value,
    $Res Function(_$ProductCatalogCartImpl) then,
  ) = __$$ProductCatalogCartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
    ShoppingCartType? shoppingCartTypeId,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'ForceRedirection', includeIfNull: false)
    bool? forceRedirection,
  });
}

/// @nodoc
class __$$ProductCatalogCartImplCopyWithImpl<$Res>
    extends _$ProductCatalogCartCopyWithImpl<$Res, _$ProductCatalogCartImpl>
    implements _$$ProductCatalogCartImplCopyWith<$Res> {
  __$$ProductCatalogCartImplCopyWithImpl(
    _$ProductCatalogCartImpl _value,
    $Res Function(_$ProductCatalogCartImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductCatalogCart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? shoppingCartTypeId = freezed,
    Object? quantity = freezed,
    Object? forceRedirection = freezed,
  }) {
    return _then(
      _$ProductCatalogCartImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        shoppingCartTypeId:
            freezed == shoppingCartTypeId
                ? _value.shoppingCartTypeId
                : shoppingCartTypeId // ignore: cast_nullable_to_non_nullable
                    as ShoppingCartType?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        forceRedirection:
            freezed == forceRedirection
                ? _value.forceRedirection
                : forceRedirection // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductCatalogCartImpl implements _ProductCatalogCart {
  _$ProductCatalogCartImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
    this.shoppingCartTypeId = ShoppingCartType.onHoldCart,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'ForceRedirection', includeIfNull: false)
    this.forceRedirection = false,
  });

  factory _$ProductCatalogCartImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductCatalogCartImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
  final ShoppingCartType? shoppingCartTypeId;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
  @override
  @JsonKey(name: 'ForceRedirection', includeIfNull: false)
  final bool? forceRedirection;

  @override
  String toString() {
    return 'ProductCatalogCart(productId: $productId, shoppingCartTypeId: $shoppingCartTypeId, quantity: $quantity, forceRedirection: $forceRedirection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductCatalogCartImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.shoppingCartTypeId, shoppingCartTypeId) ||
                other.shoppingCartTypeId == shoppingCartTypeId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.forceRedirection, forceRedirection) ||
                other.forceRedirection == forceRedirection));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    shoppingCartTypeId,
    quantity,
    forceRedirection,
  );

  /// Create a copy of ProductCatalogCart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductCatalogCartImplCopyWith<_$ProductCatalogCartImpl> get copyWith =>
      __$$ProductCatalogCartImplCopyWithImpl<_$ProductCatalogCartImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductCatalogCartImplToJson(this);
  }
}

abstract class _ProductCatalogCart implements ProductCatalogCart {
  factory _ProductCatalogCart({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
    final ShoppingCartType? shoppingCartTypeId,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'ForceRedirection', includeIfNull: false)
    final bool? forceRedirection,
  }) = _$ProductCatalogCartImpl;

  factory _ProductCatalogCart.fromJson(Map<String, dynamic> json) =
      _$ProductCatalogCartImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'ShoppingCartTypeId', includeIfNull: false)
  ShoppingCartType? get shoppingCartTypeId;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'ForceRedirection', includeIfNull: false)
  bool? get forceRedirection;

  /// Create a copy of ProductCatalogCart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductCatalogCartImplCopyWith<_$ProductCatalogCartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
