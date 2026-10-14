import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/app_config.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/services/deeplink/deeplink_service.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/flutter_html/extensions/scrollable_table_html_extension.dart';
import 'package:store_user_app/domain/entities/messages/queued_email/queued_email.dart';
import 'package:store_user_app/domain/entities/notification/notification_model.dart';
import 'package:store_user_app/domain/repositories/notification/notification_storage_repository.dart';
import 'package:store_user_app/domain/usecases/notification/notification_use_case.dart';

@RoutePage()
class NotificationDetailScreen extends StatefulHookConsumerWidget {
  final String notificationId;

  const NotificationDetailScreen({
    super.key,
    @PathParam('notificationId') required this.notificationId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends ConsumerState<NotificationDetailScreen> {
  QueuedEmail? _notificationDetail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotificationDetail();
  }

  Future<void> _loadNotificationDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await ref
          .read(notificationUseCaseProvider.notifier)
          .getNotificationDetail(widget.notificationId);

      if (response != null &&
          response.success == true &&
          response.message != null) {
        // Yerel depolamada bildirimi görüldü olarak işaretle
        await getIt<NotificationStorageRepository>().markNotificationSeen(
          widget.notificationId,
        );

        // Sunucuda bildirimi okundu olarak işaretle
        await ref
            .read(notificationUseCaseProvider.notifier)
            .markNotificationAsRead(widget.notificationId);

        setState(() {
          _notificationDetail = response.message;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Bildirim detayı yüklenemedi';
          _isLoading = false;
        });
        context.router.replacePath(AppPaths.notFound());
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Bildirim detayı yüklenirken bir hata oluştu';
        _isLoading = false;
      });
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
          'Bildirim Detayı',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            getIt<ThemeController>().isDarkMode ? darkPrimary : Colors.white,
        elevation: 0,
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_notificationDetail == null) {
      return Center(
        child: Text(
          'Bildirim detayı bulunamadı',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard(theme),
          const SizedBox(height: 16),
          _buildContentCard(theme),
        ],
      ),
    );
  }

  Widget _buildDetailCard(ThemeData theme) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final createdDate =
        _notificationDetail!.createdOnUtc != null
            ? dateFormat.format(_notificationDetail!.createdOnUtc!.toLocal())
            : 'Bilinmiyor';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            getIt<ThemeController>().isDarkMode ? cardDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _notificationDetail!.subject ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Gönderen:', _notificationDetail!.from ?? '', theme),
          const SizedBox(height: 8),
          _buildDetailRow('Alıcı:', _notificationDetail!.to ?? '', theme),
          const SizedBox(height: 8),
          _buildDetailRow('Tarih:', createdDate, theme),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  getIt<ThemeController>().isDarkMode
                      ? Colors.white70
                      : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
      ],
    );
  }

  Widget _buildContentCard(ThemeData theme) {
    if (_notificationDetail?.body == null ||
        _notificationDetail!.body!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              getIt<ThemeController>().isDarkMode
                  ? cardDarkColor
                  : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('İçerik bulunamadı', style: theme.textTheme.bodyLarge),
      );
    }

    final deeplinkService = getIt<DeeplinkService>();
    final apiBaseUrl = AppConfig.instance.apiBaseUrl;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            getIt<ThemeController>().isDarkMode ? cardDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İçerik',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Html(
            data: _notificationDetail!.body,
            style: {
              'body': Style(
                fontSize: FontSize(16),
                color:
                    getIt<ThemeController>().isDarkMode
                        ? Colors.white
                        : Colors.black87,
              ),
              'a': Style(
                color: theme.primaryColor,
                textDecoration: TextDecoration.none,
              ),
            },
            onLinkTap: (url, _, __) async {
              if (url == null) return;

              if (url.startsWith(apiBaseUrl)) {
                // Uygulama içi link ise deeplink servisi ile açalım
                final uri = Uri.parse(url);
                final route = await deeplinkService.handleIncomingLink(uri);
                if (route != null && context.mounted) {
                  context.router.pushPath(route);
                }
              }
            },
            extensions: [ScrollableTableHtmlExtension()],
          ),
        ],
      ),
    );
  }
}
