// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_order_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerOrderListModel _$CustomerOrderListModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerOrderListModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerOrderListModel {
  @JsonKey(name: 'PagingContext', includeIfNull: false)
  OrderPagingModel? get pagingContext => throw _privateConstructorUsedError;
  @JsonKey(name: 'Orders', includeIfNull: false)
  List<OrderDetailsModel>? get orders => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerOrderListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerOrderListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerOrderListModelCopyWith<CustomerOrderListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerOrderListModelCopyWith<$Res> {
  factory $CustomerOrderListModelCopyWith(
    CustomerOrderListModel value,
    $Res Function(CustomerOrderListModel) then,
  ) = _$CustomerOrderListModelCopyWithImpl<$Res, CustomerOrderListModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'PagingContext', includeIfNull: false)
    OrderPagingModel? pagingContext,
    @JsonKey(name: 'Orders', includeIfNull: false)
    List<OrderDetailsModel>? orders,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $OrderPagingModelCopyWith<$Res>? get pagingContext;
}

/// @nodoc
class _$CustomerOrderListModelCopyWithImpl<
  $Res,
  $Val extends CustomerOrderListModel
>
    implements $CustomerOrderListModelCopyWith<$Res> {
  _$CustomerOrderListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerOrderListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagingContext = freezed,
    Object? orders = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            pagingContext:
                freezed == pagingContext
                    ? _value.pagingContext
                    : pagingContext // ignore: cast_nullable_to_non_nullable
                        as OrderPagingModel?,
            orders:
                freezed == orders
                    ? _value.orders
                    : orders // ignore: cast_nullable_to_non_nullable
                        as List<OrderDetailsModel>?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of CustomerOrderListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderPagingModelCopyWith<$Res>? get pagingContext {
    if (_value.pagingContext == null) {
      return null;
    }

    return $OrderPagingModelCopyWith<$Res>(_value.pagingContext!, (value) {
      return _then(_value.copyWith(pagingContext: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CustomerOrderListModelImplCopyWith<$Res>
    implements $CustomerOrderListModelCopyWith<$Res> {
  factory _$$CustomerOrderListModelImplCopyWith(
    _$CustomerOrderListModelImpl value,
    $Res Function(_$CustomerOrderListModelImpl) then,
  ) = __$$CustomerOrderListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PagingContext', includeIfNull: false)
    OrderPagingModel? pagingContext,
    @JsonKey(name: 'Orders', includeIfNull: false)
    List<OrderDetailsModel>? orders,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $OrderPagingModelCopyWith<$Res>? get pagingContext;
}

/// @nodoc
class __$$CustomerOrderListModelImplCopyWithImpl<$Res>
    extends
        _$CustomerOrderListModelCopyWithImpl<$Res, _$CustomerOrderListModelImpl>
    implements _$$CustomerOrderListModelImplCopyWith<$Res> {
  __$$CustomerOrderListModelImplCopyWithImpl(
    _$CustomerOrderListModelImpl _value,
    $Res Function(_$CustomerOrderListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerOrderListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagingContext = freezed,
    Object? orders = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CustomerOrderListModelImpl(
        pagingContext:
            freezed == pagingContext
                ? _value.pagingContext
                : pagingContext // ignore: cast_nullable_to_non_nullable
                    as OrderPagingModel?,
        orders:
            freezed == orders
                ? _value._orders
                : orders // ignore: cast_nullable_to_non_nullable
                    as List<OrderDetailsModel>?,
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
class _$CustomerOrderListModelImpl implements _CustomerOrderListModel {
  _$CustomerOrderListModelImpl({
    @JsonKey(name: 'PagingContext', includeIfNull: false) this.pagingContext,
    @JsonKey(name: 'Orders', includeIfNull: false)
    final List<OrderDetailsModel>? orders = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _orders = orders,
       _userFields = userFields;

  factory _$CustomerOrderListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerOrderListModelImplFromJson(json);

  @override
  @JsonKey(name: 'PagingContext', includeIfNull: false)
  final OrderPagingModel? pagingContext;
  final List<OrderDetailsModel>? _orders;
  @override
  @JsonKey(name: 'Orders', includeIfNull: false)
  List<OrderDetailsModel>? get orders {
    final value = _orders;
    if (value == null) return null;
    if (_orders is EqualUnmodifiableListView) return _orders;
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
    return 'CustomerOrderListModel(pagingContext: $pagingContext, orders: $orders, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerOrderListModelImpl &&
            (identical(other.pagingContext, pagingContext) ||
                other.pagingContext == pagingContext) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pagingContext,
    const DeepCollectionEquality().hash(_orders),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CustomerOrderListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerOrderListModelImplCopyWith<_$CustomerOrderListModelImpl>
  get copyWith =>
      __$$CustomerOrderListModelImplCopyWithImpl<_$CustomerOrderListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerOrderListModelImplToJson(this);
  }
}

abstract class _CustomerOrderListModel implements CustomerOrderListModel {
  factory _CustomerOrderListModel({
    @JsonKey(name: 'PagingContext', includeIfNull: false)
    final OrderPagingModel? pagingContext,
    @JsonKey(name: 'Orders', includeIfNull: false)
    final List<OrderDetailsModel>? orders,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerOrderListModelImpl;

  factory _CustomerOrderListModel.fromJson(Map<String, dynamic> json) =
      _$CustomerOrderListModelImpl.fromJson;

  @override
  @JsonKey(name: 'PagingContext', includeIfNull: false)
  OrderPagingModel? get pagingContext;
  @override
  @JsonKey(name: 'Orders', includeIfNull: false)
  List<OrderDetailsModel>? get orders;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerOrderListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerOrderListModelImplCopyWith<_$CustomerOrderListModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
