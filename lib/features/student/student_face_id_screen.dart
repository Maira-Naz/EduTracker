import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_icons.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/student_store.dart';
import 'student_scaffold.dart';

class StudentFaceIdScreen extends StatelessWidget {
  const StudentFaceIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentStore>();
    return StudentScaffold(
      tab: StudentTab.faceId,
      children: [
        Text(s.studentId,
            style: AppText.style(14, FontWeight.w600, AppColors.muted)),
        gap(2),
        Text('Face ID', style: AppText.h1()),
        gap(16),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.deep,
            borderRadius: BorderRadius.circular(26),
            boxShadow: AppShadows.deepCard,
          ),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.blobSmall),
                child: const EtPersonIcon(
                    size: 40, color: AppColors.deep, strokeWidth: 3.2),
              ),
              hgap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        s.faceRegistered
                            ? 'Face registered'
                            : 'Not registered',
                        style: AppText.style(
                            20, FontWeight.w800, Colors.white)),
                    gap(2),
                    Text('Last updated ${s.faceUpdatedLabel}',
                        style: AppText.style(
                            13, FontWeight.w400, AppColors.onDeepMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
        gap(16),
        EtCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Looks different lately?',
                  style: AppText.style(15, FontWeight.w800, AppColors.ink)),
              gap(10),
              Text(
                'New glasses, a new haircut or a beard can lower your match score. Re-register your face to keep attendance accurate.',
                style: AppText.style(14, FontWeight.w400, AppColors.muted,
                    height: 1.5),
              ),
              gap(10),
              EtButton(
                label: 'Re-register face',
                height: 50,
                onPressed: () => Navigator.of(context).pushNamed(
                    Routes.studentRegister,
                    arguments: true),
              ),
            ],
          ),
        ),
        gap(16),
        EtRowList(
          rows: [
            _InfoRow('Recent match score', '${s.recentMatchScore}%',
                valueColor: AppColors.greenFg),
            _InfoRow('Scans needing review',
                '${s.scansNeedingReview} this month'),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.valueColor = AppColors.ink});
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppText.style(15, FontWeight.w700, AppColors.ink)),
          Text(value, style: AppText.style(15, FontWeight.w800, valueColor)),
        ],
      ),
    );
  }
}
