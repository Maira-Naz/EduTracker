import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/models.dart';
import '../../data/teacher_store.dart';
import 'teacher_scaffold.dart';

class TeacherRoomScreen extends StatefulWidget {
  const TeacherRoomScreen({super.key, required this.sessionId});
  final String sessionId;

  @override
  State<TeacherRoomScreen> createState() => _TeacherRoomScreenState();
}

class _TeacherRoomScreenState extends State<TeacherRoomScreen> {
  late int _lateAfter;
  late int _closeAt;

  @override
  void initState() {
    super.initState();
    final s = context.read<TeacherStore>().sessionById(widget.sessionId);
    _lateAfter = s.lateAfterMin;
    _closeAt = s.closeAtMin;
  }

  static const _step = TeacherStore.timeStep;

  bool _canLate(ClassSession s, int d) {
    final v = _lateAfter + d;
    return v >= s.startMin && v <= _closeAt - _step;
  }

  bool _canClose(ClassSession s, int d) {
    final v = _closeAt + d;
    return v >= _lateAfter + _step && v <= s.endMin;
  }

  void _save(ClassSession s) {
    context.read<TeacherStore>().setTiming(s.id, _lateAfter, _closeAt);
    showEtSnack(context, 'Timing saved for ${s.roomLabel}');
  }

  void _openList(ClassSession s, AttendanceStatus status) {
    Navigator.of(context).pushNamed(Routes.teacherClassList,
        arguments: ClassListArgs(s.id, status));
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TeacherStore>();
    final s = store.sessionById(widget.sessionId);
    final editable = s.state != SessionState.closed;
    final minsAfterStart = _lateAfter - s.startMin;

    final EtPill status;
    switch (s.state) {
      case SessionState.running:
        status = const EtPill('Online',
            bg: AppColors.greenBg, fg: AppColors.greenFg);
        break;
      case SessionState.upcoming:
        status = const EtPill('Scheduled',
            bg: AppColors.chip, fg: AppColors.deep);
        break;
      case SessionState.closed:
        status = const EtPill('Closed',
            bg: AppColors.closedBg, fg: AppColors.muted);
        break;
    }

    return TeacherScaffold(
      tab: TeacherTab.rooms,
      children: [
        const EtBackLink('← Rooms'),
        gap(16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.roomLabel, style: AppText.h1()),
                  gap(2),
                  Text('${s.course} · ${s.timeRange}',
                      style: AppText.style(
                          14, FontWeight.w600, AppColors.muted)),
                ],
              ),
            ),
            hgap(8),
            status,
          ],
        ),
        gap(16),
        Row(
          children: [
            _CountTile(
              count: s.count(AttendanceStatus.present),
              label: 'Present',
              bg: AppColors.greenBg,
              fg: AppColors.greenFg,
              onTap: () => _openList(s, AttendanceStatus.present),
            ),
            hgap(10),
            _CountTile(
              count: s.count(AttendanceStatus.late),
              label: 'Late',
              bg: AppColors.amberBg,
              fg: AppColors.amberFg,
              onTap: () => _openList(s, AttendanceStatus.late),
            ),
            hgap(10),
            _CountTile(
              count: s.count(AttendanceStatus.absent),
              label: 'Not seen',
              bg: AppColors.redBg,
              fg: AppColors.redFg,
              onTap: () => _openList(s, AttendanceStatus.absent),
            ),
          ],
        ),
        gap(20),
        const EtSectionLabel('Attendance timing'),
        gap(12),
        EtCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TimeStepper(
                title: 'Mark students late after',
                value: fmtTime(_lateAfter),
                caption: minsAfterStart == 0
                    ? 'At class start'
                    : '$minsAfterStart minutes after class start',
                onMinus: editable && _canLate(s, -_step)
                    ? () => setState(() => _lateAfter -= _step)
                    : null,
                onPlus: editable && _canLate(s, _step)
                    ? () => setState(() => _lateAfter += _step)
                    : null,
              ),
              gap(14),
              Container(height: 1, color: AppColors.divider),
              gap(14),
              _TimeStepper(
                title: 'Close attendance at',
                value: fmtTime(_closeAt),
                caption: 'Nobody is marked after this time',
                onMinus: editable && _canClose(s, -_step)
                    ? () => setState(() => _closeAt -= _step)
                    : null,
                onPlus: editable && _canClose(s, _step)
                    ? () => setState(() => _closeAt += _step)
                    : null,
              ),
              gap(14),
              EtButton(
                label: 'Save timing',
                shadow: AppShadows.primarySmall,
                onPressed: editable ? () => _save(s) : null,
              ),
            ],
          ),
        ),
        gap(16),
        const EtNote(
            'Attendance is marked automatically for the class running in this room.'),
      ],
    );
  }
}

class _CountTile extends StatelessWidget {
  const _CountTile({
    required this.count,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  final int count;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: EtCard(
        radius: 18,
        color: bg,
        shadow: const [],
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$count', style: AppText.style(26, FontWeight.w800, fg)),
            Text(label, style: AppText.style(13, FontWeight.w600, fg)),
          ],
        ),
      ),
    );
  }
}

class _TimeStepper extends StatelessWidget {
  const _TimeStepper({
    required this.title,
    required this.value,
    required this.caption,
    required this.onMinus,
    required this.onPlus,
  });

  final String title;
  final String value;
  final String caption;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppText.style(14, FontWeight.w700, AppColors.ink)),
        gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SquareButton(symbol: '−', semantic: 'Earlier', onTap: onMinus),
            Text(value,
                style: AppText.style(30, FontWeight.w800, AppColors.ink,
                    ls: -0.02)),
            _SquareButton(symbol: '+', semantic: 'Later', onTap: onPlus),
          ],
        ),
        gap(8),
        Text(caption,
            style: AppText.style(13, FontWeight.w400, AppColors.muted)),
      ],
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton(
      {required this.symbol, required this.semantic, required this.onTap});

  final String symbol;
  final String semantic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: AppColors.border, width: 2),
    );
    return Semantics(
      button: true,
      label: semantic,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1,
        child: Material(
          color: Colors.white,
          shape: shape,
          child: InkWell(
            customBorder: shape,
            onTap: onTap,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: Text(symbol,
                    style: AppText.style(22, FontWeight.w700, AppColors.ink)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
