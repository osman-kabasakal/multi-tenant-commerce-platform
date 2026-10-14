import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';
import 'package:store_user_app/domain/entities/models/customer/LoginModel/loginModel.dart';

import '../../remote_data_sources/account/account_data_source.dart';
import '../../entities/models/customer/customer_auctions_model/customer_auctions_model.dart';
import '../../entities/models/customer/customer_notes_model/customer_notes_model.dart';
import '../../entities/models/customer/documents_model/documents_model.dart';
import '../../entities/models/customer/customer_product_reviews_model/customer_product_reviews_model.dart';
import '../../entities/models/customer/courses_model/courses_model.dart';
import '../../entities/models/customer/password_recovery_model/password_recovery_model.dart';
import '../../entities/models/customer/password_recovery_confirm_model/password_recovery_confirm_model.dart';
import '../../entities/models/customer/register_model/register_model.dart';
import '../../entities/anonymous_type__af73_d8_d8/anonymous_type__af73_d8_d8.dart';
import '../../entities/models/customer/account_activation_model/account_activation_model.dart';
import '../../entities/models/customer/customer_info_model/customer_info_model.dart';
import '../../entities/anonymous_type__fa6_c6_c9_f/anonymous_type__fa6_c6_c9_f.dart';
import '../../entities/models/customer/customer_address_list_model/customer_address_list_model.dart';
import '../../entities/models/customer/customer_address_edit_model/customer_address_edit_model.dart';
import '../../entities/models/customer/customer_downloadable_products_model/customer_downloadable_products_model.dart';
import '../../entities/models/customer/change_password_model/change_password_model.dart';
import '../../entities/models/customer/delete_account_model/delete_account_model.dart';
import '../../entities/models/customer/sub_account_simple_model/sub_account_simple_model.dart';
import '../../entities/models/customer/sub_account_create_model/sub_account_create_model.dart';
import '../../entities/models/customer/sub_account_edit_model/sub_account_edit_model.dart';
import '../../entities/anonymous_type_50_e263_dc/anonymous_type_50_e263_dc.dart';
import '../../entities/models/customer/document_paging_model/document_paging_model.dart';

@lazySingleton
class AccountRepository extends BaseRepository {
  final AccountDataSource _dataSource;

  AccountRepository(this._dataSource, super.decorator, super.eventBus);

  Future<ApiResponse<CustomerAuctionsModel>?> getAccountAuctions() async {
    return await decorator.execute<ApiResponse<CustomerAuctionsModel>>(
      operationName: "/Account/Auctions",
      cacheKey: generateCacheKey("/Account/Auctions", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountAuctions();
      },
    );
  }

  Future<ApiResponse<CustomerNotesModel>?> getAccountNotes() async {
    return await decorator.execute<ApiResponse<CustomerNotesModel>>(
      operationName: "/Account/Notes",
      cacheKey: generateCacheKey("/Account/Notes", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountNotes();
      },
    );
  }

  Future<ApiResponse<DocumentsModel>?> getAccountDocuments(
      DocumentPagingModel command) async {
    return await decorator.execute<ApiResponse<DocumentsModel>>(
      operationName: "/Account/Documents",
      cacheKey: generateCacheKey("/Account/Documents", [command]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountDocuments(command);
      },
    );
  }

  Future<ApiResponse<CustomerProductReviewsModel>?> getAccountReviews() async {
    return await decorator.execute<ApiResponse<CustomerProductReviewsModel>>(
      operationName: "/Account/Reviews",
      cacheKey: generateCacheKey("/Account/Reviews", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountReviews();
      },
    );
  }

  Future<ApiResponse<CoursesModel>?> getAccountCourses() async {
    return await decorator.execute<ApiResponse<CoursesModel>>(
      operationName: "/Account/Courses",
      cacheKey: generateCacheKey("/Account/Courses", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountCourses();
      },
    );
  }

