import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/admin_store.dart';
import '../widgets/admin_widgets.dart';
import 'edit_slot_screen.dart';


class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _dept = kDepts[0];
  String _sem = 'Semester 3';
  int _day = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: adminStore,
      builder: (context, _) {
        final list = adminStore.slots
            .where((s) =>
                s.dept == _dept && s.sem == _sem && s.day == kDays[_day])
            .toList()
          ..sort((a, b) => a.start.compareTo(b.start));
        return AppPage(children: [
          const Header(eyebrow: 'Autumn 2026', title: 'Schedule'),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              flex: 3,
              child: Field('Department',
                  value: _dept,
                  onTap: () async {
                    final v = await pickOption(context, 'Department', kDepts);
                    if (v != null) setState(() => _dept = v);
                  }),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Field('Semester',
                  value: _sem,
                  onTap: () async {
                    final v = await pickOption(context, 'Semester', kSems);
                    if (v != null) setState(() => _sem = v);
                  }),
            ),
          ]),
          const SizedBox(height: 14),
          Segmented(
            labels: [for (final d in kDays) d.substring(0, 3)],
            index: _day,
            onChanged: (v) => setState(() => _day = v),
          ),
          const SizedBox(height: 12),
          for (final s in list)
            AppCard(
              onTap: () => _open(context, s),
              child: Row(children: [
                SizedBox(
                  width: 52,
                  child: Text('${s.start}-\n${s.end}',
                      style: AppText.style(11, FontWeight.w800, AppColors.link,
                          height: 1.3)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.course,
                            style: AppText.style(
                                13, FontWeight.w800, AppColors.ink)),
                        Text('${s.teacher} · ${s.room}',
                            style: AppText.style(
                                10, FontWeight.w600, AppColors.muted)),
                      ]),
                ),
                Text('Edit',
                    style: AppText.style(12, FontWeight.w800, AppColors.link)),
              ]),
            ),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                  child: Text('No classes on ${kDays[_day]}',
                      style: AppText.style(
                          13, FontWeight.w700, AppColors.muted))),
            ),
          OutlineBtn('+ Add slot', () => _open(context, null),
              color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
              'Loaded from the timetable database. Edit only to correct or add a class.',
              style: AppText.style(11, FontWeight.w600, AppColors.muted)),
        ]);
      },
    );
  }

  void _open(BuildContext context, Slot? s) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditSlotScreen(
        slot: s,
        dept: _dept,
        sem: _sem,
        day: kDays[_day],
      ),
    ));
  }
}
