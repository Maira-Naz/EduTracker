// Class list (Present / Late / Absent) with manual "Mark present".
import 'package:flutter/material.dart';
import '../../core/core.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen(this.course, {super.key, this.initial = 0});
  final Course course;
  final int initial;
  @override
  State<ClassListScreen> createState() => _ClassListState();
}

class _ClassListState extends State<ClassListScreen> {
  late int idx = widget.initial;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final ss = Store.i.students;
          final groups = [
            ss.where((x) => x.status == 'Present').toList(),
            ss.where((x) => x.status == 'Late').toList(),
            ss.where((x) => x.status == 'Absent' || x.status == 'Review').toList(),
          ];
          final list = groups[idx];
          return Screen(
            back: true,
            backLabel: 'Room ${widget.course.room}',
            subtitle: '${widget.course.name} · ${widget.course.time}',
            title: 'Class list',
            children: [
              Seg(['Present ${groups[0].length}', 'Late ${groups[1].length}', 'Absent ${groups[2].length}'], idx, (i) => setState(() => idx = i)),
              if (list.isEmpty)
                emptyNote('Nobody here.')
              else
                AppCard(
                  child: Column(children: [
                    for (var i = 0; i < list.length; i++) ...[
                      if (i > 0) const Hr(),
                      Item(
                        list[i].name,
                        sub: '${list[i].id} · ${list[i].status == 'Absent' ? 'not seen' : 'seen'}',
                        trailing: list[i].status == 'Absent'
                            ? FilledButton.tonal(
                                style: FilledButton.styleFrom(minimumSize: const Size(0, 36), padding: const EdgeInsets.symmetric(horizontal: 14)),
                                onPressed: () {
                                  Store.i.mark(list[i]);
                                  toast(context, '${list[i].name} marked present');
                                },
                                child: const Text('Mark present'),
                              )
                            : (list[i].status == 'Review' ? const Pill('In review', Tone.violet) : null),
                      ),
                    ],
                  ]),
                ),
              const SizedBox(height: 14),
              const Text('Manual marks are recorded in the audit trail.', style: kMut),
            ],
          );
        },
      );
}
