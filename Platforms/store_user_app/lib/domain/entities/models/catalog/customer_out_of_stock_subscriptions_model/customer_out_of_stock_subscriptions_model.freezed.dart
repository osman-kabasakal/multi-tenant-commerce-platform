// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_out_of_stock_subscriptions_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerOutOfStockSubscriptionsModel
_$CustomerOutOfStockSubscriptionsModelFromJson(Map<String, dynamic> json) {
  return _CustomerOutOfStockSubscriptionsModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerOutOfStockSubscriptionsModel {
  @JsonKey(name: 'Subscriptions', includeIfNull: false)
  List<OutOfStockSubscriptionModel>? get subscriptions =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'PagerModel', includeIfNull: false)
  PagerModel? get pagerModel => throw _privateConstructorUsedError;

  /// Serializes this CustomerOutOfStockSubscriptionsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerOutOfStockSubscriptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerOutOfStockSubscriptionsModelCopyWith<
    CustomerOutOfStockSubscriptionsModel
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerOutOfStockSubscriptionsModelCopyWith<$Res> {
  factory $CustomerOutOfStockSubscriptionsModelCopyWith(
    CustomerOutOfStockSubscriptionsModel value,
    $Res Function(CustomerOutOfStockSubscriptionsModel) then,
  ) =
      _$CustomerOutOfStockSubscriptionsModelCopyWithImpl<
        $Res,
        CustomerOutOfStockSubscriptionsModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'Subscriptions', includeIfNull: false)
    List<OutOfStockSubscriptionModel>? subscriptions,
    @JsonKey(name: 'PagerModel', includeIfNull: false) PagerModel? pagerModel,
  });

  $PagerModelCopyWith<$Res>? get pagerModel;
}

/// @nodoc
class _$CustomerOutOfStockSubscriptionsModelCopyWithImpl<
  $Res,
  $Val extends CustomerOutOfStockSubscriptionsModel
