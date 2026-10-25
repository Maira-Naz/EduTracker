// Course detail with 3 tabs: Attendance, Camera history, Students.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class AdminCourseScreen extends StatefulWidget {
  const AdminCourseScreen(this.c, {super.key});
  final Course c;
  @override
  State<AdminCourseScreen> createState() => _AdminCourseState();
}

class _AdminCourseState extends State<AdminCourseScreen> {
  int tab = 0;
  bool lowOnly = false;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final c = widget.c;
          final ss = Store.i.students;
          final lowN = ss.where((x) => x.pct < 75).length;
          return Screen(
            back: true,
            backLabel: 'Room ${c.room}',
            subtitle: 'Room ${c.room} · ${c.teacher}',
            title: c.name,
            children: [
              Seg(const ['Attendance', 'Camera history', 'Students'], tab, (i) => setState(() => tab = i)),
              if (tab == 0) ..._attendance(c, lowN),
              if (tab == 1) ..._camera(c),
              if (tab == 2) ..._students(ss),
            ],
          );
        },
      );

  List<Widget> _attendance(Course c, int lowN) {
    const sessions = [('Wed, 21 Oct', 94), ('Mon, 19 Oct', 89), ('Wed, 14 Oct', 82)];
    return [
      tileRow([StatTile('${c.avg}%', 'Average', bg: kGreenBg, fg: kGreen), StatTile('$lowN', 'Students below 75%', bg: kAmberBg, fg: kAmber, onTap: () => setState(() {
        tab = 2;
        lowOnly = true;
      }))]),
      const Section('Recent sessions'),
      AppCard(
        child: Column(children: [
          for (var i = 0; i < sessions.length; i++) ...[
            if (i > 0) const Hr(),
            Column(children: [
              Item(sessions[i].$1, trailing: Text('${sessions[i].$2}%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              PercentBar(sessions[i].$2),
            ]),
          ],
        ]),
      ),
    ];
  }

  List<Widget> _camera(Course c) {
    final logs = [
      ('Wed, 21 Oct', c.start - 2, c.end + 2, 'On time', Tone.green),
      ('Mon, 19 Oct', c.start + 14, c.end, 'Opened late', Tone.amber),
      ('Wed, 14 Oct', c.start - 3, c.end + 1, 'On time', Tone.green),
    ];
    return [
      for (final l in logs)
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Item(l.$1, trailing: Pill(l.$4, l.$5)),
            const SizedBox(height: 8),
            Text('Camera opened ${hm(l.$2)} · closed ${hm(l.$3)}\nBy ${c.teacher} (${c.tid})\nLate after ${hm(c.lateAt)} · attendance closed ${hm(c.closeAt)}', style: const TextStyle(color: kMuted, fontSize: 13, height: 1.7)),
          ]),
        ),
    ];
  }

  List<Widget> _students(List<Stu> ss) {
    final list = [...ss.where((x) => !lowOnly || x.pct < 75)]..sort((a, b) => b.pct.compareTo(a.pct));
    return [
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Wrap(spacing: 8, children: [
          ChoiceChip(label: const Text('All'), selected: !lowOnly, onSelected: (_) => setState(() => lowOnly = false)),
          ChoiceChip(label: const Text('Below 75%'), selected: lowOnly, onSelected: (_) => setState(() => lowOnly = true)),
        ]),
      ),
      if (list.isEmpty)
        emptyNote('No students below 75%.')
      else
        AppCard(
          child: Column(children: [
            for (var i = 0; i < list.length; i++) ...[
              if (i > 0) const Hr(),
              Item(list[i].name, sub: list[i].id, trailing: Pill('${list[i].pct}%', pctTone(list[i].pct))),
            ],
          ]),
        ),
    ];
  }
}
