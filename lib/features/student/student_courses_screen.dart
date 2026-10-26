import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/student_models.dart';
import '../../data/student_store.dart';
import 'student_scaffold.dart';

class StudentCoursesScreen extends StatelessWidget {
  const StudentCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StudentStore>();
    return StudentScaffold(
      tab: StudentTab.courses,
      children: [
        Text('${store.studentId} · Current semester',
            style: AppText.style(14, FontWeight.w600, AppColors.muted)),
        gap(2),
        Text('My courses', style: AppText.h1()),
        gap(14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.deep,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppShadows.deepCard,
          ),
          child: Row(
            children: [
              Text('${store.overallPercent}%',
                  style: AppText.style(50, FontWeight.w800, Colors.white,
                      ls: -0.04, height: 1)),
              hgap(18),
              Expanded(
                child: Text(
                  'Overall attendance this semester. Keep every course above ${StudentCourse.threshold}%.',
                  style: AppText.style(
                      14, FontWeight.w400, AppColors.onDeepMuted,
                      height: 1.45),
                ),
              ),
            ],
          ),
        ),
        for (final c in store.courses) ...[
          gap(14),
          _CourseCard(course: c),
        ],
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});
  final StudentCourse course;

  @override
  Widget build(BuildContext context) {
    final warn = course.below;
    final radius = BorderRadius.circular(20);

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.name,
                        style:
                            AppText.style(18, FontWeight.w800, AppColors.ink)),
                    gap(2),
                    Text(course.teacher,
                        style: AppText.style(
                            13, FontWeight.w400, AppColors.muted)),
                  ],
                ),
              ),
              Text('${course.percent}%',
                  style: AppText.style(24, FontWeight.w800,
                      warn ? AppColors.warnText : AppColors.link)),
            ],
          ),
          gap(12),
          EtBar(
            fraction: course.percent / 100,
            track: warn ? AppColors.warnTrack : AppColors.chip,
            fill: warn ? AppColors.amberBar : AppColors.indigoBar,
          ),
          gap(12),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              decoration: BoxDecoration(
                color: warn ? AppColors.warnChipBg : AppColors.absentChipBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                warn ? 'Below ${StudentCourse.threshold}%' : '${course.absent} absent',
                style: AppText.style(12, FontWeight.w700,
                    warn ? AppColors.warnDeepText : AppColors.redFg),
              ),
            ),
          ),
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: warn ? AppColors.warnBg : Colors.white,
        borderRadius: radius,
        border: warn
            ? Border.all(color: AppColors.warnBorder, width: 2)
            : null,
        boxShadow: warn ? null : AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed(Routes.studentCourseDetail, arguments: course.id),
          child: content,
        ),
      ),
    );
  }
}
