import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/domain/entities/models/checkout/update_section_json_model/update_section_json_model.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/network/api_response.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_model/checkout_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/shopping_cart_model/shopping_cart_model.dart';
import 'package:store_user_app/domain/repositories/checkout/checkout_repository.dart';
import 'package:store_user_app/domain/usecases/shopping_cart/shopping_cart_use_case.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/auth/auth_step.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/billing/billing_step_command.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/completed/completed_step_command.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/confirm/confirm_step_command.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/fail/fail_step_command.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/payment_info/payment_info_step_command.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/payment_method/payment_method_step_command.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/redirect/redirect_step_command.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/shipping/shipping_step_command.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_steps/shipping_method/shipping_method_step_command.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';

import '../view_models/checkout_step.dart';
import '../view_models/checkout_step_response.dart';

part 'checkout_controller.g.dart';

abstract class CheckoutCommand<TModel> {
  TModel getModelWithStepResponse(CheckoutStepResponse? stepResponse);

  // Her komut bir sonraki adımı döndürür veya null dönerek akışı bitirir
  Future<CheckoutStepResponse?> execute(
      CheckoutState context,
      Map<String, dynamic>? model,
      );

  Widget stepContent(TModel model, CheckOutRouteData routeData);
}

@riverpod
class CheckoutController extends _$CheckoutController {
  late Map<CheckoutStep, CheckoutCommand> commands;
  late CheckoutRepository apiClient;
  late AppRouter _router;

  @override
  FutureOr<CheckoutState> build(CheckOutRouteData checkoutRouteData) async {
    _initializeCommands();
    apiClient = await getIt.getAsync<CheckoutRepository>();
    _router = getIt<AppRouter>();
    _setupAuthStateListener();
    return await _getInitialState();
  }

  void _initializeCommands() {
    commands = {
      CheckoutStep.authentication: ref.read(authStepProvider.notifier),
      CheckoutStep.billingAddress: ref.read(
        billingStepCommandProvider.notifier,
      ),
      CheckoutStep.shippingAddress: ref.read(
        shippingStepCommandProvider.notifier,
      ),
      CheckoutStep.shippingMethod: ref.read(
        shippingMethodStepCommandProvider.notifier,
      ),
      CheckoutStep.paymentMethod: ref.read(
        paymentMethodStepCommandProvider.notifier,
      ),
      CheckoutStep.paymentInfo: ref.read(
        paymentInfoStepCommandProvider.notifier,
      ),
      CheckoutStep.confirmOrder: ref.read(confirmStepCommandProvider.notifier),
      CheckoutStep.completed: ref.read(completedStepCommandProvider.notifier),
      CheckoutStep.redirected: ref.read(redirectStepCommandProvider.notifier),
      CheckoutStep.fail: ref.read(failStepCommandProvider.notifier),
    };
  }

  void _setupAuthStateListener() {
    ref.onDispose(() {
      _disposeCommands();
    });
  }

  void _disposeCommands() {
    ref.invalidate(authStepProvider);
    ref.invalidate(billingStepCommandProvider);
    ref.invalidate(shippingStepCommandProvider);
    ref.invalidate(shippingMethodStepCommandProvider);
    ref.invalidate(paymentMethodStepCommandProvider);
    ref.invalidate(paymentInfoStepCommandProvider);
    ref.invalidate(confirmStepCommandProvider);
    ref.invalidate(completedStepCommandProvider);
    ref.invalidate(redirectStepCommandProvider);
    ref.invalidate(failStepCommandProvider);
  }

  Future<CheckoutState> _getInitialState() async {
    var cartModel = ref.read(
      shoppingCartUseCaseProvider.select(
            (p) => p.requireValue.cart ?? ShoppingCartModel(),
      ),
    );

    if (cartModel.items?.isEmpty ?? true) {
      return _createFailState(cartModel);
    }

    try {
      var checkoutModel = await apiClient.getCheckoutStart();
      return await _processCheckoutModel(checkoutModel, cartModel);
    } catch (e) {
      return _createFailState(cartModel);
    }
  }

  CheckoutState _createFailState(ShoppingCartModel cartModel) {
    return CheckoutState(
      currentStep: CheckoutStep.fail,
      cart: cartModel,
      routeData: checkoutRouteData,
    );
  }

  Future<CheckoutState> _processCheckoutModel(
      ApiResponse<CheckoutModel>? checkoutModel,
      ShoppingCartModel cartModel,
      ) async {
    if (checkoutModel == null ||
        (checkoutModel.data == null && !checkoutModel.isRedirectResponse)) {
      return _createFailState(cartModel);
    }

    if (checkoutModel.isRedirectResponse) {
      return _handleRedirectResponse(checkoutModel, cartModel);
    }

    return _createInitialState(checkoutModel.data!, cartModel);
  }

  CheckoutState _handleRedirectResponse(
      ApiResponse<CheckoutModel> checkoutModel,
      ShoppingCartModel cartModel,
      ) {
    if (checkoutModel.redirect?.responseStatus == 401) {
      return CheckoutState(
        currentStep: CheckoutStep.authentication,
        cart: cartModel,
        routeData: checkoutRouteData,
      );
    }

    if ((checkoutModel.redirect!.redirectUri?.path.toLowerCase().contains(
      'route',
    ) ??
        false) &&
        checkoutModel.redirect!.redirectUri?.queryParameters['routeName'] ==
            'ShoppingCart') {
      _router.pushAndPopUntil(
        CartRoute(),
        predicate: (route) => route.settings.name == HomeRoute.name,
      );

      return _createFailState(cartModel);
    }

    if (!(checkoutModel.redirect!.redirectUri?.path.toLowerCase().contains(
      'login',
    ) ??
        false)) {
      return _createFailState(cartModel);
    }

    return CheckoutState(
      currentStep: CheckoutStep.authentication,
      cart: cartModel,
      routeData: checkoutRouteData,
    );
  }

