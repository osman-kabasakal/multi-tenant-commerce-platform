import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/models/orders/customer_order_list_model/order_details_model/order_details_model.dart';
import 'package:store_user_app/domain/usecases/orders/order_list_use_case.dart';
import 'package:store_user_app/presentation/screens/profile/widgets/order_card_skeleton.dart';
import 'package:store_user_app/presentation/screens/profile/widgets/order_card_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

@RoutePage()
class OrdersIndexScreen extends StatefulHookConsumerWidget {
  const OrdersIndexScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrdersIndexScreenState();
}

class _OrdersIndexScreenState extends ConsumerState<OrdersIndexScreen> {
  late final ThemeController _themeController;
  @override
  void initState() {
    super.initState();
    _themeController = getIt<ThemeController>();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.watch(orderListUseCaseProvider.selectAsync((s) => s.isLoading)).then(
    //       (s) => ref.read(orderListUseCaseProvider.notifier).loadOrders());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor, //AppTheme.foodLightTheme.scaffoldBackgroundColor,
      appBar: fdCommonAppBarWidget(context,
          titleText: orders.padLeft(20), isback: false),
      body: SafeArea(
        child: _buildContent(context, ref),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderListUseCaseProvider);

    return orderState.when(
      // skipLoadingOnRefresh: true,
      // skipLoadingOnReload: true,
      data: (data) => _buildOrderList(context, ref, data.isLoading, data.orders,
          data.pagingContext?.hasNextPage ?? false),
      error: (error, stack) => AppErrorWidget(
        message: 'Error loading orders: $error',
        onRetry: () async {
          await ref.read(orderListUseCaseProvider.notifier).loadOrders();
        },
      ),
      loading: () => _buildLoadingState(),
    );
  }

  Widget _buildLoadingState() {
    return Skeleton(
      isLoading: true,
      skeleton: SkeletonListView(
        itemCount: 5,
        item: OrderCardSkeleton(),
      ),
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildOrderList(BuildContext context, WidgetRef ref, bool isLoading,
      List<OrderDetailsModel> data, bool hasNext) {
    return AppInifiniteScrollList(
      key: const Key('order_list'),
      padding: const EdgeInsets.all(16),
      scrollDirection: InfiniteScrollDirection.vertical,
      loadingBuilder: (context) => const OrderCardSkeleton(),
      isLoading: isLoading,
      hasMore: hasNext,
      itemCount: data.length,
      refresh: () async {
        await ref.read(orderListUseCaseProvider.notifier).refreshOrders();
      },
      onLoadMore: () async {
        await ref.read(orderListUseCaseProvider.notifier).loadMoreOrder();
      },
      itemBuilder: (context, index) {
        final order = data[index];
        return OrderCardWidget(order: order);
      },
    );
  }
}
