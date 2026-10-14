import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/navigator/signup_route_result.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/customer/LoginModel/loginModel.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';
import 'package:store_user_app/presentation/form_builders/login_model_form_builder.dart';
import 'package:store_user_app/presentation/screens/signin/view_models/signin_view_model.dart';

part 'signin_screen_controller.g.dart';

@riverpod
class SigninScreenController extends _$SigninScreenController
    with CacheInvalidationBase, CacheAwareAsyncFamilyProvider<SigninViewModel> {
  final formKey = GlobalKey<FormState>();

  late AppRouter _appRouter;
  late AccountRepository _customerRepository;
  late AuthService _authService;

  @override
  FutureOr<SigninViewModel> build(String? returnUrl) async {
    await registerCorrelation();
    _appRouter = getIt<AppRouter>();
    _authService = await getIt.getAsync<AuthService>();
    _customerRepository = await getIt.getAsync<AccountRepository>();

    return _initialState((await _getInitialStateModel()));
  }

  Future<LoginModel> _getInitialStateModel() async {
    var registerMOdel = await correlationService
        .runRepositoryMethodWithCorrelation(
          correlationId,
          () async => await _customerRepository.getAccountLogin(true),
        );
    if (registerMOdel != null) {
      return registerMOdel;
    }
    throw Exception('Register Model is null');
  }

  SigninViewModel _initialState(LoginModel loginModel) {
    var formBuilder = LoginModelFormBuilder(loginModel);
    var formController = AppFormController<LoginModel>(
      formBuilder.build(),
      onFieldFocusChange: fieldOnChange,
    );
    ref.onDispose(() {
      // formController.dispose();
    });
    return SigninViewModel(
      formController: formController,
      formBuilder: formBuilder,
      returnUrl: returnUrl,
      loginModel: loginModel,
    );
  }

  String? lastFocusedFieldName;

  void fieldOnChange(String fieldName, bool hasFocus) {
    if (hasFocus) {
      lastFocusedFieldName = fieldName;
    } else if (!state.requireValue.formController.getValues().keys.any(
      (fieldName) =>
          state.requireValue.formController.getFocusNode(fieldName).hasFocus,
    )) {
      var values = state.requireValue.formController.getValues();
      var fieldNames = values.keys.toList();
      var focusNodeIndex = fieldNames.indexOf(fieldName);
      if (focusNodeIndex < values.length - 1) {
        state.requireValue.formController.setFocus(
          fieldNames.elementAt(focusNodeIndex + 1),
        );
      }
    }
  }

  Future<void> popWithResult(SigninRouteResult result) async {
    if (result == SigninRouteResult.redirectToSignup) {
      if (returnUrl != null) {
        await _appRouter.replace(SignupRoute(returnUrl: returnUrl));
        return;
      }
    }

    if (returnUrl != null) {
      await _appRouter.replaceNamed(returnUrl!);
      return;
    }

    if (result != SigninRouteResult.success &&
        result != SigninRouteResult.continueAsGuest) {
      await _appRouter.replaceNamed('/home');
      return;
    }

    await _appRouter.maybePop(result);
  }

  Future<void> formSubmit() async {
    // state = AsyncValue.data(state.requireValue.copyWith(processing: true));
    try {
      if (state.requireValue.formController.submit()) {
        var values = state.requireValue.formController.getValues();
        var loginModel = LoginModel.fromJson(values);
        try {
          var tokens = await _authService.login(
            loginModel.email!,
            loginModel.password!,
          );
          if (tokens == null) {
            state = AsyncValue.data(
              state.requireValue.copyWith(
                submitError:
                    'Kullanıcı adı veya şifreniz yanlış! Lütfen tekrar deneyin.',
                processing: false,
              ),
            );
            return;
          }
          await popWithResult(SigninRouteResult.success);
        } catch (e) {
          state = AsyncValue.data(
            state.requireValue.copyWith(
              submitError:
                  'Kullanıcı adı veya şifreniz yanlış! Lütfen tekrar deneyin.',
              processing: false,
            ),
          );
        }
      } else {
        state = AsyncValue.data(state.requireValue.copyWith(processing: false));
      }
    } catch (e) {
      state = AsyncValue.data(
        state.requireValue.copyWith(
          submitError: e.toString(),
          processing: false,
        ),
      );
    }
  }
}
