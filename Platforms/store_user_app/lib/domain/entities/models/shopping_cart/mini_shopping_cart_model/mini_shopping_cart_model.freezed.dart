// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_shopping_cart_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MiniShoppingCartModel _$MiniShoppingCartModelFromJson(
  Map<String, dynamic> json,
) {
  return _MiniShoppingCartModel.fromJson(json);
}

/// @nodoc
mixin _$MiniShoppingCartModel {
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShoppingCartItemModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalProducts', includeIfNull: false)
  int? get totalProducts => throw _privateConstructorUsedError;
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  String? get subTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
  bool? get subTotalIncludingTax => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayShoppingCartButton', includeIfNull: false)
  bool? get displayShoppingCartButton => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayCheckoutButton', includeIfNull: false)
  bool? get displayCheckoutButton => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentCustomerIsGuest', includeIfNull: false)
  bool? get currentCustomerIsGuest => throw _privateConstructorUsedError;
  @JsonKey(name: 'AnonymousCheckoutAllowed', includeIfNull: false)
  bool? get anonymousCheckoutAllowed => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  bool? get showProductImages => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this MiniShoppingCartModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MiniShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MiniShoppingCartModelCopyWith<MiniShoppingCartModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MiniShoppingCartModelCopyWith<$Res> {
  factory $MiniShoppingCartModelCopyWith(
    MiniShoppingCartModel value,
    $Res Function(MiniShoppingCartModel) then,
  ) = _$MiniShoppingCartModelCopyWithImpl<$Res, MiniShoppingCartModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Items', includeIfNull: false)
    List<ShoppingCartItemModel>? items,
    @JsonKey(name: 'TotalProducts', includeIfNull: false) int? totalProducts,
    @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
    @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
    bool? subTotalIncludingTax,
    @JsonKey(name: 'DisplayShoppingCartButton', includeIfNull: false)
    bool? displayShoppingCartButton,
    @JsonKey(name: 'DisplayCheckoutButton', includeIfNull: false)
    bool? displayCheckoutButton,
    @JsonKey(name: 'CurrentCustomerIsGuest', includeIfNull: false)
    bool? currentCustomerIsGuest,
    @JsonKey(name: 'AnonymousCheckoutAllowed', includeIfNull: false)
    bool? anonymousCheckoutAllowed,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    bool? showProductImages,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$MiniShoppingCartModelCopyWithImpl<
  $Res,
  $Val extends MiniShoppingCartModel
>
    implements $MiniShoppingCartModelCopyWith<$Res> {
  _$MiniShoppingCartModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MiniShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? totalProducts = freezed,
    Object? subTotal = freezed,
    Object? subTotalIncludingTax = freezed,
    Object? displayShoppingCartButton = freezed,
    Object? displayCheckoutButton = freezed,
    Object? currentCustomerIsGuest = freezed,
    Object? anonymousCheckoutAllowed = freezed,
    Object? showProductImages = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<ShoppingCartItemModel>?,
            totalProducts:
                freezed == totalProducts
                    ? _value.totalProducts
                    : totalProducts // ignore: cast_nullable_to_non_nullable
                        as int?,
            subTotal:
                freezed == subTotal
                    ? _value.subTotal
                    : subTotal // ignore: cast_nullable_to_non_nullable
                        as String?,
            subTotalIncludingTax:
                freezed == subTotalIncludingTax
                    ? _value.subTotalIncludingTax
                    : subTotalIncludingTax // ignore: cast_nullable_to_non_nullable
                        as bool?,
            displayShoppingCartButton:
                freezed == displayShoppingCartButton
                    ? _value.displayShoppingCartButton
                    : displayShoppingCartButton // ignore: cast_nullable_to_non_nullable
                        as bool?,
            displayCheckoutButton:
                freezed == displayCheckoutButton
                    ? _value.displayCheckoutButton
                    : displayCheckoutButton // ignore: cast_nullable_to_non_nullable
                        as bool?,
            currentCustomerIsGuest:
                freezed == currentCustomerIsGuest
                    ? _value.currentCustomerIsGuest
                    : currentCustomerIsGuest // ignore: cast_nullable_to_non_nullable
                        as bool?,
            anonymousCheckoutAllowed:
                freezed == anonymousCheckoutAllowed
                    ? _value.anonymousCheckoutAllowed
                    : anonymousCheckoutAllowed // ignore: cast_nullable_to_non_nullable
                        as bool?,
            showProductImages:
                freezed == showProductImages
                    ? _value.showProductImages
                    : showProductImages // ignore: cast_nullable_to_non_nullable
                        as bool?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MiniShoppingCartModelImplCopyWith<$Res>
    implements $MiniShoppingCartModelCopyWith<$Res> {
  factory _$$MiniShoppingCartModelImplCopyWith(
    _$MiniShoppingCartModelImpl value,
    $Res Function(_$MiniShoppingCartModelImpl) then,
  ) = __$$MiniShoppingCartModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Items', includeIfNull: false)
    List<ShoppingCartItemModel>? items,
    @JsonKey(name: 'TotalProducts', includeIfNull: false) int? totalProducts,
    @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
    @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
    bool? subTotalIncludingTax,
    @JsonKey(name: 'DisplayShoppingCartButton', includeIfNull: false)
    bool? displayShoppingCartButton,
    @JsonKey(name: 'DisplayCheckoutButton', includeIfNull: false)
    bool? displayCheckoutButton,
    @JsonKey(name: 'CurrentCustomerIsGuest', includeIfNull: false)
    bool? currentCustomerIsGuest,
    @JsonKey(name: 'AnonymousCheckoutAllowed', includeIfNull: false)
    bool? anonymousCheckoutAllowed,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    bool? showProductImages,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$MiniShoppingCartModelImplCopyWithImpl<$Res>
    extends
        _$MiniShoppingCartModelCopyWithImpl<$Res, _$MiniShoppingCartModelImpl>
    implements _$$MiniShoppingCartModelImplCopyWith<$Res> {
  __$$MiniShoppingCartModelImplCopyWithImpl(
    _$MiniShoppingCartModelImpl _value,
    $Res Function(_$MiniShoppingCartModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MiniShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? totalProducts = freezed,
    Object? subTotal = freezed,
    Object? subTotalIncludingTax = freezed,
    Object? displayShoppingCartButton = freezed,
    Object? displayCheckoutButton = freezed,
    Object? currentCustomerIsGuest = freezed,
    Object? anonymousCheckoutAllowed = freezed,
    Object? showProductImages = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$MiniShoppingCartModelImpl(
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<ShoppingCartItemModel>?,
        totalProducts:
            freezed == totalProducts
                ? _value.totalProducts
                : totalProducts // ignore: cast_nullable_to_non_nullable
                    as int?,
        subTotal:
            freezed == subTotal
                ? _value.subTotal
                : subTotal // ignore: cast_nullable_to_non_nullable
                    as String?,
        subTotalIncludingTax:
            freezed == subTotalIncludingTax
                ? _value.subTotalIncludingTax
                : subTotalIncludingTax // ignore: cast_nullable_to_non_nullable
                    as bool?,
        displayShoppingCartButton:
            freezed == displayShoppingCartButton
                ? _value.displayShoppingCartButton
                : displayShoppingCartButton // ignore: cast_nullable_to_non_nullable
                    as bool?,
        displayCheckoutButton:
            freezed == displayCheckoutButton
                ? _value.displayCheckoutButton
                : displayCheckoutButton // ignore: cast_nullable_to_non_nullable
                    as bool?,
        currentCustomerIsGuest:
            freezed == currentCustomerIsGuest
                ? _value.currentCustomerIsGuest
                : currentCustomerIsGuest // ignore: cast_nullable_to_non_nullable
                    as bool?,
        anonymousCheckoutAllowed:
            freezed == anonymousCheckoutAllowed
                ? _value.anonymousCheckoutAllowed
                : anonymousCheckoutAllowed // ignore: cast_nullable_to_non_nullable
                    as bool?,
        showProductImages:
            freezed == showProductImages
                ? _value.showProductImages
                : showProductImages // ignore: cast_nullable_to_non_nullable
                    as bool?,
        userFields:
            freezed == userFields
                ? _value._userFields
                : userFields // ignore: cast_nullable_to_non_nullable
                    as List<UserField>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MiniShoppingCartModelImpl implements _MiniShoppingCartModel {
  _$MiniShoppingCartModelImpl({
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<ShoppingCartItemModel>? items = const [],
    @JsonKey(name: 'TotalProducts', includeIfNull: false) this.totalProducts,
    @JsonKey(name: 'SubTotal', includeIfNull: false) this.subTotal,
    @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
    this.subTotalIncludingTax = false,
    @JsonKey(name: 'DisplayShoppingCartButton', includeIfNull: false)
    this.displayShoppingCartButton = false,
    @JsonKey(name: 'DisplayCheckoutButton', includeIfNull: false)
    this.displayCheckoutButton = false,
    @JsonKey(name: 'CurrentCustomerIsGuest', includeIfNull: false)
    this.currentCustomerIsGuest = false,
    @JsonKey(name: 'AnonymousCheckoutAllowed', includeIfNull: false)
    this.anonymousCheckoutAllowed = false,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    this.showProductImages = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _items = items,
       _userFields = userFields;

  factory _$MiniShoppingCartModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MiniShoppingCartModelImplFromJson(json);

  final List<ShoppingCartItemModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShoppingCartItemModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'TotalProducts', includeIfNull: false)
  final int? totalProducts;
  @override
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  final String? subTotal;
  @override
  @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
  final bool? subTotalIncludingTax;
  @override
  @JsonKey(name: 'DisplayShoppingCartButton', includeIfNull: false)
  final bool? displayShoppingCartButton;
  @override
  @JsonKey(name: 'DisplayCheckoutButton', includeIfNull: false)
  final bool? displayCheckoutButton;
  @override
  @JsonKey(name: 'CurrentCustomerIsGuest', includeIfNull: false)
  final bool? currentCustomerIsGuest;
  @override
  @JsonKey(name: 'AnonymousCheckoutAllowed', includeIfNull: false)
  final bool? anonymousCheckoutAllowed;
  @override
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  final bool? showProductImages;
  final List<UserField>? _userFields;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields {
    final value = _userFields;
    if (value == null) return null;
    if (_userFields is EqualUnmodifiableListView) return _userFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MiniShoppingCartModel(items: $items, totalProducts: $totalProducts, subTotal: $subTotal, subTotalIncludingTax: $subTotalIncludingTax, displayShoppingCartButton: $displayShoppingCartButton, displayCheckoutButton: $displayCheckoutButton, currentCustomerIsGuest: $currentCustomerIsGuest, anonymousCheckoutAllowed: $anonymousCheckoutAllowed, showProductImages: $showProductImages, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MiniShoppingCartModelImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.subTotalIncludingTax, subTotalIncludingTax) ||
                other.subTotalIncludingTax == subTotalIncludingTax) &&
            (identical(
                  other.displayShoppingCartButton,
                  displayShoppingCartButton,
                ) ||
                other.displayShoppingCartButton == displayShoppingCartButton) &&
            (identical(other.displayCheckoutButton, displayCheckoutButton) ||
                other.displayCheckoutButton == displayCheckoutButton) &&
            (identical(other.currentCustomerIsGuest, currentCustomerIsGuest) ||
                other.currentCustomerIsGuest == currentCustomerIsGuest) &&
            (identical(
                  other.anonymousCheckoutAllowed,
                  anonymousCheckoutAllowed,
                ) ||
                other.anonymousCheckoutAllowed == anonymousCheckoutAllowed) &&
            (identical(other.showProductImages, showProductImages) ||
                other.showProductImages == showProductImages) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    totalProducts,
    subTotal,
    subTotalIncludingTax,
    displayShoppingCartButton,
    displayCheckoutButton,
    currentCustomerIsGuest,
    anonymousCheckoutAllowed,
    showProductImages,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of MiniShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MiniShoppingCartModelImplCopyWith<_$MiniShoppingCartModelImpl>
  get copyWith =>
      __$$MiniShoppingCartModelImplCopyWithImpl<_$MiniShoppingCartModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MiniShoppingCartModelImplToJson(this);
  }
}

abstract class _MiniShoppingCartModel implements MiniShoppingCartModel {
  factory _MiniShoppingCartModel({
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<ShoppingCartItemModel>? items,
    @JsonKey(name: 'TotalProducts', includeIfNull: false)
    final int? totalProducts,
    @JsonKey(name: 'SubTotal', includeIfNull: false) final String? subTotal,
    @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
    final bool? subTotalIncludingTax,
    @JsonKey(name: 'DisplayShoppingCartButton', includeIfNull: false)
    final bool? displayShoppingCartButton,
    @JsonKey(name: 'DisplayCheckoutButton', includeIfNull: false)
    final bool? displayCheckoutButton,
    @JsonKey(name: 'CurrentCustomerIsGuest', includeIfNull: false)
    final bool? currentCustomerIsGuest,
    @JsonKey(name: 'AnonymousCheckoutAllowed', includeIfNull: false)
    final bool? anonymousCheckoutAllowed,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    final bool? showProductImages,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$MiniShoppingCartModelImpl;

  factory _MiniShoppingCartModel.fromJson(Map<String, dynamic> json) =
      _$MiniShoppingCartModelImpl.fromJson;

  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShoppingCartItemModel>? get items;
  @override
  @JsonKey(name: 'TotalProducts', includeIfNull: false)
  int? get totalProducts;
  @override
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  String? get subTotal;
  @override
  @JsonKey(name: 'SubTotalIncludingTax', includeIfNull: false)
  bool? get subTotalIncludingTax;
  @override
  @JsonKey(name: 'DisplayShoppingCartButton', includeIfNull: false)
  bool? get displayShoppingCartButton;
  @override
  @JsonKey(name: 'DisplayCheckoutButton', includeIfNull: false)
  bool? get displayCheckoutButton;
  @override
  @JsonKey(name: 'CurrentCustomerIsGuest', includeIfNull: false)
  bool? get currentCustomerIsGuest;
  @override
  @JsonKey(name: 'AnonymousCheckoutAllowed', includeIfNull: false)
  bool? get anonymousCheckoutAllowed;
  @override
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  bool? get showProductImages;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of MiniShoppingCartModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MiniShoppingCartModelImplCopyWith<_$MiniShoppingCartModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
