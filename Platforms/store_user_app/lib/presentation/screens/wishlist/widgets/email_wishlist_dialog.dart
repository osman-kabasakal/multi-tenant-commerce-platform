import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/domain/usecases/wish_list/wish_list_use_case.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_animated_loading_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/consumer_futer_builder_widget.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/services/form/app_form_controller.dart';
import '../../../../core/services/form/form_builder.dart';
import '../../../../core/services/form/form_field.dart';
import '../../../../core/utils/provider/hooks.dart';
import '../../../../domain/entities/models/shopping_cart/wishlist_email_afriend_model/wishlist_email_afriend_model.dart';
import '../../../widgets/form/widgets/generic_form.dart';

class EmailWishlistDialog extends HookConsumerWidget {
  final Future<void> Function(WishlistEmailAFriendModel model) onSubmit;

  const EmailWishlistDialog({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConsumerFuterBuilderWidget<
          WishlistEmailAFriendModel,
          WishlistEmailAFriendModel
      >(
        futureBuilder:
            (ftRef) =>
            ftRef
                .read(wishListUseCaseProvider.notifier)
                .getEmailAFriendModel(),
        builder: (ftContext, ftRef, ftSnapshot) {
          return HookBuilder(
            builder: (hookContext) {
              final (
                  :pending,
                  :snapshot,
              hasError: _,
              loaderColor: _,
              loaderStrokeWidth: _,
              ) = useAsyncTask<void>();

              // Form builder and controller setup
              final formBuilder = useMemoized(
                    () =>
                FormBuilder<WishlistEmailAFriendModel>(ftSnapshot.data!)
                  ..addField<String>(
                    'FriendEmail',
                        (model) => model.friendEmail ?? '',
                    label: 'Arkadaşınızın E-posta Adresi',
                    isRequired: true,
                    type: FormFieldType.email,
                    validations: [
                          (value) =>
                      value == null || value.isEmpty
                          ? 'Arkadaşınızın e-posta adresi gereklidir'
                          : null,
                          (value) =>
                      !value.toString().contains('@')
                          ? 'Geçerli bir e-posta adresi giriniz'
                          : null,
                    ],
                  ).setConfiguration('hintText', 'ornek@eposta.com')
                  ..addField<String>(
                    'YourEmailAddress',
                        (model) => model.yourEmailAddress ?? '',
                    label: 'Sizin E-posta Adresiniz',
                    isRequired: true,
                    type: FormFieldType.email,
                    validations: [
                          (value) =>
                      value == null || value.isEmpty
                          ? 'E-posta adresiniz gereklidir'
                          : null,
                          (value) =>
                      !value.toString().contains('@')
                          ? 'Geçerli bir e-posta adresi giriniz'
                          : null,
                    ],
                  ).setConfiguration('hintText', 'sizin@eposta.com')
                  ..addMultilineTextField<String>(
                    'PersonalMessage',
                        (model) => model.personalMessage ?? '',
                    label: 'Kişisel Mesaj',
                    lines: 4,
                  ).setConfiguration(
                    'hintText',
                    'Mesajınızı buraya yazın...',
                  ),
                [ftSnapshot.data],
              );

              final formController = useMemoized(
                    () => AppFormController(
                  formBuilder.build(),
                  onFieldChange: (_, __) {},
                ),
                [formBuilder],
              );

              // Handle form submission
              void handleSubmit() {
                if (formController.submit()) {
                  final values = formController.getValues();
                  final model = WishlistEmailAFriendModel(
                    friendEmail: values['FriendEmail'] as String?,
                    yourEmailAddress: values['YourEmailAddress'] as String?,
                    personalMessage: values['PersonalMessage'] as String?,
                    displayCaptcha: ftSnapshot.data!.displayCaptcha,
                    captcha: ftSnapshot.data!.captcha,
                  );

                  pending.value = onSubmit(model);
                }
              }

              return Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'İstek Listenizi Paylaşın',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Form content
                    Flexible(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: GenericForm(
                            formBuilder: formBuilder,
                            formController: formController,
                          ),
                        ),
                      ),
                    ),

                    // Submit button
                    ElevatedButton(
                      onPressed:
                      snapshot.connectionState == ConnectionState.waiting
                          ? null
                          : handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorPrimary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text('Gönder'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        errorBuilder: (ftContext, ftRef, ftSnapshot) {
          return AppErrorWidget(
            message: ftSnapshot.error.toString(),
            onRetry: () {
              ftRef.invalidate(wishListUseCaseProvider);
            },
          );
        },
        loadingBuilder: (ftContext, ftRef, ftSnapshot) {
          return AppAnimatedLoadingWidget();
        },
      ),
    );
  }
}
