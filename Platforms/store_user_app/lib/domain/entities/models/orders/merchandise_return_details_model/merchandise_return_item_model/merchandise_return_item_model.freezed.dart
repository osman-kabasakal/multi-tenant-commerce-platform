// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchandise_return_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MerchandiseReturnItemModel _$MerchandiseReturnItemModelFromJson(
  Map<String, dynamic> json,
) {
  return _MerchandiseReturnItemModel.fromJson(json);
}

/// @nodoc
mixin _$MerchandiseReturnItemModel {
  @JsonKey(name: 'OrderItemId', includeIfNull: false)
  String? get orderItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReasonForReturn', includeIfNull: false)
  String? get reasonForReturn => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'RequestedAction', includeIfNull: false)
  String? get requestedAction => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductPrice', includeIfNull: false)
  String? get productPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this MerchandiseReturnItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MerchandiseReturnItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchandiseReturnItemModelCopyWith<MerchandiseReturnItemModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchandiseReturnItemModelCopyWith<$Res> {
  factory $MerchandiseReturnItemModelCopyWith(
    MerchandiseReturnItemModel value,
    $Res Function(MerchandiseReturnItemModel) then,
  ) =
      _$MerchandiseReturnItemModelCopyWithImpl<
        $Res,
        MerchandiseReturnItemModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'OrderItemId', includeIfNull: false) String? orderItemId,
    @JsonKey(name: 'ReasonForReturn', includeIfNull: false)
    String? reasonForReturn,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'RequestedAction', includeIfNull: false)
    String? requestedAction,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductPrice', includeIfNull: false) String? productPrice,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$MerchandiseReturnItemModelCopyWithImpl<
  $Res,
  $Val extends MerchandiseReturnItemModel
>
    implements $MerchandiseReturnItemModelCopyWith<$Res> {
  _$MerchandiseReturnItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchandiseReturnItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderItemId = freezed,
    Object? reasonForReturn = freezed,
    Object? quantity = freezed,
    Object? requestedAction = freezed,
    Object? productSeName = freezed,
    Object? productName = freezed,
    Object? productPrice = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            orderItemId:
                freezed == orderItemId
                    ? _value.orderItemId
                    : orderItemId // ignore: cast_nullable_to_non_nullable
                        as String?,
            reasonForReturn:
                freezed == reasonForReturn
                    ? _value.reasonForReturn
                    : reasonForReturn // ignore: cast_nullable_to_non_nullable
                        as String?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            requestedAction:
                freezed == requestedAction
                    ? _value.requestedAction
                    : requestedAction // ignore: cast_nullable_to_non_nullable
                        as String?,
            productSeName:
                freezed == productSeName
                    ? _value.productSeName
                    : productSeName // ignore: cast_nullable_to_non_nullable
                        as String?,
            productName:
                freezed == productName
                    ? _value.productName
                    : productName // ignore: cast_nullable_to_non_nullable
                        as String?,
            productPrice:
                freezed == productPrice
                    ? _value.productPrice
                    : productPrice // ignore: cast_nullable_to_non_nullable
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
}

