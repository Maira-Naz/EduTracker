import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/models.dart';
import '../../data/teacher_store.dart';
import 'teacher_scaffold.dart';

class TeacherRoomsScreen extends StatelessWidget {
  const TeacherRoomsScreen({super.key});

  static const _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
    'Sunday',
  ];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
    'Nov', 'Dec',
  ];

  Future<void> _confirmSignOut(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text('Sign out?',
            style: AppText.style(20, FontWeight.w800, AppColors.ink)),
        content: Text('You will need to sign in again to manage attendance.',
            style: AppText.style(14, FontWeight.w500, AppColors.muted,
                height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: AppText.style(14, FontWeight.w700, AppColors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Sign out',
                style: AppText.style(14, FontWeight.w800, AppColors.primary)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.login, (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TeacherStore>();
    final now = DateTime.now();
    final date =
        '${_weekdays[now.weekday - 1]}, ${now.day} ${_months[now.month - 1]}';
    final running = store.sessionsWhere(SessionState.running);
    final later = store.sessionsWhere(SessionState.upcoming);
    final earlier = store.sessionsWhere(SessionState.closed);

    return TeacherScaffold(
      tab: TeacherTab.rooms,
      children: [
        Text(date,
            style: AppText.style(14, FontWeight.w600, AppColors.muted)),
        gap(2),
        // Long-press the title to sign out.
        GestureDetector(
          onLongPress: () => _confirmSignOut(context),
          child: Text('Your rooms', style: AppText.h1()),
        ),
        for (final s in running) ...[gap(20), _RunningCard(session: s)],
        if (later.isNotEmpty) ...[
          gap(20),
          _SessionSection(title: 'Later today', sessions: later),
        ],
        if (earlier.isNotEmpty) ...[
          gap(20),
          _SessionSection(title: 'Earlier today', sessions: earlier),
        ],
      ],
    );
  }
}

class _RunningCard extends StatelessWidget {
  const _RunningCard({required this.session});
  final ClassSession session;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.deep,
        borderRadius: BorderRadius.circular(26),
        boxShadow: AppShadows.deepCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Running now · ${session.timeRange}',
                  style: AppText.style(
                      13, FontWeight.w600, AppColors.onDeepMuted)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.blobSmall,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: AppColors.ink),
                    ),
                    hgap(6),
                    Text('Live',
                        style: AppText.style(
                            12, FontWeight.w800, AppColors.ink)),
                  ],
                ),
              ),
            ],
          ),
          gap(16),
          Text(session.course,
              style: AppText.style(27, FontWeight.w800, Colors.white,
                  ls: -0.02)),
          gap(2),
          Text(session.roomAndBlock,
              style:
                  AppText.style(14, FontWeight.w400, AppColors.onDeepMuted)),
          gap(16),
          Row(
            children: [
              _Stat(session.count(AttendanceStatus.present), 'Present'),
              hgap(10),
              _Stat(session.count(AttendanceStatus.late), 'Late'),
              hgap(10),
              _Stat(session.count(AttendanceStatus.absent), 'Not seen'),
            ],
          ),
          gap(16),
          EtButton(
            label: 'Open room',
            style: EtButtonStyle.white,
            height: 50,
            onPressed: () => Navigator.of(context)
                .pushNamed(Routes.teacherRoom, arguments: session.id),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.14),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$value',
                style: AppText.style(22, FontWeight.w800, Colors.white)),
            Text(label,
                style:
                    AppText.style(12, FontWeight.w400, AppColors.onDeepMuted)),
          ],
        ),
      ),
    );
  }
}

class _SessionSection extends StatelessWidget {
  const _SessionSection({required this.title, required this.sessions});
  final String title;
  final List<ClassSession> sessions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EtSectionLabel(title, leftPadding: 2),
        for (final s in sessions) ...[gap(10), _SessionTile(session: s)],
      ],
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});
  final ClassSession session;

  @override
  Widget build(BuildContext context) {
    final closed = session.state == SessionState.closed;
    return EtCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      onTap: () => Navigator.of(context)
          .pushNamed(Routes.teacherRoom, arguments: session.id),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.course,
                    style: AppText.style(17, FontWeight.w800, AppColors.ink)),
                gap(2),
                Text(session.roomAndBlock,
                    style: AppText.style(
                        13, FontWeight.w400, AppColors.muted)),
              ],
            ),
          ),
          closed
              ? const EtPill('Closed',
                  bg: AppColors.closedBg,
                  fg: AppColors.muted,
                  fontSize: 13,
                  weight: FontWeight.w700)
              : EtPill(fmtTime(session.startMin),
                  bg: AppColors.chip,
                  fg: AppColors.deep,
                  fontSize: 14),
        ],
      ),
    );
  }
}
