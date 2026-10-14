// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_categories_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomePageCategoriesViewModel {
  bool get isLoading => throw _privateConstructorUsedError;
  List<CategoryModel>? get categories => throw _privateConstructorUsedError;

  /// Create a copy of HomePageCategoriesViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomePageCategoriesViewModelCopyWith<HomePageCategoriesViewModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageCategoriesViewModelCopyWith<$Res> {
  factory $HomePageCategoriesViewModelCopyWith(
    HomePageCategoriesViewModel value,
    $Res Function(HomePageCategoriesViewModel) then,
  ) =
      _$HomePageCategoriesViewModelCopyWithImpl<
        $Res,
        HomePageCategoriesViewModel
      >;
  @useResult
  $Res call({bool isLoading, List<CategoryModel>? categories});
}

/// @nodoc
class _$HomePageCategoriesViewModelCopyWithImpl<
  $Res,
  $Val extends HomePageCategoriesViewModel
>
    implements $HomePageCategoriesViewModelCopyWith<$Res> {
  _$HomePageCategoriesViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomePageCategoriesViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? categories = freezed}) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            categories:
                freezed == categories
                    ? _value.categories
                    : categories // ignore: cast_nullable_to_non_nullable
                        as List<CategoryModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomePageCategoriesViewModelImplCopyWith<$Res>
    implements $HomePageCategoriesViewModelCopyWith<$Res> {
  factory _$$HomePageCategoriesViewModelImplCopyWith(
    _$HomePageCategoriesViewModelImpl value,
    $Res Function(_$HomePageCategoriesViewModelImpl) then,
  ) = __$$HomePageCategoriesViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<CategoryModel>? categories});
}

/// @nodoc
class __$$HomePageCategoriesViewModelImplCopyWithImpl<$Res>
    extends
        _$HomePageCategoriesViewModelCopyWithImpl<
          $Res,
          _$HomePageCategoriesViewModelImpl
        >
    implements _$$HomePageCategoriesViewModelImplCopyWith<$Res> {
  __$$HomePageCategoriesViewModelImplCopyWithImpl(
    _$HomePageCategoriesViewModelImpl _value,
    $Res Function(_$HomePageCategoriesViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomePageCategoriesViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? categories = freezed}) {
    return _then(
      _$HomePageCategoriesViewModelImpl(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        categories:
            freezed == categories
                ? _value._categories
                : categories // ignore: cast_nullable_to_non_nullable
                    as List<CategoryModel>?,
      ),
    );
  }
}

/// @nodoc

class _$HomePageCategoriesViewModelImpl
    implements _HomePageCategoriesViewModel {
  const _$HomePageCategoriesViewModelImpl({
    this.isLoading = true,
    final List<CategoryModel>? categories = const <CategoryModel>[],
  }) : _categories = categories;

  @override
  @JsonKey()
  final bool isLoading;
  final List<CategoryModel>? _categories;
  @override
  @JsonKey()
  List<CategoryModel>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HomePageCategoriesViewModel(isLoading: $isLoading, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomePageCategoriesViewModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_categories),
  );

  /// Create a copy of HomePageCategoriesViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomePageCategoriesViewModelImplCopyWith<_$HomePageCategoriesViewModelImpl>
  get copyWith => __$$HomePageCategoriesViewModelImplCopyWithImpl<
    _$HomePageCategoriesViewModelImpl
  >(this, _$identity);
}

abstract class _HomePageCategoriesViewModel
    implements HomePageCategoriesViewModel {
  const factory _HomePageCategoriesViewModel({
    final bool isLoading,
    final List<CategoryModel>? categories,
  }) = _$HomePageCategoriesViewModelImpl;

  @override
  bool get isLoading;
  @override
  List<CategoryModel>? get categories;

  /// Create a copy of HomePageCategoriesViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomePageCategoriesViewModelImplCopyWith<_$HomePageCategoriesViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
