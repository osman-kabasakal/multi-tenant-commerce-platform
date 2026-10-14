import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/domain/entities/models/customer/documents_model/documents_model.dart';
import 'package:store_user_app/presentation/screens/profile/providers/documents_controller.dart';
import 'package:store_user_app/presentation/screens/profile/widgets/document_card.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

@RoutePage()
class CustomerDocumentsScreen extends HookConsumerWidget {
  const CustomerDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(documentsControllerProvider);
    final controller = ref.watch(documentsControllerProvider.notifier);
    final scrollController = useState(ScrollController());

    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        titleText: "Belgelerim",
        isback: true,
      ),
      body: documentsAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(context, error, ref),
        data: (documents) => _buildDocumentsList(
          context,
          documents,
          controller,
          scrollController.value,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorPrimary,
          ),
          const SizedBox(height: 16),
          Text(
            'Dokümanlar yükleniyor...',
            style: TextStyle(color: colorGrey700),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: appRedColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load documents',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          AppCommonButton(
            text: 'Yeniden Dene',
            onPressed: () {
              ref.refresh(documentsControllerProvider);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            documentsIcon,
            height: 64,
            width: 64,
            colorFilter: ColorFilter.mode(
              colorGrey400,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Hiçbir belge mevcut değil!',
            style: context.textTheme.titleLarge?.copyWith(
              color: colorGrey700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hesabınızla ilgili tüm belgeler burada görünecektir.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colorGrey600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(
    BuildContext context,
    DocumentsModel documentsModel,
    DocumentsController controller,
    ScrollController scrollController,
  ) {
    final documents = documentsModel.documentList ?? [];
    final pagingContext = documentsModel.pagingContext;

    if (documents.isEmpty) {
      return _buildEmptyState(context);
    }

    return AppInifiniteScrollList(
      key: const Key('documents-list'),
      isLoading: false,
      hasMore: pagingContext?.hasNextPage ?? false,
      controller: scrollController,
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return DocumentCard(
          document: documents[index],
          onDownload: (documentId) {
            controller.downloadDocument(context, documentId);
          },
        );
      },
      onLoadMore: () async {
        await controller.loadMore();
      },
      refresh: () async {
        await controller.refresh();
      },
      padding: const EdgeInsets.all(16),
      emptyBuilder: (context) => _buildEmptyState(context),
      loadingBuilder: (context) => const SkeletonListTile(
        hasSubtitle: true,
        titleStyle: SkeletonLineStyle(height: 24),
        subtitleStyle: SkeletonLineStyle(height: 16),
        leadingStyle: SkeletonAvatarStyle(width: 64, height: 64),
      ),
    );
  }
}
