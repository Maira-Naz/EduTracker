import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/models.dart';
import '../../data/teacher_store.dart';
import 'teacher_scaffold.dart';

class TeacherReportsScreen extends StatefulWidget {
  const TeacherReportsScreen({super.key});

  @override
  State<TeacherReportsScreen> createState() => _TeacherReportsScreenState();
}

class _TeacherReportsScreenState extends State<TeacherReportsScreen> {
  int _course = 0;

  Future<void> _export(CourseReport report) async {
    final format = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Export report',
                  style: AppText.style(22, FontWeight.w800, AppColors.ink,
                      ls: -0.02)),
              gap(4),
              Text('${report.course} · current semester',
                  style: AppText.style(14, FontWeight.w600, AppColors.muted)),
              gap(18),
              EtButton(
                  label: 'Export as PDF',
                  onPressed: () => Navigator.pop(ctx, 'PDF')),
              gap(10),
              EtButton(
                  label: 'Export as spreadsheet (CSV)',
                  style: EtButtonStyle.tonal,
                  onPressed: () => Navigator.pop(ctx, 'CSV')),
            ],
          ),
        ),
      ),
    );
    if (format != null && mounted) {
      showEtSnack(context, '${report.course} report exported as $format');
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TeacherStore>();
    final report = store.reports[_course];

    return TeacherScaffold(
      tab: TeacherTab.reports,
      children: [
        Text('Current semester',
            style: AppText.style(14, FontWeight.w600, AppColors.muted)),
        gap(2),
        Text('Reports', style: AppText.h1()),
        gap(14),
        EtSegmented(
          labels: [for (final r in store.reports) r.course],
          selected: _course,
          onChanged: (i) => setState(() => _course = i),
        ),
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
              Text('${report.averagePercent}%',
                  style: AppText.style(46, FontWeight.w800, Colors.white,
                      ls: -0.04, height: 1)),
              hgap(18),
              Expanded(
                child: Text(
                  'Average attendance across ${report.sessionCount} sessions this semester.',
                  style: AppText.style(
                      14, FontWeight.w400, AppColors.onDeepMuted,
                      height: 1.45),
                ),
              ),
            ],
          ),
        ),
        gap(16),
        const EtSectionLabel('Students below 75%'),
        gap(12),
        EtRowList(
          emptyText: 'Everyone is above 75%.',
          rows: [for (final s in report.belowThreshold) _AtRiskRow(student: s)],
        ),
        gap(14),
        EtButton(
          label: 'Export report',
          style: EtButtonStyle.outlineAccent,
          onPressed: () => _export(report),
        ),
      ],
    );
  }
}

class _AtRiskRow extends StatelessWidget {
  const _AtRiskRow({required this.student});
  final AtRiskStudent student;

  @override
  Widget build(BuildContext context) {
    final severe = student.percent < 70;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name,
                    style: AppText.style(16, FontWeight.w800, AppColors.ink)),
                Text(student.roll,
                    style:
                        AppText.style(13, FontWeight.w400, AppColors.muted)),
              ],
            ),
          ),
          EtPill(
            '${student.percent}%',
            bg: severe ? AppColors.redBg : AppColors.amberBg,
            fg: severe ? AppColors.redFg : AppColors.amberFg,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}
