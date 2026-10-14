import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:auto_route/auto_route.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_updated_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/domain/entities/catalog/attribute_control_type/attribute_control_type.dart';
import 'package:store_user_app/domain/entities/microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';
import 'package:store_user_app/domain/entities/models/custom_attribute_model/custom_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_attribute_model/customer_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_attribute_value_model/customer_attribute_value_model.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/services/form/app_form_controller.dart';
import '../../../../core/services/form/form_builder.dart';
import '../../../../core/services/form/form_field.dart';
import '../../../../core/config/theme/theme.dart';
import '../../../../core/utils/extensions/string_extensions.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/theme/theme_controller.dart';

import '../../../../domain/entities/models/customer/customer_info_model/customer_info_model.dart';
import '../../../../domain/repositories/account/account_repository.dart';

import '../../../widgets/app/widgets/app_error_widget.dart';
import '../../../widgets/app/widgets/app_widget.dart';
import '../../../widgets/buttons/view/app_common_button.dart';
import '../../../widgets/form/widgets/generic_form.dart';

@RoutePage()
class AccountInfoScreen extends HookConsumerWidget {
  final CustomerInfoModel customerInfoModel;

  const AccountInfoScreen({super.key, required this.customerInfoModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeController themeController = getIt<ThemeController>();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final isDarkMode = themeController.isDarkMode;
    final accountRepository = useMemoized(() => getIt<AccountRepository>(), []);
    final cacheManager = useMemoized(() => getIt<CacheManager>(), []);

    // Setting up form controller
    final formBuilder = useMemoized(
        () => _buildFormFields(customerInfoModel), [customerInfoModel]);

    final formController = useMemoized(
        () => AppFormController<CustomerInfoModel>(
              formBuilder.build(),
              onFieldChange: (name, value) {
                // Clear error message when user edits form
                if (errorMessage.value != null) {
                  errorMessage.value = null;
                }
              },
            ),
        [formBuilder]);

    // Handle form submission
    Future<void> handleSubmit() async {
      if (!formController.submit()) {
        return;
      }

      isLoading.value = true;
      errorMessage.value = null;

      try {
        final formValues = formController.getValues();
        final updatedCustomerInfo =
            _createUpdatedCustomerInfo(customerInfoModel, formValues);

        final response =
            await accountRepository.postAccountInfo(updatedCustomerInfo);

        await cacheManager.removeByPrefix(
            accountRepository.generateCachePrefixForRemoval('/Account'));
        getIt<EventBus>().publish(EntityUpdatedEvent<CustomerInfoModel>(
            entity: (await accountRepository.getAccountInfo())?.data! ??
                customerInfoModel,
            oldEntity: customerInfoModel));
        if (response != null) {
          if (response.data != null) {
            context.router.maybePop();
          } else if (response.redirect != null &&
              response.redirect!.redirectUri != null &&
              response.redirect!.redirectUri!.queryParameters['routeName'] ==
                  'CustomerInfo') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Bilgileriniz başarıyla güncellendi',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
                backgroundColor: colorPrimary,
                duration: Duration(seconds: 2),
              ),
            );
            context.router.maybePop();
          } else {
            errorMessage.value = 'Bilgileriniz güncellenirken bir hata oluştu';
          }
        } else {
          errorMessage.value = 'Bilgileriniz güncellenirken bir hata oluştu';
        }
      } catch (e) {
        errorMessage.value = 'Bir hata oluştu: ${e.toString()}';
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        titleText: 'Hesap Bilgilerim',
        backgroundColor: isDarkMode ? darkPrimary : Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error message if any
                if (errorMessage.value != null)
                  AppErrorWidget(
                    message: errorMessage.value!,
                    type: ErrorType.error,
                    isDismissible: true,
                  ),

                // Form
                _buildPersonalDetailsCard(context, formController, formBuilder),
                SizedBox(height: 16),

                // Company details if enabled
                if (customerInfoModel.companyEnabled == true ||
                    customerInfoModel.displayVatNumber == true)
                  _buildCompanyDetailsCard(
                      context, formController, formBuilder),

                // Address details if any enabled
                if (_shouldShowAddressCard(customerInfoModel))
                  _buildAddressCard(
                      context, formController, formBuilder, customerInfoModel),

                // Contact information if enabled
                if (customerInfoModel.phoneEnabled == true ||
                    customerInfoModel.faxEnabled == true)
                  _buildContactInfoCard(context, formController, formBuilder),

                // Newsletter and customer attributes
                if (customerInfoModel.newsletterEnabled == true ||
                    (customerInfoModel.customerAttributes?.isNotEmpty ?? false))
                  _buildOptionsCard(
                      context, formController, formBuilder, customerInfoModel),

                // External auth if available
                if ((customerInfoModel
                            .numberOfExternalAuthenticationProviders ??
                        0) >
                    0)
                  _buildExternalAuthCard(context, customerInfoModel),

                // Save button
                SizedBox(height: 24),
                AppCommonButton(
                  text: save,
                  onPressed: isLoading.value ? null : handleSubmit,
                  width: double.infinity,
                  height: 50,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),

          // Loading indicator
          if (isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDarkMode ? Colors.white : colorPrimary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Check if the address card should be shown
  bool _shouldShowAddressCard(CustomerInfoModel model) {
    return model.streetAddressEnabled == true ||
        model.streetAddress2Enabled == true ||
        model.zipPostalCodeEnabled == true ||
        model.cityEnabled == true ||
        model.countryEnabled == true;
  }

  // Build the personal details card
  Widget _buildPersonalDetailsCard(
      BuildContext context,
      AppFormController<CustomerInfoModel> controller,
      FormBuilder<CustomerInfoModel> formBuilder) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Card(
      color: isDarkMode ? cardDark : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? borderDark : borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kişisel Bilgileriniz',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : textColor,
                  ),
            ),
            const SizedBox(height: 16),

            // Gender field if enabled
            if (customerInfoModel.genderEnabled == true)
              _buildGenderField(context, controller, formBuilder),

            // First name and Last name
            Row(
              children: [
                Expanded(
                  child: _getFormField(controller, 'FirstName'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _getFormField(controller, 'LastName'),
                ),
              ],
            ),

            // Date of birth if enabled
            if (customerInfoModel.dateOfBirthEnabled == true)
              _getFormField(controller, 'DateOfBirth'),

            // Email
            _getFormField(controller, 'Email'),

            // Username if enabled
            if (customerInfoModel.usernamesEnabled == true)
              _buildUsernameField(
                  context, controller, formBuilder, customerInfoModel),
          ],
        ),
      ),
    );
  }

  // Build company details card
  Widget _buildCompanyDetailsCard(
      BuildContext context,
      AppFormController<CustomerInfoModel> controller,
      FormBuilder<CustomerInfoModel> formBuilder) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Card(
      color: isDarkMode ? cardDark : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? borderDark : borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Şirket Bilgileri',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : textColor,
                  ),
            ),
            const SizedBox(height: 16),

            // Company field if enabled
            if (customerInfoModel.companyEnabled == true)
              _getFormField(controller, 'Company'),

            // VAT number if enabled
            if (customerInfoModel.displayVatNumber == true)
              _getFormField(controller, 'VatNumber'),
          ],
        ),
      ),
    );
  }

  // Build address card
  Widget _buildAddressCard(
      BuildContext context,
      AppFormController<CustomerInfoModel> controller,
      FormBuilder<CustomerInfoModel> formBuilder,
      CustomerInfoModel model) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Card(
      color: isDarkMode ? cardDark : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? borderDark : borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adres Bilgileriniz',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : textColor,
                  ),
            ),
            const SizedBox(height: 16),

            // Street address fields
            if (model.streetAddressEnabled == true ||
                model.streetAddress2Enabled == true)
              Row(
                children: [
                  if (model.streetAddressEnabled == true)
                    Expanded(
                      child: _getFormField(controller, 'StreetAddress'),
                    ),
                  if (model.streetAddressEnabled == true &&
                      model.streetAddress2Enabled == true)
                    SizedBox(width: 12),
                  if (model.streetAddress2Enabled == true)
                    Expanded(
                      child: _getFormField(controller, 'StreetAddress2'),
                    ),
                ],
              ),

            // Zip code and city
            if (model.zipPostalCodeEnabled == true || model.cityEnabled == true)
              Row(
                children: [
                  if (model.zipPostalCodeEnabled == true)
                    Expanded(
                      child: _getFormField(controller, 'ZipPostalCode'),
                    ),
                  if (model.zipPostalCodeEnabled == true &&
                      model.cityEnabled == true)
                    SizedBox(width: 12),
                  if (model.cityEnabled == true)
                    Expanded(
                      child: _getFormField(controller, 'City'),
                    ),
                ],
              ),

            // Country and state
            if (model.countryEnabled == true)
              _getFormField(controller, 'CountryId'),

            if (model.countryEnabled == true &&
                model.stateProvinceEnabled == true)
              _getFormField(controller, 'StateProvinceId'),
          ],
        ),
      ),
    );
  }

  // Build contact information card
  Widget _buildContactInfoCard(
      BuildContext context,
      AppFormController<CustomerInfoModel> controller,
      FormBuilder<CustomerInfoModel> formBuilder) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Card(
      color: isDarkMode ? cardDark : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? borderDark : borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'İletişim Bilgileriniz',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : textColor,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (customerInfoModel.phoneEnabled == true)
                  Expanded(
                    child: _getFormField(controller, 'Phone'),
                  ),
                if (customerInfoModel.phoneEnabled == true &&
                    customerInfoModel.faxEnabled == true)
                  SizedBox(width: 12),
                if (customerInfoModel.faxEnabled == true)
                  Expanded(
                    child: _getFormField(controller, 'Fax'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build options card for newsletter and customer attributes
  Widget _buildOptionsCard(
      BuildContext context,
      AppFormController<CustomerInfoModel> controller,
      FormBuilder<CustomerInfoModel> formBuilder,
      CustomerInfoModel model) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Card(
      color: isDarkMode ? cardDark : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? borderDark : borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tercihleriniz',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : textColor,
                  ),
            ),
            const SizedBox(height: 16),

            // Newsletter
            if (model.newsletterEnabled == true)
              _getFormField(controller, 'Newsletter'),

            // Newsletter categories if newsletter enabled
            if (model.newsletterEnabled == true &&
                model.newsletter == true &&
                (model.newsletterCategories?.isNotEmpty ?? false))
              _buildNewsletterCategories(
                  context, controller, formBuilder, model),

            // Customer attributes
            if (model.customerAttributes?.isNotEmpty ?? false)
              _buildCustomerAttributes(context, controller, formBuilder, model),
          ],
        ),
      ),
    );
  }

  // Build external authentication card
  Widget _buildExternalAuthCard(BuildContext context, CustomerInfoModel model) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Card(
      color: isDarkMode ? cardDark : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? borderDark : borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dış Kimlik Doğrulama',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : textColor,
                  ),
            ),
            const SizedBox(height: 16),

            // External auth records
            if (model.associatedExternalAuthRecords?.isNotEmpty ?? false)
              _buildExternalAuthTable(context, model),

            // Add more records text
            if ((model.numberOfExternalAuthenticationProviders ?? 0) >
                (model.associatedExternalAuthRecords?.length ?? 0))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Daha fazla dış kimlik doğrulama ekleyebilirsiniz',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Build external auth records table
  Widget _buildExternalAuthTable(
      BuildContext context, CustomerInfoModel model) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode ? borderDark : borderColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            isDarkMode ? Colors.black26 : Colors.grey[100],
          ),
          dataRowColor: WidgetStateProperty.all(
            isDarkMode ? cardDark : Colors.white,
          ),
          columns: [
            DataColumn(
              label: Text(
                'Yöntem',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : textColor,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'E-posta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : textColor,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'ID',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : textColor,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Kaldır',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : textColor,
                ),
              ),
            ),
          ],
          rows: model.associatedExternalAuthRecords?.map((auth) {
                return DataRow(
                  cells: [
                    DataCell(Text(
                      auth.authMethodName ?? '',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    )),
                    DataCell(Text(
                      auth.email ?? '',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    )),
                    DataCell(Text(
                      (auth.externalIdentifier?.length ?? 0) > 40
                          ? '${auth.externalIdentifier?.substring(0, 37)}...'
                          : auth.externalIdentifier ?? '',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    )),
                    DataCell(
                      InkWell(
                        onTap: () => _removeExternalAuth(auth.id ?? ''),
                        child: Text(
                          'Kaldır',
                          style: TextStyle(
                            color: colorPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList() ??
              [],
        ),
      ),
    );
  }

  // Build gender selection
  Widget _buildGenderField(
      BuildContext context,
      AppFormController<CustomerInfoModel> controller,
      FormBuilder<CustomerInfoModel> formBuilder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _getFormField(controller, 'Gender'),
    );
  }

  // Build username field - either editable or readonly
  Widget _buildUsernameField(
      BuildContext context,
      AppFormController<CustomerInfoModel> controller,
      FormBuilder<CustomerInfoModel> formBuilder,
      CustomerInfoModel model) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    if (model.allowUsersToChangeUsernames == true) {
      return _getFormField(controller, 'Username');
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kullanıcı Adı:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(textFieldRadius),
                border: Border.all(
                  color: isDarkMode ? borderDark : borderColor,
                ),
                color: isDarkMode ? Colors.black26 : Colors.grey[100],
              ),
              child: Text(
                model.username ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : textColor,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Build newsletter categories
  Widget _buildNewsletterCategories(
      BuildContext context,
      AppFormController<CustomerInfoModel> controller,
      FormBuilder<CustomerInfoModel> formBuilder,
      CustomerInfoModel model) {
    final themeController = getIt<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Bülten Kategorileri',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : textColor,
            ),
          ),
        ),
        Column(
          children: model.newsletterCategories?.map((category) {
                return _getFormField(
                    controller, 'NewsletterCategory_${category.id}');
              }).toList() ??
              [],
        ),
      ],
    );
  }

  // Build customer attributes
  Widget _buildCustomerAttributes(
      BuildContext context,
      AppFormController<CustomerInfoModel> controller,
      FormBuilder<CustomerInfoModel> formBuilder,
      CustomerInfoModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: model.customerAttributes?.map((attribute) {
            return _getFormField(
                controller, 'customer_attribute_${attribute.id}');
          }).toList() ??
          [],
    );
  }

  // Helper method to get a form field by name
  Widget _getFormField(
      AppFormController<CustomerInfoModel> controller, String fieldName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GenericForm<CustomerInfoModel>(
        formController: AppFormController<CustomerInfoModel>(
          [controller.fields.firstWhere((field) => field.name == fieldName)],
          onFieldChange: controller.updateField,
        ),
        formBuilder: FormBuilder<CustomerInfoModel>(customerInfoModel),
      ),
    );
  }

  // Remove external auth method
  Future<void> _removeExternalAuth(String id) async {
    final accountRepository = getIt<AccountRepository>();
    try {
      final result =
          await accountRepository.postAccountRemoveExternalAssociation(id);
      if (result != null &&
          result.data != null &&
          result.data!.success == true) {
        // Handle success - perhaps refresh the screen
      }
    } catch (e) {
      // Handle error
      print('Error removing external auth: $e');
    }
  }

  // Build form fields
  FormBuilder<CustomerInfoModel> _buildFormFields(CustomerInfoModel model) {
    final formBuilder = FormBuilder<CustomerInfoModel>(model);

    // Personal details
    if (model.genderEnabled == true) {
      formBuilder.addRadioGroupField<String, SelectListItem, String>(
        'Gender',
        (m) => m.gender ?? '',
        (m) => [
          SelectListItem(value: 'M', text: 'Erkek', selected: m.gender == 'M'),
          SelectListItem(value: 'F', text: 'Kadın', selected: m.gender == 'F'),
        ],
        (item) => item.text ?? '',
        (item) => item.value ?? '',
        label: 'Cinsiyet',
      );
    }

    formBuilder.addField(
      'FirstName',
      (m) => m.firstName,
      label: 'Ad',
      isRequired: model.firstLastNameRequired ?? false,
      validation: (value) =>
          (value as String?)?.validateText('Ad alanı gereklidir'),
    );

    formBuilder.addField(
      'LastName',
      (m) => m.lastName,
      label: 'Soyad',
      isRequired: model.firstLastNameRequired ?? false,
      validation: (value) =>
          (value as String?)?.validateText('Soyad alanı gereklidir'),
    );

    if (model.dateOfBirthEnabled == true) {
      formBuilder.addField(
        'DateOfBirth',
        (m) => m.dateOfBirthDay != null &&
                m.dateOfBirthMonth != null &&
                m.dateOfBirthYear != null
            ? DateTime(
                m.dateOfBirthYear!, m.dateOfBirthMonth!, m.dateOfBirthDay!)
            : null,
        label: 'Doğum Tarihi',
        isRequired: model.dateOfBirthRequired ?? false,
        type: FormFieldType.date,
        validation: (value) =>
            model.dateOfBirthRequired == true && value == null
                ? 'Doğum tarihi gereklidir'
                : null,
      );
    }

    formBuilder.addField(
      'Email',
      (m) => m.email,
      label: 'E-posta',
      isRequired: true,
      type: FormFieldType.email,
      readonly: !(model.allowUsersToChangeEmail ?? false),
      validation: (value) {
        if (value == null || value.isEmpty) {
          return 'E-posta alanı gereklidir';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Geçerli bir e-posta adresi giriniz';
        }
        return null;
      },
    );

    if (model.usernamesEnabled == true) {
      formBuilder.addField(
        'Username',
        (m) => m.username,
        label: 'Kullanıcı Adı',
        isRequired: true,
        readonly: model.allowUsersToChangeUsernames != true,
        validation: (value) =>
            (value as String?)?.validateText('Kullanıcı adı gereklidir'),
      );
    }

    // Company fields
    if (model.companyEnabled == true) {
      formBuilder.addField(
        'Company',
        (m) => m.company,
        label: 'Şirket',
        isRequired: model.companyRequired ?? false,
        validation: (value) =>
            model.companyRequired == true && (value == null || value.isEmpty)
                ? 'Şirket adı gereklidir'
                : null,
      );
    }

    if (model.displayVatNumber == true) {
      formBuilder.addField(
        'VatNumber',
        (m) => m.vatNumber,
        label: 'Vergi Numarası',
      );
    }

    // Address fields
    if (model.streetAddressEnabled == true) {
      formBuilder.addField(
        'StreetAddress',
        (m) => m.streetAddress,
        label: 'Adres',
        isRequired: model.streetAddressRequired ?? false,
        validation: (value) => model.streetAddressRequired == true &&
                (value == null || value.isEmpty)
            ? 'Adres gereklidir'
            : null,
      );
    }

    if (model.streetAddress2Enabled == true) {
      formBuilder.addField(
        'StreetAddress2',
        (m) => m.streetAddress2,
        label: 'Adres 2',
        isRequired: model.streetAddress2Required ?? false,
        validation: (value) => model.streetAddress2Required == true &&
                (value == null || value.isEmpty)
            ? 'Adres 2 gereklidir'
            : null,
      );
    }

    if (model.zipPostalCodeEnabled == true) {
      formBuilder.addField(
        'ZipPostalCode',
        (m) => m.zipPostalCode,
        label: 'Posta Kodu',
        isRequired: model.zipPostalCodeRequired ?? false,
        validation: (value) => model.zipPostalCodeRequired == true &&
                (value == null || value.isEmpty)
            ? 'Posta kodu gereklidir'
            : null,
      );
    }

    if (model.cityEnabled == true) {
      formBuilder.addField(
        'City',
        (m) => m.city,
        label: 'Şehir',
        isRequired: model.cityRequired ?? false,
        validation: (value) =>
            model.cityRequired == true && (value == null || value.isEmpty)
                ? 'Şehir gereklidir'
                : null,
      );
    }

    if (model.countryEnabled == true) {
      formBuilder.addDropDownField<String?, SelectListItem, String>(
        'CountryId',
        (m) => m.countryId,
        (m) => m.availableCountries ?? [],
        (item) => item.text ?? '',
        (item) => item.value ?? '',
        label: 'Ülke',
        isRequired: model.countryRequired ?? false,
      );
    }

    if (model.countryEnabled == true && model.stateProvinceEnabled == true) {
      formBuilder.addDropDownField<String?, SelectListItem, String>(
        'StateProvinceId',
        (m) => m.stateProvinceId,
        (m) => m.availableStates ?? [],
        (item) => item.text ?? '',
        (item) => item.value ?? '',
        label: 'İl',
        isRequired: model.stateProvinceRequired ?? false,
      );
    }

    // Contact fields
    if (model.phoneEnabled == true) {
      formBuilder.addField(
        'Phone',
        (m) => m.phone,
        label: 'Telefon',
        type: FormFieldType.phone,
        isRequired: model.phoneRequired ?? false,
        validation: (value) =>
            model.phoneRequired == true && (value == null || value.isEmpty)
                ? 'Telefon numarası gereklidir'
                : null,
      );
    }

    if (model.faxEnabled == true) {
      formBuilder.addField(
        'Fax',
        (m) => m.fax,
        label: 'Faks',
        isRequired: model.faxRequired ?? false,
        validation: (value) =>
            model.faxRequired == true && (value == null || value.isEmpty)
                ? 'Faks numarası gereklidir'
                : null,
      );
    }

    // Newsletter
    if (model.newsletterEnabled == true) {
      formBuilder.addSwitchField(
        'Newsletter',
        'Bülten aboneliği',
        (m) => m.newsletter ?? false,
      );
    }

    // Newsletter categories
    if (model.newsletterEnabled == true &&
        (model.newsletterCategories?.isNotEmpty ?? false)) {
      for (var category in model.newsletterCategories ?? []) {
        formBuilder.addField(
          'NewsletterCategory_${category.id}',
          (m) =>
              model.selectedNewsletterCategory?.contains(category.id ?? '') ??
              false,
          label: category.name ?? '',
          type: FormFieldType.checkbox,
        );
      }
    }

    // Customer attributes
    if (model.customerAttributes?.isNotEmpty ?? false) {
      for (var attribute in model.customerAttributes ?? []) {
        _addCustomerAttributeField(formBuilder, attribute, model);
      }
    }

    return formBuilder;
  }

  // Add customer attribute field based on attribute type
  void _addCustomerAttributeField(FormBuilder<CustomerInfoModel> formBuilder,
      CustomerAttributeModel attribute, CustomerInfoModel model) {
    switch (attribute.attributeControlType) {
      case AttributeControlType.dropdownList:
        formBuilder
            .addDropDownField<String?, CustomerAttributeValueModel, String>(
          'customer_attribute_${attribute.id}',
          (m) => _getSelectedAttributeValue(attribute.id ?? '', m),
          (m) => attribute.values ?? [],
          (item) => item.name ?? '',
          (item) => item.id ?? '',
          label: attribute.name ?? '',
          isRequired: attribute.isRequired ?? false,
        );
        break;

      case AttributeControlType.radioList:
        formBuilder
            .addRadioGroupField<String?, CustomerAttributeValueModel, String>(
          'customer_attribute_${attribute.id}',
          (m) => _getSelectedAttributeValue(attribute.id ?? '', m),
          (m) => attribute.values ?? [],
          (item) => item.name ?? '',
          (item) => item.id ?? '',
          label: attribute.name ?? '',
          isRequired: attribute.isRequired ?? false,
        );
        break;

      case AttributeControlType.checkboxes:
      case AttributeControlType.readonlyCheckboxes:
        formBuilder.addCheckboxGroupField<List<String>,
            CustomerAttributeValueModel, String>(
          'customer_attribute_${attribute.id}',
          (m) => _getSelectedAttributeValues(attribute.id ?? '', m),
          (m) => attribute.values ?? [],
          (item) => item.name ?? '',
          (item) => item.id ?? '',
          label: attribute.name ?? '',
          isRequired: attribute.isRequired ?? false,
          readonly: attribute.isReadOnly ?? false,
        );
        break;

      case AttributeControlType.textBox:
        formBuilder.addField(
          'customer_attribute_${attribute.id}',
          (m) => _getAttributeDefaultValue(attribute.id ?? '', m),
          label: attribute.name ?? '',
          isRequired: attribute.isRequired ?? false,
          readonly: attribute.isReadOnly ?? false,
          validation: (value) =>
              attribute.isRequired == true && (value == null || value.isEmpty)
                  ? '${attribute.name} gereklidir'
                  : null,
        );
        break;

      case AttributeControlType.multilineTextbox:
        formBuilder.addMultilineTextField(
          'customer_attribute_${attribute.id}',
          (m) => _getAttributeDefaultValue(attribute.id ?? '', m),
          label: attribute.name ?? '',
          isRequired: attribute.isRequired ?? false,
          readonly: attribute.isReadOnly ?? false,
          validation: (value) =>
              attribute.isRequired == true && (value == null || value.isEmpty)
                  ? '${attribute.name} gereklidir'
                  : null,
        );
        break;

      case AttributeControlType.datepicker:
        formBuilder.addField(
          'customer_attribute_${attribute.id}',
          (m) => _parseAttributeDateValue(attribute.id ?? '', m),
          label: attribute.name ?? '',
          type: FormFieldType.date,
          isRequired: attribute.isRequired ?? false,
          readonly: attribute.isReadOnly ?? false,
          validation: (value) => attribute.isRequired == true && value == null
              ? '${attribute.name} gereklidir'
              : null,
        );
        break;

      default:
        // Other attribute types can be handled as needed
        break;
    }
  }

  // Helper to get selected attribute value
  String? _getSelectedAttributeValue(
      String attributeId, CustomerInfoModel model) {
    final attribute = model.selectedAttributes?.firstWhere(
      (attr) => attr.key == attributeId,
      orElse: () => CustomAttributeModel(),
    );
    return attribute?.value;
  }

  // Helper to get selected attribute values (for checkboxes)
  List<String> _getSelectedAttributeValues(
      String attributeId, CustomerInfoModel model) {
    final attribute = model.selectedAttributes?.firstWhere(
      (attr) => attr.key == attributeId,
      orElse: () => CustomAttributeModel(),
    );
    if (attribute?.value == null) return [];
    return attribute!.value!.split(',');
  }

  // Helper to get attribute default value
  String? _getAttributeDefaultValue(
      String attributeId, CustomerInfoModel model) {
    final customerAttribute = model.customerAttributes?.firstWhere(
      (attr) => attr.id == attributeId,
      orElse: () => CustomerAttributeModel(),
    );
    return customerAttribute?.defaultValue;
  }

  // Helper to parse date value from attribute
  DateTime? _parseAttributeDateValue(
      String attributeId, CustomerInfoModel model) {
    final value = _getAttributeDefaultValue(attributeId, model);
    if (value == null) return null;

    try {
      return DateTime.parse(value);
    } catch (e) {
      return null;
    }
  }

  // Create updated customer info model from form values
  CustomerInfoModel _createUpdatedCustomerInfo(
      CustomerInfoModel originalModel, Map<String, dynamic> formValues) {
    // Create a copy of the original model
    var updatedModel = CustomerInfoModel.fromJson(originalModel.toJson());

    // Update basic fields
    updatedModel = updatedModel.copyWith(
      firstName: formValues['FirstName'],
      lastName: formValues['LastName'],
      email: formValues['Email'],
    );

    if (originalModel.genderEnabled == true) {
      updatedModel = updatedModel.copyWith(gender: formValues['Gender']);
    }

    if (originalModel.dateOfBirthEnabled == true) {
      final birthDate = formValues['DateOfBirth'] as DateTime?;
      if (birthDate != null) {
        updatedModel = updatedModel.copyWith(
          dateOfBirthDay: birthDate.day,
          dateOfBirthMonth: birthDate.month,
          dateOfBirthYear: birthDate.year,
        );
      }
    }

    if (originalModel.usernamesEnabled == true &&
        originalModel.allowUsersToChangeUsernames == true) {
      updatedModel = updatedModel.copyWith(username: formValues['Username']);
    }

    // Company info
    if (originalModel.companyEnabled == true) {
      updatedModel = updatedModel.copyWith(company: formValues['Company']);
    }

    if (originalModel.displayVatNumber == true) {
      updatedModel = updatedModel.copyWith(vatNumber: formValues['VatNumber']);
    }

    // Address info
    if (originalModel.streetAddressEnabled == true) {
      updatedModel =
          updatedModel.copyWith(streetAddress: formValues['StreetAddress']);
    }

    if (originalModel.streetAddress2Enabled == true) {
      updatedModel =
          updatedModel.copyWith(streetAddress2: formValues['StreetAddress2']);
    }

    if (originalModel.zipPostalCodeEnabled == true) {
      updatedModel =
          updatedModel.copyWith(zipPostalCode: formValues['ZipPostalCode']);
    }

    if (originalModel.cityEnabled == true) {
      updatedModel = updatedModel.copyWith(city: formValues['City']);
    }

    if (originalModel.countryEnabled == true) {
      updatedModel = updatedModel.copyWith(countryId: formValues['CountryId']);
    }

    if (originalModel.countryEnabled == true &&
        originalModel.stateProvinceEnabled == true) {
      updatedModel =
          updatedModel.copyWith(stateProvinceId: formValues['StateProvinceId']);
    }

    // Contact info
    if (originalModel.phoneEnabled == true) {
      updatedModel = updatedModel.copyWith(phone: formValues['Phone']);
    }

    if (originalModel.faxEnabled == true) {
      updatedModel = updatedModel.copyWith(fax: formValues['Fax']);
    }

    // Newsletter
    if (originalModel.newsletterEnabled == true) {
      updatedModel =
          updatedModel.copyWith(newsletter: formValues['Newsletter']);

      // Newsletter categories
      if (originalModel.newsletterCategories?.isNotEmpty ?? false) {
        var selectedCategories = <String>[];
        for (var category in originalModel.newsletterCategories ?? []) {
          final selected =
              formValues['NewsletterCategory_${category.id}'] as bool?;
          if (selected == true) {
            selectedCategories.add(category.id ?? '');
          }
        }

        updatedModel = updatedModel.copyWith(
            selectedNewsletterCategory: selectedCategories);
      }
    }

    // Customer attributes
    if (originalModel.customerAttributes?.isNotEmpty ?? false) {
      var selectedAttributes = <CustomAttributeModel>[];

      for (var attribute in originalModel.customerAttributes ?? []) {
        final key = 'customer_attribute_${attribute.id}';
        final value = formValues[key];

        if (value != null) {
          String stringValue;

          if (value is List) {
            stringValue = value.join(',');
          } else if (value is DateTime) {
            stringValue = value.toIso8601String();
          } else {
            stringValue = value.toString();
          }

          selectedAttributes
              .add(CustomAttributeModel(key: attribute.id, value: stringValue));
        }
      }
      updatedModel =
          updatedModel.copyWith(selectedAttributes: selectedAttributes);
    }

    return updatedModel;
  }
}
