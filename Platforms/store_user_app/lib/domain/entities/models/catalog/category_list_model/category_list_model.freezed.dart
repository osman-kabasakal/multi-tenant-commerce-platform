// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategoryListModel _$CategoryListModelFromJson(Map<String, dynamic> json) {
  return _CategoryListModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryListModel {
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  CategoryPagingModel? get pagingModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'CategoriesModel', includeIfNull: false)
  List<CategoryModel>? get categoriesModel =>
      throw _privateConstructorUsedError;

  /// Serializes this CategoryListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryListModelCopyWith<CategoryListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryListModelCopyWith<$Res> {
  factory $CategoryListModelCopyWith(
    CategoryListModel value,
    $Res Function(CategoryListModel) then,
  ) = _$CategoryListModelCopyWithImpl<$Res, CategoryListModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    CategoryPagingModel? pagingModel,
    @JsonKey(name: 'CategoriesModel', includeIfNull: false)
    List<CategoryModel>? categoriesModel,
  });

  $CategoryPagingModelCopyWith<$Res>? get pagingModel;
}

/// @nodoc
class _$CategoryListModelCopyWithImpl<$Res, $Val extends CategoryListModel>
    implements $CategoryListModelCopyWith<$Res> {
  _$CategoryListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagingModel = freezed,
    Object? categoriesModel = freezed,
  }) {
    return _then(
      _value.copyWith(
            pagingModel:
                freezed == pagingModel
                    ? _value.pagingModel
                    : pagingModel // ignore: cast_nullable_to_non_nullable
                        as CategoryPagingModel?,
            categoriesModel:
                freezed == categoriesModel
                    ? _value.categoriesModel
                    : categoriesModel // ignore: cast_nullable_to_non_nullable
                        as List<CategoryModel>?,
          )
          as $Val,
    );
  }

  /// Create a copy of CategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryPagingModelCopyWith<$Res>? get pagingModel {
    if (_value.pagingModel == null) {
      return null;
    }

    return $CategoryPagingModelCopyWith<$Res>(_value.pagingModel!, (value) {
      return _then(_value.copyWith(pagingModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CategoryListModelImplCopyWith<$Res>
    implements $CategoryListModelCopyWith<$Res> {
  factory _$$CategoryListModelImplCopyWith(
    _$CategoryListModelImpl value,
    $Res Function(_$CategoryListModelImpl) then,
  ) = __$$CategoryListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    CategoryPagingModel? pagingModel,
    @JsonKey(name: 'CategoriesModel', includeIfNull: false)
    List<CategoryModel>? categoriesModel,
  });

  @override
  $CategoryPagingModelCopyWith<$Res>? get pagingModel;
}

/// @nodoc
class __$$CategoryListModelImplCopyWithImpl<$Res>
    extends _$CategoryListModelCopyWithImpl<$Res, _$CategoryListModelImpl>
    implements _$$CategoryListModelImplCopyWith<$Res> {
  __$$CategoryListModelImplCopyWithImpl(
    _$CategoryListModelImpl _value,
    $Res Function(_$CategoryListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pagingModel = freezed,
    Object? categoriesModel = freezed,
  }) {
    return _then(
      _$CategoryListModelImpl(
        pagingModel:
            freezed == pagingModel
                ? _value.pagingModel
                : pagingModel // ignore: cast_nullable_to_non_nullable
                    as CategoryPagingModel?,
        categoriesModel:
            freezed == categoriesModel
                ? _value._categoriesModel
                : categoriesModel // ignore: cast_nullable_to_non_nullable
                    as List<CategoryModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryListModelImpl implements _CategoryListModel {
  _$CategoryListModelImpl({
    @JsonKey(name: 'PagingModel', includeIfNull: false) this.pagingModel,
    @JsonKey(name: 'CategoriesModel', includeIfNull: false)
    final List<CategoryModel>? categoriesModel = const [],
  }) : _categoriesModel = categoriesModel;

  factory _$CategoryListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryListModelImplFromJson(json);

  @override
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  final CategoryPagingModel? pagingModel;
  final List<CategoryModel>? _categoriesModel;
  @override
  @JsonKey(name: 'CategoriesModel', includeIfNull: false)
  List<CategoryModel>? get categoriesModel {
    final value = _categoriesModel;
    if (value == null) return null;
    if (_categoriesModel is EqualUnmodifiableListView) return _categoriesModel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CategoryListModel(pagingModel: $pagingModel, categoriesModel: $categoriesModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryListModelImpl &&
            (identical(other.pagingModel, pagingModel) ||
                other.pagingModel == pagingModel) &&
            const DeepCollectionEquality().equals(
              other._categoriesModel,
              _categoriesModel,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pagingModel,
    const DeepCollectionEquality().hash(_categoriesModel),
  );

  /// Create a copy of CategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryListModelImplCopyWith<_$CategoryListModelImpl> get copyWith =>
      __$$CategoryListModelImplCopyWithImpl<_$CategoryListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryListModelImplToJson(this);
  }
}

abstract class _CategoryListModel implements CategoryListModel {
  factory _CategoryListModel({
    @JsonKey(name: 'PagingModel', includeIfNull: false)
    final CategoryPagingModel? pagingModel,
    @JsonKey(name: 'CategoriesModel', includeIfNull: false)
    final List<CategoryModel>? categoriesModel,
  }) = _$CategoryListModelImpl;

  factory _CategoryListModel.fromJson(Map<String, dynamic> json) =
      _$CategoryListModelImpl.fromJson;

  @override
  @JsonKey(name: 'PagingModel', includeIfNull: false)
  CategoryPagingModel? get pagingModel;
  @override
  @JsonKey(name: 'CategoriesModel', includeIfNull: false)
  List<CategoryModel>? get categoriesModel;

  /// Create a copy of CategoryListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryListModelImplCopyWith<_$CategoryListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
