// Course attendance summary; tap an absent day to see date and details.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail(this.c, {super.key});
  final Course c;
  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  int? open = 0;

  @override
  Widget build(BuildContext context) {
    final c = widget.c, s = Store.i;
    final st = s.stats[c.name]!, p = s.pctOf(c), days = s.absentDays[c.name] ?? [];
    return Screen(
      back: true,
      backLabel: 'My courses',
      subtitle: c.teacher,
      title: c.name,
      children: [
        AppCard(
          child: Row(children: [
            SizedBox(
              width: 92,
              height: 92,
              child: Stack(fit: StackFit.expand, children: [
                CircularProgressIndicator(value: p / 100, strokeWidth: 10, backgroundColor: kGrey, color: barColor(p)),
                Center(child: Text('$p%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
              ]),
            ),
            const SizedBox(width: 18),
            Expanded(child: Text('${st[0]} classes held\n${st[1]} present · ${st[2]} late · ${st[3]} absent', style: const TextStyle(color: kMuted, fontSize: 13, height: 1.7))),
          ]),
        ),
        AppCard(child: Item('Schedule', sub: '${c.days} · ${c.time} · Room ${c.room}')),
        if (p < 75)
          AppCard(color: kAmberBg, border: kAmberBg, child: const Text('Your attendance is below 75% in this course.', style: TextStyle(color: kAmber, fontSize: 13))),
        const Section('Absent days'),
        if (days.isEmpty)
          emptyNote('No absences. Nice work.')
        else ...[
          const Padding(padding: EdgeInsets.only(top: 2), child: Text('Tap a day to see what happened.', style: kMut)),
          for (var i = 0; i < days.length; i++)
            AppCard(
              border: open == i ? kPrimary : kLine,
              onTap: () => setState(() => open = open == i ? null : i),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.topCenter,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Item(days[i], trailing: const Pill('Absent', Tone.red)),
                  if (open == i) ...[
                    const Hr(),
                    Text('Class ${c.time}, Room ${c.room}. The camera did not detect you during this session.', style: kMut),
                    const SizedBox(height: 8),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 32), foregroundColor: kViolet),
                      onPressed: () => toast(context, 'Request sent to ${c.teacher}'),
                      child: Text('Ask ${c.teacher} to review'),
                    ),
                  ],
                ]),
              ),
            ),
        ],
      ],
    );
  }
}
