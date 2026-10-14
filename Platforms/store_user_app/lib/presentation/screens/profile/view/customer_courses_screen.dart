import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/domain/entities/models/customer/courses_model/course/course.dart';
import 'package:store_user_app/domain/entities/models/customer/courses_model/courses_model.dart';
import 'package:store_user_app/presentation/screens/profile/providers/customer_courses_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

@RoutePage()
class CustomerCoursesScreen extends StatefulHookConsumerWidget {
  const CustomerCoursesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerCoursesScreenState();
}

class _CustomerCoursesScreenState extends ConsumerState<CustomerCoursesScreen> {
  // const CustomerCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coursesState = ref.watch(customerCoursesControllerProvider);
    final themeController = getIt<ThemeController>();

    return Scaffold(
      appBar: fdCommonAppBarWidget(
        context,
        titleText: 'Kurslarım',
        backgroundColor:
            themeController.isDarkMode ? darkPrimary : Colors.white,
      ),
      body: coursesState.when(
        data: (coursesModel) => _buildCoursesContent(context, coursesModel),
        loading: () => _buildLoadingState(),
        error: (error, stack) => AppErrorWidget(
          message: 'Kurslar yüklenirken bir hata oluştu',
          type: ErrorType.error,
          onRetry: () => ref
              .read(customerCoursesControllerProvider.notifier)
              .refreshCourses(),
        ),
      ),
    );
  }

  Widget _buildCoursesContent(BuildContext context, CoursesModel coursesModel) {
    if (coursesModel.courseList?.isEmpty ?? true) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.school_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Henüz kayıtlı kursunuz bulunmamaktadır.',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: getIt<ThemeController>().isDarkMode
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(customerCoursesControllerProvider.notifier).refreshCourses(),
      color: colorPrimary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: coursesModel.courseList!.length,
        itemBuilder: (context, index) {
          final course = coursesModel.courseList![index];
          return _buildCourseCard(context, course);
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    final themeController = getIt<ThemeController>();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: themeController.isDarkMode ? borderDark : borderColor,
          width: 1,
        ),
      ),
      color: themeController.isDarkMode ? cardDark : Colors.white,
      elevation: themeController.isDarkMode ? 1 : 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to course detail page
                      // context.router.push(CourseDetailRoute(seName: course.seName));
                    },
                    child: Text(
                      course.name ?? '',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: themeController.isDarkMode
                            ? Colors.white
                            : textColor,
                      ),
                    ),
                  ),
                ),
                // Approval status checkbox
                if (course.approved != null)
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      value: course.approved,
                      onChanged: null, // Read-only checkbox
                      activeColor: colorPrimary,
                      checkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: BorderSide(
                        color: themeController.isDarkMode
                            ? colorGrey500
                            : colorGrey400,
                        width: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (course.shortDescription != null &&
              course.shortDescription!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Html(
                data: course.shortDescription!,
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    color:
                        themeController.isDarkMode ? Colors.white70 : textColor,
                    fontSize: FontSize(14),
                    fontFamily: AppTheme.fontFamily,
                  ),
                  "a": Style(
                    color: colorPrimary,
                  ),
                },
                onLinkTap: (url, _, __) {
                  // TODO: Handle link taps
                  // if (url != null) launchUrl(Uri.parse(url));
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SkeletonListView(
        item: SkeletonItem(
          child: Column(
            children: [
              SkeletonListTile(
                hasLeading: false,
                titleStyle: const SkeletonLineStyle(
                  height: 20,
                  width: 200,
                  padding: EdgeInsets.zero,
                ),
                trailing: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SkeletonParagraph(
                  style: const SkeletonParagraphStyle(
                    lines: 3,
                    spacing: 8,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        scrollable: false,
      ),
    );
  }
}
