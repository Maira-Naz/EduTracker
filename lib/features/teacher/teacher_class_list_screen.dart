import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/models.dart';
import '../../data/teacher_store.dart';
import 'teacher_scaffold.dart';

class TeacherClassListScreen extends StatefulWidget {
  const TeacherClassListScreen({super.key, required this.args});
  final ClassListArgs args;

  @override
  State<TeacherClassListScreen> createState() => _TeacherClassListScreenState();
}

class _TeacherClassListScreenState extends State<TeacherClassListScreen> {
  static const _tabs = [
    AttendanceStatus.present,
    AttendanceStatus.late,
    AttendanceStatus.absent,
  ];

  late int _tab = _tabs.indexOf(widget.args.initial).clamp(0, 2).toInt();

  void _markPresent(ClassSession s, Student st) {
    final prevStatus = st.status;
    final prevSeen = st.seenAt;
    context.read<TeacherStore>().markPresent(s.id, st.id);
    showEtSnack(
      context,
      '${st.name} marked present',
      actionLabel: 'Undo',
      onAction: () => context
          .read<TeacherStore>()
          .restoreStatus(s.id, st.id, prevStatus, prevSeen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TeacherStore>();
    final s = store.sessionById(widget.args.sessionId);
    final status = _tabs[_tab];
    final students = s.students.where((x) => x.status == status).toList();

    String emptyText;
    if (s.state == SessionState.upcoming) {
      emptyText = "This class hasn't started yet.";
    } else if (status == AttendanceStatus.absent) {
      emptyText = 'Everyone has been marked.';
    } else {
      emptyText = 'No students here yet.';
    }

    return TeacherScaffold(
      tab: TeacherTab.rooms,
      children: [
        EtBackLink('← ${s.roomLabel}'),
        gap(16),
        Text('Class list', style: AppText.h1()),
        gap(2),
        Text('${s.course} · ${s.timeRange}',
            style: AppText.style(14, FontWeight.w600, AppColors.muted)),
        gap(16),
        EtSegmented(
          labels: [
            'Present ${s.count(AttendanceStatus.present)}',
            'Late ${s.count(AttendanceStatus.late)}',
            'Absent ${s.count(AttendanceStatus.absent)}',
          ],
          selected: _tab,
          onChanged: (i) => setState(() => _tab = i),
        ),
        gap(16),
        EtRowList(
          emptyText: emptyText,
          rows: [
            for (final st in students) _StudentRow(session: s, student: st,
                onMarkPresent: () => _markPresent(s, st)),
          ],
        ),
        gap(16),
        const EtNote('Manual marks are recorded in the audit trail.'),
      ],
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({
    required this.session,
    required this.student,
    required this.onMarkPresent,
  });

  final ClassSession session;
  final Student student;
  final VoidCallback onMarkPresent;

  String get _subtitle {
    switch (student.status) {
      case AttendanceStatus.absent:
        return '${student.roll} · not seen';
      case AttendanceStatus.present:
      case AttendanceStatus.late:
        return student.seenAt == 'manual'
            ? '${student.roll} · marked by you'
            : '${student.roll} · seen ${student.seenAt}';
      case AttendanceStatus.pending:
        return '${student.roll} · awaiting review';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    switch (student.status) {
      case AttendanceStatus.absent:
        trailing = EtButton(
          label: 'Mark present',
          style: EtButtonStyle.tonal,
          height: 40,
          radius: 12,
          fontSize: 13,
          horizontalPadding: 14,
          onPressed: session.state == SessionState.upcoming
              ? null
              : onMarkPresent,
        );
        break;
      case AttendanceStatus.present:
        trailing = EtPill.presentPill();
        break;
      case AttendanceStatus.late:
        trailing = EtPill.latePill();
        break;
      case AttendanceStatus.pending:
        trailing = const EtPill('In review',
            bg: AppColors.chip, fg: AppColors.deep);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name,
                    style: AppText.style(17, FontWeight.w800, AppColors.ink)),
                gap(2),
                Text(_subtitle,
                    style:
                        AppText.style(13, FontWeight.w400, AppColors.muted)),
              ],
            ),
          ),
          hgap(8),
          trailing,
        ],
      ),
    );
  }
}
