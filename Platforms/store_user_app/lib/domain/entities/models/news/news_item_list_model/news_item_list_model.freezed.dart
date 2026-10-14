// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_item_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NewsItemListModel _$NewsItemListModelFromJson(Map<String, dynamic> json) {
  return _NewsItemListModel.fromJson(json);
}

/// @nodoc
mixin _$NewsItemListModel {
  @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
  String? get workingLanguageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  NewsPagingFilteringModel? get pagingFilteringContext =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'NewsItems', includeIfNull: false)
  List<NewsItemModel>? get newsItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this NewsItemListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NewsItemListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsItemListModelCopyWith<NewsItemListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsItemListModelCopyWith<$Res> {
  factory $NewsItemListModelCopyWith(
    NewsItemListModel value,
    $Res Function(NewsItemListModel) then,
  ) = _$NewsItemListModelCopyWithImpl<$Res, NewsItemListModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
    String? workingLanguageId,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    NewsPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'NewsItems', includeIfNull: false)
    List<NewsItemModel>? newsItems,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $NewsPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
}

/// @nodoc
class _$NewsItemListModelCopyWithImpl<$Res, $Val extends NewsItemListModel>
    implements $NewsItemListModelCopyWith<$Res> {
  _$NewsItemListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewsItemListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workingLanguageId = freezed,
    Object? pagingFilteringContext = freezed,
    Object? newsItems = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            workingLanguageId:
                freezed == workingLanguageId
                    ? _value.workingLanguageId
                    : workingLanguageId // ignore: cast_nullable_to_non_nullable
                        as String?,
            pagingFilteringContext:
                freezed == pagingFilteringContext
                    ? _value.pagingFilteringContext
                    : pagingFilteringContext // ignore: cast_nullable_to_non_nullable
                        as NewsPagingFilteringModel?,
            newsItems:
                freezed == newsItems
                    ? _value.newsItems
                    : newsItems // ignore: cast_nullable_to_non_nullable
                        as List<NewsItemModel>?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of NewsItemListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NewsPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext {
    if (_value.pagingFilteringContext == null) {
      return null;
    }

    return $NewsPagingFilteringModelCopyWith<$Res>(
      _value.pagingFilteringContext!,
      (value) {
        return _then(_value.copyWith(pagingFilteringContext: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$NewsItemListModelImplCopyWith<$Res>
    implements $NewsItemListModelCopyWith<$Res> {
  factory _$$NewsItemListModelImplCopyWith(
    _$NewsItemListModelImpl value,
    $Res Function(_$NewsItemListModelImpl) then,
  ) = __$$NewsItemListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
    String? workingLanguageId,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    NewsPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'NewsItems', includeIfNull: false)
    List<NewsItemModel>? newsItems,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $NewsPagingFilteringModelCopyWith<$Res>? get pagingFilteringContext;
}

/// @nodoc
class __$$NewsItemListModelImplCopyWithImpl<$Res>
    extends _$NewsItemListModelCopyWithImpl<$Res, _$NewsItemListModelImpl>
    implements _$$NewsItemListModelImplCopyWith<$Res> {
  __$$NewsItemListModelImplCopyWithImpl(
    _$NewsItemListModelImpl _value,
    $Res Function(_$NewsItemListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NewsItemListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workingLanguageId = freezed,
    Object? pagingFilteringContext = freezed,
    Object? newsItems = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$NewsItemListModelImpl(
        workingLanguageId:
            freezed == workingLanguageId
                ? _value.workingLanguageId
                : workingLanguageId // ignore: cast_nullable_to_non_nullable
                    as String?,
        pagingFilteringContext:
            freezed == pagingFilteringContext
                ? _value.pagingFilteringContext
                : pagingFilteringContext // ignore: cast_nullable_to_non_nullable
                    as NewsPagingFilteringModel?,
        newsItems:
            freezed == newsItems
                ? _value._newsItems
                : newsItems // ignore: cast_nullable_to_non_nullable
                    as List<NewsItemModel>?,
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
class _$NewsItemListModelImpl implements _NewsItemListModel {
  _$NewsItemListModelImpl({
    @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
    this.workingLanguageId,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    this.pagingFilteringContext,
    @JsonKey(name: 'NewsItems', includeIfNull: false)
    final List<NewsItemModel>? newsItems = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _newsItems = newsItems,
       _userFields = userFields;

  factory _$NewsItemListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsItemListModelImplFromJson(json);

  @override
  @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
  final String? workingLanguageId;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  final NewsPagingFilteringModel? pagingFilteringContext;
  final List<NewsItemModel>? _newsItems;
  @override
  @JsonKey(name: 'NewsItems', includeIfNull: false)
  List<NewsItemModel>? get newsItems {
    final value = _newsItems;
    if (value == null) return null;
    if (_newsItems is EqualUnmodifiableListView) return _newsItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'NewsItemListModel(workingLanguageId: $workingLanguageId, pagingFilteringContext: $pagingFilteringContext, newsItems: $newsItems, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsItemListModelImpl &&
            (identical(other.workingLanguageId, workingLanguageId) ||
                other.workingLanguageId == workingLanguageId) &&
            (identical(other.pagingFilteringContext, pagingFilteringContext) ||
                other.pagingFilteringContext == pagingFilteringContext) &&
            const DeepCollectionEquality().equals(
              other._newsItems,
              _newsItems,
            ) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    workingLanguageId,
    pagingFilteringContext,
    const DeepCollectionEquality().hash(_newsItems),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of NewsItemListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsItemListModelImplCopyWith<_$NewsItemListModelImpl> get copyWith =>
      __$$NewsItemListModelImplCopyWithImpl<_$NewsItemListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsItemListModelImplToJson(this);
  }
}

abstract class _NewsItemListModel implements NewsItemListModel {
  factory _NewsItemListModel({
    @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
    final String? workingLanguageId,
    @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
    final NewsPagingFilteringModel? pagingFilteringContext,
    @JsonKey(name: 'NewsItems', includeIfNull: false)
    final List<NewsItemModel>? newsItems,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$NewsItemListModelImpl;

  factory _NewsItemListModel.fromJson(Map<String, dynamic> json) =
      _$NewsItemListModelImpl.fromJson;

  @override
  @JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
  String? get workingLanguageId;
  @override
  @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
  NewsPagingFilteringModel? get pagingFilteringContext;
  @override
  @JsonKey(name: 'NewsItems', includeIfNull: false)
  List<NewsItemModel>? get newsItems;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of NewsItemListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsItemListModelImplCopyWith<_$NewsItemListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
