// Today's sessions with Live / Done / Upcoming filter.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'course_screen.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});
  @override
  State<SessionsScreen> createState() => _SessionsState();
}

class _SessionsState extends State<SessionsScreen> {
  int f = 0;
  static const _f = ['All', 'Live', 'Done', 'Upcoming'];
  @override
  Widget build(BuildContext context) {
    final all = Store.i.sessions;
    final list = all.where((x) => f == 0 || x.status == _f[f]).toList();
    return Screen(
      back: true,
      backLabel: 'Overview',
      title: "Today's sessions",
      subtitle: '${all.length} classes scheduled',
      children: [
        Seg(_f, f, (i) => setState(() => f = i)),
        if (list.isEmpty) emptyNote('No sessions in this filter.'),
        for (final x in list)
          AppCard(
            onTap: () => go(context, AdminCourseScreen(x.course)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Item(x.course.name, sub: 'Room ${x.course.room} · ${x.course.teacher}', trailing: Pill(x.status, x.status == 'Live' ? Tone.green : (x.status == 'Done' ? Tone.violet : Tone.amber))),
              const SizedBox(height: 6),
              Text(x.course.time, style: kMut),
            ]),
          ),
      ],
    );
  }
}
