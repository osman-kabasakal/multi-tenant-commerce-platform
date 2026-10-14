import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/presentation/screens/pages/Providers/page_screen_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_animated_loading_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/consumer_futer_builder_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';

@RoutePage(name: 'PageScreenRoute')
class PageScreen extends ConsumerStatefulWidget {
  final String pageSystemName;
  const PageScreen({super.key, @PathParam("pageSystemName") required this.pageSystemName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PageScreenState();
}

class _PageScreenState extends ConsumerState<PageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ConsumerFuterBuilderWidget(
          futureBuilder:
              (pageSecreenTitleRef) => pageSecreenTitleRef.watch(
                pageScreenControllerProvider.selectAsync((s) => s.pageTitle),
              ),
          builder: (titleFtContext, pageScreenTitleRef, snapshot) {
            return fdCommonAppBarWidget(
              titleFtContext,
              titleText: snapshot.data ?? 'Page',
              isback: true,
              backgroundColor: context.theme.appBarTheme.backgroundColor,
            );
          },
          loadingBuilder: (loadingContext, pageScreenTitleRef, snapshot) {
            return fdCommonAppBarWidget(
              loadingContext,
              titleText: '....',
              isback: true,
              backgroundColor: context.theme.appBarTheme.backgroundColor,
            );
          },
        ),
      ),
      body: LoadComponentWhenVisible(
        onVisible: () async {
          final pageScreenControllerRef = ref.read(pageScreenControllerProvider.notifier);
          await pageScreenControllerRef.loadPage(widget.pageSystemName,);
        },
        builder: (context) {
          return ConsumerFuterBuilderWidget(
            futureBuilder: (pageScreenControllerRef) =>
                pageScreenControllerRef.watch(pageScreenControllerProvider.selectAsync((s)=>s)),
            builder: (context, pageScreenControllerRef, snapshot) {
              if (snapshot.hasError) {
                return AppErrorWidget(message: snapshot.error.toString());
              }
              if (snapshot.hasData) {
                final viewModel = snapshot.data!;
                if (viewModel.isLoading) {
                  return const AppAnimatedLoadingWidget();
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Html(data: viewModel.pageContent ?? ''),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
      ),
    );
  }
}
