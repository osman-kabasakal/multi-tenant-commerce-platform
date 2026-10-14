// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_bid_tuple.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductBidTuple _$ProductBidTupleFromJson(Map<String, dynamic> json) {
  return _ProductBidTuple.fromJson(json);
}

/// @nodoc
mixin _$ProductBidTuple {
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentBidAmount', includeIfNull: false)
  String? get currentBidAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'CurrentBidAmountValue', includeIfNull: false)
  double? get currentBidAmountValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'BidAmount', includeIfNull: false)
  String? get bidAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'BidAmountValue', includeIfNull: false)
  double? get bidAmountValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'EndBidDate', includeIfNull: false)
  DateTime? get endBidDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'Ended', includeIfNull: false)
  bool? get ended => throw _privateConstructorUsedError;
  @JsonKey(name: 'HighestBidder', includeIfNull: false)
  bool? get highestBidder => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId => throw _privateConstructorUsedError;

  /// Serializes this ProductBidTuple to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductBidTuple
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductBidTupleCopyWith<ProductBidTuple> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductBidTupleCopyWith<$Res> {
  factory $ProductBidTupleCopyWith(
    ProductBidTuple value,
    $Res Function(ProductBidTuple) then,
  ) = _$ProductBidTupleCopyWithImpl<$Res, ProductBidTuple>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'CurrentBidAmount', includeIfNull: false)
    String? currentBidAmount,
    @JsonKey(name: 'CurrentBidAmountValue', includeIfNull: false)
    double? currentBidAmountValue,
    @JsonKey(name: 'BidAmount', includeIfNull: false) String? bidAmount,
    @JsonKey(name: 'BidAmountValue', includeIfNull: false)
    double? bidAmountValue,
    @JsonKey(name: 'EndBidDate', includeIfNull: false) DateTime? endBidDate,
    @JsonKey(name: 'Ended', includeIfNull: false) bool? ended,
    @JsonKey(name: 'HighestBidder', includeIfNull: false) bool? highestBidder,
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
  });
}

/// @nodoc
class _$ProductBidTupleCopyWithImpl<$Res, $Val extends ProductBidTuple>
    implements $ProductBidTupleCopyWith<$Res> {
  _$ProductBidTupleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductBidTuple
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? currentBidAmount = freezed,
    Object? currentBidAmountValue = freezed,
    Object? bidAmount = freezed,
    Object? bidAmountValue = freezed,
    Object? endBidDate = freezed,
    Object? ended = freezed,
    Object? highestBidder = freezed,
    Object? orderId = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            currentBidAmount:
                freezed == currentBidAmount
                    ? _value.currentBidAmount
                    : currentBidAmount // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentBidAmountValue:
                freezed == currentBidAmountValue
                    ? _value.currentBidAmountValue
                    : currentBidAmountValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            bidAmount:
                freezed == bidAmount
                    ? _value.bidAmount
                    : bidAmount // ignore: cast_nullable_to_non_nullable
                        as String?,
            bidAmountValue:
                freezed == bidAmountValue
                    ? _value.bidAmountValue
                    : bidAmountValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            endBidDate:
                freezed == endBidDate
                    ? _value.endBidDate
                    : endBidDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            ended:
                freezed == ended
                    ? _value.ended
                    : ended // ignore: cast_nullable_to_non_nullable
                        as bool?,
            highestBidder:
                freezed == highestBidder
                    ? _value.highestBidder
                    : highestBidder // ignore: cast_nullable_to_non_nullable
                        as bool?,
            orderId:
                freezed == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductBidTupleImplCopyWith<$Res>
    implements $ProductBidTupleCopyWith<$Res> {
  factory _$$ProductBidTupleImplCopyWith(
    _$ProductBidTupleImpl value,
    $Res Function(_$ProductBidTupleImpl) then,
  ) = __$$ProductBidTupleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'CurrentBidAmount', includeIfNull: false)
    String? currentBidAmount,
    @JsonKey(name: 'CurrentBidAmountValue', includeIfNull: false)
    double? currentBidAmountValue,
    @JsonKey(name: 'BidAmount', includeIfNull: false) String? bidAmount,
    @JsonKey(name: 'BidAmountValue', includeIfNull: false)
    double? bidAmountValue,
    @JsonKey(name: 'EndBidDate', includeIfNull: false) DateTime? endBidDate,
    @JsonKey(name: 'Ended', includeIfNull: false) bool? ended,
    @JsonKey(name: 'HighestBidder', includeIfNull: false) bool? highestBidder,
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
  });
}

