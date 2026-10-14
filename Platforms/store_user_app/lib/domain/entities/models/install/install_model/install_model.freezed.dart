// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'install_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InstallModel _$InstallModelFromJson(Map<String, dynamic> json) {
  return _InstallModel.fromJson(json);
}

/// @nodoc
mixin _$InstallModel {
  @JsonKey(name: 'SelectedLanguage', includeIfNull: false)
  String? get selectedLanguage => throw _privateConstructorUsedError;
  @JsonKey(name: 'AdminEmail', includeIfNull: false)
  String? get adminEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'AdminPassword', includeIfNull: false)
  String? get adminPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'ConfirmPassword', includeIfNull: false)
  String? get confirmPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'DatabaseConnectionString', includeIfNull: false)
  String? get databaseConnectionString => throw _privateConstructorUsedError;
  @JsonKey(name: 'DataProvider', includeIfNull: false)
  DbProvider? get dataProvider => throw _privateConstructorUsedError;
  @JsonKey(name: 'ConnectionInfo', includeIfNull: false)
  bool? get connectionInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'MongoDBServerName', includeIfNull: false)
  String? get mongoDBServerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'MongoDBDatabaseName', includeIfNull: false)
  String? get mongoDBDatabaseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'MongoDBUsername', includeIfNull: false)
  String? get mongoDBUsername => throw _privateConstructorUsedError;
  @JsonKey(name: 'MongoDBPassword', includeIfNull: false)
  String? get mongoDBPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'DisableSampleDataOption', includeIfNull: false)
  bool? get disableSampleDataOption => throw _privateConstructorUsedError;
  @JsonKey(name: 'InstallSampleData', includeIfNull: false)
  bool? get installSampleData => throw _privateConstructorUsedError;
  @JsonKey(name: 'Installed', includeIfNull: false)
  bool? get installed => throw _privateConstructorUsedError;
  @JsonKey(name: 'Collation', includeIfNull: false)
  String? get collation => throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableLanguages', includeIfNull: false)
  List<SelectListItem>? get availableLanguages =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableCollation', includeIfNull: false)
  List<SelectListItem>? get availableCollation =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'AvailableProviders', includeIfNull: false)
  List<SelectListItem>? get availableProviders =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'CompanyName', includeIfNull: false)
  String? get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'CompanyAddress', includeIfNull: false)
  String? get companyAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'CompanyPhoneNumber', includeIfNull: false)
  String? get companyPhoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'CompanyEmail', includeIfNull: false)
  String? get companyEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this InstallModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstallModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstallModelCopyWith<InstallModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstallModelCopyWith<$Res> {
  factory $InstallModelCopyWith(
    InstallModel value,
    $Res Function(InstallModel) then,
  ) = _$InstallModelCopyWithImpl<$Res, InstallModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'SelectedLanguage', includeIfNull: false)
    String? selectedLanguage,
    @JsonKey(name: 'AdminEmail', includeIfNull: false) String? adminEmail,
    @JsonKey(name: 'AdminPassword', includeIfNull: false) String? adminPassword,
    @JsonKey(name: 'ConfirmPassword', includeIfNull: false)
    String? confirmPassword,
    @JsonKey(name: 'DatabaseConnectionString', includeIfNull: false)
    String? databaseConnectionString,
    @JsonKey(name: 'DataProvider', includeIfNull: false)
    DbProvider? dataProvider,
    @JsonKey(name: 'ConnectionInfo', includeIfNull: false) bool? connectionInfo,
    @JsonKey(name: 'MongoDBServerName', includeIfNull: false)
    String? mongoDBServerName,
    @JsonKey(name: 'MongoDBDatabaseName', includeIfNull: false)
    String? mongoDBDatabaseName,
    @JsonKey(name: 'MongoDBUsername', includeIfNull: false)
    String? mongoDBUsername,
    @JsonKey(name: 'MongoDBPassword', includeIfNull: false)
    String? mongoDBPassword,
    @JsonKey(name: 'DisableSampleDataOption', includeIfNull: false)
    bool? disableSampleDataOption,
    @JsonKey(name: 'InstallSampleData', includeIfNull: false)
    bool? installSampleData,
    @JsonKey(name: 'Installed', includeIfNull: false) bool? installed,
    @JsonKey(name: 'Collation', includeIfNull: false) String? collation,
    @JsonKey(name: 'AvailableLanguages', includeIfNull: false)
    List<SelectListItem>? availableLanguages,
    @JsonKey(name: 'AvailableCollation', includeIfNull: false)
    List<SelectListItem>? availableCollation,
    @JsonKey(name: 'AvailableProviders', includeIfNull: false)
    List<SelectListItem>? availableProviders,
    @JsonKey(name: 'CompanyName', includeIfNull: false) String? companyName,
    @JsonKey(name: 'CompanyAddress', includeIfNull: false)
    String? companyAddress,
    @JsonKey(name: 'CompanyPhoneNumber', includeIfNull: false)
    String? companyPhoneNumber,
    @JsonKey(name: 'CompanyEmail', includeIfNull: false) String? companyEmail,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$InstallModelCopyWithImpl<$Res, $Val extends InstallModel>
    implements $InstallModelCopyWith<$Res> {
  _$InstallModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstallModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedLanguage = freezed,
    Object? adminEmail = freezed,
    Object? adminPassword = freezed,
    Object? confirmPassword = freezed,
    Object? databaseConnectionString = freezed,
    Object? dataProvider = freezed,
    Object? connectionInfo = freezed,
    Object? mongoDBServerName = freezed,
    Object? mongoDBDatabaseName = freezed,
    Object? mongoDBUsername = freezed,
    Object? mongoDBPassword = freezed,
    Object? disableSampleDataOption = freezed,
    Object? installSampleData = freezed,
    Object? installed = freezed,
    Object? collation = freezed,
    Object? availableLanguages = freezed,
    Object? availableCollation = freezed,
    Object? availableProviders = freezed,
    Object? companyName = freezed,
    Object? companyAddress = freezed,
    Object? companyPhoneNumber = freezed,
    Object? companyEmail = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            selectedLanguage:
                freezed == selectedLanguage
                    ? _value.selectedLanguage
                    : selectedLanguage // ignore: cast_nullable_to_non_nullable
                        as String?,
            adminEmail:
                freezed == adminEmail
                    ? _value.adminEmail
                    : adminEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            adminPassword:
                freezed == adminPassword
                    ? _value.adminPassword
                    : adminPassword // ignore: cast_nullable_to_non_nullable
                        as String?,
            confirmPassword:
                freezed == confirmPassword
                    ? _value.confirmPassword
                    : confirmPassword // ignore: cast_nullable_to_non_nullable
                        as String?,
            databaseConnectionString:
                freezed == databaseConnectionString
                    ? _value.databaseConnectionString
                    : databaseConnectionString // ignore: cast_nullable_to_non_nullable
                        as String?,
            dataProvider:
                freezed == dataProvider
                    ? _value.dataProvider
                    : dataProvider // ignore: cast_nullable_to_non_nullable
                        as DbProvider?,
            connectionInfo:
                freezed == connectionInfo
                    ? _value.connectionInfo
                    : connectionInfo // ignore: cast_nullable_to_non_nullable
                        as bool?,
            mongoDBServerName:
                freezed == mongoDBServerName
                    ? _value.mongoDBServerName
                    : mongoDBServerName // ignore: cast_nullable_to_non_nullable
                        as String?,
            mongoDBDatabaseName:
                freezed == mongoDBDatabaseName
                    ? _value.mongoDBDatabaseName
                    : mongoDBDatabaseName // ignore: cast_nullable_to_non_nullable
                        as String?,
            mongoDBUsername:
                freezed == mongoDBUsername
                    ? _value.mongoDBUsername
                    : mongoDBUsername // ignore: cast_nullable_to_non_nullable
                        as String?,
            mongoDBPassword:
                freezed == mongoDBPassword
                    ? _value.mongoDBPassword
                    : mongoDBPassword // ignore: cast_nullable_to_non_nullable
                        as String?,
            disableSampleDataOption:
                freezed == disableSampleDataOption
                    ? _value.disableSampleDataOption
                    : disableSampleDataOption // ignore: cast_nullable_to_non_nullable
                        as bool?,
            installSampleData:
                freezed == installSampleData
                    ? _value.installSampleData
                    : installSampleData // ignore: cast_nullable_to_non_nullable
                        as bool?,
            installed:
                freezed == installed
                    ? _value.installed
                    : installed // ignore: cast_nullable_to_non_nullable
                        as bool?,
            collation:
                freezed == collation
                    ? _value.collation
                    : collation // ignore: cast_nullable_to_non_nullable
                        as String?,
            availableLanguages:
                freezed == availableLanguages
                    ? _value.availableLanguages
                    : availableLanguages // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            availableCollation:
                freezed == availableCollation
                    ? _value.availableCollation
                    : availableCollation // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            availableProviders:
                freezed == availableProviders
                    ? _value.availableProviders
                    : availableProviders // ignore: cast_nullable_to_non_nullable
                        as List<SelectListItem>?,
            companyName:
                freezed == companyName
                    ? _value.companyName
                    : companyName // ignore: cast_nullable_to_non_nullable
                        as String?,
            companyAddress:
                freezed == companyAddress
                    ? _value.companyAddress
                    : companyAddress // ignore: cast_nullable_to_non_nullable
                        as String?,
            companyPhoneNumber:
                freezed == companyPhoneNumber
                    ? _value.companyPhoneNumber
                    : companyPhoneNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            companyEmail:
                freezed == companyEmail
                    ? _value.companyEmail
                    : companyEmail // ignore: cast_nullable_to_non_nullable
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
abstract class _$$InstallModelImplCopyWith<$Res>
    implements $InstallModelCopyWith<$Res> {
  factory _$$InstallModelImplCopyWith(
    _$InstallModelImpl value,
    $Res Function(_$InstallModelImpl) then,
  ) = __$$InstallModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'SelectedLanguage', includeIfNull: false)
    String? selectedLanguage,
    @JsonKey(name: 'AdminEmail', includeIfNull: false) String? adminEmail,
    @JsonKey(name: 'AdminPassword', includeIfNull: false) String? adminPassword,
    @JsonKey(name: 'ConfirmPassword', includeIfNull: false)
    String? confirmPassword,
    @JsonKey(name: 'DatabaseConnectionString', includeIfNull: false)
    String? databaseConnectionString,
    @JsonKey(name: 'DataProvider', includeIfNull: false)
    DbProvider? dataProvider,
    @JsonKey(name: 'ConnectionInfo', includeIfNull: false) bool? connectionInfo,
    @JsonKey(name: 'MongoDBServerName', includeIfNull: false)
    String? mongoDBServerName,
    @JsonKey(name: 'MongoDBDatabaseName', includeIfNull: false)
    String? mongoDBDatabaseName,
    @JsonKey(name: 'MongoDBUsername', includeIfNull: false)
    String? mongoDBUsername,
    @JsonKey(name: 'MongoDBPassword', includeIfNull: false)
    String? mongoDBPassword,
    @JsonKey(name: 'DisableSampleDataOption', includeIfNull: false)
    bool? disableSampleDataOption,
    @JsonKey(name: 'InstallSampleData', includeIfNull: false)
    bool? installSampleData,
    @JsonKey(name: 'Installed', includeIfNull: false) bool? installed,
    @JsonKey(name: 'Collation', includeIfNull: false) String? collation,
    @JsonKey(name: 'AvailableLanguages', includeIfNull: false)
    List<SelectListItem>? availableLanguages,
    @JsonKey(name: 'AvailableCollation', includeIfNull: false)
    List<SelectListItem>? availableCollation,
    @JsonKey(name: 'AvailableProviders', includeIfNull: false)
    List<SelectListItem>? availableProviders,
    @JsonKey(name: 'CompanyName', includeIfNull: false) String? companyName,
    @JsonKey(name: 'CompanyAddress', includeIfNull: false)
    String? companyAddress,
    @JsonKey(name: 'CompanyPhoneNumber', includeIfNull: false)
    String? companyPhoneNumber,
    @JsonKey(name: 'CompanyEmail', includeIfNull: false) String? companyEmail,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$InstallModelImplCopyWithImpl<$Res>
    extends _$InstallModelCopyWithImpl<$Res, _$InstallModelImpl>
    implements _$$InstallModelImplCopyWith<$Res> {
  __$$InstallModelImplCopyWithImpl(
    _$InstallModelImpl _value,
    $Res Function(_$InstallModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstallModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedLanguage = freezed,
    Object? adminEmail = freezed,
    Object? adminPassword = freezed,
    Object? confirmPassword = freezed,
    Object? databaseConnectionString = freezed,
    Object? dataProvider = freezed,
    Object? connectionInfo = freezed,
    Object? mongoDBServerName = freezed,
    Object? mongoDBDatabaseName = freezed,
    Object? mongoDBUsername = freezed,
    Object? mongoDBPassword = freezed,
    Object? disableSampleDataOption = freezed,
    Object? installSampleData = freezed,
    Object? installed = freezed,
    Object? collation = freezed,
    Object? availableLanguages = freezed,
    Object? availableCollation = freezed,
    Object? availableProviders = freezed,
    Object? companyName = freezed,
    Object? companyAddress = freezed,
    Object? companyPhoneNumber = freezed,
    Object? companyEmail = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$InstallModelImpl(
        selectedLanguage:
            freezed == selectedLanguage
                ? _value.selectedLanguage
                : selectedLanguage // ignore: cast_nullable_to_non_nullable
                    as String?,
        adminEmail:
            freezed == adminEmail
                ? _value.adminEmail
                : adminEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        adminPassword:
            freezed == adminPassword
                ? _value.adminPassword
                : adminPassword // ignore: cast_nullable_to_non_nullable
                    as String?,
        confirmPassword:
            freezed == confirmPassword
                ? _value.confirmPassword
                : confirmPassword // ignore: cast_nullable_to_non_nullable
                    as String?,
        databaseConnectionString:
            freezed == databaseConnectionString
                ? _value.databaseConnectionString
                : databaseConnectionString // ignore: cast_nullable_to_non_nullable
                    as String?,
        dataProvider:
            freezed == dataProvider
                ? _value.dataProvider
                : dataProvider // ignore: cast_nullable_to_non_nullable
                    as DbProvider?,
        connectionInfo:
            freezed == connectionInfo
                ? _value.connectionInfo
                : connectionInfo // ignore: cast_nullable_to_non_nullable
                    as bool?,
        mongoDBServerName:
            freezed == mongoDBServerName
                ? _value.mongoDBServerName
                : mongoDBServerName // ignore: cast_nullable_to_non_nullable
                    as String?,
        mongoDBDatabaseName:
            freezed == mongoDBDatabaseName
                ? _value.mongoDBDatabaseName
                : mongoDBDatabaseName // ignore: cast_nullable_to_non_nullable
                    as String?,
        mongoDBUsername:
            freezed == mongoDBUsername
                ? _value.mongoDBUsername
                : mongoDBUsername // ignore: cast_nullable_to_non_nullable
                    as String?,
        mongoDBPassword:
            freezed == mongoDBPassword
                ? _value.mongoDBPassword
                : mongoDBPassword // ignore: cast_nullable_to_non_nullable
                    as String?,
        disableSampleDataOption:
            freezed == disableSampleDataOption
                ? _value.disableSampleDataOption
                : disableSampleDataOption // ignore: cast_nullable_to_non_nullable
                    as bool?,
        installSampleData:
            freezed == installSampleData
                ? _value.installSampleData
                : installSampleData // ignore: cast_nullable_to_non_nullable
                    as bool?,
        installed:
            freezed == installed
                ? _value.installed
                : installed // ignore: cast_nullable_to_non_nullable
                    as bool?,
        collation:
            freezed == collation
                ? _value.collation
                : collation // ignore: cast_nullable_to_non_nullable
                    as String?,
        availableLanguages:
            freezed == availableLanguages
                ? _value._availableLanguages
                : availableLanguages // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        availableCollation:
            freezed == availableCollation
                ? _value._availableCollation
                : availableCollation // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        availableProviders:
            freezed == availableProviders
                ? _value._availableProviders
                : availableProviders // ignore: cast_nullable_to_non_nullable
                    as List<SelectListItem>?,
        companyName:
            freezed == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                    as String?,
        companyAddress:
            freezed == companyAddress
                ? _value.companyAddress
                : companyAddress // ignore: cast_nullable_to_non_nullable
                    as String?,
        companyPhoneNumber:
            freezed == companyPhoneNumber
                ? _value.companyPhoneNumber
                : companyPhoneNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        companyEmail:
            freezed == companyEmail
                ? _value.companyEmail
                : companyEmail // ignore: cast_nullable_to_non_nullable
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
class _$InstallModelImpl implements _InstallModel {
  _$InstallModelImpl({
    @JsonKey(name: 'SelectedLanguage', includeIfNull: false)
    this.selectedLanguage,
    @JsonKey(name: 'AdminEmail', includeIfNull: false) this.adminEmail,
    @JsonKey(name: 'AdminPassword', includeIfNull: false) this.adminPassword,
    @JsonKey(name: 'ConfirmPassword', includeIfNull: false)
    this.confirmPassword,
    @JsonKey(name: 'DatabaseConnectionString', includeIfNull: false)
    this.databaseConnectionString,
    @JsonKey(name: 'DataProvider', includeIfNull: false)
    this.dataProvider = DbProvider.mongoDB,
    @JsonKey(name: 'ConnectionInfo', includeIfNull: false)
    this.connectionInfo = false,
    @JsonKey(name: 'MongoDBServerName', includeIfNull: false)
    this.mongoDBServerName,
    @JsonKey(name: 'MongoDBDatabaseName', includeIfNull: false)
    this.mongoDBDatabaseName,
    @JsonKey(name: 'MongoDBUsername', includeIfNull: false)
    this.mongoDBUsername,
    @JsonKey(name: 'MongoDBPassword', includeIfNull: false)
    this.mongoDBPassword,
    @JsonKey(name: 'DisableSampleDataOption', includeIfNull: false)
    this.disableSampleDataOption = false,
    @JsonKey(name: 'InstallSampleData', includeIfNull: false)
    this.installSampleData = false,
    @JsonKey(name: 'Installed', includeIfNull: false) this.installed = false,
    @JsonKey(name: 'Collation', includeIfNull: false) this.collation,
    @JsonKey(name: 'AvailableLanguages', includeIfNull: false)
    final List<SelectListItem>? availableLanguages = const [],
    @JsonKey(name: 'AvailableCollation', includeIfNull: false)
    final List<SelectListItem>? availableCollation = const [],
    @JsonKey(name: 'AvailableProviders', includeIfNull: false)
    final List<SelectListItem>? availableProviders = const [],
    @JsonKey(name: 'CompanyName', includeIfNull: false) this.companyName,
    @JsonKey(name: 'CompanyAddress', includeIfNull: false) this.companyAddress,
    @JsonKey(name: 'CompanyPhoneNumber', includeIfNull: false)
    this.companyPhoneNumber,
    @JsonKey(name: 'CompanyEmail', includeIfNull: false) this.companyEmail,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _availableLanguages = availableLanguages,
       _availableCollation = availableCollation,
       _availableProviders = availableProviders,
       _userFields = userFields;

  factory _$InstallModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstallModelImplFromJson(json);

  @override
  @JsonKey(name: 'SelectedLanguage', includeIfNull: false)
  final String? selectedLanguage;
  @override
  @JsonKey(name: 'AdminEmail', includeIfNull: false)
  final String? adminEmail;
  @override
  @JsonKey(name: 'AdminPassword', includeIfNull: false)
  final String? adminPassword;
  @override
  @JsonKey(name: 'ConfirmPassword', includeIfNull: false)
  final String? confirmPassword;
  @override
  @JsonKey(name: 'DatabaseConnectionString', includeIfNull: false)
  final String? databaseConnectionString;
  @override
  @JsonKey(name: 'DataProvider', includeIfNull: false)
  final DbProvider? dataProvider;
  @override
  @JsonKey(name: 'ConnectionInfo', includeIfNull: false)
  final bool? connectionInfo;
  @override
  @JsonKey(name: 'MongoDBServerName', includeIfNull: false)
  final String? mongoDBServerName;
  @override
  @JsonKey(name: 'MongoDBDatabaseName', includeIfNull: false)
  final String? mongoDBDatabaseName;
  @override
  @JsonKey(name: 'MongoDBUsername', includeIfNull: false)
  final String? mongoDBUsername;
  @override
  @JsonKey(name: 'MongoDBPassword', includeIfNull: false)
  final String? mongoDBPassword;
  @override
  @JsonKey(name: 'DisableSampleDataOption', includeIfNull: false)
  final bool? disableSampleDataOption;
  @override
  @JsonKey(name: 'InstallSampleData', includeIfNull: false)
  final bool? installSampleData;
  @override
  @JsonKey(name: 'Installed', includeIfNull: false)
  final bool? installed;
  @override
  @JsonKey(name: 'Collation', includeIfNull: false)
  final String? collation;
  final List<SelectListItem>? _availableLanguages;
  @override
  @JsonKey(name: 'AvailableLanguages', includeIfNull: false)
  List<SelectListItem>? get availableLanguages {
    final value = _availableLanguages;
    if (value == null) return null;
    if (_availableLanguages is EqualUnmodifiableListView)
      return _availableLanguages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SelectListItem>? _availableCollation;
  @override
  @JsonKey(name: 'AvailableCollation', includeIfNull: false)
  List<SelectListItem>? get availableCollation {
    final value = _availableCollation;
    if (value == null) return null;
    if (_availableCollation is EqualUnmodifiableListView)
      return _availableCollation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SelectListItem>? _availableProviders;
  @override
  @JsonKey(name: 'AvailableProviders', includeIfNull: false)
  List<SelectListItem>? get availableProviders {
    final value = _availableProviders;
    if (value == null) return null;
    if (_availableProviders is EqualUnmodifiableListView)
      return _availableProviders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'CompanyName', includeIfNull: false)
  final String? companyName;
  @override
  @JsonKey(name: 'CompanyAddress', includeIfNull: false)
  final String? companyAddress;
  @override
  @JsonKey(name: 'CompanyPhoneNumber', includeIfNull: false)
  final String? companyPhoneNumber;
  @override
  @JsonKey(name: 'CompanyEmail', includeIfNull: false)
  final String? companyEmail;
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
    return 'InstallModel(selectedLanguage: $selectedLanguage, adminEmail: $adminEmail, adminPassword: $adminPassword, confirmPassword: $confirmPassword, databaseConnectionString: $databaseConnectionString, dataProvider: $dataProvider, connectionInfo: $connectionInfo, mongoDBServerName: $mongoDBServerName, mongoDBDatabaseName: $mongoDBDatabaseName, mongoDBUsername: $mongoDBUsername, mongoDBPassword: $mongoDBPassword, disableSampleDataOption: $disableSampleDataOption, installSampleData: $installSampleData, installed: $installed, collation: $collation, availableLanguages: $availableLanguages, availableCollation: $availableCollation, availableProviders: $availableProviders, companyName: $companyName, companyAddress: $companyAddress, companyPhoneNumber: $companyPhoneNumber, companyEmail: $companyEmail, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstallModelImpl &&
            (identical(other.selectedLanguage, selectedLanguage) ||
                other.selectedLanguage == selectedLanguage) &&
            (identical(other.adminEmail, adminEmail) ||
                other.adminEmail == adminEmail) &&
            (identical(other.adminPassword, adminPassword) ||
                other.adminPassword == adminPassword) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(
                  other.databaseConnectionString,
                  databaseConnectionString,
                ) ||
                other.databaseConnectionString == databaseConnectionString) &&
            (identical(other.dataProvider, dataProvider) ||
                other.dataProvider == dataProvider) &&
            (identical(other.connectionInfo, connectionInfo) ||
                other.connectionInfo == connectionInfo) &&
            (identical(other.mongoDBServerName, mongoDBServerName) ||
                other.mongoDBServerName == mongoDBServerName) &&
            (identical(other.mongoDBDatabaseName, mongoDBDatabaseName) ||
                other.mongoDBDatabaseName == mongoDBDatabaseName) &&
            (identical(other.mongoDBUsername, mongoDBUsername) ||
                other.mongoDBUsername == mongoDBUsername) &&
            (identical(other.mongoDBPassword, mongoDBPassword) ||
                other.mongoDBPassword == mongoDBPassword) &&
            (identical(
                  other.disableSampleDataOption,
                  disableSampleDataOption,
                ) ||
                other.disableSampleDataOption == disableSampleDataOption) &&
            (identical(other.installSampleData, installSampleData) ||
                other.installSampleData == installSampleData) &&
            (identical(other.installed, installed) ||
                other.installed == installed) &&
            (identical(other.collation, collation) ||
                other.collation == collation) &&
            const DeepCollectionEquality().equals(
              other._availableLanguages,
              _availableLanguages,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableCollation,
              _availableCollation,
            ) &&
            const DeepCollectionEquality().equals(
              other._availableProviders,
              _availableProviders,
            ) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyAddress, companyAddress) ||
                other.companyAddress == companyAddress) &&
            (identical(other.companyPhoneNumber, companyPhoneNumber) ||
                other.companyPhoneNumber == companyPhoneNumber) &&
            (identical(other.companyEmail, companyEmail) ||
                other.companyEmail == companyEmail) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    selectedLanguage,
    adminEmail,
    adminPassword,
    confirmPassword,
    databaseConnectionString,
    dataProvider,
    connectionInfo,
    mongoDBServerName,
    mongoDBDatabaseName,
    mongoDBUsername,
    mongoDBPassword,
    disableSampleDataOption,
    installSampleData,
    installed,
    collation,
    const DeepCollectionEquality().hash(_availableLanguages),
    const DeepCollectionEquality().hash(_availableCollation),
    const DeepCollectionEquality().hash(_availableProviders),
    companyName,
    companyAddress,
    companyPhoneNumber,
    companyEmail,
    const DeepCollectionEquality().hash(_userFields),
  ]);

  /// Create a copy of InstallModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstallModelImplCopyWith<_$InstallModelImpl> get copyWith =>
      __$$InstallModelImplCopyWithImpl<_$InstallModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstallModelImplToJson(this);
  }
}

abstract class _InstallModel implements InstallModel {
  factory _InstallModel({
    @JsonKey(name: 'SelectedLanguage', includeIfNull: false)
    final String? selectedLanguage,
    @JsonKey(name: 'AdminEmail', includeIfNull: false) final String? adminEmail,
    @JsonKey(name: 'AdminPassword', includeIfNull: false)
    final String? adminPassword,
    @JsonKey(name: 'ConfirmPassword', includeIfNull: false)
    final String? confirmPassword,
    @JsonKey(name: 'DatabaseConnectionString', includeIfNull: false)
    final String? databaseConnectionString,
    @JsonKey(name: 'DataProvider', includeIfNull: false)
    final DbProvider? dataProvider,
    @JsonKey(name: 'ConnectionInfo', includeIfNull: false)
    final bool? connectionInfo,
    @JsonKey(name: 'MongoDBServerName', includeIfNull: false)
    final String? mongoDBServerName,
    @JsonKey(name: 'MongoDBDatabaseName', includeIfNull: false)
    final String? mongoDBDatabaseName,
    @JsonKey(name: 'MongoDBUsername', includeIfNull: false)
    final String? mongoDBUsername,
    @JsonKey(name: 'MongoDBPassword', includeIfNull: false)
    final String? mongoDBPassword,
    @JsonKey(name: 'DisableSampleDataOption', includeIfNull: false)
    final bool? disableSampleDataOption,
    @JsonKey(name: 'InstallSampleData', includeIfNull: false)
    final bool? installSampleData,
    @JsonKey(name: 'Installed', includeIfNull: false) final bool? installed,
    @JsonKey(name: 'Collation', includeIfNull: false) final String? collation,
    @JsonKey(name: 'AvailableLanguages', includeIfNull: false)
    final List<SelectListItem>? availableLanguages,
    @JsonKey(name: 'AvailableCollation', includeIfNull: false)
    final List<SelectListItem>? availableCollation,
    @JsonKey(name: 'AvailableProviders', includeIfNull: false)
    final List<SelectListItem>? availableProviders,
    @JsonKey(name: 'CompanyName', includeIfNull: false)
    final String? companyName,
    @JsonKey(name: 'CompanyAddress', includeIfNull: false)
    final String? companyAddress,
    @JsonKey(name: 'CompanyPhoneNumber', includeIfNull: false)
    final String? companyPhoneNumber,
    @JsonKey(name: 'CompanyEmail', includeIfNull: false)
    final String? companyEmail,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$InstallModelImpl;

  factory _InstallModel.fromJson(Map<String, dynamic> json) =
      _$InstallModelImpl.fromJson;

  @override
  @JsonKey(name: 'SelectedLanguage', includeIfNull: false)
  String? get selectedLanguage;
  @override
  @JsonKey(name: 'AdminEmail', includeIfNull: false)
  String? get adminEmail;
  @override
  @JsonKey(name: 'AdminPassword', includeIfNull: false)
  String? get adminPassword;
  @override
  @JsonKey(name: 'ConfirmPassword', includeIfNull: false)
  String? get confirmPassword;
  @override
  @JsonKey(name: 'DatabaseConnectionString', includeIfNull: false)
  String? get databaseConnectionString;
  @override
  @JsonKey(name: 'DataProvider', includeIfNull: false)
  DbProvider? get dataProvider;
  @override
  @JsonKey(name: 'ConnectionInfo', includeIfNull: false)
  bool? get connectionInfo;
  @override
  @JsonKey(name: 'MongoDBServerName', includeIfNull: false)
  String? get mongoDBServerName;
  @override
  @JsonKey(name: 'MongoDBDatabaseName', includeIfNull: false)
  String? get mongoDBDatabaseName;
  @override
  @JsonKey(name: 'MongoDBUsername', includeIfNull: false)
  String? get mongoDBUsername;
  @override
  @JsonKey(name: 'MongoDBPassword', includeIfNull: false)
  String? get mongoDBPassword;
  @override
  @JsonKey(name: 'DisableSampleDataOption', includeIfNull: false)
  bool? get disableSampleDataOption;
  @override
  @JsonKey(name: 'InstallSampleData', includeIfNull: false)
  bool? get installSampleData;
  @override
  @JsonKey(name: 'Installed', includeIfNull: false)
  bool? get installed;
  @override
  @JsonKey(name: 'Collation', includeIfNull: false)
  String? get collation;
  @override
  @JsonKey(name: 'AvailableLanguages', includeIfNull: false)
  List<SelectListItem>? get availableLanguages;
  @override
  @JsonKey(name: 'AvailableCollation', includeIfNull: false)
  List<SelectListItem>? get availableCollation;
  @override
  @JsonKey(name: 'AvailableProviders', includeIfNull: false)
  List<SelectListItem>? get availableProviders;
  @override
  @JsonKey(name: 'CompanyName', includeIfNull: false)
  String? get companyName;
  @override
  @JsonKey(name: 'CompanyAddress', includeIfNull: false)
  String? get companyAddress;
  @override
  @JsonKey(name: 'CompanyPhoneNumber', includeIfNull: false)
  String? get companyPhoneNumber;
  @override
  @JsonKey(name: 'CompanyEmail', includeIfNull: false)
  String? get companyEmail;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of InstallModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstallModelImplCopyWith<_$InstallModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
