// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tier_price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TierPrice _$TierPriceFromJson(Map<String, dynamic> json) {
  return _TierPrice.fromJson(json);
}

/// @nodoc
mixin _$TierPrice {
  @JsonKey(name: 'StoreId', includeIfNull: false)
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerGroupId', includeIfNull: false)
  String? get customerGroupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  String? get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'Price', includeIfNull: false)
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'StartDateTimeUtc', includeIfNull: false)
  DateTime? get startDateTimeUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'EndDateTimeUtc', includeIfNull: false)
  DateTime? get endDateTimeUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this TierPrice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TierPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TierPriceCopyWith<TierPrice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TierPriceCopyWith<$Res> {
  factory $TierPriceCopyWith(TierPrice value, $Res Function(TierPrice) then) =
      _$TierPriceCopyWithImpl<$Res, TierPrice>;
  @useResult
  $Res call({
    @JsonKey(name: 'StoreId', includeIfNull: false) String? storeId,
    @JsonKey(name: 'CustomerGroupId', includeIfNull: false)
    String? customerGroupId,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'Price', includeIfNull: false) double? price,
    @JsonKey(name: 'StartDateTimeUtc', includeIfNull: false)
    DateTime? startDateTimeUtc,
    @JsonKey(name: 'EndDateTimeUtc', includeIfNull: false)
    DateTime? endDateTimeUtc,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
  });
}

/// @nodoc
class _$TierPriceCopyWithImpl<$Res, $Val extends TierPrice>
    implements $TierPriceCopyWith<$Res> {
  _$TierPriceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TierPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = freezed,
    Object? customerGroupId = freezed,
    Object? currencyCode = freezed,
    Object? quantity = freezed,
    Object? price = freezed,
    Object? startDateTimeUtc = freezed,
    Object? endDateTimeUtc = freezed,
    Object? id = freezed,
  }) {
    return _then(
      _value.copyWith(
            storeId:
                freezed == storeId
                    ? _value.storeId
                    : storeId // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerGroupId:
                freezed == customerGroupId
                    ? _value.customerGroupId
                    : customerGroupId // ignore: cast_nullable_to_non_nullable
                        as String?,
            currencyCode:
                freezed == currencyCode
                    ? _value.currencyCode
                    : currencyCode // ignore: cast_nullable_to_non_nullable
                        as String?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            price:
                freezed == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double?,
            startDateTimeUtc:
                freezed == startDateTimeUtc
                    ? _value.startDateTimeUtc
                    : startDateTimeUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endDateTimeUtc:
                freezed == endDateTimeUtc
                    ? _value.endDateTimeUtc
                    : endDateTimeUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TierPriceImplCopyWith<$Res>
    implements $TierPriceCopyWith<$Res> {
  factory _$$TierPriceImplCopyWith(
    _$TierPriceImpl value,
    $Res Function(_$TierPriceImpl) then,
  ) = __$$TierPriceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'StoreId', includeIfNull: false) String? storeId,
    @JsonKey(name: 'CustomerGroupId', includeIfNull: false)
    String? customerGroupId,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) String? currencyCode,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'Price', includeIfNull: false) double? price,
    @JsonKey(name: 'StartDateTimeUtc', includeIfNull: false)
    DateTime? startDateTimeUtc,
    @JsonKey(name: 'EndDateTimeUtc', includeIfNull: false)
    DateTime? endDateTimeUtc,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
  });
}

