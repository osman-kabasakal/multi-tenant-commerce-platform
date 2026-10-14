// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipment_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShipmentDetailsModel _$ShipmentDetailsModelFromJson(Map<String, dynamic> json) {
  return _ShipmentDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$ShipmentDetailsModel {
  @JsonKey(name: 'ShipmentNumber', includeIfNull: false)
  int? get shipmentNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'TrackingNumber', includeIfNull: false)
  String? get trackingNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'TrackingNumberUrl', includeIfNull: false)
  String? get trackingNumberUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippedDate', includeIfNull: false)
  DateTime? get shippedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'DeliveryDate', includeIfNull: false)
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShipmentStatusEvents', includeIfNull: false)
  List<ShipmentStatusEventModel>? get shipmentStatusEvents =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  bool? get showSku => throw _privateConstructorUsedError;
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShipmentItemModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShipmentNotes', includeIfNull: false)
  List<ShipmentNote>? get shipmentNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'Order', includeIfNull: false)
  OrderModel? get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ShipmentDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentDetailsModelCopyWith<ShipmentDetailsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentDetailsModelCopyWith<$Res> {
  factory $ShipmentDetailsModelCopyWith(
    ShipmentDetailsModel value,
    $Res Function(ShipmentDetailsModel) then,
  ) = _$ShipmentDetailsModelCopyWithImpl<$Res, ShipmentDetailsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ShipmentNumber', includeIfNull: false) int? shipmentNumber,
    @JsonKey(name: 'TrackingNumber', includeIfNull: false)
    String? trackingNumber,
    @JsonKey(name: 'TrackingNumberUrl', includeIfNull: false)
    String? trackingNumberUrl,
    @JsonKey(name: 'ShippedDate', includeIfNull: false) DateTime? shippedDate,
    @JsonKey(name: 'DeliveryDate', includeIfNull: false) DateTime? deliveryDate,
    @JsonKey(name: 'ShipmentStatusEvents', includeIfNull: false)
    List<ShipmentStatusEventModel>? shipmentStatusEvents,
    @JsonKey(name: 'ShowSku', includeIfNull: false) bool? showSku,
    @JsonKey(name: 'Items', includeIfNull: false)
    List<ShipmentItemModel>? items,
    @JsonKey(name: 'ShipmentNotes', includeIfNull: false)
    List<ShipmentNote>? shipmentNotes,
    @JsonKey(name: 'Order', includeIfNull: false) OrderModel? order,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $OrderModelCopyWith<$Res>? get order;
}

/// @nodoc
class _$ShipmentDetailsModelCopyWithImpl<
  $Res,
  $Val extends ShipmentDetailsModel
