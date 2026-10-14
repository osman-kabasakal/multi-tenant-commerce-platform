import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/navigator/signup_route_result.dart';
import 'package:store_user_app/core/models/network/api_response.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/deeplink/deeplink_service.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/customer/register_model/register_model.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';
import 'package:store_user_app/presentation/form_builders/register_model_form_builder.dart';
import 'package:store_user_app/presentation/screens/signup/view_models/signup_view_model.dart';

part 'signup_controller.g.dart';

@riverpod
class SignupController extends _$SignupController
    with CacheInvalidationBase, CacheAwareAsyncFamilyProvider<SignupViewModel> {
  final formKey = GlobalKey<FormState>();

  late AppRouter _appRouter;
  late AccountRepository _customerRepository;
  late AuthService _authService;
  bool isDisposed = false;

  @override
  Future<SignupViewModel> build(String? returnUrl) async {
    await registerCorrelation();

    _appRouter = getIt<AppRouter>();
    _authService = await getIt.getAsync<AuthService>();
    _customerRepository = await getIt.getAsync<AccountRepository>();
    ref.onDispose(
      () {
        isDisposed = true;
      },
    );

    return _initialState((await _getInitialStateModel(true)).data!);
  }

  Future<ApiResponse<RegisterModel>> _getInitialStateModel(
      [bool tryAgain = false]) async {
    var registerMOdel =
        await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async => await _customerRepository.getAccountRegister(),
    );

    if (registerMOdel != null) {
      if (registerMOdel.data != null) {
        return registerMOdel;
      } else if (tryAgain &&
          registerMOdel.isRedirectResponse &&
          registerMOdel.redirect!.redirectUri!.hasQuery &&
          registerMOdel.redirect!.redirectUri!.queryParameters
              .containsKey('routeName') &&
          registerMOdel.redirect!.redirectUri!.queryParameters['routeName'] ==
              'HomePage') {
        var cookieManager = getIt.get<CookieManager>();
        await cookieManager.cookieJar.deleteAll();
        await _authService.refreshToken();
        return _getInitialStateModel(false);
      }
    }

    throw Exception('Register Model is null');
  }

  SignupViewModel _initialState(RegisterModel registerModel) {
    var formBuilder = RegisterModelFormBuilder(registerModel);
    var formController = AppFormController<RegisterModel>(
      formBuilder.build(),
      onFieldFocusChange: fieldOnChange,
      onDispose: () {
        if (!isDisposed) {
          // state = AsyncValue.data(_initialState(registerModel));
        }
      },
    );

    formController.setValidator('ConfirmPassword', (value) {
      if (value != formController.getFieldState('Password')!.value) {
        return 'Password does not match';
      }
      return null;
    });

    return SignupViewModel(
      formController: formController,
      formBuilder: formBuilder,
      returnUrl: returnUrl,
      registerModel: registerModel,
    );
  }

  Future<void> formSubmit() async {
    state = AsyncValue.loading();
    if (state.requireValue.formController.submit()) {
      var values = state.requireValue.formController.getValues();
      var registerModel = RegisterModel.fromJson(values);
      try {
        var registerResponse =
            await _customerRepository.postAccountRegister(registerModel, '');
        if (registerResponse != null) {
          if (registerResponse.redirect != null) {
            if(registerResponse.redirect!.redirectUri!=null) {
              var redirectUriSplit = registerResponse.redirect!.redirectUri!
                  .toString().split("/").where((x) => x.isNotEmpty).toList();
              if (redirectUriSplit.length > 1) {
                var controller = redirectUriSplit[redirectUriSplit.length-2];
                var resultId = int.tryParse(redirectUriSplit[redirectUriSplit.length-1]);

                if (controller == "registerresult") {
                  if (resultId != null && resultId > 1) {
                    await _authService.logout();
                    await _authService.guestLogin();
                    if (resultId == 2) {
                      //EmailValidationRequired show success register message but say check your email

                      state = AsyncValue.data(state.requireValue.copyWith(
                        registrationResultId: resultId,
                        registrationResultMessage: 'Kayıt başarılı! Hesabınızı doğrulamak için lütfen e-postanızı kontrol edin.',
                        showRegistrationResult: true,
                      ));
                      return;
                    } else if (resultId == 3) {
                      //AdminApprovalRequired show success register message but say check your email
                      state = AsyncValue.data(state.requireValue.copyWith(
                        registrationResultId: resultId,
                        registrationResultMessage: 'Kayıt başarılı! Hesabınız yönetici onayı bekliyor. Onaylandığında e-posta alacaksınız.',
                        showRegistrationResult: true,
                      ));
                      return;
                    } else if (resultId == 4) {
                      //RegistrationDisabled show fail message
                      state = AsyncValue.data(state.requireValue.copyWith(
                        registrationResultId: resultId,
                        registrationResultMessage: 'Kayıt işlemi şu anda devre dışı. Lütfen destek ile iletişime geçin.',
                        showRegistrationResult: true,
                      ));
                      return;
                    }
                  }
                }
              }
            }
            await _authService.login(
                registerModel.email!, registerModel.password!);
            goToProfileScreen(SignupRouteResult.success);
          } else if (registerResponse.data != null) {
            state = AsyncValue.data(_initialState(registerResponse.data!));
          }
        } else {
          state = AsyncValue.data(state.requireValue);
        }
      } catch (e) {
        state = AsyncValue.data(state.requireValue.copyWith(submitError: ''));
        var firstNode =
            state.requireValue.formController.fields.firstOrNull?.name;
        if (firstNode != null) {
          state.requireValue.formController.setFocus(firstNode);
        }
      }
    } else {
      state = AsyncValue.data(state.requireValue);
    }
  }

  void goToProfileScreen(SignupRouteResult result) {
    if (returnUrl != null) {
      _appRouter.replacePath(returnUrl!);
      return;
    }
    _appRouter.maybePop<SignupRouteResult>(result);
  }

  String? lastFocusedFieldName;

  void fieldOnChange(String fieldName, bool hasFocus) {
    if (hasFocus) {
      lastFocusedFieldName = fieldName;
    } else if (!state.requireValue.formController.getValues().keys.any(
        (fieldName) => state.requireValue.formController
            .getFocusNode(fieldName)
            .hasFocus)) {
      var values = state.requireValue.formController.getValues();
      var fieldNames = values.keys.toList();
      var focusNodeIndex = fieldNames.indexOf(fieldName);
      if (focusNodeIndex < values.length - 1) {
        state.requireValue.formController
            .setFocus(fieldNames.elementAt(focusNodeIndex + 1));
      }
    }
  }

  void goToSignInScreen() {
    if (returnUrl != null) {
      _appRouter.replace(SigninRoute(returnUrl: returnUrl));
      return;
    }

    _appRouter.maybePop(SignupRouteResult.redirectToLogin);
  }
}