/// @nodoc
abstract class _$$MerchandiseReturnItemModelImplCopyWith<$Res>
    implements $MerchandiseReturnItemModelCopyWith<$Res> {
  factory _$$MerchandiseReturnItemModelImplCopyWith(
    _$MerchandiseReturnItemModelImpl value,
    $Res Function(_$MerchandiseReturnItemModelImpl) then,
  ) = __$$MerchandiseReturnItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'OrderItemId', includeIfNull: false) String? orderItemId,
    @JsonKey(name: 'ReasonForReturn', includeIfNull: false)
    String? reasonForReturn,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'RequestedAction', includeIfNull: false)
    String? requestedAction,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductPrice', includeIfNull: false) String? productPrice,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$MerchandiseReturnItemModelImplCopyWithImpl<$Res>
    extends
        _$MerchandiseReturnItemModelCopyWithImpl<
          $Res,
          _$MerchandiseReturnItemModelImpl
        >
    implements _$$MerchandiseReturnItemModelImplCopyWith<$Res> {
  __$$MerchandiseReturnItemModelImplCopyWithImpl(
    _$MerchandiseReturnItemModelImpl _value,
    $Res Function(_$MerchandiseReturnItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MerchandiseReturnItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderItemId = freezed,
    Object? reasonForReturn = freezed,
    Object? quantity = freezed,
    Object? requestedAction = freezed,
    Object? productSeName = freezed,
    Object? productName = freezed,
    Object? productPrice = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$MerchandiseReturnItemModelImpl(
        orderItemId:
            freezed == orderItemId
                ? _value.orderItemId
                : orderItemId // ignore: cast_nullable_to_non_nullable
                    as String?,
        reasonForReturn:
            freezed == reasonForReturn
                ? _value.reasonForReturn
                : reasonForReturn // ignore: cast_nullable_to_non_nullable
                    as String?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        requestedAction:
            freezed == requestedAction
                ? _value.requestedAction
                : requestedAction // ignore: cast_nullable_to_non_nullable
                    as String?,
        productSeName:
            freezed == productSeName
                ? _value.productSeName
                : productSeName // ignore: cast_nullable_to_non_nullable
                    as String?,
        productName:
            freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                    as String?,
        productPrice:
            freezed == productPrice
                ? _value.productPrice
                : productPrice // ignore: cast_nullable_to_non_nullable
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
class _$MerchandiseReturnItemModelImpl implements _MerchandiseReturnItemModel {
  _$MerchandiseReturnItemModelImpl({
    @JsonKey(name: 'OrderItemId', includeIfNull: false) this.orderItemId,
    @JsonKey(name: 'ReasonForReturn', includeIfNull: false)
    this.reasonForReturn,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'RequestedAction', includeIfNull: false)
    this.requestedAction,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'ProductPrice', includeIfNull: false) this.productPrice,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$MerchandiseReturnItemModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$MerchandiseReturnItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'OrderItemId', includeIfNull: false)
  final String? orderItemId;
  @override
  @JsonKey(name: 'ReasonForReturn', includeIfNull: false)
  final String? reasonForReturn;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
  @override
  @JsonKey(name: 'RequestedAction', includeIfNull: false)
  final String? requestedAction;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  final String? productSeName;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  final String? productName;
  @override
  @JsonKey(name: 'ProductPrice', includeIfNull: false)
  final String? productPrice;
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
    return 'MerchandiseReturnItemModel(orderItemId: $orderItemId, reasonForReturn: $reasonForReturn, quantity: $quantity, requestedAction: $requestedAction, productSeName: $productSeName, productName: $productName, productPrice: $productPrice, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchandiseReturnItemModelImpl &&
            (identical(other.orderItemId, orderItemId) ||
                other.orderItemId == orderItemId) &&
            (identical(other.reasonForReturn, reasonForReturn) ||
                other.reasonForReturn == reasonForReturn) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.requestedAction, requestedAction) ||
                other.requestedAction == requestedAction) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productPrice, productPrice) ||
                other.productPrice == productPrice) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderItemId,
    reasonForReturn,
    quantity,
    requestedAction,
    productSeName,
    productName,
    productPrice,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of MerchandiseReturnItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchandiseReturnItemModelImplCopyWith<_$MerchandiseReturnItemModelImpl>
  get copyWith => __$$MerchandiseReturnItemModelImplCopyWithImpl<
    _$MerchandiseReturnItemModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchandiseReturnItemModelImplToJson(this);
  }
}

abstract class _MerchandiseReturnItemModel
    implements MerchandiseReturnItemModel {
  factory _MerchandiseReturnItemModel({
    @JsonKey(name: 'OrderItemId', includeIfNull: false)
    final String? orderItemId,
    @JsonKey(name: 'ReasonForReturn', includeIfNull: false)
    final String? reasonForReturn,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'RequestedAction', includeIfNull: false)
    final String? requestedAction,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'ProductPrice', includeIfNull: false)
    final String? productPrice,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$MerchandiseReturnItemModelImpl;

  factory _MerchandiseReturnItemModel.fromJson(Map<String, dynamic> json) =
      _$MerchandiseReturnItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'OrderItemId', includeIfNull: false)
  String? get orderItemId;
  @override
  @JsonKey(name: 'ReasonForReturn', includeIfNull: false)
  String? get reasonForReturn;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'RequestedAction', includeIfNull: false)
  String? get requestedAction;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName;
  @override
  @JsonKey(name: 'ProductPrice', includeIfNull: false)
  String? get productPrice;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of MerchandiseReturnItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchandiseReturnItemModelImplCopyWith<_$MerchandiseReturnItemModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
