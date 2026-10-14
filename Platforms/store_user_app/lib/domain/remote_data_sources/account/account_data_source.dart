import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/customer/LoginModel/loginModel.dart';
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

part 'account_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class AccountDataSource {
  @factoryMethod
  factory AccountDataSource(Dio dio) {
    return _AccountDataSource(dio);
  }

  @GET('/Account/Auctions')
  @Extra({'responseType': ApiResponse<CustomerAuctionsModel>()})
  Future<ApiResponse<CustomerAuctionsModel>> getAccountAuctions();

  @GET('/Account/Notes')
  @Extra({'responseType': ApiResponse<CustomerNotesModel>()})
  Future<ApiResponse<CustomerNotesModel>> getAccountNotes();

  @GET('/Account/Documents')
  @Extra({'responseType': ApiResponse<DocumentsModel>()})
  Future<ApiResponse<DocumentsModel>> getAccountDocuments(
    @Field('command') DocumentPagingModel command,
  );

  @GET('/Account/Reviews')
  @Extra({'responseType': ApiResponse<CustomerProductReviewsModel>()})
  Future<ApiResponse<CustomerProductReviewsModel>> getAccountReviews();

  @GET('/Account/Courses')
  @Extra({'responseType': ApiResponse<CoursesModel>()})
  Future<ApiResponse<CoursesModel>> getAccountCourses();

  @GET('/Account/PasswordRecovery')
  @Extra({'responseType': ApiResponse<PasswordRecoveryModel>()})
  Future<ApiResponse<PasswordRecoveryModel>> getAccountPasswordRecovery();

  @POST('/Account/PasswordRecovery')
  @Extra({'responseType': ApiResponse<PasswordRecoveryModel>(), 'csrf': true})
  Future<ApiResponse<PasswordRecoveryModel>> postAccountPasswordRecovery(
    @Body() PasswordRecoveryModel model,
  );

  @GET('/Account/PasswordRecoveryConfirm')
  @Extra({'responseType': ApiResponse<PasswordRecoveryConfirmModel>()})
  Future<ApiResponse<PasswordRecoveryConfirmModel>>
  getAccountPasswordRecoveryConfirm(
    @Query('token') String token,
    @Query('email') String email,
  );

  @POST('/Account/PasswordRecoveryConfirm')
  @Extra({
    'responseType': ApiResponse<PasswordRecoveryConfirmModel>(),
    'csrf': true,
  })
  Future<ApiResponse<PasswordRecoveryConfirmModel>>
  postAccountPasswordRecoveryConfirm(
    @Body() PasswordRecoveryConfirmModel model,
  );

  @GET('/Account/Login')
  Future<LoginModel> getAccountLogin(
    @Query('checkoutAsGuest') bool checkoutAsGuest,
  );

  @GET('/Account/Register')
  @Extra({'responseType': ApiResponse<RegisterModel>()})
  Future<ApiResponse<RegisterModel>> getAccountRegister();

  @POST('/Account/Register')
  @Extra({'responseType': ApiResponse<RegisterModel>(), 'csrf': true})
  Future<ApiResponse<RegisterModel>> postAccountRegister(
    @Body() RegisterModel model,
    @Query('returnUrl') String? returnUrl,
  );

  @POST('/Account/CheckUsernameAvailability')
  @Extra({'responseType': ApiResponse<AnonymousType_AF73D8D8>(), 'csrf': true})
  Future<ApiResponse<AnonymousType_AF73D8D8>>
  postAccountCheckUsernameAvailability(@Query('username') String username);

  @GET('/Account/AccountActivation')
  @Extra({'responseType': ApiResponse<AccountActivationModel>()})
  Future<ApiResponse<AccountActivationModel>> getAccountAccountActivation(
    @Query('token') String token,
    @Query('email') String email,
  );

  @GET('/Account/Info')
  @Extra({'responseType': ApiResponse<CustomerInfoModel>()})
  Future<ApiResponse<CustomerInfoModel>> getAccountInfo();

  @POST('/Account/Info')
  @Extra({'responseType': ApiResponse<CustomerInfoModel>(), 'csrf': true})
  Future<ApiResponse<CustomerInfoModel>> postAccountInfo(
    @Body() CustomerInfoModel model,
  );

  @POST('/Account/RemoveExternalAssociation')
  @Extra({'responseType': ApiResponse<AnonymousType_FA6C6C9F>(), 'csrf': true})
  Future<ApiResponse<AnonymousType_FA6C6C9F>>
  postAccountRemoveExternalAssociation(@Query('id') String id);

  @GET('/Account/Export')
  Future<dynamic> getAccountExport();

  @GET('/Account/Addresses')
  @Extra({'responseType': ApiResponse<CustomerAddressListModel>()})
  Future<ApiResponse<CustomerAddressListModel>> getAccountAddresses();

  @POST('/Account/AddressDelete')
  @Extra({'responseType': ApiResponse<AnonymousType_FA6C6C9F>(), 'csrf': true})
  Future<ApiResponse<AnonymousType_FA6C6C9F>> postAccountAddressDelete(
    @Query('addressId') String addressId,
  );

  @GET('/Account/AddressAdd')
  @Extra({'responseType': ApiResponse<CustomerAddressEditModel>()})
  Future<ApiResponse<CustomerAddressEditModel>> getAccountAddressAdd();

  @POST('/Account/AddressAdd')
  @Extra({
    'responseType': ApiResponse<CustomerAddressEditModel>(),
    'csrf': true,
  })
  Future<ApiResponse<CustomerAddressEditModel>> postAccountAddressAdd(
    @Body() CustomerAddressEditModel model,
  );

  @GET('/Account/AddressEdit')
  @Extra({'responseType': ApiResponse<CustomerAddressEditModel>()})
  Future<ApiResponse<CustomerAddressEditModel>> getAccountAddressEdit(
    @Query('addressId') String addressId,
  );

  @POST('/Account/AddressEdit')
  @Extra({
    'responseType': ApiResponse<CustomerAddressEditModel>(),
    'csrf': true,
  })
  Future<ApiResponse<CustomerAddressEditModel>> postAccountAddressEdit(
    @Body() CustomerAddressEditModel model,
  );

  @GET('/Account/DownloadableProducts')
  @Extra({'responseType': ApiResponse<CustomerDownloadableProductsModel>()})
  Future<ApiResponse<CustomerDownloadableProductsModel>>
  getAccountDownloadableProducts();

  @GET('/Account/UserAgreement')
  Future<dynamic> getAccountUserAgreement(
    @Query('orderItemId') String orderItemId,
  );

  @GET('/Account/ChangePassword')
  @Extra({'responseType': ApiResponse<ChangePasswordModel>()})
  Future<ApiResponse<ChangePasswordModel>> getAccountChangePassword();

  @POST('/Account/ChangePassword')
  @Extra({'responseType': ApiResponse<ChangePasswordModel>(), 'csrf': true})
  Future<ApiResponse<ChangePasswordModel>> postAccountChangePassword(
    @Body() ChangePasswordModel model,
  );

  @GET('/Account/DeleteAccount')
  @Extra({'responseType': ApiResponse<DeleteAccountModel>()})
  Future<ApiResponse<DeleteAccountModel>> getAccountDeleteAccount();

  @POST('/Account/DeleteAccount')
  @Extra({'responseType': ApiResponse<DeleteAccountModel>(), 'csrf': true})
  Future<ApiResponse<DeleteAccountModel>> postAccountDeleteAccount(
    @Body() DeleteAccountModel model,
  );

  @GET('/Account/SubAccounts')
  @Extra({'responseType': ApiResponse<List<SubAccountSimpleModel>>()})
  Future<ApiResponse<List<SubAccountSimpleModel>>> getAccountSubAccounts();

  @GET('/Account/SubAccountAdd')
  @Extra({'responseType': ApiResponse<SubAccountCreateModel>()})
  Future<ApiResponse<SubAccountCreateModel>> getAccountSubAccountAdd();

  @POST('/Account/SubAccountAdd')
  @Extra({'responseType': ApiResponse<SubAccountCreateModel>(), 'csrf': true})
  Future<ApiResponse<SubAccountCreateModel>> postAccountSubAccountAdd(
    @Body() SubAccountCreateModel model,
  );

  @GET('/Account/SubAccountEdit')
  @Extra({'responseType': ApiResponse<SubAccountEditModel>()})
  Future<ApiResponse<SubAccountEditModel>> getAccountSubAccountEdit(
    @Query('id') String id,
  );

  @POST('/Account/SubAccountEdit')
  @Extra({'responseType': ApiResponse<SubAccountEditModel>(), 'csrf': true})
  Future<ApiResponse<SubAccountEditModel>> postAccountSubAccountEdit(
    @Body() SubAccountEditModel model,
  );

  @POST('/Account/SubAccountDelete')
  @Extra({'responseType': ApiResponse<AnonymousType_50E263DC>(), 'csrf': true})
  Future<ApiResponse<AnonymousType_50E263DC>> postAccountSubAccountDelete(
    @Query('id') String id,
  );
}
