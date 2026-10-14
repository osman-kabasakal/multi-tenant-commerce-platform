// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_wishlist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MiniWishlistModel _$MiniWishlistModelFromJson(Map<String, dynamic> json) {
  return _MiniWishlistModel.fromJson(json);
}

/// @nodoc
mixin _$MiniWishlistModel {
  @JsonKey(name: 'Items', includeIfNull: false)
  List<WishlistItemModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'TotalProducts', includeIfNull: false)
  int? get totalProducts => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  bool? get showProductImages => throw _privateConstructorUsedError;
  @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
  bool? get emailWishlistEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this MiniWishlistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MiniWishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MiniWishlistModelCopyWith<MiniWishlistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MiniWishlistModelCopyWith<$Res> {
  factory $MiniWishlistModelCopyWith(
    MiniWishlistModel value,
    $Res Function(MiniWishlistModel) then,
  ) = _$MiniWishlistModelCopyWithImpl<$Res, MiniWishlistModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Items', includeIfNull: false)
    List<WishlistItemModel>? items,
    @JsonKey(name: 'TotalProducts', includeIfNull: false) int? totalProducts,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    bool? showProductImages,
    @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
    bool? emailWishlistEnabled,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$MiniWishlistModelCopyWithImpl<$Res, $Val extends MiniWishlistModel>
    implements $MiniWishlistModelCopyWith<$Res> {
  _$MiniWishlistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MiniWishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? totalProducts = freezed,
    Object? showProductImages = freezed,
    Object? emailWishlistEnabled = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<WishlistItemModel>?,
            totalProducts:
                freezed == totalProducts
                    ? _value.totalProducts
                    : totalProducts // ignore: cast_nullable_to_non_nullable
                        as int?,
            showProductImages:
                freezed == showProductImages
                    ? _value.showProductImages
                    : showProductImages // ignore: cast_nullable_to_non_nullable
                        as bool?,
            emailWishlistEnabled:
                freezed == emailWishlistEnabled
                    ? _value.emailWishlistEnabled
                    : emailWishlistEnabled // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MiniWishlistModelImplCopyWith<$Res>
    implements $MiniWishlistModelCopyWith<$Res> {
  factory _$$MiniWishlistModelImplCopyWith(
    _$MiniWishlistModelImpl value,
    $Res Function(_$MiniWishlistModelImpl) then,
  ) = __$$MiniWishlistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Items', includeIfNull: false)
    List<WishlistItemModel>? items,
    @JsonKey(name: 'TotalProducts', includeIfNull: false) int? totalProducts,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    bool? showProductImages,
    @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
    bool? emailWishlistEnabled,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$MiniWishlistModelImplCopyWithImpl<$Res>
    extends _$MiniWishlistModelCopyWithImpl<$Res, _$MiniWishlistModelImpl>
    implements _$$MiniWishlistModelImplCopyWith<$Res> {
  __$$MiniWishlistModelImplCopyWithImpl(
    _$MiniWishlistModelImpl _value,
    $Res Function(_$MiniWishlistModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MiniWishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = freezed,
    Object? totalProducts = freezed,
    Object? showProductImages = freezed,
    Object? emailWishlistEnabled = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$MiniWishlistModelImpl(
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<WishlistItemModel>?,
        totalProducts:
            freezed == totalProducts
                ? _value.totalProducts
                : totalProducts // ignore: cast_nullable_to_non_nullable
                    as int?,
        showProductImages:
            freezed == showProductImages
                ? _value.showProductImages
                : showProductImages // ignore: cast_nullable_to_non_nullable
                    as bool?,
        emailWishlistEnabled:
            freezed == emailWishlistEnabled
                ? _value.emailWishlistEnabled
                : emailWishlistEnabled // ignore: cast_nullable_to_non_nullable
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
class _$MiniWishlistModelImpl implements _MiniWishlistModel {
  _$MiniWishlistModelImpl({
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<WishlistItemModel>? items = const [],
    @JsonKey(name: 'TotalProducts', includeIfNull: false) this.totalProducts,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    this.showProductImages = false,
    @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
    this.emailWishlistEnabled = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _items = items,
       _userFields = userFields;

  factory _$MiniWishlistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MiniWishlistModelImplFromJson(json);

  final List<WishlistItemModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<WishlistItemModel>? get items {
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
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  final bool? showProductImages;
  @override
  @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
  final bool? emailWishlistEnabled;
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
    return 'MiniWishlistModel(items: $items, totalProducts: $totalProducts, showProductImages: $showProductImages, emailWishlistEnabled: $emailWishlistEnabled, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MiniWishlistModelImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.showProductImages, showProductImages) ||
                other.showProductImages == showProductImages) &&
            (identical(other.emailWishlistEnabled, emailWishlistEnabled) ||
                other.emailWishlistEnabled == emailWishlistEnabled) &&
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
    showProductImages,
    emailWishlistEnabled,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of MiniWishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MiniWishlistModelImplCopyWith<_$MiniWishlistModelImpl> get copyWith =>
      __$$MiniWishlistModelImplCopyWithImpl<_$MiniWishlistModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MiniWishlistModelImplToJson(this);
  }
}

abstract class _MiniWishlistModel implements MiniWishlistModel {
  factory _MiniWishlistModel({
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<WishlistItemModel>? items,
    @JsonKey(name: 'TotalProducts', includeIfNull: false)
    final int? totalProducts,
    @JsonKey(name: 'ShowProductImages', includeIfNull: false)
    final bool? showProductImages,
    @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
    final bool? emailWishlistEnabled,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$MiniWishlistModelImpl;

  factory _MiniWishlistModel.fromJson(Map<String, dynamic> json) =
      _$MiniWishlistModelImpl.fromJson;

  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<WishlistItemModel>? get items;
  @override
  @JsonKey(name: 'TotalProducts', includeIfNull: false)
  int? get totalProducts;
  @override
  @JsonKey(name: 'ShowProductImages', includeIfNull: false)
  bool? get showProductImages;
  @override
  @JsonKey(name: 'EmailWishlistEnabled', includeIfNull: false)
  bool? get emailWishlistEnabled;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of MiniWishlistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MiniWishlistModelImplCopyWith<_$MiniWishlistModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