  Future<ApiResponse<PasswordRecoveryModel>?>
  getAccountPasswordRecovery() async {
    return await decorator.execute<ApiResponse<PasswordRecoveryModel>>(
      operationName: "/Account/PasswordRecovery",
      cacheKey: null, //generateCacheKey("/Account/PasswordRecovery", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountPasswordRecovery();
      },
    );
  }

  Future<ApiResponse<PasswordRecoveryModel>?> postAccountPasswordRecovery(
      PasswordRecoveryModel model) async {
    return await decorator.execute<ApiResponse<PasswordRecoveryModel>>(
      operationName: "/Account/PasswordRecovery",
      cacheKey: null, //generateCacheKey("/Account/PasswordRecovery", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountPasswordRecovery(model);
      },
    );
  }

  Future<ApiResponse<PasswordRecoveryConfirmModel>?>
  getAccountPasswordRecoveryConfirm(String token, String email) async {
    return await decorator.execute<ApiResponse<PasswordRecoveryConfirmModel>>(
      operationName: "/Account/PasswordRecoveryConfirm",
      cacheKey: null,
      // generateCacheKey("/Account/PasswordRecoveryConfirm", [token, email]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountPasswordRecoveryConfirm(
            token, email);
      },
    );
  }

  Future<ApiResponse<PasswordRecoveryConfirmModel>?>
  postAccountPasswordRecoveryConfirm(
      PasswordRecoveryConfirmModel model) async {
    return await decorator.execute<ApiResponse<PasswordRecoveryConfirmModel>>(
      operationName: "/Account/PasswordRecoveryConfirm",
      cacheKey:
      null, //generateCacheKey("/Account/PasswordRecoveryConfirm", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountPasswordRecoveryConfirm(model);
      },
    );
  }

  Future<LoginModel?> getAccountLogin(bool checkoutAsGuest) async {
    return await decorator.execute<LoginModel>(
      operationName: "/Account/Login",
      cacheKey: null, //generateCacheKey("/Account/Register", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountLogin(checkoutAsGuest);
      },
    );
  }

  Future<ApiResponse<RegisterModel>?> getAccountRegister() async {
    return await decorator.execute<ApiResponse<RegisterModel>>(
      operationName: "/Account/Register",
      cacheKey: generateCacheKey("/Account/Register", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountRegister();
      },
    );
  }

  Future<ApiResponse<RegisterModel>?> postAccountRegister(
      RegisterModel model, String? returnUrl) async {
    return await decorator.execute<ApiResponse<RegisterModel>>(
      operationName: "/Account/Register",
      cacheKey:
      null, //generateCacheKey("/Account/Register", [model, returnUrl]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountRegister(model, returnUrl);
      },
    );
  }

  Future<ApiResponse<AnonymousType_AF73D8D8>?>
  postAccountCheckUsernameAvailability(String username) async {
    return await decorator.execute<ApiResponse<AnonymousType_AF73D8D8>>(
      operationName: "/Account/CheckUsernameAvailability",
      cacheKey: null,
      // generateCacheKey("/Account/CheckUsernameAvailability", [username]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountCheckUsernameAvailability(username);
      },
    );
  }

  Future<ApiResponse<AccountActivationModel>?> getAccountAccountActivation(
      String token, String email) async {
    return await decorator.execute<ApiResponse<AccountActivationModel>>(
      operationName: "/Account/AccountActivation",
      cacheKey:
      null, //generateCacheKey("/Account/AccountActivation", [token, email]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountAccountActivation(token, email);
      },
    );
  }

  Future<ApiResponse<CustomerInfoModel>?> getAccountInfo() async {
    return await decorator.execute<ApiResponse<CustomerInfoModel>>(
      operationName: "/Account/Info",
      cacheKey: generateCacheKey("/Account/Info", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountInfo();
      },
    );
  }

  Future<ApiResponse<CustomerInfoModel>?> postAccountInfo(
      CustomerInfoModel model) async {
    return await decorator.execute<ApiResponse<CustomerInfoModel>>(
      operationName: "/Account/Info",
      cacheKey: null, //generateCacheKey("/Account/Info", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountInfo(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_FA6C6C9F>?>
  postAccountRemoveExternalAssociation(String id) async {
    return await decorator.execute<ApiResponse<AnonymousType_FA6C6C9F>>(
      operationName: "/Account/RemoveExternalAssociation",
      cacheKey:
      null, //generateCacheKey("/Account/RemoveExternalAssociation", [id]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountRemoveExternalAssociation(id);
      },
    );
  }

  Future<dynamic> getAccountExport() async {
    return await decorator.execute<dynamic>(
      operationName: "/Account/Export",
      cacheKey: generateCacheKey("/Account/Export", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountExport();
      },
    );
  }

  Future<ApiResponse<CustomerAddressListModel>?> getAccountAddresses() async {
    return await decorator.execute<ApiResponse<CustomerAddressListModel>>(
      operationName: "/Account/Addresses",
      cacheKey: generateCacheKey("/Account/Addresses", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountAddresses();
      },
    );
  }

  Future<ApiResponse<AnonymousType_FA6C6C9F>?> postAccountAddressDelete(
      String addressId) async {
    return await decorator.execute<ApiResponse<AnonymousType_FA6C6C9F>>(
      operationName: "/Account/AddressDelete",
      cacheKey: null, //generateCacheKey("/Account/AddressDelete", [addressId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountAddressDelete(addressId);
      },
    );
  }

  Future<ApiResponse<CustomerAddressEditModel>?> getAccountAddressAdd() async {
    return await decorator.execute<ApiResponse<CustomerAddressEditModel>>(
      operationName: "/Account/AddressAdd",
      cacheKey: null, //generateCacheKey("/Account/AddressAdd", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountAddressAdd();
      },
    );
  }

  Future<ApiResponse<CustomerAddressEditModel>?> postAccountAddressAdd(
      CustomerAddressEditModel model) async {
    return await decorator.execute<ApiResponse<CustomerAddressEditModel>>(
      operationName: "/Account/AddressAdd",
      cacheKey: null, // generateCacheKey("/Account/AddressAdd", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountAddressAdd(model);
      },
    );
  }

  Future<ApiResponse<CustomerAddressEditModel>?> getAccountAddressEdit(
      String addressId) async {
    return await decorator.execute<ApiResponse<CustomerAddressEditModel>>(
      operationName: "/Account/AddressEdit",
      cacheKey: null, //generateCacheKey("/Account/AddressEdit", [addressId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountAddressEdit(addressId);
      },
    );
  }

  Future<ApiResponse<CustomerAddressEditModel>?> postAccountAddressEdit(
      CustomerAddressEditModel model) async {
    return await decorator.execute<ApiResponse<CustomerAddressEditModel>>(
      operationName: "/Account/AddressEdit",
      cacheKey: null, //generateCacheKey("/Account/AddressEdit", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountAddressEdit(model);
      },
    );
  }

  Future<ApiResponse<CustomerDownloadableProductsModel>?>
  getAccountDownloadableProducts() async {
    return await decorator
        .execute<ApiResponse<CustomerDownloadableProductsModel>>(
      operationName: "/Account/DownloadableProducts",
      cacheKey: null, //generateCacheKey("/Account/DownloadableProducts", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountDownloadableProducts();
      },
    );
  }

  Future<dynamic> getAccountUserAgreement(String orderItemId) async {
    return await decorator.execute<dynamic>(
      operationName: "/Account/UserAgreement",
      cacheKey:
      null, //generateCacheKey("/Account/UserAgreement", [orderItemId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountUserAgreement(orderItemId);
      },
    );
  }

  Future<ApiResponse<ChangePasswordModel>?> getAccountChangePassword() async {
    return await decorator.execute<ApiResponse<ChangePasswordModel>>(
      operationName: "/Account/ChangePassword",
      cacheKey: null, //generateCacheKey("/Account/ChangePassword", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountChangePassword();
      },
    );
  }

  Future<ApiResponse<ChangePasswordModel>?> postAccountChangePassword(
      ChangePasswordModel model) async {
    return await decorator.execute<ApiResponse<ChangePasswordModel>>(
      operationName: "/Account/ChangePassword",
      cacheKey: null, //generateCacheKey("/Account/ChangePassword", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountChangePassword(model);
      },
    );
  }

  Future<ApiResponse<DeleteAccountModel>?> getAccountDeleteAccount() async {
    return await decorator.execute<ApiResponse<DeleteAccountModel>>(
      operationName: "/Account/DeleteAccount",
      cacheKey: null, //generateCacheKey("/Account/DeleteAccount", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountDeleteAccount();
      },
    );
  }

  Future<ApiResponse<DeleteAccountModel>?> postAccountDeleteAccount(
      DeleteAccountModel model) async {
    return await decorator.execute<ApiResponse<DeleteAccountModel>>(
      operationName: "/Account/DeleteAccount",
      cacheKey: null, //generateCacheKey("/Account/DeleteAccount", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountDeleteAccount(model);
      },
    );
  }

  Future<ApiResponse<List<SubAccountSimpleModel>>?>
  getAccountSubAccounts() async {
    return await decorator.execute<ApiResponse<List<SubAccountSimpleModel>>>(
      operationName: "/Account/SubAccounts",
      cacheKey: generateCacheKey("/Account/SubAccounts", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountSubAccounts();
      },
    );
  }

  Future<ApiResponse<SubAccountCreateModel>?> getAccountSubAccountAdd() async {
    return await decorator.execute<ApiResponse<SubAccountCreateModel>>(
      operationName: "/Account/SubAccountAdd",
      cacheKey: generateCacheKey("/Account/SubAccountAdd", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountSubAccountAdd();
      },
    );
  }

  Future<ApiResponse<SubAccountCreateModel>?> postAccountSubAccountAdd(
      SubAccountCreateModel model) async {
    return await decorator.execute<ApiResponse<SubAccountCreateModel>>(
      operationName: "/Account/SubAccountAdd",
      cacheKey: null, //generateCacheKey("/Account/SubAccountAdd", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountSubAccountAdd(model);
      },
    );
  }

  Future<ApiResponse<SubAccountEditModel>?> getAccountSubAccountEdit(
      String id) async {
    return await decorator.execute<ApiResponse<SubAccountEditModel>>(
      operationName: "/Account/SubAccountEdit",
      cacheKey: generateCacheKey("/Account/SubAccountEdit", [id]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getAccountSubAccountEdit(id);
      },
    );
  }

  Future<ApiResponse<SubAccountEditModel>?> postAccountSubAccountEdit(
      SubAccountEditModel model) async {
    return await decorator.execute<ApiResponse<SubAccountEditModel>>(
      operationName: "/Account/SubAccountEdit",
      cacheKey: null, //generateCacheKey("/Account/SubAccountEdit", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountSubAccountEdit(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_50E263DC>?> postAccountSubAccountDelete(
      String id) async {
    return await decorator.execute<ApiResponse<AnonymousType_50E263DC>>(
      operationName: "/Account/SubAccountDelete",
      cacheKey: null, //generateCacheKey("/Account/SubAccountDelete", [id]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postAccountSubAccountDelete(id);
      },
    );
  }
}