/// @nodoc
class __$$TierPriceImplCopyWithImpl<$Res>
    extends _$TierPriceCopyWithImpl<$Res, _$TierPriceImpl>
    implements _$$TierPriceImplCopyWith<$Res> {
  __$$TierPriceImplCopyWithImpl(
    _$TierPriceImpl _value,
    $Res Function(_$TierPriceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TierPrice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = freezed,
    Object? customerGroupId = freezed,
    Object? currencyCode = freezed,
    Object? quantity = freezed,
    Object? price = freezed,
    Object? startDateTimeUtc = freezed,
    Object? endDateTimeUtc = freezed,
    Object? id = freezed,
  }) {
    return _then(
      _$TierPriceImpl(
        storeId:
            freezed == storeId
                ? _value.storeId
                : storeId // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerGroupId:
            freezed == customerGroupId
                ? _value.customerGroupId
                : customerGroupId // ignore: cast_nullable_to_non_nullable
                    as String?,
        currencyCode:
            freezed == currencyCode
                ? _value.currencyCode
                : currencyCode // ignore: cast_nullable_to_non_nullable
                    as String?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        price:
            freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double?,
        startDateTimeUtc:
            freezed == startDateTimeUtc
                ? _value.startDateTimeUtc
                : startDateTimeUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endDateTimeUtc:
            freezed == endDateTimeUtc
                ? _value.endDateTimeUtc
                : endDateTimeUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TierPriceImpl implements _TierPrice {
  _$TierPriceImpl({
    @JsonKey(name: 'StoreId', includeIfNull: false) this.storeId,
    @JsonKey(name: 'CustomerGroupId', includeIfNull: false)
    this.customerGroupId,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false) this.currencyCode,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'Price', includeIfNull: false) this.price,
    @JsonKey(name: 'StartDateTimeUtc', includeIfNull: false)
    this.startDateTimeUtc = null,
    @JsonKey(name: 'EndDateTimeUtc', includeIfNull: false)
    this.endDateTimeUtc = null,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
  });

  factory _$TierPriceImpl.fromJson(Map<String, dynamic> json) =>
      _$$TierPriceImplFromJson(json);

  @override
  @JsonKey(name: 'StoreId', includeIfNull: false)
  final String? storeId;
  @override
  @JsonKey(name: 'CustomerGroupId', includeIfNull: false)
  final String? customerGroupId;
  @override
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  final String? currencyCode;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  final double? price;
  @override
  @JsonKey(name: 'StartDateTimeUtc', includeIfNull: false)
  final DateTime? startDateTimeUtc;
  @override
  @JsonKey(name: 'EndDateTimeUtc', includeIfNull: false)
  final DateTime? endDateTimeUtc;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;

  @override
  String toString() {
    return 'TierPrice(storeId: $storeId, customerGroupId: $customerGroupId, currencyCode: $currencyCode, quantity: $quantity, price: $price, startDateTimeUtc: $startDateTimeUtc, endDateTimeUtc: $endDateTimeUtc, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TierPriceImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.customerGroupId, customerGroupId) ||
                other.customerGroupId == customerGroupId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.startDateTimeUtc, startDateTimeUtc) ||
                other.startDateTimeUtc == startDateTimeUtc) &&
            (identical(other.endDateTimeUtc, endDateTimeUtc) ||
                other.endDateTimeUtc == endDateTimeUtc) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    storeId,
    customerGroupId,
    currencyCode,
    quantity,
    price,
    startDateTimeUtc,
    endDateTimeUtc,
    id,
  );

  /// Create a copy of TierPrice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TierPriceImplCopyWith<_$TierPriceImpl> get copyWith =>
      __$$TierPriceImplCopyWithImpl<_$TierPriceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TierPriceImplToJson(this);
  }
}

abstract class _TierPrice implements TierPrice {
  factory _TierPrice({
    @JsonKey(name: 'StoreId', includeIfNull: false) final String? storeId,
    @JsonKey(name: 'CustomerGroupId', includeIfNull: false)
    final String? customerGroupId,
    @JsonKey(name: 'CurrencyCode', includeIfNull: false)
    final String? currencyCode,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'Price', includeIfNull: false) final double? price,
    @JsonKey(name: 'StartDateTimeUtc', includeIfNull: false)
    final DateTime? startDateTimeUtc,
    @JsonKey(name: 'EndDateTimeUtc', includeIfNull: false)
    final DateTime? endDateTimeUtc,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
  }) = _$TierPriceImpl;

  factory _TierPrice.fromJson(Map<String, dynamic> json) =
      _$TierPriceImpl.fromJson;

  @override
  @JsonKey(name: 'StoreId', includeIfNull: false)
  String? get storeId;
  @override
  @JsonKey(name: 'CustomerGroupId', includeIfNull: false)
  String? get customerGroupId;
  @override
  @JsonKey(name: 'CurrencyCode', includeIfNull: false)
  String? get currencyCode;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  double? get price;
  @override
  @JsonKey(name: 'StartDateTimeUtc', includeIfNull: false)
  DateTime? get startDateTimeUtc;
  @override
  @JsonKey(name: 'EndDateTimeUtc', includeIfNull: false)
  DateTime? get endDateTimeUtc;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;

  /// Create a copy of TierPrice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TierPriceImplCopyWith<_$TierPriceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
