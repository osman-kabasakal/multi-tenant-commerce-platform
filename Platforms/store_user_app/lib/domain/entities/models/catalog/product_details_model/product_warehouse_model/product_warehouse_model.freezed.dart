// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_warehouse_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductWarehouseModel _$ProductWarehouseModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProductWarehouseModel.fromJson(json);
}

/// @nodoc
mixin _$ProductWarehouseModel {
  @JsonKey(name: 'Use', includeIfNull: false)
  bool? get use => throw _privateConstructorUsedError;
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  String? get warehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Code', includeIfNull: false)
  String? get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'StockQuantity', includeIfNull: false)
  int? get stockQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReservedQuantity', includeIfNull: false)
  int? get reservedQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'Selected', includeIfNull: false)
  bool? get selected => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductWarehouseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductWarehouseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductWarehouseModelCopyWith<ProductWarehouseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductWarehouseModelCopyWith<$Res> {
  factory $ProductWarehouseModelCopyWith(
    ProductWarehouseModel value,
    $Res Function(ProductWarehouseModel) then,
  ) = _$ProductWarehouseModelCopyWithImpl<$Res, ProductWarehouseModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Use', includeIfNull: false) bool? use,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
    @JsonKey(name: 'Code', includeIfNull: false) String? code,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'StockQuantity', includeIfNull: false) int? stockQuantity,
    @JsonKey(name: 'ReservedQuantity', includeIfNull: false)
    int? reservedQuantity,
    @JsonKey(name: 'Selected', includeIfNull: false) bool? selected,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ProductWarehouseModelCopyWithImpl<
  $Res,
  $Val extends ProductWarehouseModel