>
    implements $CustomerOutOfStockSubscriptionsModelCopyWith<$Res> {
  _$CustomerOutOfStockSubscriptionsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerOutOfStockSubscriptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? subscriptions = freezed, Object? pagerModel = freezed}) {
    return _then(
      _value.copyWith(
            subscriptions:
                freezed == subscriptions
                    ? _value.subscriptions
                    : subscriptions // ignore: cast_nullable_to_non_nullable
                        as List<OutOfStockSubscriptionModel>?,
            pagerModel:
                freezed == pagerModel
                    ? _value.pagerModel
                    : pagerModel // ignore: cast_nullable_to_non_nullable
                        as PagerModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of CustomerOutOfStockSubscriptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PagerModelCopyWith<$Res>? get pagerModel {
    if (_value.pagerModel == null) {
      return null;
    }

    return $PagerModelCopyWith<$Res>(_value.pagerModel!, (value) {
      return _then(_value.copyWith(pagerModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CustomerOutOfStockSubscriptionsModelImplCopyWith<$Res>
    implements $CustomerOutOfStockSubscriptionsModelCopyWith<$Res> {
  factory _$$CustomerOutOfStockSubscriptionsModelImplCopyWith(
    _$CustomerOutOfStockSubscriptionsModelImpl value,
    $Res Function(_$CustomerOutOfStockSubscriptionsModelImpl) then,
  ) = __$$CustomerOutOfStockSubscriptionsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Subscriptions', includeIfNull: false)
    List<OutOfStockSubscriptionModel>? subscriptions,
    @JsonKey(name: 'PagerModel', includeIfNull: false) PagerModel? pagerModel,
  });

  @override
  $PagerModelCopyWith<$Res>? get pagerModel;
}

/// @nodoc
class __$$CustomerOutOfStockSubscriptionsModelImplCopyWithImpl<$Res>
    extends
        _$CustomerOutOfStockSubscriptionsModelCopyWithImpl<
          $Res,
          _$CustomerOutOfStockSubscriptionsModelImpl
        >
    implements _$$CustomerOutOfStockSubscriptionsModelImplCopyWith<$Res> {
  __$$CustomerOutOfStockSubscriptionsModelImplCopyWithImpl(
    _$CustomerOutOfStockSubscriptionsModelImpl _value,
    $Res Function(_$CustomerOutOfStockSubscriptionsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerOutOfStockSubscriptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? subscriptions = freezed, Object? pagerModel = freezed}) {
    return _then(
      _$CustomerOutOfStockSubscriptionsModelImpl(
        subscriptions:
            freezed == subscriptions
                ? _value._subscriptions
                : subscriptions // ignore: cast_nullable_to_non_nullable
                    as List<OutOfStockSubscriptionModel>?,
        pagerModel:
            freezed == pagerModel
                ? _value.pagerModel
                : pagerModel // ignore: cast_nullable_to_non_nullable
                    as PagerModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerOutOfStockSubscriptionsModelImpl
    implements _CustomerOutOfStockSubscriptionsModel {
  _$CustomerOutOfStockSubscriptionsModelImpl({
    @JsonKey(name: 'Subscriptions', includeIfNull: false)
    final List<OutOfStockSubscriptionModel>? subscriptions = const [],
    @JsonKey(name: 'PagerModel', includeIfNull: false) this.pagerModel,
  }) : _subscriptions = subscriptions;

  factory _$CustomerOutOfStockSubscriptionsModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CustomerOutOfStockSubscriptionsModelImplFromJson(json);

  final List<OutOfStockSubscriptionModel>? _subscriptions;
  @override
  @JsonKey(name: 'Subscriptions', includeIfNull: false)
  List<OutOfStockSubscriptionModel>? get subscriptions {
    final value = _subscriptions;
    if (value == null) return null;
    if (_subscriptions is EqualUnmodifiableListView) return _subscriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'PagerModel', includeIfNull: false)
  final PagerModel? pagerModel;

  @override
  String toString() {
    return 'CustomerOutOfStockSubscriptionsModel(subscriptions: $subscriptions, pagerModel: $pagerModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerOutOfStockSubscriptionsModelImpl &&
            const DeepCollectionEquality().equals(
              other._subscriptions,
              _subscriptions,
            ) &&
            (identical(other.pagerModel, pagerModel) ||
                other.pagerModel == pagerModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_subscriptions),
    pagerModel,
  );

  /// Create a copy of CustomerOutOfStockSubscriptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerOutOfStockSubscriptionsModelImplCopyWith<
    _$CustomerOutOfStockSubscriptionsModelImpl
  >
  get copyWith => __$$CustomerOutOfStockSubscriptionsModelImplCopyWithImpl<
    _$CustomerOutOfStockSubscriptionsModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerOutOfStockSubscriptionsModelImplToJson(this);
  }
}

abstract class _CustomerOutOfStockSubscriptionsModel
    implements CustomerOutOfStockSubscriptionsModel {
  factory _CustomerOutOfStockSubscriptionsModel({
    @JsonKey(name: 'Subscriptions', includeIfNull: false)
    final List<OutOfStockSubscriptionModel>? subscriptions,
    @JsonKey(name: 'PagerModel', includeIfNull: false)
    final PagerModel? pagerModel,
  }) = _$CustomerOutOfStockSubscriptionsModelImpl;

  factory _CustomerOutOfStockSubscriptionsModel.fromJson(
    Map<String, dynamic> json,
  ) = _$CustomerOutOfStockSubscriptionsModelImpl.fromJson;

  @override
  @JsonKey(name: 'Subscriptions', includeIfNull: false)
  List<OutOfStockSubscriptionModel>? get subscriptions;
  @override
  @JsonKey(name: 'PagerModel', includeIfNull: false)
  PagerModel? get pagerModel;

  /// Create a copy of CustomerOutOfStockSubscriptionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerOutOfStockSubscriptionsModelImplCopyWith<
    _$CustomerOutOfStockSubscriptionsModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
