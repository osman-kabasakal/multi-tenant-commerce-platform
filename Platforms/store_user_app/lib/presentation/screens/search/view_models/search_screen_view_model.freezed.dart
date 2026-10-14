// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_screen_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SearchScreenViewModel {
  bool get isLoading => throw _privateConstructorUsedError;
  List<String> get searchHistory => throw _privateConstructorUsedError;

  /// Create a copy of SearchScreenViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchScreenViewModelCopyWith<SearchScreenViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchScreenViewModelCopyWith<$Res> {
  factory $SearchScreenViewModelCopyWith(
    SearchScreenViewModel value,
    $Res Function(SearchScreenViewModel) then,
  ) = _$SearchScreenViewModelCopyWithImpl<$Res, SearchScreenViewModel>;
  @useResult
  $Res call({bool isLoading, List<String> searchHistory});
}

/// @nodoc
class _$SearchScreenViewModelCopyWithImpl<
  $Res,
  $Val extends SearchScreenViewModel
>
    implements $SearchScreenViewModelCopyWith<$Res> {
  _$SearchScreenViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchScreenViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? searchHistory = null}) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            searchHistory:
                null == searchHistory
                    ? _value.searchHistory
                    : searchHistory // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchScreenViewModelImplCopyWith<$Res>
    implements $SearchScreenViewModelCopyWith<$Res> {
  factory _$$SearchScreenViewModelImplCopyWith(
    _$SearchScreenViewModelImpl value,
    $Res Function(_$SearchScreenViewModelImpl) then,
  ) = __$$SearchScreenViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<String> searchHistory});
}

/// @nodoc
class __$$SearchScreenViewModelImplCopyWithImpl<$Res>
    extends
        _$SearchScreenViewModelCopyWithImpl<$Res, _$SearchScreenViewModelImpl>
    implements _$$SearchScreenViewModelImplCopyWith<$Res> {
  __$$SearchScreenViewModelImplCopyWithImpl(
    _$SearchScreenViewModelImpl _value,
    $Res Function(_$SearchScreenViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchScreenViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? searchHistory = null}) {
    return _then(
      _$SearchScreenViewModelImpl(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        searchHistory:
            null == searchHistory
                ? _value._searchHistory
                : searchHistory // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$SearchScreenViewModelImpl implements _SearchScreenViewModel {
  const _$SearchScreenViewModelImpl({
    this.isLoading = true,
    final List<String> searchHistory = const [],
  }) : _searchHistory = searchHistory;

  @override
  @JsonKey()
  final bool isLoading;
  final List<String> _searchHistory;
  @override
  @JsonKey()
  List<String> get searchHistory {
    if (_searchHistory is EqualUnmodifiableListView) return _searchHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchHistory);
  }

  @override
  String toString() {
    return 'SearchScreenViewModel(isLoading: $isLoading, searchHistory: $searchHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchScreenViewModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(
              other._searchHistory,
              _searchHistory,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    const DeepCollectionEquality().hash(_searchHistory),
  );

  /// Create a copy of SearchScreenViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchScreenViewModelImplCopyWith<_$SearchScreenViewModelImpl>
  get copyWith =>
      __$$SearchScreenViewModelImplCopyWithImpl<_$SearchScreenViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _SearchScreenViewModel implements SearchScreenViewModel {
  const factory _SearchScreenViewModel({
    final bool isLoading,
    final List<String> searchHistory,
  }) = _$SearchScreenViewModelImpl;

  @override
  bool get isLoading;
  @override
  List<String> get searchHistory;

  /// Create a copy of SearchScreenViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchScreenViewModelImplCopyWith<_$SearchScreenViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