>
    implements $ShipmentDetailsModelCopyWith<$Res> {
  _$ShipmentDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipmentNumber = freezed,
    Object? trackingNumber = freezed,
    Object? trackingNumberUrl = freezed,
    Object? shippedDate = freezed,
    Object? deliveryDate = freezed,
    Object? shipmentStatusEvents = freezed,
    Object? showSku = freezed,
    Object? items = freezed,
    Object? shipmentNotes = freezed,
    Object? order = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            shipmentNumber:
                freezed == shipmentNumber
                    ? _value.shipmentNumber
                    : shipmentNumber // ignore: cast_nullable_to_non_nullable
                        as int?,
            trackingNumber:
                freezed == trackingNumber
                    ? _value.trackingNumber
                    : trackingNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            trackingNumberUrl:
                freezed == trackingNumberUrl
                    ? _value.trackingNumberUrl
                    : trackingNumberUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            shippedDate:
                freezed == shippedDate
                    ? _value.shippedDate
                    : shippedDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            deliveryDate:
                freezed == deliveryDate
                    ? _value.deliveryDate
                    : deliveryDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            shipmentStatusEvents:
                freezed == shipmentStatusEvents
                    ? _value.shipmentStatusEvents
                    : shipmentStatusEvents // ignore: cast_nullable_to_non_nullable
                        as List<ShipmentStatusEventModel>?,
            showSku:
                freezed == showSku
                    ? _value.showSku
                    : showSku // ignore: cast_nullable_to_non_nullable
                        as bool?,
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<ShipmentItemModel>?,
            shipmentNotes:
                freezed == shipmentNotes
                    ? _value.shipmentNotes
                    : shipmentNotes // ignore: cast_nullable_to_non_nullable
                        as List<ShipmentNote>?,
            order:
                freezed == order
                    ? _value.order
                    : order // ignore: cast_nullable_to_non_nullable
                        as OrderModel?,
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

  /// Create a copy of ShipmentDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderModelCopyWith<$Res>? get order {
    if (_value.order == null) {
      return null;
    }

    return $OrderModelCopyWith<$Res>(_value.order!, (value) {
      return _then(_value.copyWith(order: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShipmentDetailsModelImplCopyWith<$Res>
    implements $ShipmentDetailsModelCopyWith<$Res> {
  factory _$$ShipmentDetailsModelImplCopyWith(
    _$ShipmentDetailsModelImpl value,
    $Res Function(_$ShipmentDetailsModelImpl) then,
  ) = __$$ShipmentDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ShipmentNumber', includeIfNull: false) int? shipmentNumber,
    @JsonKey(name: 'TrackingNumber', includeIfNull: false)
    String? trackingNumber,
    @JsonKey(name: 'TrackingNumberUrl', includeIfNull: false)
    String? trackingNumberUrl,
    @JsonKey(name: 'ShippedDate', includeIfNull: false) DateTime? shippedDate,
    @JsonKey(name: 'DeliveryDate', includeIfNull: false) DateTime? deliveryDate,
    @JsonKey(name: 'ShipmentStatusEvents', includeIfNull: false)
    List<ShipmentStatusEventModel>? shipmentStatusEvents,
    @JsonKey(name: 'ShowSku', includeIfNull: false) bool? showSku,
    @JsonKey(name: 'Items', includeIfNull: false)
    List<ShipmentItemModel>? items,
    @JsonKey(name: 'ShipmentNotes', includeIfNull: false)
    List<ShipmentNote>? shipmentNotes,
    @JsonKey(name: 'Order', includeIfNull: false) OrderModel? order,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $OrderModelCopyWith<$Res>? get order;
}

/// @nodoc
class __$$ShipmentDetailsModelImplCopyWithImpl<$Res>
    extends _$ShipmentDetailsModelCopyWithImpl<$Res, _$ShipmentDetailsModelImpl>
    implements _$$ShipmentDetailsModelImplCopyWith<$Res> {
  __$$ShipmentDetailsModelImplCopyWithImpl(
    _$ShipmentDetailsModelImpl _value,
    $Res Function(_$ShipmentDetailsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShipmentDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shipmentNumber = freezed,
    Object? trackingNumber = freezed,
    Object? trackingNumberUrl = freezed,
    Object? shippedDate = freezed,
    Object? deliveryDate = freezed,
    Object? shipmentStatusEvents = freezed,
    Object? showSku = freezed,
    Object? items = freezed,
    Object? shipmentNotes = freezed,
    Object? order = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ShipmentDetailsModelImpl(
        shipmentNumber:
            freezed == shipmentNumber
                ? _value.shipmentNumber
                : shipmentNumber // ignore: cast_nullable_to_non_nullable
                    as int?,
        trackingNumber:
            freezed == trackingNumber
                ? _value.trackingNumber
                : trackingNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        trackingNumberUrl:
            freezed == trackingNumberUrl
                ? _value.trackingNumberUrl
                : trackingNumberUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        shippedDate:
            freezed == shippedDate
                ? _value.shippedDate
                : shippedDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        deliveryDate:
            freezed == deliveryDate
                ? _value.deliveryDate
                : deliveryDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        shipmentStatusEvents:
            freezed == shipmentStatusEvents
                ? _value._shipmentStatusEvents
                : shipmentStatusEvents // ignore: cast_nullable_to_non_nullable
                    as List<ShipmentStatusEventModel>?,
        showSku:
            freezed == showSku
                ? _value.showSku
                : showSku // ignore: cast_nullable_to_non_nullable
                    as bool?,
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<ShipmentItemModel>?,
        shipmentNotes:
            freezed == shipmentNotes
                ? _value._shipmentNotes
                : shipmentNotes // ignore: cast_nullable_to_non_nullable
                    as List<ShipmentNote>?,
        order:
            freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                    as OrderModel?,
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
class _$ShipmentDetailsModelImpl implements _ShipmentDetailsModel {
  _$ShipmentDetailsModelImpl({
    @JsonKey(name: 'ShipmentNumber', includeIfNull: false) this.shipmentNumber,
    @JsonKey(name: 'TrackingNumber', includeIfNull: false) this.trackingNumber,
    @JsonKey(name: 'TrackingNumberUrl', includeIfNull: false)
    this.trackingNumberUrl,
    @JsonKey(name: 'ShippedDate', includeIfNull: false) this.shippedDate = null,
    @JsonKey(name: 'DeliveryDate', includeIfNull: false)
    this.deliveryDate = null,
    @JsonKey(name: 'ShipmentStatusEvents', includeIfNull: false)
    final List<ShipmentStatusEventModel>? shipmentStatusEvents = const [],
    @JsonKey(name: 'ShowSku', includeIfNull: false) this.showSku = false,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<ShipmentItemModel>? items = const [],
    @JsonKey(name: 'ShipmentNotes', includeIfNull: false)
    final List<ShipmentNote>? shipmentNotes = const [],
    @JsonKey(name: 'Order', includeIfNull: false) this.order,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _shipmentStatusEvents = shipmentStatusEvents,
       _items = items,
       _shipmentNotes = shipmentNotes,
       _userFields = userFields;

  factory _$ShipmentDetailsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentDetailsModelImplFromJson(json);

  @override
  @JsonKey(name: 'ShipmentNumber', includeIfNull: false)
  final int? shipmentNumber;
  @override
  @JsonKey(name: 'TrackingNumber', includeIfNull: false)
  final String? trackingNumber;
  @override
  @JsonKey(name: 'TrackingNumberUrl', includeIfNull: false)
  final String? trackingNumberUrl;
  @override
  @JsonKey(name: 'ShippedDate', includeIfNull: false)
  final DateTime? shippedDate;
  @override
  @JsonKey(name: 'DeliveryDate', includeIfNull: false)
  final DateTime? deliveryDate;
  final List<ShipmentStatusEventModel>? _shipmentStatusEvents;
  @override
  @JsonKey(name: 'ShipmentStatusEvents', includeIfNull: false)
  List<ShipmentStatusEventModel>? get shipmentStatusEvents {
    final value = _shipmentStatusEvents;
    if (value == null) return null;
    if (_shipmentStatusEvents is EqualUnmodifiableListView)
      return _shipmentStatusEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  final bool? showSku;
  final List<ShipmentItemModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShipmentItemModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ShipmentNote>? _shipmentNotes;
  @override
  @JsonKey(name: 'ShipmentNotes', includeIfNull: false)
  List<ShipmentNote>? get shipmentNotes {
    final value = _shipmentNotes;
    if (value == null) return null;
    if (_shipmentNotes is EqualUnmodifiableListView) return _shipmentNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'Order', includeIfNull: false)
  final OrderModel? order;
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
    return 'ShipmentDetailsModel(shipmentNumber: $shipmentNumber, trackingNumber: $trackingNumber, trackingNumberUrl: $trackingNumberUrl, shippedDate: $shippedDate, deliveryDate: $deliveryDate, shipmentStatusEvents: $shipmentStatusEvents, showSku: $showSku, items: $items, shipmentNotes: $shipmentNotes, order: $order, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentDetailsModelImpl &&
            (identical(other.shipmentNumber, shipmentNumber) ||
                other.shipmentNumber == shipmentNumber) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.trackingNumberUrl, trackingNumberUrl) ||
                other.trackingNumberUrl == trackingNumberUrl) &&
            (identical(other.shippedDate, shippedDate) ||
                other.shippedDate == shippedDate) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            const DeepCollectionEquality().equals(
              other._shipmentStatusEvents,
              _shipmentStatusEvents,
            ) &&
            (identical(other.showSku, showSku) || other.showSku == showSku) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._shipmentNotes,
              _shipmentNotes,
            ) &&
            (identical(other.order, order) || other.order == order) &&
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
    shipmentNumber,
    trackingNumber,
    trackingNumberUrl,
    shippedDate,
    deliveryDate,
    const DeepCollectionEquality().hash(_shipmentStatusEvents),
    showSku,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_shipmentNotes),
    order,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ShipmentDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentDetailsModelImplCopyWith<_$ShipmentDetailsModelImpl>
  get copyWith =>
      __$$ShipmentDetailsModelImplCopyWithImpl<_$ShipmentDetailsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentDetailsModelImplToJson(this);
  }
}

abstract class _ShipmentDetailsModel implements ShipmentDetailsModel {
  factory _ShipmentDetailsModel({
    @JsonKey(name: 'ShipmentNumber', includeIfNull: false)
    final int? shipmentNumber,
    @JsonKey(name: 'TrackingNumber', includeIfNull: false)
    final String? trackingNumber,
    @JsonKey(name: 'TrackingNumberUrl', includeIfNull: false)
    final String? trackingNumberUrl,
    @JsonKey(name: 'ShippedDate', includeIfNull: false)
    final DateTime? shippedDate,
    @JsonKey(name: 'DeliveryDate', includeIfNull: false)
    final DateTime? deliveryDate,
    @JsonKey(name: 'ShipmentStatusEvents', includeIfNull: false)
    final List<ShipmentStatusEventModel>? shipmentStatusEvents,
    @JsonKey(name: 'ShowSku', includeIfNull: false) final bool? showSku,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<ShipmentItemModel>? items,
    @JsonKey(name: 'ShipmentNotes', includeIfNull: false)
    final List<ShipmentNote>? shipmentNotes,
    @JsonKey(name: 'Order', includeIfNull: false) final OrderModel? order,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ShipmentDetailsModelImpl;

  factory _ShipmentDetailsModel.fromJson(Map<String, dynamic> json) =
      _$ShipmentDetailsModelImpl.fromJson;

  @override
  @JsonKey(name: 'ShipmentNumber', includeIfNull: false)
  int? get shipmentNumber;
  @override
  @JsonKey(name: 'TrackingNumber', includeIfNull: false)
  String? get trackingNumber;
  @override
  @JsonKey(name: 'TrackingNumberUrl', includeIfNull: false)
  String? get trackingNumberUrl;
  @override
  @JsonKey(name: 'ShippedDate', includeIfNull: false)
  DateTime? get shippedDate;
  @override
  @JsonKey(name: 'DeliveryDate', includeIfNull: false)
  DateTime? get deliveryDate;
  @override
  @JsonKey(name: 'ShipmentStatusEvents', includeIfNull: false)
  List<ShipmentStatusEventModel>? get shipmentStatusEvents;
  @override
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  bool? get showSku;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ShipmentItemModel>? get items;
  @override
  @JsonKey(name: 'ShipmentNotes', includeIfNull: false)
  List<ShipmentNote>? get shipmentNotes;
  @override
  @JsonKey(name: 'Order', includeIfNull: false)
  OrderModel? get order;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ShipmentDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentDetailsModelImplCopyWith<_$ShipmentDetailsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
