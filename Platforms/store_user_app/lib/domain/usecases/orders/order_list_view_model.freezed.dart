// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_list_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderListViewModel {
  bool get isLoading => throw _privateConstructorUsedError;
  OrderPagingModel? get pagingContext => throw _privateConstructorUsedError;
  List<OrderDetailsModel> get orders => throw _privateConstructorUsedError;
  CustomerOrderListModel? get customerOrderListModel =>
      throw _privateConstructorUsedError;

  /// Create a copy of OrderListViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderListViewModelCopyWith<OrderListViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderListViewModelCopyWith<$Res> {
  factory $OrderListViewModelCopyWith(
    OrderListViewModel value,
    $Res Function(OrderListViewModel) then,
  ) = _$OrderListViewModelCopyWithImpl<$Res, OrderListViewModel>;
  @useResult
  $Res call({
    bool isLoading,
    OrderPagingModel? pagingContext,
    List<OrderDetailsModel> orders,
    CustomerOrderListModel? customerOrderListModel,
  });

  $OrderPagingModelCopyWith<$Res>? get pagingContext;
  $CustomerOrderListModelCopyWith<$Res>? get customerOrderListModel;
}

/// @nodoc
class _$OrderListViewModelCopyWithImpl<$Res, $Val extends OrderListViewModel>
    implements $OrderListViewModelCopyWith<$Res> {
  _$OrderListViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderListViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? pagingContext = freezed,
    Object? orders = null,
    Object? customerOrderListModel = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            pagingContext:
                freezed == pagingContext
                    ? _value.pagingContext
                    : pagingContext // ignore: cast_nullable_to_non_nullable
                        as OrderPagingModel?,
            orders:
                null == orders
                    ? _value.orders
                    : orders // ignore: cast_nullable_to_non_nullable
                        as List<OrderDetailsModel>,
            customerOrderListModel:
                freezed == customerOrderListModel
                    ? _value.customerOrderListModel
                    : customerOrderListModel // ignore: cast_nullable_to_non_nullable
                        as CustomerOrderListModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderListViewModel
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

  /// Create a copy of OrderListViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerOrderListModelCopyWith<$Res>? get customerOrderListModel {
    if (_value.customerOrderListModel == null) {
      return null;
    }

    return $CustomerOrderListModelCopyWith<$Res>(
      _value.customerOrderListModel!,
      (value) {
        return _then(_value.copyWith(customerOrderListModel: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$OrderListViewModelImplCopyWith<$Res>
    implements $OrderListViewModelCopyWith<$Res> {
  factory _$$OrderListViewModelImplCopyWith(
    _$OrderListViewModelImpl value,
    $Res Function(_$OrderListViewModelImpl) then,
  ) = __$$OrderListViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    OrderPagingModel? pagingContext,
    List<OrderDetailsModel> orders,
    CustomerOrderListModel? customerOrderListModel,
  });

  @override
  $OrderPagingModelCopyWith<$Res>? get pagingContext;
  @override
  $CustomerOrderListModelCopyWith<$Res>? get customerOrderListModel;
}

/// @nodoc
class __$$OrderListViewModelImplCopyWithImpl<$Res>
    extends _$OrderListViewModelCopyWithImpl<$Res, _$OrderListViewModelImpl>
    implements _$$OrderListViewModelImplCopyWith<$Res> {
  __$$OrderListViewModelImplCopyWithImpl(
    _$OrderListViewModelImpl _value,
    $Res Function(_$OrderListViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderListViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? pagingContext = freezed,
    Object? orders = null,
    Object? customerOrderListModel = freezed,
  }) {
    return _then(
      _$OrderListViewModelImpl(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        pagingContext:
            freezed == pagingContext
                ? _value.pagingContext
                : pagingContext // ignore: cast_nullable_to_non_nullable
                    as OrderPagingModel?,
        orders:
            null == orders
                ? _value._orders
                : orders // ignore: cast_nullable_to_non_nullable
                    as List<OrderDetailsModel>,
        customerOrderListModel:
            freezed == customerOrderListModel
                ? _value.customerOrderListModel
                : customerOrderListModel // ignore: cast_nullable_to_non_nullable
                    as CustomerOrderListModel?,
      ),
    );
  }
}

/// @nodoc

class _$OrderListViewModelImpl implements _OrderListViewModel {
  const _$OrderListViewModelImpl({
    this.isLoading = true,
    this.pagingContext,
    final List<OrderDetailsModel> orders = const <OrderDetailsModel>[],
    this.customerOrderListModel,
  }) : _orders = orders;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final OrderPagingModel? pagingContext;
  final List<OrderDetailsModel> _orders;
  @override
  @JsonKey()
  List<OrderDetailsModel> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  final CustomerOrderListModel? customerOrderListModel;

  @override
  String toString() {
    return 'OrderListViewModel(isLoading: $isLoading, pagingContext: $pagingContext, orders: $orders, customerOrderListModel: $customerOrderListModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderListViewModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.pagingContext, pagingContext) ||
                other.pagingContext == pagingContext) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.customerOrderListModel, customerOrderListModel) ||
                other.customerOrderListModel == customerOrderListModel));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    pagingContext,
    const DeepCollectionEquality().hash(_orders),
    customerOrderListModel,
  );

  /// Create a copy of OrderListViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderListViewModelImplCopyWith<_$OrderListViewModelImpl> get copyWith =>
      __$$OrderListViewModelImplCopyWithImpl<_$OrderListViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _OrderListViewModel implements OrderListViewModel {
  const factory _OrderListViewModel({
    final bool isLoading,
    final OrderPagingModel? pagingContext,
    final List<OrderDetailsModel> orders,
    final CustomerOrderListModel? customerOrderListModel,
  }) = _$OrderListViewModelImpl;

  @override
  bool get isLoading;
  @override
  OrderPagingModel? get pagingContext;
  @override
  List<OrderDetailsModel> get orders;
  @override
  CustomerOrderListModel? get customerOrderListModel;

  /// Create a copy of OrderListViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderListViewModelImplCopyWith<_$OrderListViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
