// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_cart_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeleteCartItemModel _$DeleteCartItemModelFromJson(Map<String, dynamic> json) {
  return _DeleteCartItemModel.fromJson(json);
}

/// @nodoc
mixin _$DeleteCartItemModel {
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShoppingCartPage', includeIfNull: false)
  bool? get shoppingCartPage => throw _privateConstructorUsedError;

  /// Serializes this DeleteCartItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeleteCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteCartItemModelCopyWith<DeleteCartItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteCartItemModelCopyWith<$Res> {
  factory $DeleteCartItemModelCopyWith(
    DeleteCartItemModel value,
    $Res Function(DeleteCartItemModel) then,
  ) = _$DeleteCartItemModelCopyWithImpl<$Res, DeleteCartItemModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'ShoppingCartPage', includeIfNull: false)
    bool? shoppingCartPage,
  });
}

/// @nodoc
class _$DeleteCartItemModelCopyWithImpl<$Res, $Val extends DeleteCartItemModel>
    implements $DeleteCartItemModelCopyWith<$Res> {
  _$DeleteCartItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? shoppingCartPage = freezed}) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            shoppingCartPage:
                freezed == shoppingCartPage
                    ? _value.shoppingCartPage
                    : shoppingCartPage // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeleteCartItemModelImplCopyWith<$Res>
    implements $DeleteCartItemModelCopyWith<$Res> {
  factory _$$DeleteCartItemModelImplCopyWith(
    _$DeleteCartItemModelImpl value,
    $Res Function(_$DeleteCartItemModelImpl) then,
  ) = __$$DeleteCartItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'ShoppingCartPage', includeIfNull: false)
    bool? shoppingCartPage,
  });
}

/// @nodoc
class __$$DeleteCartItemModelImplCopyWithImpl<$Res>
    extends _$DeleteCartItemModelCopyWithImpl<$Res, _$DeleteCartItemModelImpl>
    implements _$$DeleteCartItemModelImplCopyWith<$Res> {
  __$$DeleteCartItemModelImplCopyWithImpl(
    _$DeleteCartItemModelImpl _value,
    $Res Function(_$DeleteCartItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeleteCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = freezed, Object? shoppingCartPage = freezed}) {
    return _then(
      _$DeleteCartItemModelImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        shoppingCartPage:
            freezed == shoppingCartPage
                ? _value.shoppingCartPage
                : shoppingCartPage // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeleteCartItemModelImpl implements _DeleteCartItemModel {
  _$DeleteCartItemModelImpl({
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'ShoppingCartPage', includeIfNull: false)
    this.shoppingCartPage = false,
  });

  factory _$DeleteCartItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeleteCartItemModelImplFromJson(json);

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
  @override
  @JsonKey(name: 'ShoppingCartPage', includeIfNull: false)
  final bool? shoppingCartPage;

  @override
  String toString() {
    return 'DeleteCartItemModel(id: $id, shoppingCartPage: $shoppingCartPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteCartItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shoppingCartPage, shoppingCartPage) ||
                other.shoppingCartPage == shoppingCartPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, shoppingCartPage);

  /// Create a copy of DeleteCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteCartItemModelImplCopyWith<_$DeleteCartItemModelImpl> get copyWith =>
      __$$DeleteCartItemModelImplCopyWithImpl<_$DeleteCartItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeleteCartItemModelImplToJson(this);
  }
}

abstract class _DeleteCartItemModel implements DeleteCartItemModel {
  factory _DeleteCartItemModel({
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'ShoppingCartPage', includeIfNull: false)
    final bool? shoppingCartPage,
  }) = _$DeleteCartItemModelImpl;

  factory _DeleteCartItemModel.fromJson(Map<String, dynamic> json) =
      _$DeleteCartItemModelImpl.fromJson;

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'ShoppingCartPage', includeIfNull: false)
  bool? get shoppingCartPage;

  /// Create a copy of DeleteCartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteCartItemModelImplCopyWith<_$DeleteCartItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
