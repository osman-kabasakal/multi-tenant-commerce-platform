// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'install_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstallModelImpl _$$InstallModelImplFromJson(Map<String, dynamic> json) =>
    _$InstallModelImpl(
      selectedLanguage: json['SelectedLanguage'] as String?,
      adminEmail: json['AdminEmail'] as String?,
      adminPassword: json['AdminPassword'] as String?,
      confirmPassword: json['ConfirmPassword'] as String?,
      databaseConnectionString: json['DatabaseConnectionString'] as String?,
      dataProvider:
          $enumDecodeNullable(_$DbProviderEnumMap, json['DataProvider']) ??
          DbProvider.mongoDB,
      connectionInfo: json['ConnectionInfo'] as bool? ?? false,
      mongoDBServerName: json['MongoDBServerName'] as String?,
      mongoDBDatabaseName: json['MongoDBDatabaseName'] as String?,
      mongoDBUsername: json['MongoDBUsername'] as String?,
      mongoDBPassword: json['MongoDBPassword'] as String?,
      disableSampleDataOption:
          json['DisableSampleDataOption'] as bool? ?? false,
      installSampleData: json['InstallSampleData'] as bool? ?? false,
      installed: json['Installed'] as bool? ?? false,
      collation: json['Collation'] as String?,
      availableLanguages:
          (json['AvailableLanguages'] as List<dynamic>?)
              ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      availableCollation:
          (json['AvailableCollation'] as List<dynamic>?)
              ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      availableProviders:
          (json['AvailableProviders'] as List<dynamic>?)
              ?.map((e) => SelectListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      companyName: json['CompanyName'] as String?,
      companyAddress: json['CompanyAddress'] as String?,
      companyPhoneNumber: json['CompanyPhoneNumber'] as String?,
      companyEmail: json['CompanyEmail'] as String?,
      userFields:
          (json['UserFields'] as List<dynamic>?)
              ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$InstallModelImplToJson(
  _$InstallModelImpl instance,
) => <String, dynamic>{
  if (instance.selectedLanguage case final value?) 'SelectedLanguage': value,
  if (instance.adminEmail case final value?) 'AdminEmail': value,
  if (instance.adminPassword case final value?) 'AdminPassword': value,
  if (instance.confirmPassword case final value?) 'ConfirmPassword': value,
  if (instance.databaseConnectionString case final value?)
    'DatabaseConnectionString': value,
  if (_$DbProviderEnumMap[instance.dataProvider] case final value?)
    'DataProvider': value,
  if (instance.connectionInfo case final value?) 'ConnectionInfo': value,
  if (instance.mongoDBServerName case final value?) 'MongoDBServerName': value,
  if (instance.mongoDBDatabaseName case final value?)
    'MongoDBDatabaseName': value,
  if (instance.mongoDBUsername case final value?) 'MongoDBUsername': value,
  if (instance.mongoDBPassword case final value?) 'MongoDBPassword': value,
  if (instance.disableSampleDataOption case final value?)
    'DisableSampleDataOption': value,
  if (instance.installSampleData case final value?) 'InstallSampleData': value,
  if (instance.installed case final value?) 'Installed': value,
  if (instance.collation case final value?) 'Collation': value,
  if (instance.availableLanguages case final value?)
    'AvailableLanguages': value,
  if (instance.availableCollation case final value?)
    'AvailableCollation': value,
  if (instance.availableProviders case final value?)
    'AvailableProviders': value,
  if (instance.companyName case final value?) 'CompanyName': value,
  if (instance.companyAddress case final value?) 'CompanyAddress': value,
  if (instance.companyPhoneNumber case final value?)
    'CompanyPhoneNumber': value,
  if (instance.companyEmail case final value?) 'CompanyEmail': value,
  if (instance.userFields case final value?) 'UserFields': value,
};

const _$DbProviderEnumMap = {
  DbProvider.mongoDB: 0,
  DbProvider.cosmosDB: 1,
  DbProvider.documentDB: 2,
  DbProvider.liteDB: 3,
};
