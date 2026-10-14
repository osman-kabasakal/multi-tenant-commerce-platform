// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipment_brief_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShipmentBriefModel _$ShipmentBriefModelFromJson(Map<String, dynamic> json) {
  return _ShipmentBriefModel.fromJson(json);
}

/// @nodoc
mixin _$ShipmentBriefModel {
  @JsonKey(name: 'TrackingNumber', includeIfNull: false)
  String? get trackingNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShipmentNumber', includeIfNull: false)
  int? get shipmentNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShippedDate', includeIfNull: false)
  DateTime? get shippedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'DeliveryDate', includeIfNull: false)
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ShipmentBriefModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentBriefModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentBriefModelCopyWith<ShipmentBriefModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentBriefModelCopyWith<$Res> {
  factory $ShipmentBriefModelCopyWith(
    ShipmentBriefModel value,
    $Res Function(ShipmentBriefModel) then,
  ) = _$ShipmentBriefModelCopyWithImpl<$Res, ShipmentBriefModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'TrackingNumber', includeIfNull: false)
    String? trackingNumber,
    @JsonKey(name: 'ShipmentNumber', includeIfNull: false) int? shipmentNumber,
    @JsonKey(name: 'ShippedDate', includeIfNull: false) DateTime? shippedDate,
    @JsonKey(name: 'DeliveryDate', includeIfNull: false) DateTime? deliveryDate,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ShipmentBriefModelCopyWithImpl<$Res, $Val extends ShipmentBriefModel>
    implements $ShipmentBriefModelCopyWith<$Res> {
  _$ShipmentBriefModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentBriefModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackingNumber = freezed,
    Object? shipmentNumber = freezed,
    Object? shippedDate = freezed,
    Object? deliveryDate = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            trackingNumber:
                freezed == trackingNumber
                    ? _value.trackingNumber
                    : trackingNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            shipmentNumber:
                freezed == shipmentNumber
                    ? _value.shipmentNumber
                    : shipmentNumber // ignore: cast_nullable_to_non_nullable
                        as int?,
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
}

/// @nodoc
abstract class _$$ShipmentBriefModelImplCopyWith<$Res>
    implements $ShipmentBriefModelCopyWith<$Res> {
  factory _$$ShipmentBriefModelImplCopyWith(
    _$ShipmentBriefModelImpl value,
    $Res Function(_$ShipmentBriefModelImpl) then,
  ) = __$$ShipmentBriefModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'TrackingNumber', includeIfNull: false)
    String? trackingNumber,
    @JsonKey(name: 'ShipmentNumber', includeIfNull: false) int? shipmentNumber,
    @JsonKey(name: 'ShippedDate', includeIfNull: false) DateTime? shippedDate,
    @JsonKey(name: 'DeliveryDate', includeIfNull: false) DateTime? deliveryDate,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ShipmentBriefModelImplCopyWithImpl<$Res>
    extends _$ShipmentBriefModelCopyWithImpl<$Res, _$ShipmentBriefModelImpl>
    implements _$$ShipmentBriefModelImplCopyWith<$Res> {
  __$$ShipmentBriefModelImplCopyWithImpl(
    _$ShipmentBriefModelImpl _value,
    $Res Function(_$ShipmentBriefModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShipmentBriefModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trackingNumber = freezed,
    Object? shipmentNumber = freezed,
    Object? shippedDate = freezed,
    Object? deliveryDate = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ShipmentBriefModelImpl(
        trackingNumber:
            freezed == trackingNumber
                ? _value.trackingNumber
                : trackingNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        shipmentNumber:
            freezed == shipmentNumber
                ? _value.shipmentNumber
                : shipmentNumber // ignore: cast_nullable_to_non_nullable
                    as int?,
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
class _$ShipmentBriefModelImpl implements _ShipmentBriefModel {
  _$ShipmentBriefModelImpl({
    @JsonKey(name: 'TrackingNumber', includeIfNull: false) this.trackingNumber,
    @JsonKey(name: 'ShipmentNumber', includeIfNull: false) this.shipmentNumber,
    @JsonKey(name: 'ShippedDate', includeIfNull: false) this.shippedDate = null,
    @JsonKey(name: 'DeliveryDate', includeIfNull: false)
    this.deliveryDate = null,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ShipmentBriefModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentBriefModelImplFromJson(json);

  @override
  @JsonKey(name: 'TrackingNumber', includeIfNull: false)
  final String? trackingNumber;
  @override
  @JsonKey(name: 'ShipmentNumber', includeIfNull: false)
  final int? shipmentNumber;
  @override
  @JsonKey(name: 'ShippedDate', includeIfNull: false)
  final DateTime? shippedDate;
  @override
  @JsonKey(name: 'DeliveryDate', includeIfNull: false)
  final DateTime? deliveryDate;
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
    return 'ShipmentBriefModel(trackingNumber: $trackingNumber, shipmentNumber: $shipmentNumber, shippedDate: $shippedDate, deliveryDate: $deliveryDate, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentBriefModelImpl &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.shipmentNumber, shipmentNumber) ||
                other.shipmentNumber == shipmentNumber) &&
            (identical(other.shippedDate, shippedDate) ||
                other.shippedDate == shippedDate) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
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
    trackingNumber,
    shipmentNumber,
    shippedDate,
    deliveryDate,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ShipmentBriefModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentBriefModelImplCopyWith<_$ShipmentBriefModelImpl> get copyWith =>
      __$$ShipmentBriefModelImplCopyWithImpl<_$ShipmentBriefModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentBriefModelImplToJson(this);
  }
}

abstract class _ShipmentBriefModel implements ShipmentBriefModel {
  factory _ShipmentBriefModel({
    @JsonKey(name: 'TrackingNumber', includeIfNull: false)
    final String? trackingNumber,
    @JsonKey(name: 'ShipmentNumber', includeIfNull: false)
    final int? shipmentNumber,
    @JsonKey(name: 'ShippedDate', includeIfNull: false)
    final DateTime? shippedDate,
    @JsonKey(name: 'DeliveryDate', includeIfNull: false)
    final DateTime? deliveryDate,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ShipmentBriefModelImpl;

  factory _ShipmentBriefModel.fromJson(Map<String, dynamic> json) =
      _$ShipmentBriefModelImpl.fromJson;

  @override
  @JsonKey(name: 'TrackingNumber', includeIfNull: false)
  String? get trackingNumber;
  @override
  @JsonKey(name: 'ShipmentNumber', includeIfNull: false)
  int? get shipmentNumber;
  @override
  @JsonKey(name: 'ShippedDate', includeIfNull: false)
  DateTime? get shippedDate;
  @override
  @JsonKey(name: 'DeliveryDate', includeIfNull: false)
  DateTime? get deliveryDate;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ShipmentBriefModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentBriefModelImplCopyWith<_$ShipmentBriefModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