/// @nodoc
class __$$ProductBidTupleImplCopyWithImpl<$Res>
    extends _$ProductBidTupleCopyWithImpl<$Res, _$ProductBidTupleImpl>
    implements _$$ProductBidTupleImplCopyWith<$Res> {
  __$$ProductBidTupleImplCopyWithImpl(
    _$ProductBidTupleImpl _value,
    $Res Function(_$ProductBidTupleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductBidTuple
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? currentBidAmount = freezed,
    Object? currentBidAmountValue = freezed,
    Object? bidAmount = freezed,
    Object? bidAmountValue = freezed,
    Object? endBidDate = freezed,
    Object? ended = freezed,
    Object? highestBidder = freezed,
    Object? orderId = freezed,
  }) {
    return _then(
      _$ProductBidTupleImpl(
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
        currentBidAmount:
            freezed == currentBidAmount
                ? _value.currentBidAmount
                : currentBidAmount // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentBidAmountValue:
            freezed == currentBidAmountValue
                ? _value.currentBidAmountValue
                : currentBidAmountValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        bidAmount:
            freezed == bidAmount
                ? _value.bidAmount
                : bidAmount // ignore: cast_nullable_to_non_nullable
                    as String?,
        bidAmountValue:
            freezed == bidAmountValue
                ? _value.bidAmountValue
                : bidAmountValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        endBidDate:
            freezed == endBidDate
                ? _value.endBidDate
                : endBidDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        ended:
            freezed == ended
                ? _value.ended
                : ended // ignore: cast_nullable_to_non_nullable
                    as bool?,
        highestBidder:
            freezed == highestBidder
                ? _value.highestBidder
                : highestBidder // ignore: cast_nullable_to_non_nullable
                    as bool?,
        orderId:
            freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductBidTupleImpl implements _ProductBidTuple {
  _$ProductBidTupleImpl({
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'CurrentBidAmount', includeIfNull: false)
    this.currentBidAmount,
    @JsonKey(name: 'CurrentBidAmountValue', includeIfNull: false)
    this.currentBidAmountValue,
    @JsonKey(name: 'BidAmount', includeIfNull: false) this.bidAmount,
    @JsonKey(name: 'BidAmountValue', includeIfNull: false) this.bidAmountValue,
    @JsonKey(name: 'EndBidDate', includeIfNull: false) this.endBidDate,
    @JsonKey(name: 'Ended', includeIfNull: false) this.ended = false,
    @JsonKey(name: 'HighestBidder', includeIfNull: false)
    this.highestBidder = false,
    @JsonKey(name: 'OrderId', includeIfNull: false) this.orderId,
  });

  factory _$ProductBidTupleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductBidTupleImplFromJson(json);

  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  final String? productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  final String? productSeName;
  @override
  @JsonKey(name: 'CurrentBidAmount', includeIfNull: false)
  final String? currentBidAmount;
  @override
  @JsonKey(name: 'CurrentBidAmountValue', includeIfNull: false)
  final double? currentBidAmountValue;
  @override
  @JsonKey(name: 'BidAmount', includeIfNull: false)
  final String? bidAmount;
  @override
  @JsonKey(name: 'BidAmountValue', includeIfNull: false)
  final double? bidAmountValue;
  @override
  @JsonKey(name: 'EndBidDate', includeIfNull: false)
  final DateTime? endBidDate;
  @override
  @JsonKey(name: 'Ended', includeIfNull: false)
  final bool? ended;
  @override
  @JsonKey(name: 'HighestBidder', includeIfNull: false)
  final bool? highestBidder;
  @override
  @JsonKey(name: 'OrderId', includeIfNull: false)
  final String? orderId;

  @override
  String toString() {
    return 'ProductBidTuple(productName: $productName, productSeName: $productSeName, currentBidAmount: $currentBidAmount, currentBidAmountValue: $currentBidAmountValue, bidAmount: $bidAmount, bidAmountValue: $bidAmountValue, endBidDate: $endBidDate, ended: $ended, highestBidder: $highestBidder, orderId: $orderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductBidTupleImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            (identical(other.currentBidAmount, currentBidAmount) ||
                other.currentBidAmount == currentBidAmount) &&
            (identical(other.currentBidAmountValue, currentBidAmountValue) ||
                other.currentBidAmountValue == currentBidAmountValue) &&
            (identical(other.bidAmount, bidAmount) ||
                other.bidAmount == bidAmount) &&
            (identical(other.bidAmountValue, bidAmountValue) ||
                other.bidAmountValue == bidAmountValue) &&
            (identical(other.endBidDate, endBidDate) ||
                other.endBidDate == endBidDate) &&
            (identical(other.ended, ended) || other.ended == ended) &&
            (identical(other.highestBidder, highestBidder) ||
                other.highestBidder == highestBidder) &&
            (identical(other.orderId, orderId) || other.orderId == orderId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productName,
    productSeName,
    currentBidAmount,
    currentBidAmountValue,
    bidAmount,
    bidAmountValue,
    endBidDate,
    ended,
    highestBidder,
    orderId,
  );

  /// Create a copy of ProductBidTuple
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductBidTupleImplCopyWith<_$ProductBidTupleImpl> get copyWith =>
      __$$ProductBidTupleImplCopyWithImpl<_$ProductBidTupleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductBidTupleImplToJson(this);
  }
}

abstract class _ProductBidTuple implements ProductBidTuple {
  factory _ProductBidTuple({
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'CurrentBidAmount', includeIfNull: false)
    final String? currentBidAmount,
    @JsonKey(name: 'CurrentBidAmountValue', includeIfNull: false)
    final double? currentBidAmountValue,
    @JsonKey(name: 'BidAmount', includeIfNull: false) final String? bidAmount,
    @JsonKey(name: 'BidAmountValue', includeIfNull: false)
    final double? bidAmountValue,
    @JsonKey(name: 'EndBidDate', includeIfNull: false)
    final DateTime? endBidDate,
    @JsonKey(name: 'Ended', includeIfNull: false) final bool? ended,
    @JsonKey(name: 'HighestBidder', includeIfNull: false)
    final bool? highestBidder,
    @JsonKey(name: 'OrderId', includeIfNull: false) final String? orderId,
  }) = _$ProductBidTupleImpl;

  factory _ProductBidTuple.fromJson(Map<String, dynamic> json) =
      _$ProductBidTupleImpl.fromJson;

  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName;
  @override
  @JsonKey(name: 'CurrentBidAmount', includeIfNull: false)
  String? get currentBidAmount;
  @override
  @JsonKey(name: 'CurrentBidAmountValue', includeIfNull: false)
  double? get currentBidAmountValue;
  @override
  @JsonKey(name: 'BidAmount', includeIfNull: false)
  String? get bidAmount;
  @override
  @JsonKey(name: 'BidAmountValue', includeIfNull: false)
  double? get bidAmountValue;
  @override
  @JsonKey(name: 'EndBidDate', includeIfNull: false)
  DateTime? get endBidDate;
  @override
  @JsonKey(name: 'Ended', includeIfNull: false)
  bool? get ended;
  @override
  @JsonKey(name: 'HighestBidder', includeIfNull: false)
  bool? get highestBidder;
  @override
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId;

  /// Create a copy of ProductBidTuple
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductBidTupleImplCopyWith<_$ProductBidTupleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
