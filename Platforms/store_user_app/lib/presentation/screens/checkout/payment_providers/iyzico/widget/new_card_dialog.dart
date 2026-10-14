import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/form/card_type.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/input_formatters/card_number_formatter.dart';
import 'package:store_user_app/core/utils/input_formatters/expiry_date_formatter.dart';
import 'package:store_user_app/domain/entities/model/card/card.dart'
as iyzi_card;
import 'package:store_user_app/domain/entities/utilities/field_definition/field_definition.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/form_builder/form_data_builder.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/payment_info_step_model.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/app_switch_field.dart';

class NewCardDialog extends StatefulHookConsumerWidget {
  final List<iyzi_card.Card>? storedCards;
  final Map<String, FieldDefinition>? creditCardFormData;
  final PaymentInfoStepModel paymentInfoStepModel;

  const NewCardDialog({
    super.key,
    required this.storedCards,
    required this.creditCardFormData,
    required this.paymentInfoStepModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewCardDialogState();
}

class _NewCardDialogState extends ConsumerState<NewCardDialog>
    with SingleTickerProviderStateMixin {
  late final FormDataBuilder formBuilder;
  late final AppFormController<FormDataBuilder> formController;

  final ValueNotifier<bool> _showBackView = ValueNotifier<bool>(false);
  final ValueNotifier<CardType> _cardType = ValueNotifier(CardType.unknown);
  final ValueNotifier<bool> _cartStoreValue = ValueNotifier(true);
  final ValueNotifier<String?> _cartHolderNameLister = ValueNotifier(null);
  final ValueNotifier<String?> _cartNumberListener = ValueNotifier(null);
  final ValueNotifier<String?> _expireDateListener = ValueNotifier(null);
  final ValueNotifier<String?> _cvcListener = ValueNotifier(null);

  late AnimationController _animationController;
  late Animation<double> _animation;

  final String expireMonthFieldKey = 'expireMonth';
  final String expireYearFieldKey = 'expireYear';
  final String approveCartStoreWithIyzicoFieldKey =
      'approveCartStoreWithIyzico';

  TextEditingController get _cardNumberController =>
      formController.getController('cardNumber')!;
  TextEditingController get _cardHolderController =>
      formController.getController('cardHolderName')!;
  TextEditingController get _expiryDateController =>
      formController.getController('expiryDate')!;
  TextEditingController get _cvvController =>
      formController.getController('cvc')!;
  TextEditingController get _cardAlias =>
      formController.getController('cardAlias')!;

  FocusNode get _cardNumberFocus => formController.getFocusNode('cardNumber');
  FocusNode get _cardHolderFocus =>
      formController.getFocusNode('cardHolderName');
  FocusNode get _expiryDateFocus => formController.getFocusNode('expiryDate');
  FocusNode get _cvvFocus => formController.getFocusNode('cvc');
  FocusNode get _cardAliasFocus => formController.getFocusNode('cardAlias');

  @override
  void initState() {
    formBuilder = FormDataBuilder(widget.creditCardFormData!);
    formBuilder.addField<String?>('expiryDate', (_) => null,
        type: FormFieldType.text);
    formBuilder.addSwitchField(
        approveCartStoreWithIyzicoFieldKey, 'Kartımı hatırla', (m) => true);

    formController = AppFormController(
      formBuilder.build(),
      onFieldChange: (fieldName, value) {
        if (fieldName == approveCartStoreWithIyzicoFieldKey) {
          _cartStoreValue.value = formController
              .getFieldState(approveCartStoreWithIyzicoFieldKey)!
              .value;
        }

        if (fieldName == 'cvc') {
          _cvcListener.value = value;
        }

        if (fieldName == 'cardHolderName') {
          _cartHolderNameLister.value = value;
        }

        if (fieldName == 'expiryDate') {
          _expireDateListener.value = value;
        }
      },
      onFieldFocusChange: (fieldName, hasFocus) {
        if (!hasFocus && fieldName == 'expiryDate') {
          var value = _expiryDateController.text;
          if (value.length == 5) {
            var parts = value.split('/');
            formController.updateField(expireMonthFieldKey, parts[0]);
            formController.updateField(expireYearFieldKey, parts[1]);
          }
        }
      },
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _cvvFocus.addListener(() {
      _showBackView.value = _cvvFocus.hasFocus;
      if (_cvvFocus.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    _cardNumberController.addListener(_updateCardType);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    formController.dispose();
    _showBackView.dispose();
    _cardType.dispose();
    _cartStoreValue.dispose();
    _cartNumberListener.dispose();
    _expireDateListener.dispose();
    _cvcListener.dispose();
    _cartHolderNameLister.dispose();
    super.dispose();
  }

  void _updateCardType() {
    final number = _cardNumberController.text.replaceAll(' ', '');
    if (number.isEmpty) {
      _cardType.value = CardType.unknown;
    } else if (number.startsWith('4')) {
      _cardType.value = CardType.visa;
    } else if (number.startsWith('5')) {
      _cardType.value = CardType.mastercard;
    } else if (number.startsWith('3')) {
      _cardType.value = CardType.amex;
    } else if (number.startsWith('9')) {
      _cardType.value = CardType.troy;
    } else {
      _cardType.value = CardType.unknown;
    }
  }

  void _submitForm() {
    if (formController.submit()) {
      context.router.maybePop(formController.getValues());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fdCommonAppBarWidget(context, titleText: 'Yeni Kart Ekle'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCreditCardWidget(),
              const SizedBox(height: 24),
              _buildForm(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: AppCommonButton(
                text: 'Vazgeç',
                height: 48,
                bgColor: getIt<ThemeController>().isDarkMode
                    ? borderDark
                    : primaryColor100,
                textColor: getIt<ThemeController>().isDarkMode
                    ? colorWhite1
                    : colorPrimary,
                onPressed: () => context.router.maybePop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppCommonButton(
                text: 'Seç',
                height: 48,
                onPressed: () => _submitForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardWidget() {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 10),
      child: ValueListenableBuilder(
          valueListenable: _showBackView,
          builder: (context, state, child) {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(state ? math.pi : 0),
                  child: state ? _buildBackCard() : _buildFrontCard(),
                );
              },
            );
          }),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [colorPrimary, colorPrimaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(creditCardBg),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _cardType,
                  builder: (context, _, __) {
                    return _buildCardTypeIcon();
                  }),
            ],
          ),
          ValueListenableBuilder(
              valueListenable: _cartNumberListener,
              builder: (context, state, child) {
                return Text(
                  _cardNumberController.text.isEmpty || state.isEmptyOrNull
                      ? "•••• •••• •••• ••••"
                      : "•••• •••• •••• ••••"
                      .replaceRange(0, state!.length, state),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "KART SAHİBİ",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ValueListenableBuilder(
                      valueListenable: _cartHolderNameLister,
                      builder: (context, state, child) {
                        return Text(
                          _cardHolderController.text.isEmpty ||
                              _cartHolderNameLister.value.isEmptyOrNull
                              ? "AD SOYAD"
                              : state!.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SON KULLANMA",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ValueListenableBuilder(
                      valueListenable: _expireDateListener,
                      builder: (context, state, child) {
                        return Text(
                          _expiryDateController.text.isEmpty ||
                              state.isEmptyOrNull
                              ? "MM/YY"
                              : "MM/YY".replaceRange(0, state!.length, state),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorPrimaryContainer, colorPrimary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              height: 40,
              color: Colors.black54,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: ValueListenableBuilder(
                      valueListenable: _cvcListener,
                      builder: (context, state, child) {
                        return Text(
                          _cvvController.text.isEmpty || state.isEmptyOrNull
                              ? "CVV"
                              : state!,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                ),
              ],
            ),
            const Spacer(),
            ValueListenableBuilder(
                valueListenable: _cardType,
                builder: (context, _, __) {
                  return _buildCardTypeIcon();
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTypeIcon() {
    var iconPath = switch (_cardType.value) {
      CardType.visa => visaIcon,
      CardType.mastercard => masterCardIcon,
      CardType.amex => amexCardIcon,
      CardType.troy => troyCardIcon,
      _ => creditCardIcon
    };

    return Container(
      width: 48,
      height: 32,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
        ),
      ),
      child: iconPath.endsWith('.svg')
          ? SvgPicture.asset(
        iconPath,
        fit: BoxFit.contain,
      )
          : Image.asset(
        iconPath,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: formController.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAliasField(),
          const SizedBox(height: 16),
          _buildCardNumberField(),
          const SizedBox(height: 16),
          _buildCardHolderField(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildExpiryDateField()),
              const SizedBox(width: 16),
              Expanded(child: _buildCvvField()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardNumberField() {
    return TextFormField(
      controller: _cardNumberController,
      focusNode: _cardNumberFocus,
      decoration: inputDecoration(
        context,
        labelText: "Kart Numarası",
        hintText: "1234 5678 9012 3456",
        prefixIcon: creditCardIcon,
        prefixIconColor: context.theme.primaryColor,
      ),
      keyboardType: TextInputType.number,
      onTapOutside: (event) {
        _cardNumberFocus.unfocus();
      },
      onChanged: (v) {
        _cartNumberListener.value = v;
        formController.updateField('cardNumber', v.replaceAll(' ', ''), false);
      },
      autovalidateMode: AutovalidateMode.onUnfocus,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        CardNumberFormatter(),
      ],
      validator: (v) => formController.fields
          .firstWhere((f) => f.name == 'cardNumber')
          .validator!(v?.replaceAll(' ', '')),
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return "Kart numarası gerekli";
      //   }
      //   if (value.replaceAll(" ", "").length < 16) {
      //     return "Geçerli bir kart numarası girin";
      //   }
      //   return null;
      // },
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_cardHolderFocus);
      },
    );
  }

  Widget _buildCardHolderField() {
    return TextFormField(
      controller: _cardHolderController,
      focusNode: _cardHolderFocus,
      onTapOutside: (event) {
        _cardHolderFocus.unfocus();
      },
      decoration: inputDecoration(
        context,
        labelText: "Kart Sahibi",
        hintText: "Ad Soyad",
        prefixIcon: personIcon,
        prefixIconColor: context.theme.primaryColor,
      ),
      onChanged: (v) => formController.updateField('cardHolderName', v),
      textCapitalization: TextCapitalization.characters,
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: formController.fields
          .firstWhere((f) => f.name == 'cardHolderName')
          .validator,
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return "Kart sahibi adı gerekli";
      //   }
      //   return null;
      // },
      // onFieldSubmitted: (_) {
      //   FocusScope.of(context).requestFocus(_expiryDateFocus);
      // },
    );
  }

  Widget _buildExpiryDateField() {
    return TextFormField(
      controller: _expiryDateController,
      focusNode: _expiryDateFocus,
      onTapOutside: (event) {
        _expiryDateFocus.unfocus();
      },
      decoration: inputDecoration(
        context,
        labelText: "Son Kullanma Tarihi",
        hintText: "MM/YY",
        prefixIcon: calendarIcon,
        prefixIconColor: context.theme.primaryColor,
      ),
      onChanged: (v) => formController.updateField('expiryDate', v),
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUnfocus,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        ExpiryDateFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Son kullanma tarihi gerekli";
        }
        if (value.length < 5) {
          return "MM/YY formatında girin";
        }

        final parts = value.split('/');
        if (parts.length != 2) {
          return "Geçersiz format";
        }

        final month = int.tryParse(parts[0]);
        final year = int.tryParse(parts[1]);

        if (month == null || year == null || month < 1 || month > 12) {
          return "Geçersiz ay";
        }

        final now = DateTime.now();
        final cardYear = 2000 + year;

        if (cardYear < now.year ||
            (cardYear == now.year && month < now.month)) {
          return "Kartınız süresi dolmuş";
        }

        return null;
      },
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_cvvFocus);
      },
    );
  }

  Widget _buildCvvField() {
    return TextFormField(
      controller: _cvvController,
      focusNode: _cvvFocus,
      onTapOutside: (event) {
        _cvvFocus.unfocus();
      },
      decoration: inputDecoration(
        context,
        labelText: "CVV",
        hintText: "123",
        prefixIcon: lockCircleIcon,
        prefixIconColor: context.theme.primaryColor,
      ),
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUnfocus,
      onChanged: (v) => formController.updateField('cvc', v),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      validator:
      formController.fields.firstWhere((f) => f.name == 'cvc').validator,
      //            (value) {
      //   if (value == null || value.isEmpty) {
      //     return "CVV kodu gerekli";
      //   }
      //   if (value.length < 3) {
      //     return "Geçersiz CVV";
      //   }
      //   return null;
      // },
    );
  }

  Widget _buildAliasField() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ValueListenableBuilder(
          valueListenable: _cartStoreValue,
          child: AppSwitchField(
            field: formController.fields.firstWhere(
                    (f) => f.name == approveCartStoreWithIyzicoFieldKey),
            state: formController
                .getFieldState(approveCartStoreWithIyzicoFieldKey)!,
            onChanged: formController.updateField,
            focusNode:
            formController.getFocusNode(approveCartStoreWithIyzicoFieldKey),
          ),
          builder: (context, state, child) {
            return Column(
              children: [
                child!,
                if (state) ...[
                  16.height,
                  TextFormField(
                    controller: _cardAlias,
                    focusNode: _cardAliasFocus,
                    onTapOutside: (event) {
                      _cardAliasFocus.unfocus();
                    },
                    decoration: inputDecoration(context,
                        labelText: "Kart Adı",
                        hintText: "Kart Adı",
                        prefixIcon: paymentCardIcon,
                        prefixIconColor: context.theme.primaryColor),
                    onChanged: (v) =>
                        formController.updateField('cardAlias', v),
                    textCapitalization: TextCapitalization.characters,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    validator: (value) {
                      if (formController
                          .getFieldState(
                          approveCartStoreWithIyzicoFieldKey)!
                          .value &&
                          (value == null || value.isEmpty)) {
                        return "Kart adı gerekli";
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_cardNumberFocus);
                    },
                  )
                ]
              ],
            );
          }),
    );
  }
}
