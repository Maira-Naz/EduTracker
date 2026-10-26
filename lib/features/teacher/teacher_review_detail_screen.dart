import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_icons.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/models.dart';
import '../../data/teacher_store.dart';
import 'teacher_review_screen.dart' show resolveScan;
import 'teacher_scaffold.dart';

class TeacherReviewDetailScreen extends StatelessWidget {
  const TeacherReviewDetailScreen({super.key, required this.scanId});
  final String scanId;

  void _act(BuildContext context, ScanReview scan, bool approve) {
    resolveScan(context, scan, approve: approve);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TeacherStore>();
    final scan = store.scanById(scanId);
    final session = store.sessionById(scan.sessionId);
    final pct = scan.confidence;
    final below = pct < TeacherStore.autoApproveThreshold;
    final fraction = (pct / 100).clamp(0.0, 1.0).toDouble();

    return TeacherScaffold(
      tab: TeacherTab.review,
      children: [
        const EtBackLink('← Needs review'),
        gap(16),
        Text(scan.name, style: AppText.h1(32)),
        gap(2),
        Text('${scan.roll} · seen ${scan.seenAt} · ${session.roomLabel}',
            style: AppText.style(14, FontWeight.w600, AppColors.muted)),
        gap(16),
        Row(
          children: const [
            Expanded(
                child: _FaceCard(
                    label: 'Camera scan', color: AppColors.blobSmall)),
            SizedBox(width: 12),
            Expanded(
                child: _FaceCard(
                    label: 'Registered face', color: AppColors.blobLarge)),
          ],
        ),
        gap(16),
        EtCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('Match confidence',
                      style:
                          AppText.style(14, FontWeight.w700, AppColors.ink)),
                  Text(scan.confidenceLabel,
                      style: AppText.style(
                          28,
                          FontWeight.w800,
                          below ? AppColors.amberFg : AppColors.greenFg)),
                ],
              ),
              gap(10),
              _ConfidenceBar(
                fraction: fraction,
                threshold: TeacherStore.autoApproveThreshold / 100,
                color: below ? AppColors.amberBar : AppColors.greenFg,
              ),
              gap(10),
              Text(
                below
                    ? 'Auto-approve starts at ${TeacherStore.autoApproveThreshold.toStringAsFixed(0)}%. This scan is just below it.'
                    : 'Auto-approve starts at ${TeacherStore.autoApproveThreshold.toStringAsFixed(0)}%. This scan is above it.',
                style: AppText.style(13, FontWeight.w400, AppColors.muted),
              ),
            ],
          ),
        ),
        gap(16),
        Row(
          children: [
            Expanded(
              child: EtButton(
                label: 'Not her, mark absent',
                style: EtButtonStyle.outline,
                height: 54,
                radius: 16,
                onPressed: scan.resolved ? null : () => _act(context, scan, false),
              ),
            ),
            hgap(10),
            Expanded(
              child: EtButton(
                label: 'Yes, approve',
                height: 54,
                radius: 16,
                shadow: AppShadows.primarySmall,
                onPressed: scan.resolved ? null : () => _act(context, scan, true),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FaceCard extends StatelessWidget {
  const _FaceCard({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return EtCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const EtPersonIcon(size: 64, color: AppColors.deep),
          ),
          gap(8),
          Text(label,
              style: AppText.style(13, FontWeight.w700, AppColors.ink)),
        ],
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  const _ConfidenceBar({
    required this.fraction,
    required this.threshold,
    required this.color,
  });

  final double fraction;
  final double threshold;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      return SizedBox(
        height: 10,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.chip,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Container(
              width: w * fraction,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Positioned(
              left: w * threshold,
              top: -4,
              child: Container(width: 3, height: 18, color: AppColors.ink),
            ),
          ],
        ),
      );
    });
  }
}
