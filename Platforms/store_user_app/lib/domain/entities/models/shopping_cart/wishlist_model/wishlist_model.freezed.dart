// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WishlistModel _$WishlistModelFromJson(Map<String, dynamic> json) {
  return _WishlistModel.fromJson(json);
}

/// @nodoc
mixin _$WishlistModel {
  @JsonKey(name: 'CustomerGuid', includeIfNull: false)
  String? get customerGuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerFullname', includeIfNull: false)
  String? get customerFullname => throw _privateConstructorUsedError;
  @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
  bool? get emailWishlistEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  bool? get showSku => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  bool? get showProductImages => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsEditable', includeIfNull: false)
  bool? get isEditable => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisplayAddToCart', includeIfNull: false)
  bool? get displayAddToCart => throw _privateConstructorUsedError;
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShoppingCartItemModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this WishlistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishlistModelCopyWith<WishlistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistModelCopyWith<$Res> {
  factory $WishlistModelCopyWith(
    WishlistModel value,
    $Res Function(WishlistModel) then,
  ) = _$WishlistModelCopyWithImpl<$Res, WishlistModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerGuid', includeIfNull: false) String? customerGuid,
    @JsonKey(name: 'CustomerFullname', includeIfNull: false)
    String? customerFullname,
    @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
    bool? emailWishlistEnabled,
    @JsonKey(name: 'ShowSku', includeIfNull: false) bool? showSku,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    bool? showProductImages,
    @JsonKey(name: 'IsEditable', includeIfNull: false) bool? isEditable,
    @JsonKey(name: 'DisplayAddToCart', includeIfNull: false)
    bool? displayAddToCart,
    @JsonKey(name: 'Items', includeIfNull: false)
    List<ShoppingCartItemModel>? items,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$WishlistModelCopyWithImpl<$Res, $Val extends WishlistModel>
    implements $WishlistModelCopyWith<$Res> {
  _$WishlistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerGuid = freezed,
    Object? customerFullname = freezed,
    Object? emailWishlistEnabled = freezed,
    Object? showSku = freezed,
    Object? showProductImages = freezed,
    Object? isEditable = freezed,
    Object? displayAddToCart = freezed,
    Object? items = freezed,
    Object? warnings = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            customerGuid:
                freezed == customerGuid
                    ? _value.customerGuid
                    : customerGuid // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerFullname:
                freezed == customerFullname
                    ? _value.customerFullname
                    : customerFullname // ignore: cast_nullable_to_non_nullable
                        as String?,
            emailWishlistEnabled:
                freezed == emailWishlistEnabled
                    ? _value.emailWishlistEnabled
                    : emailWishlistEnabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            showSku:
                freezed == showSku
                    ? _value.showSku
                    : showSku // ignore: cast_nullable_to_non_nullable
                        as bool?,
            showProductImages:
                freezed == showProductImages
                    ? _value.showProductImages
                    : showProductImages // ignore: cast_nullable_to_non_nullable
                        as bool?,
            isEditable:
                freezed == isEditable
                    ? _value.isEditable
                    : isEditable // ignore: cast_nullable_to_non_nullable
                        as bool?,
            displayAddToCart:
                freezed == displayAddToCart
                    ? _value.displayAddToCart
                    : displayAddToCart // ignore: cast_nullable_to_non_nullable
                        as bool?,
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<ShoppingCartItemModel>?,
            warnings:
                freezed == warnings
                    ? _value.warnings
                    : warnings // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
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
abstract class _$$WishlistModelImplCopyWith<$Res>
    implements $WishlistModelCopyWith<$Res> {
  factory _$$WishlistModelImplCopyWith(
    _$WishlistModelImpl value,
    $Res Function(_$WishlistModelImpl) then,
  ) = __$$WishlistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerGuid', includeIfNull: false) String? customerGuid,
    @JsonKey(name: 'CustomerFullname', includeIfNull: false)
    String? customerFullname,
    @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
    bool? emailWishlistEnabled,
    @JsonKey(name: 'ShowSku', includeIfNull: false) bool? showSku,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    bool? showProductImages,
    @JsonKey(name: 'IsEditable', includeIfNull: false) bool? isEditable,
    @JsonKey(name: 'DisplayAddToCart', includeIfNull: false)
    bool? displayAddToCart,
    @JsonKey(name: 'Items', includeIfNull: false)
    List<ShoppingCartItemModel>? items,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$WishlistModelImplCopyWithImpl<$Res>
    extends _$WishlistModelCopyWithImpl<$Res, _$WishlistModelImpl>
    implements _$$WishlistModelImplCopyWith<$Res> {
  __$$WishlistModelImplCopyWithImpl(
    _$WishlistModelImpl _value,
    $Res Function(_$WishlistModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerGuid = freezed,
    Object? customerFullname = freezed,
    Object? emailWishlistEnabled = freezed,
    Object? showSku = freezed,
    Object? showProductImages = freezed,
    Object? isEditable = freezed,
    Object? displayAddToCart = freezed,
    Object? items = freezed,
    Object? warnings = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$WishlistModelImpl(
        customerGuid:
            freezed == customerGuid
                ? _value.customerGuid
                : customerGuid // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerFullname:
            freezed == customerFullname
                ? _value.customerFullname
                : customerFullname // ignore: cast_nullable_to_non_nullable
                    as String?,
        emailWishlistEnabled:
            freezed == emailWishlistEnabled
                ? _value.emailWishlistEnabled
                : emailWishlistEnabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        showSku:
            freezed == showSku
                ? _value.showSku
                : showSku // ignore: cast_nullable_to_non_nullable
                    as bool?,
        showProductImages:
            freezed == showProductImages
                ? _value.showProductImages
                : showProductImages // ignore: cast_nullable_to_non_nullable
                    as bool?,
        isEditable:
            freezed == isEditable
                ? _value.isEditable
                : isEditable // ignore: cast_nullable_to_non_nullable
                    as bool?,
        displayAddToCart:
            freezed == displayAddToCart
                ? _value.displayAddToCart
                : displayAddToCart // ignore: cast_nullable_to_non_nullable
                    as bool?,
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<ShoppingCartItemModel>?,
        warnings:
            freezed == warnings
                ? _value._warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
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
class _$WishlistModelImpl implements _WishlistModel {
  _$WishlistModelImpl({
    @JsonKey(name: 'CustomerGuid', includeIfNull: false) this.customerGuid,
    @JsonKey(name: 'CustomerFullname', includeIfNull: false)
    this.customerFullname,
    @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
    this.emailWishlistEnabled = false,
    @JsonKey(name: 'ShowSku', includeIfNull: false) this.showSku = false,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    this.showProductImages = false,
    @JsonKey(name: 'IsEditable', includeIfNull: false) this.isEditable = false,
    @JsonKey(name: 'DisplayAddToCart', includeIfNull: false)
    this.displayAddToCart = false,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<ShoppingCartItemModel>? items = const [],
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _items = items,
       _warnings = warnings,
       _userFields = userFields;

  factory _$WishlistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistModelImplFromJson(json);

  @override
  @JsonKey(name: 'CustomerGuid', includeIfNull: false)
  final String? customerGuid;
  @override
  @JsonKey(name: 'CustomerFullname', includeIfNull: false)
  final String? customerFullname;
  @override
  @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
  final bool? emailWishlistEnabled;
  @override
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  final bool? showSku;
  @override
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  final bool? showProductImages;
  @override
  @JsonKey(name: 'IsEditable', includeIfNull: false)
  final bool? isEditable;
  @override
  @JsonKey(name: 'DisplayAddToCart', includeIfNull: false)
  final bool? displayAddToCart;
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

  final List<String>? _warnings;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings {
    final value = _warnings;
    if (value == null) return null;
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'WishlistModel(customerGuid: $customerGuid, customerFullname: $customerFullname, emailWishlistEnabled: $emailWishlistEnabled, showSku: $showSku, showProductImages: $showProductImages, isEditable: $isEditable, displayAddToCart: $displayAddToCart, items: $items, warnings: $warnings, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistModelImpl &&
            (identical(other.customerGuid, customerGuid) ||
                other.customerGuid == customerGuid) &&
            (identical(other.customerFullname, customerFullname) ||
                other.customerFullname == customerFullname) &&
            (identical(other.emailWishlistEnabled, emailWishlistEnabled) ||
                other.emailWishlistEnabled == emailWishlistEnabled) &&
            (identical(other.showSku, showSku) || other.showSku == showSku) &&
            (identical(other.showProductImages, showProductImages) ||
                other.showProductImages == showProductImages) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable) &&
            (identical(other.displayAddToCart, displayAddToCart) ||
                other.displayAddToCart == displayAddToCart) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    customerGuid,
    customerFullname,
    emailWishlistEnabled,
    showSku,
    showProductImages,
    isEditable,
    displayAddToCart,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_warnings),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of WishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistModelImplCopyWith<_$WishlistModelImpl> get copyWith =>
      __$$WishlistModelImplCopyWithImpl<_$WishlistModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistModelImplToJson(this);
  }
}

abstract class _WishlistModel implements WishlistModel {
  factory _WishlistModel({
    @JsonKey(name: 'CustomerGuid', includeIfNull: false)
    final String? customerGuid,
    @JsonKey(name: 'CustomerFullname', includeIfNull: false)
    final String? customerFullname,
    @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
    final bool? emailWishlistEnabled,
    @JsonKey(name: 'ShowSku', includeIfNull: false) final bool? showSku,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    final bool? showProductImages,
    @JsonKey(name: 'IsEditable', includeIfNull: false) final bool? isEditable,
    @JsonKey(name: 'DisplayAddToCart', includeIfNull: false)
    final bool? displayAddToCart,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<ShoppingCartItemModel>? items,
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$WishlistModelImpl;

  factory _WishlistModel.fromJson(Map<String, dynamic> json) =
      _$WishlistModelImpl.fromJson;

  @override
  @JsonKey(name: 'CustomerGuid', includeIfNull: false)
  String? get customerGuid;
  @override
  @JsonKey(name: 'CustomerFullname', includeIfNull: false)
  String? get customerFullname;
  @override
  @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
  bool? get emailWishlistEnabled;
  @override
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  bool? get showSku;
  @override
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  bool? get showProductImages;
  @override
  @JsonKey(name: 'IsEditable', includeIfNull: false)
  bool? get isEditable;
  @override
  @JsonKey(name: 'DisplayAddToCart', includeIfNull: false)
  bool? get displayAddToCart;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShoppingCartItemModel>? get items;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of WishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishlistModelImplCopyWith<_$WishlistModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
