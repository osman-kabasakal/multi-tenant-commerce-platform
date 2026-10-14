import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/domain/entities/messages/queued_email/queued_email.dart';
import 'package:store_user_app/domain/entities/notification/notification_model.dart';
import 'package:store_user_app/domain/usecases/notification/notification_use_case.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';

@RoutePage()
class NotificationsScreen extends StatefulHookConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMoreNotifications = true;

  Future<void> _loadMoreNotifications() async {
    final notificationList = await ref
        .read(notificationUseCaseProvider.notifier)
        .loadMore(_currentPage + 1, _pageSize);

    // Eğer yüklenen veri sayısı pageSize'dan küçükse, daha fazla veri yok demektir
    if ((notificationList.data?.length ?? 0) < _pageSize) {
      _hasMoreNotifications = false;
    } else {
      _currentPage++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        getIt<ThemeController>().isDarkMode
            ? AppTheme.foodDarkTheme
            : AppTheme.foodLightTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Bildirimler',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            getIt<ThemeController>().isDarkMode ? darkPrimary : Colors.white,
        elevation: 0,
      ),
      body: ref
          .watch(notificationUseCaseProvider)
          .when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stack) => Center(
                  child: Text(
                    'Bildirimler yüklenirken bir hata oluştu',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
            data: (notifications) {
              return AppInifiniteScrollList(
                key: const ValueKey('notifications_list'),
                isLoading: false,
                hasMore:
                    _hasMoreNotifications &&
                    (notifications.total ?? 0) > _pageSize,
                itemCount: notifications.data?.length ?? 0,
                onLoadMore: _loadMoreNotifications,
                refresh: () async {
                  _currentPage = 1;
                  _hasMoreNotifications = true;
                  ref.invalidate(notificationUseCaseProvider);
                },
                padding: const EdgeInsets.all(16),
                emptyBuilder:
                    (context) => Center(
                      child: Text(
                        'Henüz hiç bildiriminiz yok',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                itemBuilder: (context, index) {
                  final notification = notifications.data![index];
                  return Column(
                    children: [
                      _buildNotificationItem(context, notification, theme),
                      if (index < (notifications.data!.length - 1))
                        const Divider(),
                    ],
                  );
                },
              );
            },
          ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    QueuedEmail notification,
    ThemeData theme,
  ) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final date =
        notification.createdOnUtc != null
            ? dateFormat.format(notification.createdOnUtc!.toLocal())
            : '';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      tileColor:
          getIt<ThemeController>().isDarkMode ? cardDarkColor : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        notification.subject ?? '',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color:
              notification.readOnUtc == null
                  ? (getIt<ThemeController>().isDarkMode
                      ? Colors.white
                      : Colors.black)
                  : getIt<ThemeController>().isDarkMode
                  ? Colors.white70
                  : Colors.black54,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'Gönderen: ${notification.from ?? ''}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? Colors.white70
                      : Colors.black54,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? Colors.white70
                      : Colors.black54,
            ),
          ),
        ],
      ),
      trailing:
          notification.readOnUtc == null
              ? Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  shape: BoxShape.circle,
                ),
              )
              : null,
      onTap: () {
        context.router.push(
          NotificationDetailRoute(notificationId: notification.id ?? ''),
        );
      },
    );
  }
}
