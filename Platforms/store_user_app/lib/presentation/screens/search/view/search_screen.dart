import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart' hide ContextExtensions;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/constants/strings.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/presentation/screens/search/providers/search_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';

@RoutePage()
class SearchScreen extends StatefulHookConsumerWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeacrhScreenState();
}

class _SeacrhScreenState extends ConsumerState<SearchScreen> {
  final themeController = getIt<ThemeController>();
  late final textController = TextEditingController();
  late final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: TextFormField(
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: themeController.isDarkMode
                  ? colorWhite1
                  : textColor, // Set your desired text color
            ),
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.text,
            focusNode: focusNode,
            onFieldSubmitted: (v) {
              focusNode.unfocus();
              if (textController.text.trim().isNotEmpty &&
                  textController.text.trim().length > 3) {
                ref
                    .read(searchControllerProvider.notifier)
                    .search(textController.text.trim());
              } else {
                Fluttertoast.showToast(
                    msg: 'Arama kelimesi boş ve 3 harfden az olmaz...');
              }
            },
            // onChanged: controller.search,
            controller: textController,
            decoration: inputDecoration(context,
                prefixIcon: searchIcon,
                suffixWidget: InkWell(
                  onTap: () {
                    textController.text = '';
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      cancelIcon,
                      width: 10,
                      height: 10,
                      colorFilter: ColorFilter.mode(
                          themeController.isDarkMode ? Colors.white : textColor,
                          BlendMode.srcIn),
                    ),
                  ),
                ),
                leftContentPadding: 5,
                bottomContentPadding: 15,
                rightContentPadding: 0,
                topContentPadding: 15,
                inputBorderColor: colorPrimary,
                fillColor: colorPrimary.withValues(alpha: 0.08),
                hintColor: colorGrey500,
                borderRadius: textFieldRadius,
                prefixIconColor: colorPrimary,
                hintText: search),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: themeController.isDarkMode ? cardDark : Colors.white,
              borderRadius: BorderRadius.circular(12)),
          child: LoadComponentWhenVisible(
            builder: (isVisible) => ref.watch(searchControllerProvider).when(
                data: (data) {
                  if (data.isLoading) {
                    return Skeletonizer(
                        child: SizedBox(
                      width: double.infinity,
                      child: Card(),
                    ));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRecentSearchList(data.searchHistory),
                      15.height,
                    ],
                  );
                },
                error: (err, stack) {
                  return AppErrorWidget(
                    message: err.toString(),
                    onRetry: () {
                      ref
                          .read(searchControllerProvider.notifier)
                          .loadSearchHistory();
                    },
                  );
                },
                loading: () => Skeletonizer(
                        child: SizedBox(
                      width: double.infinity,
                      child: Card(),
                    ))),
            onVisible: () async => await ref
                .read(searchControllerProvider.notifier)
                .loadSearchHistory(),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearchList(List<String> recentSeachList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recentSeachList.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildText(recentSearches),
              GestureDetector(
                onTap: () {
                  ref.read(searchControllerProvider.notifier).clearAllHistory();
                },
                child: Text(
                  clearAll,
                  style: context.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        15.height,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2, // Adjust this value to control the height
          ),
          itemCount: recentSeachList.length,
          itemBuilder: (context, index) {
            final suggestion = recentSeachList[index];
            return InkWell(
              onTap: () {
                ref.read(searchControllerProvider.notifier).search(suggestion);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: colorPrimary)),
                child: Center(
                  child: Text(
                    suggestion,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600, color: colorPrimary),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  _buildText(String data) {
    return Text(
      data,
      style: context.textTheme.headlineSmall
          ?.copyWith(fontWeight: FontWeight.w900),
    );
  }
}
