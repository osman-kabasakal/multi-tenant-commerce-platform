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
  @JsonKey(name: 'Sku', includeIfNull: false)
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'Picture', includeIfNull: false)
  PictureModel? get picture => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductUrl', includeIfNull: false)
  String? get productUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  String? get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  String? get subTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'Discount', includeIfNull: false)
  String? get discount => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
  List<SelectListItem>? get allowedQuantities =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  String? get attributeInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'RecurringInfo', includeIfNull: false)
  String? get recurringInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'RentalInfo', includeIfNull: false)
  String? get rentalInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'AllowItemEditing', includeIfNull: false)
  bool? get allowItemEditing => throw _privateConstructorUsedError;
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings => throw _privateConstructorUsedError;
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
    @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
    @JsonKey(name: 'Picture', includeIfNull: false) PictureModel? picture,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'ProductUrl', includeIfNull: false) String? productUrl,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
    @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
    @JsonKey(name: 'Discount', includeIfNull: false) String? discount,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
    List<SelectListItem>? allowedQuantities,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) String? attributeInfo,
    @JsonKey(name: 'RecurringInfo', includeIfNull: false) String? recurringInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) String? rentalInfo,
    @JsonKey(name: 'AllowItemEditing', includeIfNull: false)
    bool? allowItemEditing,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
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
    Object? sku = freezed,
    Object? picture = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? productUrl = freezed,
    Object? unitPrice = freezed,
    Object? subTotal = freezed,
    Object? discount = freezed,
    Object? quantity = freezed,
    Object? allowedQuantities = freezed,
    Object? attributeInfo = freezed,
    Object? recurringInfo = freezed,
    Object? rentalInfo = freezed,
    Object? allowItemEditing = freezed,
    Object? warnings = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            sku:
                freezed == sku
                    ? _value.sku
                    : sku // ignore: cast_nullable_to_non_nullable
                        as String?,
            picture:
                freezed == picture
                    ? _value.picture
                    : picture // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
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
            unitPrice:
                freezed == unitPrice
                    ? _value.unitPrice
                    : unitPrice // ignore: cast_nullable_to_non_nullable
                        as String?,
            subTotal:
                freezed == subTotal
                    ? _value.subTotal
                    : subTotal // ignore: cast_nullable_to_non_nullable
                        as String?,
            discount:
                freezed == discount
                    ? _value.discount
                    : discount // ignore: cast_nullable_to_non_nullable
                        as String?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            allowedQuantities:
                freezed == allowedQuantities
                    ? _value.allowedQuantities
                    : allowedQuantities // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            attributeInfo:
                freezed == attributeInfo
                    ? _value.attributeInfo
                    : attributeInfo // ignore: cast_nullable_to_non_nullable
                        as String?,
            recurringInfo:
                freezed == recurringInfo
                    ? _value.recurringInfo
                    : recurringInfo // ignore: cast_nullable_to_non_nullable
                        as String?,
            rentalInfo:
                freezed == rentalInfo
                    ? _value.rentalInfo
                    : rentalInfo // ignore: cast_nullable_to_non_nullable
                        as String?,
            allowItemEditing:
                freezed == allowItemEditing
                    ? _value.allowItemEditing
                    : allowItemEditing // ignore: cast_nullable_to_non_nullable
                        as bool?,
            warnings:
                freezed == warnings
                    ? _value.warnings
                    : warnings // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
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
    @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
    @JsonKey(name: 'Picture', includeIfNull: false) PictureModel? picture,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'ProductUrl', includeIfNull: false) String? productUrl,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) String? unitPrice,
    @JsonKey(name: 'SubTotal', includeIfNull: false) String? subTotal,
    @JsonKey(name: 'Discount', includeIfNull: false) String? discount,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
    List<SelectListItem>? allowedQuantities,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) String? attributeInfo,
    @JsonKey(name: 'RecurringInfo', includeIfNull: false) String? recurringInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) String? rentalInfo,
    @JsonKey(name: 'AllowItemEditing', includeIfNull: false)
    bool? allowItemEditing,
    @JsonKey(name: 'Warnings', includeIfNull: false) List<String>? warnings,
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
    Object? sku = freezed,
    Object? picture = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? productUrl = freezed,
    Object? unitPrice = freezed,
    Object? subTotal = freezed,
    Object? discount = freezed,
    Object? quantity = freezed,
    Object? allowedQuantities = freezed,
    Object? attributeInfo = freezed,
    Object? recurringInfo = freezed,
    Object? rentalInfo = freezed,
    Object? allowItemEditing = freezed,
    Object? warnings = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ShoppingCartItemModelImpl(
        sku:
            freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                    as String?,
        picture:
            freezed == picture
                ? _value.picture
                : picture // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
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
        unitPrice:
            freezed == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                    as String?,
        subTotal:
            freezed == subTotal
                ? _value.subTotal
                : subTotal // ignore: cast_nullable_to_non_nullable
                    as String?,
        discount:
            freezed == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                    as String?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        allowedQuantities:
            freezed == allowedQuantities
                ? _value._allowedQuantities
                : allowedQuantities // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        attributeInfo:
            freezed == attributeInfo
                ? _value.attributeInfo
                : attributeInfo // ignore: cast_nullable_to_non_nullable
                    as String?,
        recurringInfo:
            freezed == recurringInfo
                ? _value.recurringInfo
                : recurringInfo // ignore: cast_nullable_to_non_nullable
                    as String?,
        rentalInfo:
            freezed == rentalInfo
                ? _value.rentalInfo
                : rentalInfo // ignore: cast_nullable_to_non_nullable
                    as String?,
        allowItemEditing:
            freezed == allowItemEditing
                ? _value.allowItemEditing
                : allowItemEditing // ignore: cast_nullable_to_non_nullable
                    as bool?,
        warnings:
            freezed == warnings
                ? _value._warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
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
    @JsonKey(name: 'Sku', includeIfNull: false) this.sku,
    @JsonKey(name: 'Picture', includeIfNull: false) this.picture,
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'ProductUrl', includeIfNull: false) this.productUrl,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) this.unitPrice,
    @JsonKey(name: 'SubTotal', includeIfNull: false) this.subTotal,
    @JsonKey(name: 'Discount', includeIfNull: false) this.discount,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
    final List<SelectListItem>? allowedQuantities = const [],
    @JsonKey(name: 'AttributeInfo', includeIfNull: false) this.attributeInfo,
    @JsonKey(name: 'RecurringInfo', includeIfNull: false) this.recurringInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) this.rentalInfo,
    @JsonKey(name: 'AllowItemEditing', includeIfNull: false)
    this.allowItemEditing = false,
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _allowedQuantities = allowedQuantities,
       _warnings = warnings,
       _userFields = userFields;

  factory _$ShoppingCartItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingCartItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'Sku', includeIfNull: false)
  final String? sku;
  @override
  @JsonKey(name: 'Picture', includeIfNull: false)
  final PictureModel? picture;
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
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  final String? unitPrice;
  @override
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  final String? subTotal;
  @override
  @JsonKey(name: 'Discount', includeIfNull: false)
  final String? discount;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
  final List<SelectListItem>? _allowedQuantities;
  @override
  @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
  List<SelectListItem>? get allowedQuantities {
    final value = _allowedQuantities;
    if (value == null) return null;
    if (_allowedQuantities is EqualUnmodifiableListView)
      return _allowedQuantities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  final String? attributeInfo;
  @override
  @JsonKey(name: 'RecurringInfo', includeIfNull: false)
  final String? recurringInfo;
  @override
  @JsonKey(name: 'RentalInfo', includeIfNull: false)
  final String? rentalInfo;
  @override
  @JsonKey(name: 'AllowItemEditing', includeIfNull: false)
  final bool? allowItemEditing;
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
    return 'ShoppingCartItemModel(sku: $sku, picture: $picture, productId: $productId, productName: $productName, productSeName: $productSeName, productUrl: $productUrl, unitPrice: $unitPrice, subTotal: $subTotal, discount: $discount, quantity: $quantity, allowedQuantities: $allowedQuantities, attributeInfo: $attributeInfo, recurringInfo: $recurringInfo, rentalInfo: $rentalInfo, allowItemEditing: $allowItemEditing, warnings: $warnings, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingCartItemModelImpl &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.picture, picture) || other.picture == picture) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            (identical(other.productUrl, productUrl) ||
                other.productUrl == productUrl) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            const DeepCollectionEquality().equals(
              other._allowedQuantities,
              _allowedQuantities,
            ) &&
            (identical(other.attributeInfo, attributeInfo) ||
                other.attributeInfo == attributeInfo) &&
            (identical(other.recurringInfo, recurringInfo) ||
                other.recurringInfo == recurringInfo) &&
            (identical(other.rentalInfo, rentalInfo) ||
                other.rentalInfo == rentalInfo) &&
            (identical(other.allowItemEditing, allowItemEditing) ||
                other.allowItemEditing == allowItemEditing) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
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
    sku,
    picture,
    productId,
    productName,
    productSeName,
    productUrl,
    unitPrice,
    subTotal,
    discount,
    quantity,
    const DeepCollectionEquality().hash(_allowedQuantities),
    attributeInfo,
    recurringInfo,
    rentalInfo,
    allowItemEditing,
    const DeepCollectionEquality().hash(_warnings),
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
    @JsonKey(name: 'Sku', includeIfNull: false) final String? sku,
    @JsonKey(name: 'Picture', includeIfNull: false) final PictureModel? picture,
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'ProductUrl', includeIfNull: false) final String? productUrl,
    @JsonKey(name: 'UnitPrice', includeIfNull: false) final String? unitPrice,
    @JsonKey(name: 'SubTotal', includeIfNull: false) final String? subTotal,
    @JsonKey(name: 'Discount', includeIfNull: false) final String? discount,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
    final List<SelectListItem>? allowedQuantities,
    @JsonKey(name: 'AttributeInfo', includeIfNull: false)
    final String? attributeInfo,
    @JsonKey(name: 'RecurringInfo', includeIfNull: false)
    final String? recurringInfo,
    @JsonKey(name: 'RentalInfo', includeIfNull: false) final String? rentalInfo,
    @JsonKey(name: 'AllowItemEditing', includeIfNull: false)
    final bool? allowItemEditing,
    @JsonKey(name: 'Warnings', includeIfNull: false)
    final List<String>? warnings,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ShoppingCartItemModelImpl;

  factory _ShoppingCartItemModel.fromJson(Map<String, dynamic> json) =
      _$ShoppingCartItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'Sku', includeIfNull: false)
  String? get sku;
  @override
  @JsonKey(name: 'Picture', includeIfNull: false)
  PictureModel? get picture;
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
  @JsonKey(name: 'UnitPrice', includeIfNull: false)
  String? get unitPrice;
  @override
  @JsonKey(name: 'SubTotal', includeIfNull: false)
  String? get subTotal;
  @override
  @JsonKey(name: 'Discount', includeIfNull: false)
  String? get discount;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'AllowedQuantities', includeIfNull: false)
  List<SelectListItem>? get allowedQuantities;
  @override
  @JsonKey(name: 'AttributeInfo', includeIfNull: false)
  String? get attributeInfo;
  @override
  @JsonKey(name: 'RecurringInfo', includeIfNull: false)
  String? get recurringInfo;
  @override
  @JsonKey(name: 'RentalInfo', includeIfNull: false)
  String? get rentalInfo;
  @override
  @JsonKey(name: 'AllowItemEditing', includeIfNull: false)
  bool? get allowItemEditing;
  @override
  @JsonKey(name: 'Warnings', includeIfNull: false)
  List<String>? get warnings;
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
