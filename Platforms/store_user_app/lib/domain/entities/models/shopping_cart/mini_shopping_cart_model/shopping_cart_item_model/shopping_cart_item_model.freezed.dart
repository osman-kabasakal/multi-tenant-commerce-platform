// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_cart_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShoppingCartItemModel _$ShoppingCartItemModelFromJson(
  Map<String, dynamic> json,
) {
  return _ShoppingCartItemModel.fromJson(json);
}

/// @nodoc
mixin _$ShoppingCartItemModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductUrl', includeIfNull: false)
  String? get productUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  String? get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  String? get attributeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'Picture', includeIfNull: false)
  PictureModel? get picture => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ShoppingCartItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingCartItemModelCopyWith<ShoppingCartItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingCartItemModelCopyWith<$Res> {
  factory $ShoppingCartItemModelCopyWith(
    ShoppingCartItemModel value,
    $Res Function(ShoppingCartItemModel) then,
  ) = _$ShoppingCartItemModelCopyWithImpl<$Res, ShoppingCartItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'ProductUrl', includeIfNull: false) String? productUrl,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) String? attributeInfo,
    @JsonKey(name: 'Picture', includeIfNull: false) PictureModel? picture,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $PictureModelCopyWith<$Res>? get picture;
}

/// @nodoc
class _$ShoppingCartItemModelCopyWithImpl<
  $Res,
  $Val extends ShoppingCartItemModel
>
    implements $ShoppingCartItemModelCopyWith<$Res> {
  _$ShoppingCartItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? productUrl = freezed,
    Object? quantity = freezed,
    Object? unitPrice = freezed,
    Object? attributeInfo = freezed,
    Object? picture = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            productName:
                freezed == productName
                    ? _value.productName
                    : productName // ignore: cast_nullable_to_non_nullable
                        as String?,
            productSeName:
                freezed == productSeName
                    ? _value.productSeName
                    : productSeName // ignore: cast_nullable_to_non_nullable
                        as String?,
            productUrl:
                freezed == productUrl
                    ? _value.productUrl
                    : productUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            unitPrice:
                freezed == unitPrice
                    ? _value.unitPrice
                    : unitPrice // ignore: cast_nullable_to_non_nullable
                        as String?,
            attributeInfo:
                freezed == attributeInfo
                    ? _value.attributeInfo
                    : attributeInfo // ignore: cast_nullable_to_non_nullable
                        as String?,
            picture:
                freezed == picture
                    ? _value.picture
                    : picture // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ShoppingCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PictureModelCopyWith<$Res>? get picture {
    if (_value.picture == null) {
      return null;
    }

    return $PictureModelCopyWith<$Res>(_value.picture!, (value) {
      return _then(_value.copyWith(picture: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShoppingCartItemModelImplCopyWith<$Res>
    implements $ShoppingCartItemModelCopyWith<$Res> {
  factory _$$ShoppingCartItemModelImplCopyWith(
    _$ShoppingCartItemModelImpl value,
    $Res Function(_$ShoppingCartItemModelImpl) then,
  ) = __$$ShoppingCartItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'ProductUrl', includeIfNull: false) String? productUrl,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) String? attributeInfo,
    @JsonKey(name: 'Picture', includeIfNull: false) PictureModel? picture,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $PictureModelCopyWith<$Res>? get picture;
}

/// @nodoc
class __$$ShoppingCartItemModelImplCopyWithImpl<$Res>
    extends
        _$ShoppingCartItemModelCopyWithImpl<$Res, _$ShoppingCartItemModelImpl>
    implements _$$ShoppingCartItemModelImplCopyWith<$Res> {
  __$$ShoppingCartItemModelImplCopyWithImpl(
    _$ShoppingCartItemModelImpl _value,
    $Res Function(_$ShoppingCartItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoppingCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? productUrl = freezed,
    Object? quantity = freezed,
    Object? unitPrice = freezed,
    Object? attributeInfo = freezed,
    Object? picture = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ShoppingCartItemModelImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        productName:
            freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                    as String?,
        productSeName:
            freezed == productSeName
                ? _value.productSeName
                : productSeName // ignore: cast_nullable_to_non_nullable
                    as String?,
        productUrl:
            freezed == productUrl
                ? _value.productUrl
                : productUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        unitPrice:
            freezed == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                    as String?,
        attributeInfo:
            freezed == attributeInfo
                ? _value.attributeInfo
                : attributeInfo // ignore: cast_nullable_to_non_nullable
                    as String?,
        picture:
            freezed == picture
                ? _value.picture
                : picture // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$ShoppingCartItemModelImpl implements _ShoppingCartItemModel {
  _$ShoppingCartItemModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'ProductUrl', includeIfNull: false) this.productUrl,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) this.unitPrice,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) this.attributeInfo,
    @JsonKey(name: 'Picture', includeIfNull: false) this.picture,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ShoppingCartItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingCartItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  final String? productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  final String? productSeName;
  @override
  @JsonKey(name: 'ProductUrl', includeIfNull: false)
  final String? productUrl;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
  @override
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  final String? unitPrice;
  @override
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  final String? attributeInfo;
  @override
  @JsonKey(name: 'Picture', includeIfNull: false)
  final PictureModel? picture;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
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
    return 'ShoppingCartItemModel(productId: $productId, productName: $productName, productSeName: $productSeName, productUrl: $productUrl, quantity: $quantity, unitPrice: $unitPrice, attributeInfo: $attributeInfo, picture: $picture, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingCartItemModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            (identical(other.productUrl, productUrl) ||
                other.productUrl == productUrl) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.attributeInfo, attributeInfo) ||
                other.attributeInfo == attributeInfo) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    productName,
    productSeName,
    productUrl,
    quantity,
    unitPrice,
    attributeInfo,
    picture,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ShoppingCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingCartItemModelImplCopyWith<_$ShoppingCartItemModelImpl>
  get copyWith =>
      __$$ShoppingCartItemModelImplCopyWithImpl<_$ShoppingCartItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingCartItemModelImplToJson(this);
  }
}

abstract class _ShoppingCartItemModel implements ShoppingCartItemModel {
  factory _ShoppingCartItemModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'ProductUrl', includeIfNull: false) final String? productUrl,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) final String? unitPrice,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false)
    final String? attributeInfo,
    @JsonKey(name: 'Picture', includeIfNull: false) final PictureModel? picture,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ShoppingCartItemModelImpl;

  factory _ShoppingCartItemModel.fromJson(Map<String, dynamic> json) =
      _$ShoppingCartItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName;
  @override
  @JsonKey(name: 'ProductUrl', includeIfNull: false)
  String? get productUrl;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  String? get unitPrice;
  @override
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  String? get attributeInfo;
  @override
  @JsonKey(name: 'Picture', includeIfNull: false)
  PictureModel? get picture;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ShoppingCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingCartItemModelImplCopyWith<_$ShoppingCartItemModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
