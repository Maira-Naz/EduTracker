import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/models.dart';
import '../../data/teacher_store.dart';
import 'teacher_scaffold.dart';

/// Shared by the list and the detail screen so the wording stays identical.
void resolveScan(BuildContext context, ScanReview scan,
    {required bool approve}) {
  final store = context.read<TeacherStore>();
  if (approve) {
    store.approveScan(scan.id);
  } else {
    store.rejectScan(scan.id);
  }
  showEtSnack(
    context,
    approve
        ? '${scan.name} approved as present'
        : '${scan.name} marked absent',
    actionLabel: 'Undo',
    onAction: () => store.undoScan(scan.id),
  );
}

class TeacherReviewScreen extends StatelessWidget {
  const TeacherReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TeacherStore>();
    final pending = store.pendingScans;
    final resolved = store.resolvedScans;
    final running = store.runningSession;
    final header = running == null
        ? 'Today'
        : '${running.course}, ${fmtTime(running.startMin)}, ${running.roomLabel}';
    final countLabel = pending.isEmpty
        ? 'No scans'
        : '${pending.length} ${pending.length == 1 ? 'scan' : 'scans'}';

    return TeacherScaffold(
      tab: TeacherTab.review,
      children: [
        Text(header,
            style: AppText.style(14, FontWeight.w600, AppColors.muted)),
        gap(2),
        Text('Needs review', style: AppText.h1()),
        gap(16),
        Align(
          alignment: Alignment.centerLeft,
          child: EtPill(countLabel, bg: AppColors.chip, fg: AppColors.deep),
        ),
        gap(16),
        if (pending.isEmpty)
          EtCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text('All caught up. No scans need review.',
                    textAlign: TextAlign.center,
                    style:
                        AppText.style(14, FontWeight.w600, AppColors.muted)),
              ),
            ),
          ),
        for (var i = 0; i < pending.length; i++) ...[
          if (i > 0) gap(16),
          _PendingCard(scan: pending[i]),
        ],
        gap(20),
        const EtSectionLabel('Resolved today'),
        gap(12),
        EtRowList(
          emptyText: 'Nothing resolved yet.',
          rows: [for (final r in resolved) _ResolvedRow(scan: r)],
        ),
      ],
    );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({required this.scan});
  final ScanReview scan;

  @override
  Widget build(BuildContext context) {
    return EtCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => Navigator.of(context)
                .pushNamed(Routes.teacherReviewDetail, arguments: scan.id),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.avatarViolet),
                  child: Text(scan.initials,
                      style:
                          AppText.style(15, FontWeight.w800, Colors.white)),
                ),
                hgap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scan.name,
                          style: AppText.style(
                              17, FontWeight.w800, AppColors.ink)),
                      gap(2),
                      Text('${scan.roll}, seen ${scan.seenAt}',
                          style: AppText.style(
                              13, FontWeight.w400, AppColors.muted)),
                    ],
                  ),
                ),
                EtPill(scan.confidenceLabel,
                    bg: AppColors.amberBg,
                    fg: AppColors.amberFg,
                    fontSize: 13,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6)),
              ],
            ),
          ),
          gap(14),
          Row(
            children: [
              Expanded(
                child: EtButton(
                  label: 'Mark absent',
                  style: EtButtonStyle.outline,
                  height: 48,
                  fontSize: 14,
                  onPressed: () => resolveScan(context, scan, approve: false),
                ),
              ),
              hgap(10),
              Expanded(
                child: EtButton(
                  label: 'Approve',
                  height: 48,
                  fontSize: 14,
                  onPressed: () => resolveScan(context, scan, approve: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResolvedRow extends StatelessWidget {
  const _ResolvedRow({required this.scan});
  final ScanReview scan;

  @override
  Widget build(BuildContext context) {
    final approved = scan.outcome == ScanOutcome.approved;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scan.name,
                    style: AppText.style(17, FontWeight.w800, AppColors.ink)),
                gap(2),
                Text(
                    '${scan.confidenceLabel}, you ${approved ? 'approved' : 'marked absent'}',
                    style:
                        AppText.style(13, FontWeight.w400, AppColors.muted)),
              ],
            ),
          ),
          hgap(8),
          approved ? EtPill.presentPill() : EtPill.absentPill(),
        ],
      ),
    );
  }
}
