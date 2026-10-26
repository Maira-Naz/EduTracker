// Course attendance: status card + recent sessions. Tap a session to see details.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen(this.c, {super.key});
  final Course c;
  @override
  State<CourseDetailScreen> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetailScreen> {
  int filter = 0;
  int? open;
  static const _filters = ['All', 'Absent', 'Late'];

  Tone _tone(String s) => s == 'Present' ? Tone.green : (s == 'Late' ? Tone.amber : Tone.red);

  String _note(Course c, String sub, String status) {
    final room = Store.i.roomOf(c.room).name;
    final seen = sub.replaceFirst('Seen ', '');
    return switch (status) {
      'Present' => 'The camera in $room matched your face at $seen.',
      'Late' => 'You were seen at $seen, after the late time (${hm(c.lateAt)}).',
      _ => 'The camera in $room did not see you during this class (${c.time}).',
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = Store.i;
    final c = widget.c;
    final p = s.pctOf(c);
    final m = s.canMiss(c);
    final low = p < 75;
    final list = s.recent[c.name]!.where((e) => filter == 0 || e.$3 == _filters[filter]).toList();
    final message = low
        ? 'Below 75%. You can miss $m more classes before it drops further.'
        : 'Above 75%. You can miss $m more ${m == 1 ? 'class' : 'classes'} and stay above the line.';
    return Screen(
      backLabel: 'My courses',
      title: c.name,
      titleSize: 32,
      below: '${c.teacher} · ${s.roomOf(c.room).name}',
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(color: low ? const Color(0xFFFFF6DF) : kGreenBg, border: Border.all(color: low ? const Color(0xFFF2B84B) : kDotGreen, width: 2), borderRadius: BorderRadius.circular(22)),
          child: Row(children: [
            Text('$p%', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -1, color: low ? const Color(0xFF8A5A00) : kGreen)),
            const SizedBox(width: 16),
            Expanded(child: Text(message, style: TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w600, color: low ? const Color(0xFF5C4108) : kGreen))),
          ]),
        ),
        const SectionTitle('Recent sessions'),
        Chips(_filters, filter, (i) => setState(() {
              filter = i;
              open = null;
            })),
        Panel(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          child: list.isEmpty
              ? const Padding(padding: EdgeInsets.symmetric(vertical: 18), child: Text('No sessions in this filter.', textAlign: TextAlign.center, style: kRowSub))
              : Column(children: [
                  for (var i = 0; i < list.length; i++) ...[
                    if (i > 0) const Divider(height: 1, thickness: 1, color: kDivider),
                    InkWell(
                      onTap: () => setState(() => open = open == i ? null : i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(list[i].$1, style: kRowTitle), Text(list[i].$2, style: kRowSub)])),
                            Pill(list[i].$3, _tone(list[i].$3)),
                          ]),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            alignment: Alignment.topCenter,
                            child: open == i
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(_note(c, list[i].$2, list[i].$3), style: kNote),
                                      if (list[i].$3 == 'Absent')
                                        GestureDetector(
                                          onTap: () => toast(context, 'Request sent to ${c.teacher}'),
                                          child: Padding(padding: const EdgeInsets.only(top: 8), child: Text('Ask ${c.teacher} to review  ›', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kLink))),
                                        ),
                                    ]),
                                  )
                                : const SizedBox(width: double.infinity),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ]),
        ),
      ],
    );
  }
}
