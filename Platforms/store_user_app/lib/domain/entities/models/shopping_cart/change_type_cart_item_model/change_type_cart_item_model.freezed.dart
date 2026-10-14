// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_type_cart_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChangeTypeCartItemModel _$ChangeTypeCartItemModelFromJson(
  Map<String, dynamic> json,
) {
  return _ChangeTypeCartItemModel.fromJson(json);
}

/// @nodoc
mixin _$ChangeTypeCartItemModel {
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Status', includeIfNull: false)
  bool? get status => throw _privateConstructorUsedError;

  /// Serializes this ChangeTypeCartItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChangeTypeCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChangeTypeCartItemModelCopyWith<ChangeTypeCartItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeTypeCartItemModelCopyWith<$Res> {
  factory $ChangeTypeCartItemModelCopyWith(
    ChangeTypeCartItemModel value,
    $Res Function(ChangeTypeCartItemModel) then,
  ) = _$ChangeTypeCartItemModelCopyWithImpl<$Res, ChangeTypeCartItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'Status', includeIfNull: false) bool? status,
  });
}

/// @nodoc
class _$ChangeTypeCartItemModelCopyWithImpl<
  $Res,
  $Val extends ChangeTypeCartItemModel
>
    implements $ChangeTypeCartItemModelCopyWith<$Res> {
  _$ChangeTypeCartItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChangeTypeCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? status = freezed}) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChangeTypeCartItemModelImplCopyWith<$Res>
    implements $ChangeTypeCartItemModelCopyWith<$Res> {
  factory _$$ChangeTypeCartItemModelImplCopyWith(
    _$ChangeTypeCartItemModelImpl value,
    $Res Function(_$ChangeTypeCartItemModelImpl) then,
  ) = __$$ChangeTypeCartItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'Status', includeIfNull: false) bool? status,
  });
}

/// @nodoc
class __$$ChangeTypeCartItemModelImplCopyWithImpl<$Res>
    extends
        _$ChangeTypeCartItemModelCopyWithImpl<
          $Res,
          _$ChangeTypeCartItemModelImpl
        >
    implements _$$ChangeTypeCartItemModelImplCopyWith<$Res> {
  __$$ChangeTypeCartItemModelImplCopyWithImpl(
    _$ChangeTypeCartItemModelImpl _value,
    $Res Function(_$ChangeTypeCartItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChangeTypeCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? status = freezed}) {
    return _then(
      _$ChangeTypeCartItemModelImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangeTypeCartItemModelImpl implements _ChangeTypeCartItemModel {
  _$ChangeTypeCartItemModelImpl({
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'Status', includeIfNull: false) this.status = false,
  });

  factory _$ChangeTypeCartItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangeTypeCartItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
  @override
  @JsonKey(name: 'Status', includeIfNull: false)
  final bool? status;

  @override
  String toString() {
    return 'ChangeTypeCartItemModel(id: $id, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeTypeCartItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, status);

  /// Create a copy of ChangeTypeCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeTypeCartItemModelImplCopyWith<_$ChangeTypeCartItemModelImpl>
  get copyWith => __$$ChangeTypeCartItemModelImplCopyWithImpl<
    _$ChangeTypeCartItemModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangeTypeCartItemModelImplToJson(this);
  }
}

abstract class _ChangeTypeCartItemModel implements ChangeTypeCartItemModel {
  factory _ChangeTypeCartItemModel({
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'Status', includeIfNull: false) final bool? status,
  }) = _$ChangeTypeCartItemModelImpl;

  factory _ChangeTypeCartItemModel.fromJson(Map<String, dynamic> json) =
      _$ChangeTypeCartItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'Status', includeIfNull: false)
  bool? get status;

  /// Create a copy of ChangeTypeCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangeTypeCartItemModelImplCopyWith<_$ChangeTypeCartItemModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