>
    implements $ProductWarehouseModelCopyWith<$Res> {
  _$ProductWarehouseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductWarehouseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? use = freezed,
    Object? warehouseId = freezed,
    Object? code = freezed,
    Object? name = freezed,
    Object? stockQuantity = freezed,
    Object? reservedQuantity = freezed,
    Object? selected = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            use:
                freezed == use
                    ? _value.use
                    : use // ignore: cast_nullable_to_non_nullable
                        as bool?,
            warehouseId:
                freezed == warehouseId
                    ? _value.warehouseId
                    : warehouseId // ignore: cast_nullable_to_non_nullable
                        as String?,
            code:
                freezed == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            stockQuantity:
                freezed == stockQuantity
                    ? _value.stockQuantity
                    : stockQuantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            reservedQuantity:
                freezed == reservedQuantity
                    ? _value.reservedQuantity
                    : reservedQuantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            selected:
                freezed == selected
                    ? _value.selected
                    : selected // ignore: cast_nullable_to_non_nullable
                        as bool?,
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
abstract class _$$ProductWarehouseModelImplCopyWith<$Res>
    implements $ProductWarehouseModelCopyWith<$Res> {
  factory _$$ProductWarehouseModelImplCopyWith(
    _$ProductWarehouseModelImpl value,
    $Res Function(_$ProductWarehouseModelImpl) then,
  ) = __$$ProductWarehouseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Use', includeIfNull: false) bool? use,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) String? warehouseId,
    @JsonKey(name: 'Code', includeIfNull: false) String? code,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'StockQuantity', includeIfNull: false) int? stockQuantity,
    @JsonKey(name: 'ReservedQuantity', includeIfNull: false)
    int? reservedQuantity,
    @JsonKey(name: 'Selected', includeIfNull: false) bool? selected,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ProductWarehouseModelImplCopyWithImpl<$Res>
    extends
        _$ProductWarehouseModelCopyWithImpl<$Res, _$ProductWarehouseModelImpl>
    implements _$$ProductWarehouseModelImplCopyWith<$Res> {
  __$$ProductWarehouseModelImplCopyWithImpl(
    _$ProductWarehouseModelImpl _value,
    $Res Function(_$ProductWarehouseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductWarehouseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? use = freezed,
    Object? warehouseId = freezed,
    Object? code = freezed,
    Object? name = freezed,
    Object? stockQuantity = freezed,
    Object? reservedQuantity = freezed,
    Object? selected = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductWarehouseModelImpl(
        use:
            freezed == use
                ? _value.use
                : use // ignore: cast_nullable_to_non_nullable
                    as bool?,
        warehouseId:
            freezed == warehouseId
                ? _value.warehouseId
                : warehouseId // ignore: cast_nullable_to_non_nullable
                    as String?,
        code:
            freezed == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        stockQuantity:
            freezed == stockQuantity
                ? _value.stockQuantity
                : stockQuantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        reservedQuantity:
            freezed == reservedQuantity
                ? _value.reservedQuantity
                : reservedQuantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        selected:
            freezed == selected
                ? _value.selected
                : selected // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$ProductWarehouseModelImpl implements _ProductWarehouseModel {
  _$ProductWarehouseModelImpl({
    @JsonKey(name: 'Use', includeIfNull: false) this.use = false,
    @JsonKey(name: 'WarehouseId', includeIfNull: false) this.warehouseId,
    @JsonKey(name: 'Code', includeIfNull: false) this.code,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'StockQuantity', includeIfNull: false) this.stockQuantity,
    @JsonKey(name: 'ReservedQuantity', includeIfNull: false)
    this.reservedQuantity,
    @JsonKey(name: 'Selected', includeIfNull: false) this.selected = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ProductWarehouseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductWarehouseModelImplFromJson(json);

  @override
  @JsonKey(name: 'Use', includeIfNull: false)
  final bool? use;
  @override
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  final String? warehouseId;
  @override
  @JsonKey(name: 'Code', includeIfNull: false)
  final String? code;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'StockQuantity', includeIfNull: false)
  final int? stockQuantity;
  @override
  @JsonKey(name: 'ReservedQuantity', includeIfNull: false)
  final int? reservedQuantity;
  @override
  @JsonKey(name: 'Selected', includeIfNull: false)
  final bool? selected;
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
    return 'ProductWarehouseModel(use: $use, warehouseId: $warehouseId, code: $code, name: $name, stockQuantity: $stockQuantity, reservedQuantity: $reservedQuantity, selected: $selected, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductWarehouseModelImpl &&
            (identical(other.use, use) || other.use == use) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.reservedQuantity, reservedQuantity) ||
                other.reservedQuantity == reservedQuantity) &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    use,
    warehouseId,
    code,
    name,
    stockQuantity,
    reservedQuantity,
    selected,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductWarehouseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductWarehouseModelImplCopyWith<_$ProductWarehouseModelImpl>
  get copyWith =>
      __$$ProductWarehouseModelImplCopyWithImpl<_$ProductWarehouseModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductWarehouseModelImplToJson(this);
  }
}

abstract class _ProductWarehouseModel implements ProductWarehouseModel {
  factory _ProductWarehouseModel({
    @JsonKey(name: 'Use', includeIfNull: false) final bool? use,
    @JsonKey(name: 'WarehouseId', includeIfNull: false)
    final String? warehouseId,
    @JsonKey(name: 'Code', includeIfNull: false) final String? code,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'StockQuantity', includeIfNull: false)
    final int? stockQuantity,
    @JsonKey(name: 'ReservedQuantity', includeIfNull: false)
    final int? reservedQuantity,
    @JsonKey(name: 'Selected', includeIfNull: false) final bool? selected,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductWarehouseModelImpl;

  factory _ProductWarehouseModel.fromJson(Map<String, dynamic> json) =
      _$ProductWarehouseModelImpl.fromJson;

  @override
  @JsonKey(name: 'Use', includeIfNull: false)
  bool? get use;
  @override
  @JsonKey(name: 'WarehouseId', includeIfNull: false)
  String? get warehouseId;
  @override
  @JsonKey(name: 'Code', includeIfNull: false)
  String? get code;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'StockQuantity', includeIfNull: false)
  int? get stockQuantity;
  @override
  @JsonKey(name: 'ReservedQuantity', includeIfNull: false)
  int? get reservedQuantity;
  @override
  @JsonKey(name: 'Selected', includeIfNull: false)
  bool? get selected;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductWarehouseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductWarehouseModelImplCopyWith<_$ProductWarehouseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