  CheckoutState _createInitialState(
      CheckoutModel checkoutData,
      ShoppingCartModel cartModel,
      ) {
    return CheckoutState(
      currentStep:
      checkoutRouteData.requireAuthorization
          ? CheckoutStep.authentication
          : (checkoutData.shippingRequired ?? false)
          ? CheckoutStep.shippingAddress
          : CheckoutStep.billingAddress,
      cart: cartModel,
      checkoutModel: checkoutData,
      routeData: checkoutRouteData,
      currentStepResponse:
      checkoutRouteData.requireAuthorization
          ? null
          : (checkoutData.shippingRequired ?? false)
          ? CheckoutStepResponse(
        goToSection: CheckoutStep.shippingAddress.name,
        UpdateSection: UpdateSectionJsonModel(
          name: CheckoutStep.shippingAddress.name,
          model: jsonDecode(jsonEncode(checkoutData.shippingAddress)),
        ),
      )
          : CheckoutStepResponse(
        goToSection: CheckoutStep.billingAddress.name,
        UpdateSection: UpdateSectionJsonModel(
          name: CheckoutStep.billingAddress.name,
          model: jsonDecode(jsonEncode(checkoutData.billingAddress)),
        ),
      ),
    );
  }

  Future<void> execute(Map<String, dynamic>? model) async {
    state = const AsyncValue.loading();

    if (!commands.containsKey(state.requireValue.currentStep)) {
      state = AsyncValue.error('Invalid step', StackTrace.current);
      return;
    }

    try {
      // Check if there's an error in the model
      if (model != null &&
          model.containsKey('error') &&
          model['error'] == true) {
        // Create a checkout step response with error information
        final errorResponse = CheckoutStepResponse(
          error: 1,
          message:
          model['message'] as String? ??
              'Ödeme işlemi sırasında bir hata oluştu.',
        );

        // Transition to fail step
        state = AsyncValue.data(
          state.requireValue.copyWith(
            currentStep: CheckoutStep.fail,
            currentStepResponse: errorResponse,
          ),
        );
        return;
      }

      // Normal execution flow
      var currentCommand = commands[state.requireValue.currentStep]!;
      var response = await currentCommand.execute(state.requireValue, model);
      await _handleCommandResponse(response);
    } catch (e, stack) {
      // Create error response for unhandled exceptions
      final errorResponse = CheckoutStepResponse(
        error: 1,
        message: 'Beklenmeyen bir hata oluştu: ${e.toString()}',
      );

      // Transition to fail step
      state = AsyncValue.data(
        state.requireValue.copyWith(
          currentStep: CheckoutStep.fail,
          currentStepResponse: errorResponse,
        ),
      );

      LoggerService.error('Checkout execution error', e, stack);
    }
  }

  Future<void> _handleCommandResponse(CheckoutStepResponse? response) async {
    if (response == null) {
      return;
    }

    getIt.get<EventBus>().publish(
      EntityCreatedEvent<CheckoutStepResponse>(entity: response!),
    );

    if (response.success == 1) {
      _handleSuccessResponse();
      return;
    }

    if (response.error == 1 &&
        (response.UpdateSection != null || response.goToSection != null)) {
      _handleErrorResponse();
      return;
    }

    if (response.redirect != null) {
      _handleRedirectState(response);
      return;
    }

    await _handleStepTransition(response);
  }

  void _handleSuccessResponse() {
    state = AsyncValue.data(
      state.requireValue.copyWith(
        currentStep: CheckoutStep.completed,
        currentStepResponse: state.requireValue.currentStepResponse,
      ),
    );
  }

  void _handleErrorResponse() {
    state = AsyncValue.data(
      state.requireValue.copyWith(
        currentStep: state.requireValue.currentStep,
        currentStepResponse: state.requireValue.currentStepResponse,
      ),
    );
  }

  void _handleRedirectState(CheckoutStepResponse response) {
    state = AsyncValue.data(
      state.requireValue.copyWith(
        currentStep: CheckoutStep.redirected,
        currentStepResponse: response,
      ),
    );
  }

  Future<void> _handleStepTransition(CheckoutStepResponse response) async {
    var nextStep = _determineNextStep(response);
    if (nextStep != null && nextStep != CheckoutStep.unknown) {
      state = AsyncValue.data(
        state.requireValue.copyWith(
          currentStep: nextStep,
          currentStepResponse: response,
        ),
      );
    } else {
      state = AsyncValue.data(
        state.requireValue.copyWith(
          currentStep: CheckoutStep.fail,
          currentStepResponse: response,
        ),
      );
    }
  }

  CheckoutStep? _determineNextStep(CheckoutStepResponse response) {
    if (response.goToSection != null) {
      return CheckoutStep.fromString(
        response.goToSection!.replaceAll('_', '-'),
      );
    }

    if (response.UpdateSection?.name != null) {
      return CheckoutStep.fromString(response.UpdateSection!.name!);
    }

    return null;
  }

  Widget currentStepContent() {
    if (!commands.containsKey(state.requireValue.currentStep)) {
      return const Center(child: Text('To be implemented'));
    }

    var currentCommand = commands[state.requireValue.currentStep]!;
    return currentCommand.stepContent(
      currentCommand.getModelWithStepResponse(
        state.requireValue.currentStepResponse,
      ),
      checkoutRouteData,
    );
  }
}
