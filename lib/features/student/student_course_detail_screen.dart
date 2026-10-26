import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/models.dart';
import '../../data/student_models.dart';
import '../../data/student_store.dart';
import 'student_scaffold.dart';

class StudentCourseDetailScreen extends StatelessWidget {
  const StudentCourseDetailScreen({super.key, required this.courseId});
  final String courseId;

  @override
  Widget build(BuildContext context) {
    final c = context.watch<StudentStore>().courseById(courseId);
    final warn = c.below;

    final message = warn
        ? 'Below ${StudentCourse.threshold}%. You can miss ${c.canMiss} more classes before it drops further.'
        : 'Above ${StudentCourse.threshold}%. You can miss ${c.canMiss} more ${c.canMiss == 1 ? 'class' : 'classes'} and stay above it.';

    return StudentScaffold(
      tab: StudentTab.courses,
      children: [
        const EtBackLink('← My courses'),
        gap(14),
        Text(c.name, style: AppText.h1(32)),
        gap(2),
        Text('${c.teacher} · Room ${c.room}',
            style: AppText.style(14, FontWeight.w600, AppColors.muted)),
        gap(14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: warn ? AppColors.warnBg : AppColors.greenBg,
            borderRadius: BorderRadius.circular(22),
            border: warn
                ? Border.all(color: AppColors.warnBorder, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Text('${c.percent}%',
                  style: AppText.style(
                      40,
                      FontWeight.w800,
                      warn ? AppColors.warnText : AppColors.greenFg,
                      ls: -0.03)),
              hgap(16),
              Expanded(
                child: Text(message,
                    style: AppText.style(
                        14,
                        FontWeight.w600,
                        warn ? AppColors.warnDeepText : AppColors.greenFg,
                        height: 1.4)),
              ),
            ],
          ),
        ),
        gap(16),
        const EtSectionLabel('Recent sessions'),
        gap(12),
        EtRowList(
          emptyText: 'No sessions yet.',
          rows: [for (final r in c.recent) _SessionRow(record: r)],
        ),
      ],
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.record});
  final SessionRecord record;

  @override
  Widget build(BuildContext context) {
    final EtPill pill;
    switch (record.status) {
      case AttendanceStatus.present:
        pill = EtPill.presentPill();
        break;
      case AttendanceStatus.late:
        pill = EtPill.latePill();
        break;
      default:
        pill = EtPill.absentPill();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(record.dateLabel,
                  style: AppText.style(16, FontWeight.w800, AppColors.ink)),
              Text(
                  record.seenAt == null
                      ? 'Not seen'
                      : 'Seen ${record.seenAt}',
                  style: AppText.style(13, FontWeight.w400, AppColors.muted)),
            ],
          ),
          pill,
        ],
      ),
    );
  }
}
