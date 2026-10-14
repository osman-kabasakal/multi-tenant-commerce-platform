// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'documents_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DocumentsModel _$DocumentsModelFromJson(Map<String, dynamic> json) {
  return _DocumentsModel.fromJson(json);
}

/// @nodoc
mixin _$DocumentsModel {
  @JsonKey(name: 'DocumentList', includeIfNull: false)
  List<Document>? get documentList => throw _privateConstructorUsedError;
  @JsonKey(name: 'PagingContext', includeIfNull: false)
  DocumentPagingModel? get pagingContext => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this DocumentsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DocumentsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DocumentsModelCopyWith<DocumentsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DocumentsModelCopyWith<$Res> {
  factory $DocumentsModelCopyWith(
    DocumentsModel value,
    $Res Function(DocumentsModel) then,
  ) = _$DocumentsModelCopyWithImpl<$Res, DocumentsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'DocumentList', includeIfNull: false)
    List<Document>? documentList,
    @JsonKey(name: 'PagingContext', includeIfNull: false)
    DocumentPagingModel? pagingContext,
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $DocumentPagingModelCopyWith<$Res>? get pagingContext;
}

/// @nodoc
class _$DocumentsModelCopyWithImpl<$Res, $Val extends DocumentsModel>
    implements $DocumentsModelCopyWith<$Res> {
  _$DocumentsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DocumentsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentList = freezed,
    Object? pagingContext = freezed,
    Object? customerId = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            documentList:
                freezed == documentList
                    ? _value.documentList
                    : documentList // ignore: cast_nullable_to_non_nullable
                        as List<Document>?,
            pagingContext:
                freezed == pagingContext
                    ? _value.pagingContext
                    : pagingContext // ignore: cast_nullable_to_non_nullable
                        as DocumentPagingModel?,
            customerId:
                freezed == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of DocumentsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DocumentPagingModelCopyWith<$Res>? get pagingContext {
    if (_value.pagingContext == null) {
      return null;
    }

    return $DocumentPagingModelCopyWith<$Res>(_value.pagingContext!, (value) {
      return _then(_value.copyWith(pagingContext: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DocumentsModelImplCopyWith<$Res>
    implements $DocumentsModelCopyWith<$Res> {
  factory _$$DocumentsModelImplCopyWith(
    _$DocumentsModelImpl value,
    $Res Function(_$DocumentsModelImpl) then,
  ) = __$$DocumentsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'DocumentList', includeIfNull: false)
    List<Document>? documentList,
    @JsonKey(name: 'PagingContext', includeIfNull: false)
    DocumentPagingModel? pagingContext,
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $DocumentPagingModelCopyWith<$Res>? get pagingContext;
}

/// @nodoc
class __$$DocumentsModelImplCopyWithImpl<$Res>
    extends _$DocumentsModelCopyWithImpl<$Res, _$DocumentsModelImpl>
    implements _$$DocumentsModelImplCopyWith<$Res> {
  __$$DocumentsModelImplCopyWithImpl(
    _$DocumentsModelImpl _value,
    $Res Function(_$DocumentsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DocumentsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentList = freezed,
    Object? pagingContext = freezed,
    Object? customerId = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$DocumentsModelImpl(
        documentList:
            freezed == documentList
                ? _value._documentList
                : documentList // ignore: cast_nullable_to_non_nullable
                    as List<Document>?,
        pagingContext:
            freezed == pagingContext
                ? _value.pagingContext
                : pagingContext // ignore: cast_nullable_to_non_nullable
                    as DocumentPagingModel?,
        customerId:
            freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
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
class _$DocumentsModelImpl implements _DocumentsModel {
  _$DocumentsModelImpl({
    @JsonKey(name: 'DocumentList', includeIfNull: false)
    final List<Document>? documentList = const [],
    @JsonKey(name: 'PagingContext', includeIfNull: false) this.pagingContext,
    @JsonKey(name: 'CustomerId', includeIfNull: false) this.customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _documentList = documentList,
       _userFields = userFields;

  factory _$DocumentsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DocumentsModelImplFromJson(json);

  final List<Document>? _documentList;
  @override
  @JsonKey(name: 'DocumentList', includeIfNull: false)
  List<Document>? get documentList {
    final value = _documentList;
    if (value == null) return null;
    if (_documentList is EqualUnmodifiableListView) return _documentList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'PagingContext', includeIfNull: false)
  final DocumentPagingModel? pagingContext;
  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  final String? customerId;
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
    return 'DocumentsModel(documentList: $documentList, pagingContext: $pagingContext, customerId: $customerId, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DocumentsModelImpl &&
            const DeepCollectionEquality().equals(
              other._documentList,
              _documentList,
            ) &&
            (identical(other.pagingContext, pagingContext) ||
                other.pagingContext == pagingContext) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_documentList),
    pagingContext,
    customerId,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of DocumentsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DocumentsModelImplCopyWith<_$DocumentsModelImpl> get copyWith =>
      __$$DocumentsModelImplCopyWithImpl<_$DocumentsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DocumentsModelImplToJson(this);
  }
}

abstract class _DocumentsModel implements DocumentsModel {
  factory _DocumentsModel({
    @JsonKey(name: 'DocumentList', includeIfNull: false)
    final List<Document>? documentList,
    @JsonKey(name: 'PagingContext', includeIfNull: false)
    final DocumentPagingModel? pagingContext,
    @JsonKey(name: 'CustomerId', includeIfNull: false) final String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$DocumentsModelImpl;

  factory _DocumentsModel.fromJson(Map<String, dynamic> json) =
      _$DocumentsModelImpl.fromJson;

  @override
  @JsonKey(name: 'DocumentList', includeIfNull: false)
  List<Document>? get documentList;
  @override
  @JsonKey(name: 'PagingContext', includeIfNull: false)
  DocumentPagingModel? get pagingContext;
  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of DocumentsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DocumentsModelImplCopyWith<_$DocumentsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
