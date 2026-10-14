import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../db_provider/db_provider.dart';

import '../../../microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';

import '../../../common/user_field/user_field.dart';

part 'install_model.freezed.dart';
part 'install_model.g.dart';

@freezed
class InstallModel extends StoreJsonSerializable<InstallModel>
    with _$InstallModel {
  factory InstallModel(
      {@JsonKey(name: 'SelectedLanguage', includeIfNull: false)
      String? selectedLanguage,
      @JsonKey(name: 'AdminEmail', includeIfNull: false) String? adminEmail,
      @JsonKey(name: 'AdminPassword', includeIfNull: false)
      String? adminPassword,
      @JsonKey(name: 'ConfirmPassword', includeIfNull: false)
      String? confirmPassword,
      @JsonKey(name: 'DatabaseConnectionString', includeIfNull: false)
      String? databaseConnectionString,
      @JsonKey(name: 'DataProvider', includeIfNull: false)
      @Default(DbProvider.mongoDB)
      DbProvider? dataProvider,
      @JsonKey(name: 'ConnectionInfo', includeIfNull: false)
      @Default(false)
      bool? connectionInfo,
      @JsonKey(name: 'MongoDBServerName', includeIfNull: false)
      String? mongoDBServerName,
      @JsonKey(name: 'MongoDBDatabaseName', includeIfNull: false)
      String? mongoDBDatabaseName,
      @JsonKey(name: 'MongoDBUsername', includeIfNull: false)
      String? mongoDBUsername,
      @JsonKey(name: 'MongoDBPassword', includeIfNull: false)
      String? mongoDBPassword,
      @JsonKey(name: 'DisableSampleDataOption', includeIfNull: false)
      @Default(false)
      bool? disableSampleDataOption,
      @JsonKey(name: 'InstallSampleData', includeIfNull: false)
      @Default(false)
      bool? installSampleData,
      @JsonKey(name: 'Installed', includeIfNull: false)
      @Default(false)
      bool? installed,
      @JsonKey(name: 'Collation', includeIfNull: false) String? collation,
      @JsonKey(name: 'AvailableLanguages', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableLanguages,
      @JsonKey(name: 'AvailableCollation', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableCollation,
      @JsonKey(name: 'AvailableProviders', includeIfNull: false)
      @Default([])
      List<SelectListItem>? availableProviders,
      @JsonKey(name: 'CompanyName', includeIfNull: false) String? companyName,
      @JsonKey(name: 'CompanyAddress', includeIfNull: false)
      String? companyAddress,
      @JsonKey(name: 'CompanyPhoneNumber', includeIfNull: false)
      String? companyPhoneNumber,
      @JsonKey(name: 'CompanyEmail', includeIfNull: false) String? companyEmail,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _InstallModel;

  factory InstallModel.fromJson(Map<String, dynamic> json) =>
      _$InstallModelFromJson(json);
}
