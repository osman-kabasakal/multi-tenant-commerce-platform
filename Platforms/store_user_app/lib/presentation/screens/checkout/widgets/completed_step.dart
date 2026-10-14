import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_completed_model/checkout_completed_model.dart';
import 'package:store_user_app/domain/entities/models/orders/order_details_model/order_details_model.dart';
import 'package:store_user_app/domain/repositories/checkout/checkout_repository.dart';
import 'package:store_user_app/domain/repositories/order/order_repository.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_summary_row_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_bottom_navigation.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card_title.dart';

class CompletedStep extends HookWidget {
  final CheckoutCompletedModel model;
  const CompletedStep({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    var completedModelState = useState(model);

    Future<OrderDetailsModel?> _getCheckoutCompletedModel() async {
      var orderRepository = await getIt.getAsync<OrderRepository>();
      var checkoutRepository = await getIt.getAsync<CheckoutRepository>();
      var completedModel = await checkoutRepository.getCheckoutCompleted(
        model.orderId ?? '',
      );
      if (completedModel != null && completedModel.data != null) {
        completedModelState.value = completedModel.data!;
        var detailResponse = await orderRepository.getOrderDetails(
          completedModel.data!.orderId!,
        );
        if (detailResponse != null && detailResponse.data != null) {
          getIt<EventBus>().publish<OrderDetailsModel>(
            EntityCreatedEvent<OrderDetailsModel>(entity: detailResponse.data!),
          );
          return detailResponse.data!;
        }
      }

      return null;
    }

    var memorizedTask = useMemoized(_getCheckoutCompletedModel);

    return SafeArea(
      child: Scaffold(
        appBar: fdCommonAppBarWidget(
          context,
          backgroundColor: context.theme.scaffoldBackgroundColor,
          titleText: 'Sipariş tammalandı',
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.width() * 0.8,
              maxHeight: context.height() * 0.7,
            ),
            child: AppCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Başarılı işlem ikonu
                  SizedBox(
                    width: context.height() * 0.05,
                    height: context.height() * 0.020,
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.loose,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -context.height() * 0.07,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.theme.scaffoldBackgroundColor,
                                width: 4.0,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                size:
                                    (context.height() * 0.05) -
                                    16, // Ekran genişliğine göre ikon boyutu
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Başarılı sipariş mesajı
                  AppCardTitle.active(
                    title: 'Sipariş için teşekkür ederiz!',
                    // style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    // textAlign: TextAlign.center,
                    hasDivider: true,
                  ),
                  8.height,
                  Text(
                    'Siparişiniz başarıyla alındı. Sipariş bilgilerininz mail adresinize gönderilecektir.',
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  16.height,
                  FutureBuilder<OrderDetailsModel?>(
                    future: memorizedTask,
                    builder: (ftContext, snapshot) {
                      return Column(
                        children: [
                          AppCardTitle.error(
                            title: 'Sipariş bilgileri:',
                            hasDivider: true,
                          ),
                          8.height,
                          AppSummaryRowWidget(
                            'Sipariş No:',
                            snapshot.data?.orderCode ?? '...',
                            isHighlight: true,
                            isPrice: true,
                          ),
                          AppSummaryRowWidget(
                            'Sipariş Tarihi:',
                            DateFormat('dd MM yyyy, HH:mm').format(
                              snapshot.data?.createdOn ?? DateTime.now(),
                            ),
                            isHighlight: true,
                            isPrice: true,
                          ),
                          AppSummaryRowWidget(
                            'Sipariş Durumu:',
                            snapshot.data?.orderStatus ?? '...',
                            isHighlight: true,
                            isPrice: true,
                          ),
                          AppSummaryRowWidget(
                            'Ödeme Yöntemi:',
                            snapshot.data?.paymentMethod ?? '...',
                            isHighlight: true,
                            isPrice: true,
                          ),
                          AppSummaryRowWidget(
                            'Toplam Tutar:',
                            snapshot.data?.orderTotal ?? '...',
                            isHighlight: true,
                            isPrice: true,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(
          child: ValueListenableBuilder(
            valueListenable: completedModelState,
            builder: (context, state, child) {
              return AppCommonButton(
                onPressed: () async {
                  if (state.orderId != null && state.orderId!.isNotEmpty) {
                    context.router.popAndPush(
                      OrdersDetailRoute(orderId: state.orderId!),
                    );
                  } else {
                    context.router.popAndPush(OrdersRoute());
                  }
                },
                text:
                    state.orderId != null && state.orderId!.isNotEmpty
                        ? 'Sipariş Detayı'
                        : 'Siparişlerim',
              );
            },
          ),
        ),
      ),
    );
  }
}
