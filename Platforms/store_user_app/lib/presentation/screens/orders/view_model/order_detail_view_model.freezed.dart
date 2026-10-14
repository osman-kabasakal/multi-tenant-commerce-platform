// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_detail_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OrderDetailViewModel {
  bool get isLoading => throw _privateConstructorUsedError;
  OrderDetailsModel? get orderDetailsModel =>
      throw _privateConstructorUsedError;

  /// Create a copy of OrderDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDetailViewModelCopyWith<OrderDetailViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDetailViewModelCopyWith<$Res> {
  factory $OrderDetailViewModelCopyWith(
    OrderDetailViewModel value,
    $Res Function(OrderDetailViewModel) then,
  ) = _$OrderDetailViewModelCopyWithImpl<$Res, OrderDetailViewModel>;
  @useResult
  $Res call({bool isLoading, OrderDetailsModel? orderDetailsModel});

  $OrderDetailsModelCopyWith<$Res>? get orderDetailsModel;
}

/// @nodoc
class _$OrderDetailViewModelCopyWithImpl<
  $Res,
  $Val extends OrderDetailViewModel
>
    implements $OrderDetailViewModelCopyWith<$Res> {
  _$OrderDetailViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? orderDetailsModel = freezed}) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            orderDetailsModel:
                freezed == orderDetailsModel
                    ? _value.orderDetailsModel
                    : orderDetailsModel // ignore: cast_nullable_to_non_nullable
                        as OrderDetailsModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderDetailsModelCopyWith<$Res>? get orderDetailsModel {
    if (_value.orderDetailsModel == null) {
      return null;
    }

    return $OrderDetailsModelCopyWith<$Res>(_value.orderDetailsModel!, (value) {
      return _then(_value.copyWith(orderDetailsModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderDetailViewModelImplCopyWith<$Res>
    implements $OrderDetailViewModelCopyWith<$Res> {
  factory _$$OrderDetailViewModelImplCopyWith(
    _$OrderDetailViewModelImpl value,
    $Res Function(_$OrderDetailViewModelImpl) then,
  ) = __$$OrderDetailViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, OrderDetailsModel? orderDetailsModel});

  @override
  $OrderDetailsModelCopyWith<$Res>? get orderDetailsModel;
}

/// @nodoc
class __$$OrderDetailViewModelImplCopyWithImpl<$Res>
    extends _$OrderDetailViewModelCopyWithImpl<$Res, _$OrderDetailViewModelImpl>
    implements _$$OrderDetailViewModelImplCopyWith<$Res> {
  __$$OrderDetailViewModelImplCopyWithImpl(
    _$OrderDetailViewModelImpl _value,
    $Res Function(_$OrderDetailViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? orderDetailsModel = freezed}) {
    return _then(
      _$OrderDetailViewModelImpl(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        orderDetailsModel:
            freezed == orderDetailsModel
                ? _value.orderDetailsModel
                : orderDetailsModel // ignore: cast_nullable_to_non_nullable
                    as OrderDetailsModel?,
      ),
    );
  }
}

/// @nodoc

class _$OrderDetailViewModelImpl implements _OrderDetailViewModel {
  const _$OrderDetailViewModelImpl({
    this.isLoading = true,
    this.orderDetailsModel,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final OrderDetailsModel? orderDetailsModel;

  @override
  String toString() {
    return 'OrderDetailViewModel(isLoading: $isLoading, orderDetailsModel: $orderDetailsModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDetailViewModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.orderDetailsModel, orderDetailsModel) ||
                other.orderDetailsModel == orderDetailsModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, orderDetailsModel);

  /// Create a copy of OrderDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDetailViewModelImplCopyWith<_$OrderDetailViewModelImpl>
  get copyWith =>
      __$$OrderDetailViewModelImplCopyWithImpl<_$OrderDetailViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _OrderDetailViewModel implements OrderDetailViewModel {
  const factory _OrderDetailViewModel({
    final bool isLoading,
    final OrderDetailsModel? orderDetailsModel,
  }) = _$OrderDetailViewModelImpl;

  @override
  bool get isLoading;
  @override
  OrderDetailsModel? get orderDetailsModel;

  /// Create a copy of OrderDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDetailViewModelImplCopyWith<_$OrderDetailViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
